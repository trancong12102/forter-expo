//
//  FTRSDKPublicConstants.h
//  ForterSDK
//
//  Created by Or Polaczek on 28/08/2016.
//  Copyright © 2016 Forter. All rights reserved.
//

#pragma once

#define FTR_SDK_VERSION_STRING_NAME @"3.1.0"
#define FTR_SDK_VERSION_STRING_BUILD @"1"
#define FTR_SDK_VERSION_SIGNATURE @"cdee73c61819cc60bbf5fa710769b717"
#define FTR_SDK_UI_KIT_DEPENDENCY_ENABLED 1

/** 
 Navigation type to be used when tracking navigation using [ForterSDK trackNavigation:withType:]
 */
typedef NS_ENUM(NSUInteger, FTRSDKNavigationType) {
  FTRSDKNavigationTypeProduct,
  FTRSDKNavigationTypeAccount,
  FTRSDKNavigationTypeSearch,
  FTRSDKNavigationTypeCheckout,
  FTRSDKNavigationTypeCart,
  FTRSDKNavigationTypeApp,
  FTRSDKNavigationTypeHelp
};

/**
 Track type to be used when tracking user behaviour using [ForterSDK trackAction:]
 */
typedef NS_ENUM(NSUInteger, FTRSDKActionType) {
  FTRSDKActionTypeTap,
  FTRSDKActionTypeClipboard,
  FTRSDKActionTypeTyping,
  FTRSDKActionTypeAddToCart,
  FTRSDKActionTypeRemoveFromCart,
  FTRSDKActionTypeAcceptedPromotion,
  FTRSDKActionTypeAcceptedTos,
  FTRSDKActionTypeAccountLogin,
  FTRSDKActionTypeAccountLogout,
  FTRSDKActionTypeAccountIdAdded,
  FTRSDKActionTypePaymentInfo,
  FTRSDKActionTypeShare,
  FTRSDKActionTypeConfigurationUpdate,
  FTRSDKActionTypeAppActive,
  FTRSDKActionTypeAppPause,
  FTRSDKActionTypeRate,
  FTRSDKActionTypeIsJailbroken,
  FTRSDKActionTypeSearchQuery,
  FTRSDKActionTypeReferrer,
  FTRSDKActionTypeWebviewToken,
  FTRSDKActionTypeOther
};

/**
 Account ID type to be used when providing user account info using [ForterSDK setAccountIdentifier:withType:]
 */
typedef NS_ENUM(NSUInteger, FTRSDKAccountIdType) {
  FTRSDKAccountIdTypeMerchant,
  FTRSDKAccountIdTypeFacebook,
  FTRSDKAccountIdTypeGoogle,
  FTRSDKAccountIdTypeTwitter,
  FTRSDKAccountIdTypeAppleIDFA,
  FTRSDKAccountIdTypeOther
};

/* FTRSDKPublicConstants_h */
