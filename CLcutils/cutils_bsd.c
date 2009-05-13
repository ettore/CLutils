/* 
 filename: cutils_bsd.c 
 Copyright 2008 Cubelogic. All rights reserved.
 */

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/param.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/file.h>

#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "cl_errors.h"
#include "cl_debug.h"
#include "cutils_bsd.h"

/* -----------------------------------------------------------------------------
 *  Sprints in outBuf the IP address (xxx.xxx.xxx.xxx) given the computer name.
 *  This code was cannibalized from BSD's PING src code, available here: 
 *  ftp://ftp.uu.net/systems/unix/bsd-sources/sbin/ping                       
 *                                                                            */
int cutils_get_ip(const char *inHostName, size_t inBufSize, char *outBuf)
{
    struct sockaddr whereto;    /* who to ping */
    struct hostent *hp;
    struct sockaddr_in *to;
    //char hnamebuf[MAXHOSTNAMELEN];
    
    // precondition: minimal length for the outBuf is like "x.x.x.x"
    if (inBufSize < 8 || inHostName == NULL || strlen(inHostName) == 0)
        return -1;
    
    // preparatory work
    bzero((char *)&whereto, sizeof(struct sockaddr));
    to = (struct sockaddr_in *)&whereto;
    to->sin_family = AF_INET;
    to->sin_addr.s_addr = inet_addr(inHostName);
    if (to->sin_addr.s_addr != (u_int)-1)
    {
        // inHostName is already an IP address!
        strncpy(outBuf, inHostName, inBufSize - 1);
    }
    else 
    {
        // we have to convert the address
        hp = gethostbyname(inHostName);
        if (!hp) 
        {
            debug1msg("cutils_get_ip: unknown host %s", inHostName);
            return CL_UNKNOWN_HOST;
        }
        to->sin_family = hp->h_addrtype;
        bcopy(hp->h_addr, (caddr_t)&to->sin_addr, hp->h_length);
        //strncpy(hnamebuf, hp->h_name, sizeof(hnamebuf) - 1);

        strncpy(outBuf, inet_ntoa(*(struct in_addr *)&to->sin_addr.s_addr), 
                inBufSize);
    }
    
    return 0;
}


/*------------------------------------------------------------------------------ 
	Redirects stdin to `input_fname' and stdout/stderr to `log_fname'. 
*/
void cutils_redirect_std(const char *input_fname, const char *log_fname)
{
	/* first close current stdin/stdout/stderr */
	for(int i=0; i<3; i++)
		close(i);
	
	/* `open' assigns the file the lowest possible file descriptor, ie 0 here */ 
	if (input_fname == 0 || (open(input_fname, O_RDONLY) == -1))
		open("/dev/zero", O_RDONLY);
			
	/* ... followed by 1 (stdout) */
	if (log_fname == 0 || (open(log_fname, O_WRONLY|O_CREAT|O_TRUNC, 0644) == -1))
		open("/dev/null", O_WRONLY);

	/* stderr will coincide with stdout */
	dup(1);

	setvbuf(stdout, 0, _IOLBF, 0);
	setvbuf(stderr, 0, _IONBF, 0);
}



