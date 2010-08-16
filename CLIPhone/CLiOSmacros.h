/*  CLiOSmacros.h
 *  CLUtils
 *  Created by Ettore Pasquini on 8/15/10.
 *  Copyright 2010 Cubelogic. All rights reserved.
 */

// -----------------------------------------------------------------------------
//
// From Cocoa with Love: Conditional iOS3 / iOS 4 code
// http://cocoawithlove.com/2010/07/tips-tricks-for-conditional-ios3-ios32.html
//
// Use the kCFCoreFoundationVersionNumber to determine the iPhone OS at runtime.
// There are many examples using [[UIDevice currentDevice] systemVersion] but 
// that method requires a string comparison and potentially handling of major 
// and minor numbers within the string components. A single double comparison 
// is far more straightforward.
//
// These definitions may not be in every version of the SDK so you should 
// conditionally define them yourself in case they're missing. 
// 
// -----------------------------------------------------------------------------

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_0 478.23
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_1 478.26
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_2_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_2_2 478.29
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_0 478.47
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_1
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_1 478.52
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_3_2
#define kCFCoreFoundationVersionNumber_iPhoneOS_3_2 478.61
#endif

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif

//
// kCFCoreFoundationVersionNumber is an exported double defined inside the 
// CF lib of the running system. So this is a runtime check equivalent to:
// if ([[UIApplication sharedApplication] respondsToSelector:@selector(mysel:)])
// 
// ep:
// These conditions were extracted from the original macros from Cocoa With Love
// which you can find just below these. I find them easier to use since you can
// write normal looking C code instead of stuff like:
// IF_IOS4_OR_GREATER
// (
//   <code>
// )
// Note: use RUNNING_PRE_IOS_4 to refer something not available in IOS4
// 
#define RUNNING_IOS_4_OR_GREATER \
(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0)
#define RUNNING_IOS_3_2_OR_GREATER \
(kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_3_2)
#define RUNNING_PRE_IOS_4 \
(kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_4_0)

// original macros from Cocoa with Love
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS4_OR_GREATER(...) \
if (RUNNING_IOS_4_OR_GREATER) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS4_OR_GREATER(...)
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#define IF_3_2_OR_GREATER(...) \
if (RUNNING_IOS_3_2_OR_GREATER) \
{ \
__VA_ARGS__ \
}
#else
#define IF_3_2_OR_GREATER(...)
#endif
#define IF_PRE_IOS4(...) \
if (RUNNING_PRE_IOS_4) \
{ \
__VA_ARGS__ \
}

// -----------------------------------------------------------------------------





















