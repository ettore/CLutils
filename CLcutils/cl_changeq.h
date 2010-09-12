/*  $Id$
 *  Created by Ettore Pasquini on 12/20/09.

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

#ifndef CL_CHANGEQ_H_
#define CL_CHANGEQ_H_

#ifndef OBJC_BOOL_DEFINED
#define OBJC_BOOL_DEFINED
typedef signed char		BOOL; 
#endif

// opaque datatypes, see cl_changeq_internals.h for implementation
typedef struct cl_change    cl_change;
typedef struct cl_changeq   cl_changeq;

#pragma mark -
#pragma mark CL_CHANGE class

cl_change   cl_change_make(const char *pr, const void *p);
const char *cl_change_getkey(const cl_change *ch);
const void *cl_change_getval(const cl_change *ch);

#pragma mark -
#pragma mark CL_CHANGEQ class

cl_changeq *cl_changeq_new(void);
BOOL        cl_changeq_isempty(const cl_changeq *q);
void        cl_changeq_pushback(cl_changeq *q, const cl_change *c);
cl_change   cl_changeq_pop(cl_changeq *q);
void        cl_changeq_wipe(cl_changeq *q);
void        cl_changeq_destroy(cl_changeq *q);

#pragma mark -
#pragma mark CL_CHANGEQ helpers

void cl_change_dump(const cl_change *ch);
void cl_changeq_dump(const cl_changeq *q);

#endif
