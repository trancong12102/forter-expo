#pragma once
#if __has_include(<React/RCTBridgeModule.h>) //ver >= 0.40
#import <React/RCTBridgeModule.h>
#else //ver < 0.40
#import "RCTBridgeModule.h"
#endif

@interface RNForter : NSObject <RCTBridgeModule>

@end


