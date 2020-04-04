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
 
 @warning ** FOR ADVANCED USE ONLY **. Documentation will be provided upon request by the Forter team.
 */
@interface FTRSDKConfiguration : NSObject <NSCopying>

#pragma mark - SDK IDs storage
/** The Forter site ID (available in the Forter Portal) */
@property (nonatomic, nullable, copy) NSString *siteId;
/** Current user accountId. Please update using [ForterSDK setAccountIdentifier:withType:] with type `Merchant` */
@property (nonatomic, nullable, copy) NSString *currentAccountId;
/** Current device UID as used by you. Please update using [ForterSDK setDeviceUniqueIdentifier:] */
@property (nonatomic, nullable, copy) NSString *deviceUid;

#pragma mark - Provide information about the device
/** Provide us information about whether the device is jailbroken if possible */
@property (nonatomic, assign) BOOL isJailbroken;
/** Set this value to `TRUE` if this is the first time the user opened the app */
@property (nonatomic, assign) BOOL isFirstRun;
@property (nonatomic, nullable, copy) NSString *referralUrl;
/** Provide us the User-Agent for this device */
@property (nonatomic, nullable, copy) NSString *defaultUserAgent;

#pragma SDK behaviour
@property (nonatomic, assign) BOOL fetchRemoteConfiguration;
@property (nonatomic, nullable, copy) NSMutableDictionary *configurationValues;


/** Backward compatiability starts here: */
@property (nonatomic, readonly) NSUInteger bufferMaxEvents;
@property (nonatomic, readonly) NSUInteger bufferMaxEventSizeBytes;
@property (nonatomic, readonly) NSUInteger eventMaxAgeSeconds;
@property (nonatomic, readonly) NSUInteger networkSubmitIntervalSeconds;
@property (nonatomic, readonly) NSString* baseApiUrl;
@property (nonatomic, readonly) NSString* errorReportingUrl;

@property (nonatomic, readonly) NSUInteger networkMaxRetries;
@property (nonatomic, readonly) NSUInteger networkInitialSocketTimeout;
@property (nonatomic, readonly) NSUInteger networkBackoffMultiplier;
@property (nonatomic, readonly) NSUInteger eventCacheForSeconds;
@property (nonatomic, readonly) BOOL eventCachingEnabled;
@property (nonatomic, readonly) BOOL networkExplicitBufferSubmission;
@property (nonatomic, readonly) int logLevel;
@property (nonatomic, readonly) BOOL forceGETRequest;
@property (nonatomic, readonly) BOOL shouldCompress;

@end

NS_ASSUME_NONNULL_END
/* FTRSDKConfiguration_h */
