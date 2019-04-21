#import "RNForter.h"
#if __has_include(<ForterSDK/ForterSDK.h>) // from Pod
#import <ForterSDK/ForterSDK.h>
#else
#import "ForterSDK.h"
#endif

@implementation RNForter
RCT_EXPORT_MODULE();

- (id)init {
    self = [super init];
    if (self != nil) {
        NSLog(@"[ForterSDK] Setting up an RNForter instance");
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

static NSString *const NO_SITE_ID_FOUND             = @"SiteID is empty or missing";
static NSString *const NO_MOBILE_UID_FOUND          = @"MobileUID is empty or missing";
static NSString *const SUCCESS                      = @"Success";

RCT_EXPORT_METHOD(initSdk:(NSString*)siteId
                  mobileUid:(NSString*)mobileUid
                  successCallback:(RCTResponseSenderBlock)successCallback
                  errorCallback:(RCTResponseErrorBlock)errorCallback) {
  NSError* error = nil;
  
  if (!siteId || [siteId isEqualToString:@""]) {
      error = [NSError errorWithDomain:NO_SITE_ID_FOUND code:0 userInfo:nil];
    
  } else if (!mobileUid || [mobileUid isEqualToString:@""]) {
      error = [NSError errorWithDomain:NO_MOBILE_UID_FOUND code:1 userInfo:nil];
  }

  if (error != nil) {
    errorCallback(error);
  } else {
    [ForterSDK setupWithSiteId:siteId];
    [[ForterSDK sharedInstance] setDeviceUniqueIdentifier:mobileUid];
    successCallback(@[SUCCESS]);
  }
}

RCT_EXPORT_METHOD(getDeviceUniqueID:(RCTResponseSenderBlock)callback) {
  dispatch_async(dispatch_get_main_queue(), ^{
    callback(@[[[[UIDevice currentDevice] identifierForVendor] UUIDString]]);
  });
}

RCT_EXPORT_METHOD(setAccountIdentifier:(NSString*)accountId
                  withAccountType:(NSString*)accountType) {
  FTRSDKAccountIdType sdkAccountType = [self getMatchingAccountType:accountType];
  [[ForterSDK sharedInstance] setAccountIdentifier:accountId withType:sdkAccountType];
}

RCT_EXPORT_METHOD(trackNavigation:(NSString*)screenName
                  navigationType:(NSString*)navigationType) {
  FTRSDKNavigationType sdkNavigationType = [self getMatchingNavigationType:navigationType];
  [[ForterSDK sharedInstance] trackNavigation:screenName withType:sdkNavigationType];
}

RCT_EXPORT_METHOD(trackNavigationWithExtraData:(NSString*)screenName
                  navigationType:(NSString*)navigationType
                  itemId:(NSString*)itemId
                  itemCategory:(NSString*)itemCategory
                  otherInfo:(NSString*)otherInfo) {
  FTRSDKNavigationType sdkNavigationType = [self getMatchingNavigationType:navigationType];
  [[ForterSDK sharedInstance] trackNavigation:screenName withType:sdkNavigationType pageId:itemId pageCategory:itemCategory otherInfo:otherInfo];
}

RCT_EXPORT_METHOD(trackAction:(NSString*)actionType) {
  FTRSDKActionType sdkActionType = [self getMatchingActionType:actionType];
  [[ForterSDK sharedInstance] trackAction:sdkActionType];
}

RCT_EXPORT_METHOD(trackActionWithMessage:(NSString*)actionType
                  message:(NSString*)message) {
  FTRSDKActionType sdkActionType = [self getMatchingActionType:actionType];
  [[ForterSDK sharedInstance] trackAction:sdkActionType withMessage:message];
}

RCT_EXPORT_METHOD(trackActionWithJSON:(NSString*)actionType
                  json:(NSDictionary*)json) {
  FTRSDKActionType sdkActionType = [self getMatchingActionType:actionType];
  [[ForterSDK sharedInstance] trackAction:sdkActionType withData:json];
}

RCT_EXPORT_METHOD(trackCurrentLocation:(float)longitude
                  latitude:(float)latitude) {
  [[ForterSDK sharedInstance] didUpdateLocationLatitude:latitude longitude:longitude altitude:0.0];
}

RCT_EXPORT_METHOD(setDevLogsEnabled) {
  [ForterSDK setDevLogsEnabled:TRUE];
}

RCT_EXPORT_METHOD(getSDKVersionSignature:(RCTResponseSenderBlock)callback) {
  callback(@[[NSNull null], [ForterSDK getSDKVersionSignature]]);
}

- (FTRSDKActionType)getMatchingActionType:(NSString *)forString {
  if ([forString isEqualToString:@"TAP"]) {
    return FTRSDKActionTypeTap;
  } else if ([forString isEqualToString:@"CLIPBOARD"]) {
    return FTRSDKActionTypeClipboard;
  } else if ([forString isEqualToString:@"TYPING"]) {
    return FTRSDKActionTypeTyping;
  } else if ([forString isEqualToString:@"ADD_TO_CART"]) {
    return FTRSDKActionTypeAddToCart;
  } else if ([forString isEqualToString:@"REMOVE_FROM_CART"]) {
    return FTRSDKActionTypeRemoveFromCart;
  } else if ([forString isEqualToString:@"ACCEPTED_PROMOTION"]) {
    return FTRSDKActionTypeAcceptedPromotion;
  } else if ([forString isEqualToString:@"ACCEPTED_TOS"]) {
    return FTRSDKActionTypeAcceptedTos;
  } else if ([forString isEqualToString:@"ACCOUNT_LOGIN"]) {
    return FTRSDKActionTypeAccountLogin;
  } else if ([forString isEqualToString:@"ACCOUNT_LOGOUT"]) {
    return FTRSDKActionTypeAccountLogout;
  } else if ([forString isEqualToString:@"ACCOUNT_ID_ADDED"]) {
    return FTRSDKActionTypeAccountIdAdded;
  } else if ([forString isEqualToString:@"PAYMENT_INFO"]) {
    return FTRSDKActionTypePaymentInfo;
  } else if ([forString isEqualToString:@"SHARE"]) {
    return FTRSDKActionTypeShare;
  } else if ([forString isEqualToString:@"CONFIGURATION_UPDATE"]) {
    return FTRSDKActionTypeConfigurationUpdate;
  } else if ([forString isEqualToString:@"APP_ACTIVE"]) {
    return FTRSDKActionTypeAppActive;
  } else if ([forString isEqualToString:@"APP_PAUSE"]) {
    return FTRSDKActionTypeAppPause;
  } else if ([forString isEqualToString:@"RATE"]) {
    return FTRSDKActionTypeRate;
  } else if ([forString isEqualToString:@"IS_JAILBROKEN"]) {
    return FTRSDKActionTypeIsJailbroken;
  } else if ([forString isEqualToString:@"SEARCH_QUERY"]) {
    return FTRSDKActionTypeSearchQuery;
  } else if ([forString isEqualToString:@"REFERRER"]) {
    return FTRSDKActionTypeReferrer;
  } else if ([forString isEqualToString:@"WEBVIEW_TOKEN"]) {
    return FTRSDKActionTypeWebviewToken;
  } else {
    return FTRSDKActionTypeOther;
  }
}

- (FTRSDKNavigationType)getMatchingNavigationType:(NSString *)forString {
  if ([forString isEqualToString:@"PRODUCT"]) {
    return FTRSDKNavigationTypeProduct;
  } else if ([forString isEqualToString:@"ACCOUNT"]) {
    return FTRSDKNavigationTypeAccount;
  } else if ([forString isEqualToString:@"SEARCH"]) {
    return FTRSDKNavigationTypeSearch;
  } else if ([forString isEqualToString:@"CHECKOUT"]) {
    return FTRSDKNavigationTypeCheckout;
  } else if ([forString isEqualToString:@"CART"]) {
    return FTRSDKNavigationTypeCart;
  } else if ([forString isEqualToString:@"HELP"]) {
    return FTRSDKNavigationTypeHelp;
  } else {
    return FTRSDKNavigationTypeApp;
  }
}

- (FTRSDKAccountIdType)getMatchingAccountType:(NSString *)forString {
  if ([forString isEqualToString:@"MERCHANT"]) {
    return FTRSDKAccountIdTypeMerchant;
  } else if ([forString isEqualToString:@"FACEBOOK"]) {
    return FTRSDKAccountIdTypeFacebook;
  } else if ([forString isEqualToString:@"GOOGLE"]) {
    return FTRSDKAccountIdTypeGoogle;
  } else if ([forString isEqualToString:@"TWITTER"]) {
    return FTRSDKAccountIdTypeTwitter;
  } else if ([forString isEqualToString:@"APPLE_IDFA"]) {
    return FTRSDKAccountIdTypeAppleIDFA;
  } else {
    return FTRSDKAccountIdTypeOther;
  }
}

@end
