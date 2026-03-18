import { requireNativeModule, NativeModule } from "expo";

type ForterModuleEvents = {
  onForterTokenUpdate(event: { forterMobileUID: string }): void;
};

declare class ForterNativeModuleType extends NativeModule<ForterModuleEvents> {
  init(siteId: string, mobileUid: string): Promise<void>;
  getForterToken(): Promise<string>;
  getDeviceUniqueID(): Promise<string>;
  getSDKVersionSignature(): string;
  setAccountIdentifier(accountUid: string, accountType: string): void;
  trackNavigation(screenName: string, navigationType: string): void;
  trackNavigationWithExtraData(
    screenName: string,
    navigationType: string,
    itemId: string,
    itemCategory: string,
    otherInfo: string
  ): void;
  trackAction(actionType: string): void;
  trackActionWithMessage(actionType: string, message: string): void;
  trackActionWithJSON(
    actionType: string,
    dictionary: Record<string, unknown>
  ): void;
  trackCurrentLocation(longitude: number, latitude: number): void;
  setDevLogsEnabled(): void;
}

const ForterNativeModule =
  requireNativeModule<ForterNativeModuleType>("ForterModule");

export const ForterNavigationType = {
  PRODUCT: "PRODUCT",
  ACCOUNT: "ACCOUNT",
  SEARCH: "SEARCH",
  CHECKOUT: "CHECKOUT",
  CART: "CART",
  HELP: "HELP",
  APP: "APP",
} as const;

export const ForterActionType = {
  TAP: "TAP",
  CLIPBOARD: "CLIPBOARD",
  TYPING: "TYPING",
  ADD_TO_CART: "ADD_TO_CART",
  REMOVE_FROM_CART: "REMOVE_FROM_CART",
  ACCEPTED_PROMOTION: "ACCEPTED_PROMOTION",
  ACCEPTED_TOS: "ACCEPTED_TOS",
  ACCOUNT_LOGIN: "ACCOUNT_LOGIN",
  ACCOUNT_LOGOUT: "ACCOUNT_LOGOUT",
  ACCOUNT_ID_ADDED: "ACCOUNT_ID_ADDED",
  PAYMENT_INFO: "PAYMENT_INFO",
  SHARE: "SHARE",
  CONFIGURATION_UPDATE: "CONFIGURATION_UPDATE",
  APP_ACTIVE: "APP_ACTIVE",
  APP_PAUSE: "APP_PAUSE",
  RATE: "RATE",
  IS_JAILBROKEN: "IS_JAILBROKEN",
  SEARCH_QUERY: "SEARCH_QUERY",
  REFERRER: "REFERRER",
  WEBVIEW_TOKEN: "WEBVIEW_TOKEN",
  OTHER: "OTHER",
} as const;

export const ForterAccountType = {
  MERCHANT: "MERCHANT",
  FACEBOOK: "FACEBOOK",
  GOOGLE: "GOOGLE",
  TWITTER: "TWITTER",
  APPLE_IDFA: "APPLE_IDFA",
  OTHER: "OTHER",
} as const;

export type ForterNavigationTypeValue =
  (typeof ForterNavigationType)[keyof typeof ForterNavigationType];
export type ForterActionTypeValue =
  (typeof ForterActionType)[keyof typeof ForterActionType];
export type ForterAccountTypeValue =
  (typeof ForterAccountType)[keyof typeof ForterAccountType];

export function init(siteId: string, mobileUid: string): Promise<void> {
  return ForterNativeModule.init(siteId, mobileUid);
}

export function getForterToken(): Promise<string> {
  return ForterNativeModule.getForterToken();
}

export function getDeviceUniqueID(): Promise<string> {
  return ForterNativeModule.getDeviceUniqueID();
}

export function getSDKVersionSignature(): string {
  return ForterNativeModule.getSDKVersionSignature();
}

export function setAccountIdentifier(
  accountUid: string,
  accountType: ForterAccountTypeValue
): void {
  ForterNativeModule.setAccountIdentifier(accountUid, accountType);
}

export function trackNavigation(
  screenName: string,
  navigationType: ForterNavigationTypeValue
): void {
  ForterNativeModule.trackNavigation(screenName, navigationType);
}

export function trackNavigationWithExtraData(
  screenName: string,
  navigationType: ForterNavigationTypeValue,
  itemId: string,
  itemCategory: string,
  otherInfo: string
): void {
  ForterNativeModule.trackNavigationWithExtraData(
    screenName,
    navigationType,
    itemId,
    itemCategory,
    otherInfo
  );
}

export function trackAction(actionType: ForterActionTypeValue): void {
  ForterNativeModule.trackAction(actionType);
}

export function trackActionWithMessage(
  actionType: ForterActionTypeValue,
  message: string
): void {
  ForterNativeModule.trackActionWithMessage(actionType, message);
}

export function trackActionWithJSON(
  actionType: ForterActionTypeValue,
  dictionary: Record<string, unknown>
): void {
  ForterNativeModule.trackActionWithJSON(actionType, dictionary);
}

export function trackCurrentLocation(
  longitude: number,
  latitude: number
): void {
  ForterNativeModule.trackCurrentLocation(longitude, latitude);
}

export function setDevLogsEnabled(): void {
  ForterNativeModule.setDevLogsEnabled();
}

export function addForterTokenListener(
  callback: (token: string) => void
): ReturnType<typeof ForterNativeModule.addListener> {
  return ForterNativeModule.addListener("onForterTokenUpdate", (event) => {
    callback(event.forterMobileUID);
  });
}
