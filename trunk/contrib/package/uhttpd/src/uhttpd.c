#include "uhttpd.h"
#include "uhttpd-utils.h"
#include "uhttpd-file.h"

#ifdef HAVE_CGI
#include "uhttpd-cgi.h"
#endif

#ifdef HAVE_LUA
#include "uhttpd-lua.h"
#endif

#ifdef HAVE_TLS
#include "uhttpd-tls.h"
#endif


static int run = 1;

static void uh_sigterm(int sig)
{
	run = 0;
}

static int uh_socket_bind(
	fd_set *serv_fds, int *max_fd, const char *host, const char *port,
	struct addrinfo *hints, int do_tls, struct config *conf
) {
	int sock = -1;
	int yes = 1;
	int status;
	int bound = 0;

	struct listener *l = NULL;
	struct addrinfo *addrs = NULL, *p = NULL;

	if( (status = getaddrinfo(host, port, hints, &addrs)) != 0 )
	{
		fprintf(stderr, "getaddrinfo(): %s\n", gai_strerror(status));
	}

	/* try to bind a new socket to each found address */
	for( p = addrs; p; p = p->ai_next )
	{
		/* get the socket */
		if( (sock = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1 )
		{
			perror("socket()");
			goto error;
		}

		/* "address already in use" */
		if( setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes)) == -1 )
		{
			perror("setsockopt()");
			goto error;
		}

		/* required to get parallel v4 + v6 working */
		if( p->ai_family == AF_INET6 )
		{
			if( setsockopt(sock, IPPROTO_IPV6, IPV6_V6ONLY, &yes, sizeof(yes)) == -1 )
			{
				perror("setsockopt()");
				goto error;
			}
		}

		/* bind */
		if( bind(sock, p->ai_addr, p->ai_addrlen) == -1 )
		{
			perror("bind()");
			goto error;
		}

		/* listen */
		if( listen(sock, UH_LIMIT_CLIENTS) == -1 )
		{
			perror("listen()");
			goto error;
		}

		/* add listener to global list */
		if( ! (l = uh_listener_add(sock, conf)) )
		{
			fprintf(stderr,
				"uh_listener_add(): Can not create more than "
				"%i listen sockets\n", UH_LIMIT_LISTENERS
			);

			goto error;
		}

#ifdef HAVE_TLS
		/* init TLS */
		l->tls = do_tls ? conf->tls : NULL;
#endif

		/* add socket to server fd set */
		FD_SET(sock, serv_fds);
		*max_fd = max(*max_fd, sock);

		bound++;
		continue;

		error:
		if( sock > 0 )
			close(sock);
	}

	freeaddrinfo(addrs);

	return bound;
}

static struct http_request * uh_http_header_parse(struct client *cl, char *buffer, int buflen)
{
	char *method  = &buffer[0];
	char *path    = NULL;
	char *version = NULL;

	char *headers = NULL;
	char *hdrname = NULL;
	char *hdrdata = NULL;

	int i;
	int hdrcount = 0;

	static struct http_request req;

	memset(&req, 0, sizeof(req));


	/* terminate initial header line */
	if( (headers = strfind(buffer, buflen, "\r\n", 2)) != NULL )
	{
		buffer[buflen-1] = 0;

		*headers++ = 0;
		*headers++ = 0;

		/* find request path */
		if( (path = strchr(buffer, ' ')) != NULL )
			*path++ = 0;

		/* find http version */
		if( (path != NULL) && ((version = strchr(path, ' ')) != NULL) )
			*version++ = 0;


		/* check method */
		if( strcmp(method, "GET") && strcmp(method, "HEAD") && strcmp(method, "POST") )
		{
			/* invalid method */
			uh_http_response(cl, 405, "Method Not Allowed");
			return NULL;
		}
		else
		{
			switch(method[0])
			{
				case 'G':
					req.method = UH_HTTP_MSG_GET;
					break;

				case 'H':
					req.method = UH_HTTP_MSG_HEAD;
					break;

				case 'P':
					req.method = UH_HTTP_MSG_POST;
					break;
			}
		}

		/* check path */
		if( !path || !strlen(path) )
		{
			/* malformed request */
			uh_http_response(cl, 400, "Bad Request");
			return NULL;
		}
		else
		{
			req.url = path;
		}

		/* check version */
		if( strcmp(version, "HTTP/0.9") && strcmp(version, "HTTP/1.0") && strcmp(version, "HTTP/1.1") )
		{
			/* unsupported version */
			uh_http_response(cl, 400, "Bad Request");
			return NULL;
		}
		else
		{
			req.version = strtof(&version[5], NULL);
		}


		/* process header fields */
		for( i = (int)(headers - buffer); i < buflen; i++ )
		{
			/* found eol and have name + value, push out header tuple */
			if( hdrname && hdrdata && (buffer[i] == '\r' || buffer[i] == '\n') )
			{
				buffer[i] = 0;

				/* store */
				if( (hdrcount + 1) < array_size(req.headers) )
				{
					req.headers[hdrcount++] = hdrname;
					req.headers[hdrcount++] = hdrdata;

					hdrname = hdrdata = NULL;
				}

				/* too large */
				else
				{
					uh_http_response(cl, 413, "Request Entity Too Large");
					return NULL;
				}
			}

			/* have name but no value and found a colon, start of value */
			else if( hdrname && !hdrdata && ((i+2) < buflen) &&
				(buffer[i] == ':') && (buffer[i+1] == ' ')
			) {
				buffer[i] = 0;
				hdrdata = &buffer[i+2];
			}

			/* have no name and found [A-Z], start of name */
			else if( !hdrname && isalpha(buffer[i]) && isupper(buffer[i]) )
			{
				hdrname = &buffer[i];
			}
		}

		/* valid enough */
		return &req;
	}

	/* Malformed request */
	uh_http_response(cl, 400, "Bad Request");
	return NULL;
}


static struct http_request * uh_http_header_recv(struct client *cl)
{
	char buffer[UH_LIMIT_MSGHEAD];
	char *bufptr = &buffer[0];
	char *idxptr = NULL;

	struct timeval timeout;

	fd_set reader;

	ssize_t blen = sizeof(buffer)-1;
	ssize_t rlen = 0;


	memset(buffer, 0, sizeof(buffer));

	while( blen > 0 )
	{
		FD_ZERO(&reader);
		FD_SET(cl->socket, &reader);

		/* fail after 0.1s */
		timeout.tv_sec  = 0;
		timeout.tv_usec = 100000;

		/* check whether fd is readable */
		if( select(cl->socket + 1, &reader, NULL, NULL, &timeout) > 0 )
		{
			/* receive data */
			rlen = uh_tcp_peek(cl, bufptr, blen);

			if( rlen > 0 )
			{
				if( (idxptr = strfind(buffer, sizeof(buffer), "\r\n\r\n", 4)) )
				{
					blen -= uh_tcp_recv(cl, bufptr, (int)(idxptr - bufptr) + 4);

					/* header read complete ... */
					return uh_http_header_parse(cl, buffer, sizeof(buffer) - blen - 1);
				}
				else
				{
					rlen = uh_tcp_recv(cl, bufptr, rlen);
					blen -= rlen;
					bufptr += rlen;
				}
			}
			else
			{
				/* invalid request (unexpected eof/timeout) */
				uh_http_response(cl, 408, "Request Timeout");
				return NULL;
			}
		}
		else
		{
			/* invalid request (unexpected eof/timeout) */
			uh_http_response(cl, 408, "Request Timeout");
			return NULL;
		}
	}

	/* request entity too large */
	uh_http_response(cl, 413, "Request Entity Too Large");
	return NULL;
}


int main (int argc, char **argv)
{
#ifdef HAVE_LUA
	/* Lua runtime */
	lua_State *L = NULL;
#endif

	/* master file descriptor list */
	fd_set used_fds, serv_fds, read_fds;

	/* working structs */
	struct addrinfo hints;
	struct http_request *req;
	struct uh_path_info *pin;
	struct client *cl;
	struct sigaction sa;
	struct config conf;

	/* maximum file descriptor number */
	int new_fd, cur_fd, max_fd = 0;

	int tls = 0;
	int keys = 0;
	int bound = 0;
	int nofork = 0;

	/* args */
	char opt;
	char bind[128];
	char *port = NULL;

	/* clear the master and temp sets */
	FD_ZERO(&used_fds);
	FD_ZERO(&serv_fds);
	FD_ZERO(&read_fds);

	/* handle SIGPIPE, SIGCHILD */
	sa.sa_handler = SIG_IGN;
	sigaction(SIGPIPE, &sa, NULL);
	sigaction(SIGCHLD, &sa, NULL);

	sa.sa_handler = uh_sigterm;
	sigaction(SIGINT,  &sa, NULL);
	sigaction(SIGTERM, &sa, NULL);

	/* prepare addrinfo hints */
	memset(&hints, 0, sizeof(hints));
	hints.ai_family   = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags    = AI_PASSIVE;

	/* parse args */
	memset(&conf, 0, sizeof(conf));
	memset(bind, 0, sizeof(bind));

#ifdef HAVE_TLS
	/* init SSL context */
	if( ! (conf.tls = uh_tls_ctx_init()) )
	{
		fprintf(stderr, "Failed to initalize SSL context\n");
		exit(1);
	}
#endif

	while( (opt = getopt(argc, argv, "fC:K:p:s:h:c:l:L:d:")) > 0 )
	{
		switch(opt)
		{
			/* [addr:]port */
			case 'p':
			case 's':
				if( (port = strrchr(optarg, ':')) != NULL )
				{
					if( (optarg[0] == '[') && (port > optarg) && (port[-1] == ']') )
						memcpy(bind, optarg + 1,
							min(sizeof(bind), (int)(port - optarg) - 2));
					else
						memcpy(bind, optarg,
							min(sizeof(bind), (int)(port - optarg)));

					port++;
				}
				else
				{
					port = optarg;
				}

				if( opt == 's' )
					tls = 1;

				/* bind sockets */
				bound += uh_socket_bind(
					&serv_fds, &max_fd, bind[0] ? bind : NULL, port,
					&hints,	tls, &conf
				);

				break;

#ifdef HAVE_TLS
			/* certificate */
			case 'C':
				if( SSL_CTX_use_certificate_file(conf.tls, optarg, SSL_FILETYPE_ASN1) < 1 )
				{
					fprintf(stderr, "Invalid certificate file given\n");
					exit(1);
				}

				keys++;
				break;

			/* key */
			case 'K':
				if( SSL_CTX_use_PrivateKey_file(conf.tls, optarg, SSL_FILETYPE_ASN1) < 1 )
				{
					fprintf(stderr, "Invalid private key file given\n");
					exit(1);
				}

				keys++;
				break;
#endif

			/* docroot */
			case 'h':
				if( ! realpath(optarg, conf.docroot) )
				{
					fprintf(stderr, "Invalid directory %s: %s\n", optarg, strerror(errno));
					exit(1);
				}
				break;

#ifdef HAVE_CGI
			/* cgi prefix */
			case 'c':
				conf.cgi_prefix = optarg;
				break;
#endif

#ifdef HAVE_LUA
			/* lua prefix */
			case 'l':
				conf.lua_prefix = optarg;
				break;

			/* lua handler */
			case 'L':
				conf.lua_handler = optarg;
				break;
#endif

			/* no fork */
			case 'f':
				nofork = 1;
				break;

			/* urldecode */
			case 'd':
				if( (port = malloc(strlen(optarg)+1)) != NULL )
				{
					memset(port, 0, strlen(optarg)+1);
					uh_urldecode(port, strlen(optarg), optarg, strlen(optarg));
					printf("%s", port);
					free(port);
					exit(0);
				}
				break;

			default:
				fprintf(stderr,
					"Usage: %s -p [addr:]port [-h docroot]\n"
					"	-p	Bind to specified address and port, multiple allowed\n"
#ifdef HAVE_TLS
					"	-s	Like -p but provide HTTPS on this port\n"
					"	-C	ASN.1 server certificate file\n"
					"	-K	ASN.1 server private key file\n"
#endif
					"	-h	Specify the document root, default is '.'\n"
					"	-f	Do not fork to background\n"
#ifdef HAVE_LUA
					"	-l	URL prefix for Lua handler, default is '/lua'\n"
					"	-L	Lua handler script, omit to disable Lua\n"
#endif
#ifdef HAVE_CGI
					"	-c	URL prefix for CGI handler, default is '/cgi-bin'\n"
#endif
					"	-d	URL decode given string\n"
					"\n", argv[0]
				);

				exit(1);
		}
	}

#ifdef HAVE_TLS
	if( (tls == 1) && (keys < 2) )
	{
		fprintf(stderr, "Missing private key or certificate file\n");
		exit(1);
	}
#endif

	if( bound < 1 )
	{
		fprintf(stderr, "No sockets bound, unable to continue\n");
		exit(1);
	}

	/* default docroot */
	if( !conf.docroot[0] && !realpath(".", conf.docroot) )
	{
		fprintf(stderr, "Can not determine default document root: %s\n",
			strerror(errno));
		exit(1);
	}

#ifdef HAVE_CGI
	/* default cgi prefix */
	if( ! conf.cgi_prefix )
		conf.cgi_prefix = "/cgi-bin";
#endif

#ifdef HAVE_LUA
	/* init Lua runtime if handler is specified */
	if( conf.lua_handler )
	{
		/* default lua prefix */
		if( ! conf.lua_prefix )
			conf.lua_prefix = "/lua";

		L = uh_lua_init(conf.lua_handler);
	}
#endif

	/* fork (if not disabled) */
	if( ! nofork )
	{
		switch( fork() )
		{
			case -1:
				perror("fork()");
				exit(1);

			case 0:
				/* daemon setup */
				if( chdir("/") )
					perror("chdir()");

				if( (cur_fd = open("/dev/null", O_WRONLY)) > -1 )
					dup2(cur_fd, 0);

				if( (cur_fd = open("/dev/null", O_RDONLY)) > -1 )
					dup2(cur_fd, 1);

				if( (cur_fd = open("/dev/null", O_RDONLY)) > -1 )
					dup2(cur_fd, 2);

				break;

			default:
				exit(0);
		}
	}

	/* backup server descriptor set */
	used_fds = serv_fds;

	/* loop */
	while(run)
	{
		/* create a working copy of the used fd set */
		read_fds = used_fds;

		/* sleep until socket activity */
		if( select(max_fd + 1, &read_fds, NULL, NULL, NULL) == -1 )
		{
			perror("select()");
			exit(1);
		}

		/* run through the existing connections looking for data to be read */
		for( cur_fd = 0; cur_fd <= max_fd; cur_fd++ )
		{
			/* is a socket managed by us */
			if( FD_ISSET(cur_fd, &read_fds) )
			{
				/* is one of our listen sockets */
				if( FD_ISSET(cur_fd, &serv_fds) )
				{
					/* handle new connections */
					if( (new_fd = accept(cur_fd, NULL, 0)) != -1 )
					{
						/* add to global client list */
						if( (cl = uh_client_add(new_fd, uh_listener_lookup(cur_fd))) != NULL )
						{
#ifdef HAVE_TLS
							/* setup client tls context */
							uh_tls_client_accept(cl);
#endif

							/* add client socket to global fdset */
							FD_SET(new_fd, &used_fds);
							max_fd = max(max_fd, new_fd);
						}

						/* insufficient resources */
						else
						{
							fprintf(stderr,
								"uh_client_add(): Can not manage more than "
								"%i client sockets, connection dropped\n",
								UH_LIMIT_CLIENTS
							);

							close(new_fd);
						}
					}
				}

				/* is a client socket */
				else
				{
					if( ! (cl = uh_client_lookup(cur_fd)) )
					{
						/* this should not happen! */
						fprintf(stderr,
							"uh_client_lookup(): No entry for fd %i!\n",
							cur_fd);

						goto cleanup;
					}

					/* parse message header */
					if( (req = uh_http_header_recv(cl)) != NULL )
					{
						/* dispatch request */
						if( (pin = uh_path_lookup(cl, req->url)) != NULL )
						{
#ifdef HAVE_CGI
							if( strstr(pin->name, conf.cgi_prefix) == pin->name )
							{
								uh_cgi_request(cl, req, pin);
							}
							else
#endif
							{
								uh_file_request(cl, req, pin);
							}
						}
#ifdef HAVE_LUA
						/* Lua request? */
						else if( strstr(req->url, conf.lua_prefix) == req->url )
						{
							uh_lua_request(cl, req, L);
						}
#endif
						/* 404 */
						else
						{
							uh_http_sendhf(cl, 404, "Not Found",
								"No such file or directory");
						}
					}

					/* 400 */
					else
					{
						uh_http_sendhf(cl, 400, "Bad Request",
							"Malformed request received");
					}

#ifdef HAVE_TLS
					/* free client tls context */
					uh_tls_client_close(cl);
#endif

					cleanup:

					/* close client socket */
					close(cur_fd);
					FD_CLR(cur_fd, &used_fds);

					/* remove from global client list */
					uh_client_remove(cur_fd);
				}
			}
		}
	}

#ifdef HAVE_LUA
	/* destroy the Lua state */
	if( L != NULL )
		lua_close(L);
#endif

	return 0;
}

