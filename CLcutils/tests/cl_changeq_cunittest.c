/*
 *  cl_changeq_cunittest.c
 *  CLUtils
 *  Created by Ettore Pasquini on 12/20/09.
 *  Copyright 2009 Cubelogic. All rights reserved.
 */

#include <string.h>
#include <assert.h>
#include <cl_debug.h>
#include <CUnit/CUnit.h> // CUNIT: http://w3.scs.ryerson.ca/~schi/cps707/
#include "cl_changeq_cunittest.h"
#include "cl_changeq.h"

static void test_queue_wipe()
{
    cl_changeq *q = cl_changeq_new();
    const cl_change c1 = cl_changemake_d("char", 'a');
    const cl_change c2 = cl_changemake_d("int", 987654);
    const cl_change c3 = cl_changemake_d("double", 123456.0987);
    
    q->pushback(q, &c1);
    q->pushback(q, &c2);
    q->pushback(q, &c3);
    CU_ASSERT_FALSE(q->isempty(q));
    
    q->wipe(q);
    CU_ASSERT_TRUE(q->isempty(q));
    CU_ASSERT_PTR_NOT_NULL(q);
    CU_ASSERT_PTR_NULL(q->h);
    CU_ASSERT_PTR_NULL(q->t);
}

static void test_queue_ins_del_struct()
{
    cl_changeq *q = cl_changeq_new();
    struct stuff {
        char str[128];
        int num;
    } stuff;
    strncpy(stuff.str, "buongiorno sto cazzo", 128);
    stuff.num = 666;
    const cl_change c1 = cl_changemake_p("sticazzi", &stuff);
    
    // adding stuff pointer elem and removing it
    q->pushback(q, &c1);
    fprintf(stderr, "\n#### Q :"); cl_changeq_dump(q);
    fprintf(stderr, "\n#### c1:"); cl_change_dump(&c1);
    const cl_change c1_1 = q->pop(q);
    fprintf(stderr, "\n#### c1_1:"); cl_change_dump(&c1_1);
    CU_ASSERT_TRUE(memcmp(&c1, &c1_1, sizeof(cl_change)) == 0);
    CU_ASSERT_PTR_NOT_EQUAL(&c1, &c1_1);
    CU_ASSERT_TRUE(q->isempty(q));
}    

static void test_queue_ins_del()
{
    cl_changeq *q = cl_changeq_new();
    const cl_change c1 = cl_changemake_d("char", 'a');
    const cl_change c2 = cl_changemake_d("int", 987654);
    const cl_change c3 = cl_changemake_d("double", 123456.0987);
    
    // adding 1 elem and removing it
    q->pushback(q, &c1);
    CU_ASSERT_FALSE(q->isempty(q));
    fprintf(stderr, "\n#### Q:"); cl_changeq_dump(q);
    fprintf(stderr, "\n#### c1  :"); cl_change_dump(&c1);
    const cl_change c1_1 = q->pop(q);
    fprintf(stderr, "\n#### c1_1:"); cl_change_dump(&c1_1);
    CU_ASSERT_TRUE(memcmp(&c1, &c1_1, sizeof(cl_change)) == 0);
    CU_ASSERT_PTR_NOT_EQUAL(&c1, &c1_1);
    CU_ASSERT_TRUE(q->isempty(q));
    
    // adding 2 elem and removing them
    q->pushback(q, &c1);
    CU_ASSERT_FALSE(q->isempty(q));
    q->pushback(q, &c2);
    CU_ASSERT_FALSE(q->isempty(q));
    fprintf(stderr, "\n#### Q:"); cl_changeq_dump(q);
    const cl_change c1_2 = q->pop(q);
    fprintf(stderr, "\n#### c1_2:"); cl_change_dump(&c1_2);
    CU_ASSERT_FALSE(q->isempty(q));
    const cl_change c2_2 = q->pop(q);
    fprintf(stderr, "\n#### c2_2:"); cl_change_dump(&c2_2);
    CU_ASSERT_TRUE(memcmp(&c1, &c1_2, sizeof(cl_change)) == 0);
    CU_ASSERT_TRUE(memcmp(&c2, &c2_2, sizeof(cl_change)) == 0);
    CU_ASSERT_PTR_NOT_EQUAL(&c1, &c1_2);
    CU_ASSERT_PTR_NOT_EQUAL(&c2, &c2_2);
    CU_ASSERT_TRUE(q->isempty(q));
    
    // adding 3 elem and removing them
    q->pushback(q, &c3);
    CU_ASSERT_FALSE(q->isempty(q));
    q->pushback(q, &c2);
    CU_ASSERT_FALSE(q->isempty(q));
    q->pushback(q, &c1);
    CU_ASSERT_FALSE(q->isempty(q));
    fprintf(stderr, "\n#### Q:"); cl_changeq_dump(q);
    const cl_change c3_3 = q->pop(q);
    CU_ASSERT_FALSE(q->isempty(q));
    fprintf(stderr, "\n#### c3_3:"); cl_change_dump(&c3_3);
    const cl_change c2_3 = q->pop(q);
    CU_ASSERT_FALSE(q->isempty(q));
    fprintf(stderr, "\n#### c2_3:"); cl_change_dump(&c2_3);
    const cl_change c1_3 = q->pop(q);
    fprintf(stderr, "\n#### c1_3:"); cl_change_dump(&c1_3);
    CU_ASSERT_TRUE(memcmp(&c1, &c1_3, sizeof(cl_change)) == 0);
    CU_ASSERT_TRUE(memcmp(&c2, &c2_3, sizeof(cl_change)) == 0);
    CU_ASSERT_TRUE(memcmp(&c3, &c3_3, sizeof(cl_change)) == 0);
    CU_ASSERT_PTR_NOT_EQUAL(&c3, &c3_3);
    CU_ASSERT_PTR_NOT_EQUAL(&c2, &c2_3);
    CU_ASSERT_PTR_NOT_EQUAL(&c1, &c1_3);
    CU_ASSERT_TRUE(q->isempty(q));
}

static void test_queue_ins_c()
{
    cl_changeq *q = cl_changeq_new();
    cl_change c1 = cl_changemake_c("char", 'a');
    q->pushback(q, &c1);
    debug0msg("%s:%d:%c", q->t->change.prop, q->t->change.value.type, 
              q->t->change.value.u.c);
    CU_ASSERT_PTR_NOT_NULL(q->t);
    CU_ASSERT_PTR_EQUAL(q->h, q->t);
    //CU_ASSERT_PTR_NOT_NULL(q->t->change);
    CU_ASSERT_PTR_NOT_NULL(q->t->change.prop);
    CU_ASSERT_STRING_EQUAL("char", q->t->change.prop);
    CU_ASSERT_STRING_EQUAL(c1.prop, q->t->change.prop);
    CU_ASSERT_EQUAL(CL_CHAR, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.type, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.u.c, q->t->change.value.u.c);
    CU_ASSERT_EQUAL('a', q->t->change.value.u.c);
    
    q->destroy(q);
}

static void test_queue_ins_l()
{
    cl_changeq *q = cl_changeq_new();
    cl_change c1 = cl_changemake_l("width", 0x123456);
    q->pushback(q, &c1);
    debug0msg("%s:%d:%#x", q->t->change.prop, q->t->change.value.type, 
              (unsigned)q->t->change.value.u.l);
    CU_ASSERT_PTR_NOT_NULL(q->t);
    CU_ASSERT_PTR_EQUAL(q->h, q->t);
    CU_ASSERT_PTR_NOT_NULL(q->t->change.prop);
    CU_ASSERT_STRING_EQUAL("width", q->t->change.prop);
    CU_ASSERT_STRING_EQUAL(c1.prop, q->t->change.prop);
    CU_ASSERT_EQUAL(CL_INT, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.type, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.u.l, q->t->change.value.u.l);
    CU_ASSERT_EQUAL(0x123456, q->t->change.value.u.l);

    q->destroy(q);
}

static void test_queue_ins_d()
{
    cl_changeq *q = cl_changeq_new();
    cl_change c1 = cl_changemake_d("double", 123456.0987);
    q->pushback(q, &c1);
    debug0msg("%s:%d:%f", q->t->change.prop, q->t->change.value.type, 
              q->t->change.value.u.d);
    CU_ASSERT_PTR_NOT_NULL(q->t);
    CU_ASSERT_PTR_EQUAL(q->h, q->t);
    CU_ASSERT_PTR_NOT_NULL(q->t->change.prop);
    CU_ASSERT_STRING_EQUAL("double", q->t->change.prop);
    CU_ASSERT_STRING_EQUAL(c1.prop, q->t->change.prop);
    CU_ASSERT_EQUAL(CL_DOUBLE, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.type, q->t->change.value.type);
    CU_ASSERT_EQUAL(c1.value.u.d, q->t->change.value.u.d);
    CU_ASSERT_EQUAL(123456.0987, q->t->change.value.u.d);
    
    q->destroy(q);
}

static void test_queue_ins_p()
{
    struct stuff {
        char str[255];
        int num;
    } val;
    strncpy(val.str, "la logica dell'impossibile", 255);
    val.num = 666;
    cl_changeq *q = cl_changeq_new();
    cl_change ch = cl_changemake_p("stuff", &val);
    q->pushback(q, &ch);
    debug0msg("%s:%d:%p", q->t->change.prop, q->t->change.value.type, 
              q->t->change.value.u.p);
    debug0msg("%s %d", ((struct stuff *)q->t->change.value.u.p)->str, 
              ((struct stuff *)q->t->change.value.u.p)->num);
    CU_ASSERT_PTR_NOT_NULL(q->t);
    CU_ASSERT_PTR_EQUAL(q->h, q->t);
    CU_ASSERT_PTR_NOT_NULL(q->t->change.prop);
    CU_ASSERT_STRING_EQUAL("stuff", q->t->change.prop);
    CU_ASSERT_STRING_EQUAL(ch.prop, q->t->change.prop);
    CU_ASSERT_EQUAL(CL_PTR, q->t->change.value.type);
    CU_ASSERT_EQUAL(ch.value.type, q->t->change.value.type);
    CU_ASSERT_EQUAL(ch.value.u.p, q->t->change.value.u.p);
    
    CU_ASSERT_STRING_EQUAL("la logica dell'impossibile", 
                           ((struct stuff *)q->t->change.value.u.p)->str);
    CU_ASSERT_EQUAL(666, ((struct stuff *)q->t->change.value.u.p)->num);
    
    // verify we are not cloning the stuff, just storing the pointer
    CU_ASSERT_EQUAL(&val, q->t->change.value.u.p);
    CU_ASSERT_EQUAL(&val.str, 
                    &((struct stuff *)q->t->change.value.u.p)->str);
    // the 2nd memory cell of stuff.str has 'a', but the 2nd memory cell after
    // the value.u.p does not store the string, it simply points to it
    CU_ASSERT_EQUAL(*((char *)val.str + 1), 'a');
    // p1 points to (the cell storing) the u.p pointer
    char *p1 = (char *)&q->t->change.value.u.p;
    CU_ASSERT_NOT_EQUAL(*((char *)val.str + 1), *(p1 + 1));
//    fprintf(stderr, "### ");
//    for (int i=0; i < 20; i++) fprintf(stderr, "%c", *(p1 + i));
    
    q->destroy(q);
}

static void test_queue_ctor()
{
    cl_changeq *q = cl_changeq_new();
    CU_ASSERT_PTR_NOT_NULL(q);
    
    CU_ASSERT_PTR_NULL(q->h);
    CU_ASSERT_PTR_NULL(q->t);

    CU_ASSERT_PTR_NOT_NULL(q->destroy);
    CU_ASSERT_PTR_NOT_NULL(q->pop);
    CU_ASSERT_PTR_NOT_NULL(q->pushback);
    CU_ASSERT_PTR_NOT_NULL(q->wipe);
}

static void test_queue_destroy()
{
    cl_changeq *q = cl_changeq_new();
    debug0msg("size of q=%lu", sizeof(*q));
    CU_ASSERT_PTR_NOT_NULL(q);
    q->destroy(q);
}

int cl_funcommit_addtests()
{
    // create suite and add it to registry
    CU_pSuite s1 = CU_add_suite("funcommit", NULL, NULL);
    if (NULL == s1) {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    // add tests to suite
    if ((NULL == CU_add_test(s1, "ctor", test_queue_ctor))
        || (NULL == CU_add_test(s1, "dtor", test_queue_destroy))
        || (NULL == CU_add_test(s1, "ins char", test_queue_ins_c))
        || (NULL == CU_add_test(s1, "ins int", test_queue_ins_l))
        || (NULL == CU_add_test(s1, "ins double", test_queue_ins_d))
        || (NULL == CU_add_test(s1, "ins ptr to struct", test_queue_ins_p))
        || (NULL == CU_add_test(s1, "ins del", test_queue_ins_del))
        || (NULL == CU_add_test(s1, "ins del struct", test_queue_ins_del_struct))
        || (NULL == CU_add_test(s1, "ins wipe", test_queue_wipe))
        )
    {
        CU_cleanup_registry();
        return CU_get_error();
    }
    
    return 0;    
}
