/*  $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 *
 *  Dependencies: cl_changeq.h
 */

#ifndef CL_CHANGEQ_INTERNAL_H_
#define CL_CHANGEQ_INTERNAL_H_

#pragma mark -

//struct cl_change_val 
//{
//    const cl_change_type type;
//    const union {
//        char c;
//        long long l;
//        double d;
//        void *p;
//    } u;
//};
//typedef struct cl_change_val    cl_change_val;
//cl_change cl_change_makec(const char *pr, char c);
//cl_change cl_change_makel(const char *pr, long long n);
//cl_change cl_change_maked(const char *pr, double p);

typedef void*   cl_change_val;

struct cl_change 
{
    const char *prop;
    const void *value;
};

#pragma mark -

typedef struct cl_changeq_node  cl_changeq_node; 
struct cl_changeq_node 
{
    cl_change change;
    cl_changeq_node *next;
};

#pragma mark -

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
