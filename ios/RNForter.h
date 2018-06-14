
#if __has_include(<React/RCTBridgeModule.h>) //ver >= 0.40
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#else //ver < 0.40
#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
#endif



@interface RNForter : NSObject <RCTBridgeModule>

@end


