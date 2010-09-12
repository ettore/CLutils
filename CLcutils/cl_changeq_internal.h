/*  $Id$
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 *
 *  Dependencies: cl_changeq.h

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
