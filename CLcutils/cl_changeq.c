/*  $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <stdlib.h>
#include <cl_debug.h>
#include "cl_changeq.h"
#include "cl_changeq_internal.h"

////////////////////////////////////////////////////////////////////////////////
// HELPERS
////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helpers

void cl_change_dump(const cl_change *ch)
{
    fprintf(stderr, "{%s:%p}", ch->prop, ch->value);
}

//static const char *cl_changeq_ts(cl_changeq *q)
void cl_changeq_dump(const cl_changeq *q)
{
    LOG("cl_changeq DUMP: [");
    if (q == NULL)
        goto fine;
    
    cl_changeq_node *np = q->h;
    while (np)
    {
        cl_change_dump(&np->change);
        if (np->next)
            fprintf(stderr, ", ");
        
        np = np->next;
    }
fine:    
    fprintf(stderr, "]");
}

////////////////////////////////////////////////////////////////////////////////
// CL_CHANGE API
////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CL_CHANGE 

cl_change cl_change_make(const char *pr, const void *val)
{
    const cl_change ch = {pr, val};
    return ch;
}

const char *cl_change_getkey(const cl_change *ch)
{
    return ch->prop;
}

const void *cl_change_getval(const cl_change *ch)
{
    return ch->value;
}

//cl_change cl_change_makec(const char *pr, char c)
//{
//    cl_change_val val = {CL_CHAR, c};
//    const cl_change ch = {pr, val};
//    return (const cl_change)ch;
//}
//
//cl_change cl_change_makel(const char *pr, long long n)
//{
//    cl_change_val val;
//    cl_change_type *tp = (cl_change_type*)&val.type;
//    long long *lp = (long long *)&val.u.l;
//    *tp = CL_INT;
//    *lp = n;
//    const cl_change ch = {pr, val};
//    return ch;
//}
//
//cl_change cl_change_maked(const char *pr, double d)
//{
//    cl_change_val val;
//    cl_change_type *tp = (cl_change_type*)&val.type;
//    double *dp = (double *)&val.u.d;
//    *tp = CL_DOUBLE;
//    *dp = d;
//    const cl_change ch = {pr, val};
//    return ch;
//}

////////////////////////////////////////////////////////////////////////////////
// CL_CHANGEQ PUBLIC API
////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark CL_CHANGEQ Public API

/*
        H                    T
        1st       2nd       3rd
           --next-^  --next-^  --next=NULL
            
 */

void cl_changeq_pushback(cl_changeq *q, const cl_change *c)
{
    cl_changeq_node *np = (cl_changeq_node*)malloc(sizeof(cl_changeq_node));
    
    memcpy(&np->change, c, sizeof(cl_change));
    //np->change = c;

    np->next = NULL;
    if (q->t)
        q->t->next = np;
    
    q->t = np;
    if (q->h == NULL)
        q->h = np;
}

// client has to check for queue not null
cl_change cl_changeq_pop(cl_changeq *q)
{
    cl_change c;
    
    memcpy(&c, &q->h->change, sizeof(cl_change));
    
    q->h = q->h->next;
    if (q->h == NULL)
        q->t = NULL;
    
    return c;
}

BOOL cl_changeq_isempty(const cl_changeq *q)
{
    return (q->h == NULL);
}

void cl_changeq_wipe(cl_changeq *q)
{
    if (q == NULL)
        return;
    
    cl_changeq_node *np;
    while (q->h)
    {
        np = q->h->next;
        free(q->h);
        q->h = np;
    }
    
    q->h = q->t = NULL;
}

void cl_changeq_destroy(cl_changeq *q)
{
    cl_changeq_wipe(q);
    free(q);
}

cl_changeq *cl_changeq_new(void)
{
    cl_changeq *q = (cl_changeq *)malloc(sizeof(cl_changeq));
    q->h = q->t = NULL;
    
    /*  
     The nested function can access all the variables of the containing 
     function that are visible at the point of its definition (lexical scoping).
     If you try to call the nested function through its address after the 
     containing function has exited, all hell will break loose. If you try to 
     call it after a containing scope level has exited, and if it refers to some 
     of the variables that are no longer in scope, you may be lucky, but it's 
     not wise to take the risk. If, however, the nested function does not refer 
     to anything that has gone out of scope, you should be safe.
     */
    //    void destroy()
    //    {
    //        cl_changeq_destroy(q); //FAIL q is out of scope
    //    }
    //    q->destroy = destroy;
    
    q->isempty = cl_changeq_isempty;
    q->pushback = cl_changeq_pushback;
    q->pop = cl_changeq_pop;
    q->wipe = cl_changeq_wipe;
    q->destroy = cl_changeq_destroy;
    
    return q;
}
