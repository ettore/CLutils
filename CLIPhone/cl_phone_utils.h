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

// init logging on device to be inside <appname>/Documents/<logname>.log
// You can download the logs by going to Organizer > Summary > disclose your app
// under Applications, download the "Application Data"
void init_ios_logging(CFStringRef appname, CFStringRef logname);

// redirect console log to a file. Useful to debug apps when phone not connected
// to debugger, so you later read the console log
void redirect_stderr(CFStringRef logname);

BOOL isIPad();

// send an email to Cubelogic Support (support@cubelogic.org)
void CLSupportSendEmail(CFStringRef subject, CFStringRef body);

void debugViewFrame(char *label, UIView *a_view);
