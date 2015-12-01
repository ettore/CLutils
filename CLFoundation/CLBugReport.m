/*
 //  Created by Ettore Pasquini on 4/24/10.

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

#import "CLBugReport.h"

@implementation CLBugReport

- (id)initWithCode:(NSInteger)code
        competency:(NSString*)compet
     functionality:(NSString*)func
           userMsg:(NSString*)umsg
              info:(NSString*)infomsg
{
  if ((self = [super init]))
  {
    competency = compet;
    functionality = func;
    errorCode = code;
    userMsg = umsg;
    info = infomsg;
    if (competency)
      [competency retain];
    if (functionality)
      [functionality retain];
    if (userMsg)
      [userMsg retain];
    if (info)
      [info retain];
  }
  return self;
}

- (NSString *)subject
{
  return functionality;
}

- (NSString *)body
{
  NSString *s;
  s = [NSString stringWithFormat:@"ErrorCode = %ld\n\nInfo =\n%@\n",
       (long)errorCode, info];

  if (competency)
    s = [NSString stringWithFormat:@"Competency = %@\n\n%@", competency, s];

  if (userMsg)
    s = [NSString stringWithFormat:@"UserMsg =\n%@\n\n%@", userMsg, s];

  return s;
}

- (NSString *)description
{
  NSString *s;
  s = [NSString stringWithFormat:@"Subject=%@\n\n%@",
       [self subject], [self body]];
  return s;
}

- (void)dealloc
{
  [competency release];
  [functionality release];
  [userMsg release];
  [info release];
  [super dealloc];
}

@end
