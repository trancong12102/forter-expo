import ExpoModulesCore
import ForterSDK

public class ForterModule: Module {
  private var tokenListener: ForterTokenListener?
  private var isInitialized = false

  public func definition() -> ModuleDefinition {
    Name("ForterModule")

    Events("onForterTokenUpdate")

    AsyncFunction("init") { (siteId: String, mobileUid: String) in
      guard !self.isInitialized else { return }

      guard !siteId.isEmpty else {
        throw NSError(domain: "ForterModule", code: 0, userInfo: [NSLocalizedDescriptionKey: "SiteID is empty or missing"])
      }
      guard !mobileUid.isEmpty else {
        throw NSError(domain: "ForterModule", code: 1, userInfo: [NSLocalizedDescriptionKey: "MobileUID is empty or missing"])
      }

      self.tokenListener = ForterTokenListener { [weak self] forterMobileUid in
        self?.sendEvent("onForterTokenUpdate", [
          "forterMobileUID": forterMobileUid
        ])
      }
      ForterSDK.registerForterTokenListener(self.tokenListener)
      ForterSDK.setup(withDeviceUid: mobileUid, siteId: siteId)
      ForterSDK.sharedInstance().setDeviceUniqueIdentifier(mobileUid)
      self.isInitialized = true
    }

    AsyncFunction("getForterToken") { () -> String in
      return try ForterSDK.getForterToken()
    }

    AsyncFunction("getDeviceUniqueID") { () -> String in
      return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }

    Function("getSDKVersionSignature") { () -> String in
      return ForterSDK.getSDKVersionSignature()
    }

    Function("setAccountIdentifier") { (accountUid: String, accountType: String) in
      let sdkAccountType = Self.getMatchingAccountType(accountType)
      ForterSDK.sharedInstance().setAccountIdentifier(accountUid, with: sdkAccountType)
    }

    Function("trackNavigation") { (screenName: String, navigationType: String) in
      let sdkNavigationType = Self.getMatchingNavigationType(navigationType)
      ForterSDK.sharedInstance().trackNavigation(screenName, with: sdkNavigationType)
    }

    Function("trackNavigationWithExtraData") { (screenName: String, navigationType: String, itemId: String, itemCategory: String, otherInfo: String) in
      let sdkNavigationType = Self.getMatchingNavigationType(navigationType)
      ForterSDK.sharedInstance().trackNavigation(screenName, with: sdkNavigationType, pageId: itemId, pageCategory: itemCategory, otherInfo: otherInfo)
    }

    Function("trackAction") { (actionType: String) in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType)
    }

    Function("trackActionWithMessage") { (actionType: String, message: String) in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType, withMessage: message)
    }

    Function("trackActionWithJSON") { (actionType: String, json: [String: Any]) in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType, withData: json)
    }

    Function("trackCurrentLocation") { (longitude: Float, latitude: Float) in
      ForterSDK.sharedInstance().didUpdateLocationLatitude(latitude, longitude: longitude, altitude: 0.0)
    }

    Function("setDevLogsEnabled") { () in
      ForterSDK.setDevLogsEnabled(true)
    }

    OnStartObserving {}

    OnStopObserving {
      if let listener = self.tokenListener {
        ForterSDK.unregisterForterTokenListener(listener)
      }
    }
  }

  private static func getMatchingActionType(_ value: String) -> FTRSDKActionType {
    switch value {
    case "TAP": return .tap
    case "CLIPBOARD": return .clipboard
    case "TYPING": return .typing
    case "ADD_TO_CART": return .addToCart
    case "REMOVE_FROM_CART": return .removeFromCart
    case "ACCEPTED_PROMOTION": return .acceptedPromotion
    case "ACCEPTED_TOS": return .acceptedTos
    case "ACCOUNT_LOGIN": return .accountLogin
    case "ACCOUNT_LOGOUT": return .accountLogout
    case "ACCOUNT_ID_ADDED": return .accountIdAdded
    case "PAYMENT_INFO": return .paymentInfo
    case "SHARE": return .share
    case "CONFIGURATION_UPDATE": return .configurationUpdate
    case "APP_ACTIVE": return .appActive
    case "APP_PAUSE": return .appPause
    case "RATE": return .rate
    case "IS_JAILBROKEN": return .isJailbroken
    case "SEARCH_QUERY": return .searchQuery
    case "REFERRER": return .referrer
    case "WEBVIEW_TOKEN": return .webviewToken
    default: return .other
    }
  }

  private static func getMatchingNavigationType(_ value: String) -> FTRSDKNavigationType {
    switch value {
    case "PRODUCT": return .product
    case "ACCOUNT": return .account
    case "SEARCH": return .search
    case "CHECKOUT": return .checkout
    case "CART": return .cart
    case "HELP": return .help
    default: return .app
    }
  }

  private static func getMatchingAccountType(_ value: String) -> FTRSDKAccountIdType {
    switch value {
    case "MERCHANT": return .merchant
    case "FACEBOOK": return .facebook
    case "GOOGLE": return .google
    case "TWITTER": return .twitter
    case "APPLE_IDFA": return .appleIDFA
    default: return .other
    }
  }
}
