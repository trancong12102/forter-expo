import ExpoModulesCore
import ForterSDK

public class ForterModule: Module {
  private var tokenListener: ForterTokenListener?
  private var isInitialized = false

  public func definition() -> ModuleDefinition {
    Name("ForterModule")

    Events("onForterTokenUpdate")

    AsyncFunction("init") { (siteId: String, mobileUid: String) -> Void in
      try self.performInit(siteId: siteId, mobileUid: mobileUid)
    }

    AsyncFunction("getForterToken") { () -> String in
      return try self.performGetForterToken()
    }

    AsyncFunction("getDeviceUniqueID") { () -> String in
      return self.performGetDeviceUniqueID()
    }

    Function("getSDKVersionSignature") { () -> String in
      return ForterSDK.getSDKVersionSignature()
    }

    Function("setAccountIdentifier") { (accountUid: String, accountType: String) -> Void in
      let sdkAccountType = Self.getMatchingAccountType(accountType)
      ForterSDK.sharedInstance().setAccountIdentifier(accountUid, with: sdkAccountType)
    }

    Function("trackNavigation") { (screenName: String, navigationType: String) -> Void in
      let sdkNavigationType = Self.getMatchingNavigationType(navigationType)
      ForterSDK.sharedInstance().trackNavigation(screenName, with: sdkNavigationType)
    }

    Function("trackNavigationWithExtraData") { (screenName: String, navigationType: String, itemId: String, itemCategory: String, otherInfo: String) -> Void in
      let sdkNavigationType = Self.getMatchingNavigationType(navigationType)
      ForterSDK.sharedInstance().trackNavigation(screenName, with: sdkNavigationType, pageId: itemId, pageCategory: itemCategory, otherInfo: otherInfo)
    }

    Function("trackAction") { (actionType: String) -> Void in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType)
    }

    Function("trackActionWithMessage") { (actionType: String, message: String) -> Void in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType, withMessage: message)
    }

    Function("trackActionWithJSON") { (actionType: String, json: [String: Any]) -> Void in
      let sdkActionType = Self.getMatchingActionType(actionType)
      ForterSDK.sharedInstance().trackAction(sdkActionType, withData: json)
    }

    Function("trackCurrentLocation") { (longitude: Double, latitude: Double) -> Void in
      ForterSDK.sharedInstance().didUpdateLocationLatitude(latitude, longitude: longitude, altitude: 0.0)
    }

    Function("setDevLogsEnabled") { () -> Void in
      ForterSDK.setDevLogsEnabled(true)
    }

    OnStartObserving {}

    OnStopObserving {
      if let listener = self.tokenListener {
        ForterSDK.unregisterForterTokenListener(listener)
      }
    }
  }

  // MARK: - Implementation helpers

  private func performInit(siteId: String, mobileUid: String) throws {
    guard !isInitialized else { return }

    guard !siteId.isEmpty else {
      throw NSError(domain: "ForterModule", code: 0, userInfo: [NSLocalizedDescriptionKey: "SiteID is empty or missing"])
    }
    guard !mobileUid.isEmpty else {
      throw NSError(domain: "ForterModule", code: 1, userInfo: [NSLocalizedDescriptionKey: "MobileUID is empty or missing"])
    }

    tokenListener = ForterTokenListener { [weak self] forterMobileUid in
      self?.sendEvent("onForterTokenUpdate", [
        "forterMobileUID": forterMobileUid
      ])
    }
    ForterSDK.registerForterTokenListener(tokenListener!)
    ForterSDK.setup(withDeviceUid: mobileUid, siteId: siteId)
    ForterSDK.sharedInstance().setDeviceUniqueIdentifier(mobileUid)
    isInitialized = true
  }

  private func performGetForterToken() throws -> String {
    var error: NSError?
    let token = ForterSDK.getForterToken(&error)
    if let error = error { throw error }
    return token
  }

  private func performGetDeviceUniqueID() -> String {
    return UIDevice.current.identifierForVendor?.uuidString ?? ""
  }

  // MARK: - Type mapping

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
