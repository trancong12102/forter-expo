//
//  ForterSDKConfiguration.h
//  ForterSDK
//
//  Created by Or Polaczek on 03/07/2016.
//  Copyright © 2016 Forter. All rights reserved.
//

#pragma once
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 
 Forter SDK configuration class.
 
 @warning ** FOR ADVANCED USED ONLY **. Documentation will be provided upon request by the Forter team.
 */
@interface FTRSDKConfiguration : NSObject <NSCopying>


#pragma mark - SDK IDs storage
/** The Forter site ID (available in the Forter Portal) */
@property (nonatomic, nullable, copy) NSString *siteId;
/** Current user accountId. Please update using [ForterSDK setAccountIdentifier:withType:] with type `Merchant` */
@property (nonatomic, nullable, copy) NSString *currentAccountId;
/** Current device UID as used by you. Please update using [ForterSDK setDeviceUniqueIdentifier:] */
@property (nonatomic, nullable, copy) NSString *deviceUid;

#pragma mark - Event buffering settings
@property (nonatomic, assign) NSUInteger bufferMaxEvents;
@property (nonatomic, assign) NSUInteger bufferMaxEventSizeBytes;
@property (nonatomic, assign) NSUInteger eventMaxAgeSeconds;
@property (nonatomic, assign) NSUInteger networkSubmitIntervalSeconds;
@property (nonatomic, assign) NSUInteger networkMaxRetries;
@property (nonatomic, assign) NSUInteger networkInitialSocketTimeout;
@property (nonatomic, assign) NSUInteger networkBackoffMultiplier;
@property (nonatomic, assign) NSUInteger eventCacheForSeconds;
@property (nonatomic, assign) BOOL eventCachingEnabled;

/** This value is `FALSE` by default. Please consult with Forter's mobile team if you wish to change it's value. */
@property (nonatomic, assign) BOOL networkExplicitBufferSubmission;

#pragma mark - Provide information about the device
/** Provide us information about whether the device is jailbroken if possible */
@property (nonatomic, assign) BOOL isJailbroken;
/** Set this value to `TRUE` if this is the first time the user opened the app */
@property (nonatomic, assign) BOOL isFirstRun;
@property (nonatomic, nullable, copy) NSString *referralUrl;
/** Provide us the User-Agent for this device */
@property (nonatomic, nullable, copy) NSString *defaultUserAgent;

#pragma mark MISC
@property (nonatomic, assign) int logLevel;
@property (nonatomic, assign) BOOL forceGETRequest;
@property (nonatomic, assign) BOOL shouldCompress;

@end

NS_ASSUME_NONNULL_END
/* FTRSDKConfiguration_h */
