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

 #import "BannerWindow.h"
#import "BannerView.h"

@implementation BannerWindow

- (id)initWithImagePath:(NSString *)inImagePath;
{
    // create the content view
    bannerView = [[BannerView alloc] initWithImagePath:inImagePath];

    // use NSBorderlessWindowMask so that the window doesn't have a title bar
    self = [super initWithContentRect:[bannerView frame]
                                   styleMask:NSBorderlessWindowMask 
                                     backing:NSBackingStoreBuffered 
                                       defer:NO];
    
    // Set the background color to clear so that (along with the setOpaque call 
    // below) we can see through the parts of the window that we're not 
    // drawing into
    [self setBackgroundColor: [NSColor clearColor]];
    
    // pull the window up to the front on top of other system windows.
    // This is how the Clock.app behaves; generally you wouldn't do 
    // this for windows unless you really wanted them to float above everything.
    [self setLevel: NSStatusWindowLevel];
    
    // no transparency
    [self setAlphaValue:1.0];

    // turn off opaqueness so that we can see through the parts of 
    // the window that we're not drawing into
    [self setOpaque:NO];
    
    // make sure the window has a shadow, which will automatically 
    // be the shape of our custom content.
    [self setHasShadow: YES];
    
    [self setContentView:bannerView];
    
    return self;
}

/*" This would be the initiliazer eventually called by IB. "*/
/*- (id)initWithContentRect:(NSRect)contentRect 
styleMask:(unsigned int)aStyle 
backing:(NSBackingStoreType)bufferingType 
defer:(BOOL)flag 
{
    return [self initWithContentSize:contentRect.size];
}*/

- (void)dealloc
{
    [bannerView release];
    [super dealloc];
}

/*" Custom windows that use the NSBorderlessWindowMask can't become key 
    by default. Therefore, controls in such windows won't ever be enabled 
    by default unless we override this method to change that. "*/
- (BOOL) canBecomeKeyWindow
{
    return YES;
}

/*" We override -mouseDown: and -mouseDragged: to allow for dragging the window 
    by clicking on its content area (since it doesn't have a title bar to drag).
    We start tracking the drag operation when the user first clicks the mouse, 
    to establish the initial location. "*/
- (void)mouseDown:(NSEvent *)theEvent
{    
    NSRect win_frm = [self frame];
    
    //grab the mouse location in global coordinates
    initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
    initialLocation.x -= win_frm.origin.x;
    initialLocation.y -= win_frm.origin.y;
}

/*" Since the window has no titlebar, we've to implement dragging ourselves. "*/
- (void)mouseDragged:(NSEvent *)theEvent
{
#pragma unused(theEvent)
    NSPoint curr_loc;
    NSPoint new_orig;
    NSRect  screen_frm = [[NSScreen mainScreen] frame];
    NSRect  win_frm = [self frame];

    // grab the current global mouse location; we could just as easily get 
    // the mouse location in the same way as we do in -mouseDown:
    curr_loc = [self convertBaseToScreen:
        [self mouseLocationOutsideOfEventStream]];
    new_orig.x = curr_loc.x - initialLocation.x;
    new_orig.y = curr_loc.y - initialLocation.y;
    
    // Don't let window get dragged up under the menu bar
    if( (new_orig.y + win_frm.size.height) > 
        (screen_frm.origin.y + screen_frm.size.height) )
    {
        new_orig.y = screen_frm.origin.y + (screen_frm.size.height - 
                                              win_frm.size.height);
    }
    
    //go ahead and move the window to the new location
    [self setFrameOrigin:new_orig];
}

@end
