/* 
 $Id$

 Copyright (c) 2010, Cubelogic. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, 
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, 
 this list of conditions and the following disclaimer in the documentation 
 and/or other materials provided with the distribution.
 * Neither the name of Cubelogic nor the names of its contributors may be 
 used to endorse or promote products derived from this software without 
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
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
 *  Sprints in outbuf the IP address (xxx.xxx.xxx.xxx) given the computer name.
 *  This code was cannibalized from BSD's PING src code, available here: 
 *  ftp://ftp.uu.net/systems/unix/bsd-sources/sbin/ping                       
 *  Note: a given name could be associated with multiple IP addresses: this 
 *  function simply returns the first (AFAIK 80% of the times that's what 
 *  one needs anyway)
 *                                                                            */
int cutils_get_ip(const char *hostname, size_t bufsz, char *outbuf)
{
    struct sockaddr whereto;    /* who to ping */
    struct hostent *hp;
    struct sockaddr_in *to;
    //char hnamebuf[MAXHOSTNAMELEN];
    
    // precondition: minimal length for outbuf is 8 i.e. a string like "x.x.x.x"
    if (bufsz < 8 || hostname == NULL || strlen(hostname) == 0)
        return -1;
    
    // preparatory work
    bzero((char *)&whereto, sizeof(struct sockaddr));
    to = (struct sockaddr_in *)&whereto;
    to->sin_family = AF_INET;
    to->sin_addr.s_addr = inet_addr(hostname);
    if (to->sin_addr.s_addr != (u_int)-1)
    {
        // hostname is already an IP address!
        strncpy(outbuf, hostname, bufsz - 1);
    }
    else 
    {
        // we have to convert the address
        hp = gethostbyname(hostname);
        if (!hp) 
        {
            LOG("cutils_get_ip: unknown host %s", hostname);
            return CL_UNKNOWN_HOST;
        }
        to->sin_family = hp->h_addrtype;

        //bcopy(hp->h_addr_list[0], (caddr_t)&to->sin_addr, hp->h_length);
        //strncpy(outbuf, inet_ntoa(*(struct in_addr *)&to->sin_addr), bufsz);
        // avoid the 2 copy instructions above and just do it in one step
        strncpy(outbuf, inet_ntoa(*(struct in_addr*)hp->h_addr_list[0]), bufsz);
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



