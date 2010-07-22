//  Copyright 2008 Cubelogic. All rights reserved.

#ifndef CL_GEN_UTILS_H_
#define CL_GEN_UTILS_H_

typedef double CLTimestamp;

// returns seconds since Epoch
CLTimestamp timestampSinceEpoch();

// send an email to Cubelogic Support (support@cubelogic.org)
void CLSupportSendEmail(CFStringRef subject, CFStringRef body);

#endif
