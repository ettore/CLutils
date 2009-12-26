/*  $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#ifndef CL_CHANGEQ_INTERNAL_H_
#define CL_CHANGEQ_INTERNAL_H_

typedef struct cl_change_val    cl_change_val;
typedef struct cl_changeq_node  cl_changeq_node; 

typedef enum  {
    CL_CHAR,
    CL_INT,
    CL_DOUBLE,
    CL_PTR,
} cl_change_type;

#pragma mark -
#pragma mark CL_CHANGE_VAL class

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

cl_change cl_change_newc(const char *pr, char c);
cl_change cl_change_newl(const char *pr, long long n);
cl_change cl_change_newd(const char *pr, double p);
cl_change cl_change_newp(const char *pr, const void *p);

#pragma mark -
#pragma mark CL_CHANGE_NODE class

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

#endif
