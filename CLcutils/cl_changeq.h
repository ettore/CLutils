/*  cl_changeq.h
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

struct cl_changeq 
{
    cl_changeq_node *h;
    cl_changeq_node *t;
    
    BOOL (*isempty)(const cl_changeq *q);
    void (*push)(cl_changeq *q, const cl_change *change);
    cl_change (*get)(cl_changeq *q);
    void (*wipe)(cl_changeq *q);
    void (*destroy)(cl_changeq *q);
};

cl_changeq *cl_changeq_new();

// helpers
void cl_changeq_dump(cl_changeq *q);
void cl_change_dump(const cl_change *ch);
cl_change cl_changemake_c(const char *pr, char c);
cl_change cl_changemake_l(const char *pr, long long n);
cl_change cl_changemake_d(const char *pr, double p);
cl_change cl_changemake_p(const char *pr, const void *p);

#endif
