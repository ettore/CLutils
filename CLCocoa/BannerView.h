#import <Cocoa/Cocoa.h>

@interface BannerView : NSView
{
    // the image filling up the entire view. It is owned by the view.
    NSImage *bannerImage;
}

- (id)initWithImagePath:(NSString *)fullOrRelativePath;
- (id)initWithImagePathUTF8:(const char *)fullOrRelativeUTF8Path;

@end
