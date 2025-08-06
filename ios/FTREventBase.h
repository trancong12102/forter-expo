//
//  FTRBaseEvent.h
//  ForterSDK
//
//  Created by Or Polaczek on 03/07/2016.
//  Copyright © 2016 Forter. All rights reserved.
//
#pragma once

#import <Foundation/Foundation.h>


@class FTRRTFeature;
@class FTRRTFeatureFlag;

@protocol FTREventBase <NSObject>

@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, assign) NSUInteger retriesCount;
@property (nonatomic, assign) NSUInteger currentSocketTimeoutMs;
@property (nonatomic, assign) int64_t creationTimestamp;
@property (nonatomic, copy) NSData *processedEventBody;
@property (nonatomic, copy) NSString *processedUrl;
@property (nonatomic, copy) FTRRTFeature *featureFlags;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy) NSString *signature;

#pragma mark - init
- (id)init;

#pragma mark - Get event data
- (NSDictionary *)eventDataDictionary;
- (NSMutableDictionary *)toDictionary;
- (void)selfPopulateProperties;
- (NSString *)cacheKey;
- (NSString *)cacheData;
//- (NSString *)eventType;

@end


@interface FTREventBase : NSObject <FTREventBase>

@property (nonatomic, copy)NSDictionary *eventData;
@property (nonatomic, readonly, copy) NSString *eventType;
@property (nonatomic, assign) NSUInteger retriesCount;
@property (nonatomic, assign) NSUInteger currentSocketTimeoutMs;
@property (nonatomic, assign) int64_t creationTimestamp;
@property (nonatomic, copy) NSData *eventBody;
@property (nonatomic, copy) NSData *compressedEventBody;
@property (nonatomic, copy) NSString *processedUrl;
@property (nonatomic, copy) FTRRTFeature *featureFlags;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy) NSString *signature;
@end
