/*  $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
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
