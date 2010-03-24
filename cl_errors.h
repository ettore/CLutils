/*  cl_errors.h
 *  Created by Ettore Pasquini on 5/3/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#ifndef CL_ERRORS_H_
#define CL_ERRORS_H_

typedef int CL_ERROR;

#define CL_OK                   0
#define CL_BUSY                 -1000
#define CL_CNX_UNAVAILABLE      -1001
#define CL_UNKNOWN_HOST         -1002

#define CL_APP_ERR              -1

typedef enum {
    CL_TWITPIC_API_ERR      = -444000,
    CL_TWITPIC_HTTP_ERR     = -444001,
    CL_TWITPIC_PARSE_ERR    = -444002,
    CL_TWITPIC_LOGIN_ERR    = -444003
} CLTwitPicError;


#endif
