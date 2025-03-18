//
#pragma once
//  SessionPhaseStatus.h
//  ForterSDK
//
//  Created by Dor Brauner on 18/03/2025.
//  Copyright © 2025 Forter. All rights reserved.
//

#import <Foundation/Foundation.h>

// Manually defining this enum in Objective-C to avoid incorrect conversion in ForterSDK-Swift.h,
// which occurs due to conflicts with ForterSDK.h.
typedef NS_ENUM(NSInteger, SessionPhaseStatus) {
    SessionPhaseStatusSucceeded = 4,
    SessionPhaseStatusFailed = 9
};



