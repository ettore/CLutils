/*
 *  cl_phone_utils.h
 *  CLUtils
 *
 *  Created by Ettore Pasquini on 7/25/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
 *
 */

#include <CoreFoundation/CoreFoundation.h>

@class UIView;

// send an email to Cubelogic Support (support@cubelogic.org)
void CLSupportSendEmail(CFStringRef subject, CFStringRef body);

void debugViewFrame(char *label, UIView *a_view);
