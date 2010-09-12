/*
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

#import "BannerView.h"

@implementation BannerView

- (id)initWithImagePathUTF8:(const char *)imgPath
{
    NSString *path = [[NSString alloc] initWithUTF8String:imgPath];
    self = [self initWithImagePath:path];
    [path release];
    return self;
}

- (id)initWithImagePath:(NSString *)inImagePath
{
    NSRect content_r;
    NSRect screen_r = [[NSScreen mainScreen] frame];

    //load the images we'll use from the bundle's Resources directory
    bannerImage = [[NSImage alloc] initWithContentsOfFile:inImagePath];
    
    // calc frame size and origin
    NSSize img_sz = [bannerImage size];
    content_r.size.width  = img_sz.width;
    content_r.size.height = img_sz.height;
    content_r.origin.x = screen_r.size.width/2 - (content_r.size.width - 1)/2;
    content_r.origin.y = screen_r.size.height/2 - (content_r.size.height - 1)/2;
    
    if ((self = [super initWithFrame:content_r]) == nil) 
        return nil;

    [self setNeedsDisplay:YES];
    return self;
}

- (void)dealloc
{
    [bannerImage release];
    [super dealloc];
}

// Assumptions: this view is inside the window, the window's opaqueness has been
// turned off, the window's styleMask was set to NSBorderlessWindowMask on 
// creation. So, what this view draws is all the user sees of the window. 
- (void)drawRect:(NSRect)rect
{
#pragma unused(rect)
    // fill with "clear" color, so that any images we draw are the custom 
    // shape of the window. Erases whatever graphics were there before.
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    
    // If we called -disolveToPoint:fraction: instead of 
    // -compositeToPoint:operation:, then the image could itself be drawn
    // with less than full opaqueness, but since we're already setting the alpha
    // on the entire window, we don't bother with that here.
    [bannerImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
    
    // reset the CoreGraphics window shadow 
    // (calculated around our custom window shape content)
    // so it's recalculated for the new shape
    if (floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_1)
    {
        [[self window] setHasShadow:NO];
        [[self window] setHasShadow:YES];
    }
    else
        [[self window] invalidateShadow];
}

@end
