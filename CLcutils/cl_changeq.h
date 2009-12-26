/*  cl_changeq.h $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#ifndef CL_CHANGEQ
#define CL_CHANGEQ

#ifndef OBJC_BOOL_DEFINED
#define OBJC_BOOL_DEFINED
typedef signed char		BOOL; 
#endif

/* exported types */

typedef struct cl_change_val cl_change_val;
typedef struct cl_change   cl_change;
typedef struct cl_changeq cl_changeq;
typedef struct cl_changeq_node cl_changeq_node; 

/* type declarations */

typedef enum  {
    CL_CHAR,
    CL_INT,
    CL_DOUBLE,
    CL_PTR,
} cl_change_type;

struct cl_change_val 
{
    const cl_change_type type;
    const union {
        char c;
        long long l;
        double d;
        void *p;
    } u;
};

struct cl_change 
{
    const char *prop;
    const cl_change_val value;
};

struct cl_changeq_node 
{
    cl_change change;
    cl_changeq_node *next;
};

#pragma mark -
#pragma mark CL_CHANGEQ class

struct cl_changeq 
{
    cl_changeq_node *h;
    cl_changeq_node *t;
    
    // we need this only in case we decide to implement polymorphism
    BOOL (*isempty)(const cl_changeq *this);
    void (*pushback)(cl_changeq *this, const cl_change *change);
    cl_change (*pop)(cl_changeq *this);
    void (*wipe)(cl_changeq *this);
    void (*destroy)(cl_changeq *this);
};

cl_changeq *cl_changeq_new();
BOOL        cl_changeq_isempty(const cl_changeq *q);
void        cl_changeq_pushback(cl_changeq *q, const cl_change *c);
cl_change   cl_changeq_pop(cl_changeq *q);
void        cl_changeq_wipe(cl_changeq *q);
void        cl_changeq_destroy(cl_changeq *q);

#pragma mark -
#pragma mark CL_CHANGEQ helpers

// helpers
void cl_change_dump(const cl_change *ch);
void cl_changeq_dump(const cl_changeq *q);
cl_change cl_changemake_c(const char *pr, char c);
cl_change cl_changemake_l(const char *pr, long long n);
cl_change cl_changemake_d(const char *pr, double p);
cl_change cl_changemake_p(const char *pr, const void *p);

#endif
