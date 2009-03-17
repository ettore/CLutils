#import <Cocoa/Cocoa.h>

@interface BannerWindow : NSWindow
{
    // Used for dragging to mark the initial click location
    NSPoint initialLocation; 
    
    // the view, owned by this class
    NSView *bannerView;
}

- (id)initWithImagePath:(NSString *)fullOrRelativePath;

@end
