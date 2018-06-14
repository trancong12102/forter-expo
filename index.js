
import { NativeModules } from 'react-native';

const { RNForter } = NativeModules;

const forterSDK = {};

const ForterNavigationType = {
    PRODUCT : "PRODUCT", 
    ACCOUNT : "ACCOUNT", 
    SEARCH : "SEARCH", 
    CHECKOUT : "CHECKOUT", 
    CART : "CART", 
    HELP : "HELP",
    APP : "APP"
};

const ForterActionType = {
    TAP : "TAP",
    CLIPBOARD : "CLIPBOARD",
    TYPING : "TYPING",
    ADD_TO_CART : "ADD_TO_CART",
    REMOVE_FROM_CART : "REMOVE_FROM_CART",
    ACCEPTED_PROMOTION : "ACCEPTED_PROMOTION",
    ACCEPTED_TOS : "ACCEPTED_TOS",
    ACCOUNT_LOGIN : "ACCOUNT_LOGIN",
    ACCOUNT_LOGOUT : "ACCOUNT_LOGOUT",
    ACCOUNT_ID_ADDED : "ACCOUNT_ID_ADDED",
    PAYMENT_INFO : "PAYMENT_INFO",
    SHARE : "SHARE",
    CONFIGURATION_UPDATE : "CONFIGURATION_UPDATE",
    APP_ACTIVE : "APP_ACTIVE",
    APP_PAUSE : "APP_PAUSE",
    RATE : "RATE",
    IS_JAILBROKEN : "IS_JAILBROKEN",
    SEARCH_QUERY : "SEARCH_QUERY",
    REFERRER : "REFERRER",
    WEBVIEW_TOKEN : "WEBVIEW_TOKEN",
    OTHER : "OTHER"
};

const ForterAccountType = {
    MERCHANT : "MERCHANT",
    FACEBOOK : "FACEBOOK",
    GOOGLE : "GOOGLE",
    TWITTER : "TWITTER",
    APPLE_IDFA : "APPLE_IDFA",
    OTHER : "OTHER"
};

/**
 * Start the Forter SDK
 * @param {String} siteId 
 * @param {String} mobileUid 
 * @param {*} successC 
 * @param {*} errorC 
 */
forterSDK.init = (siteId, mobileUid, successC, errorC) => {
    return RNForter.initSDK(siteId, mobileUid, successC, errorC);
};

/**
 * Get the device's native unique ID
 * @param {*} callback 
 */
forterSDK.getDeviceUniqueID = (callback) => {
    return RNForter.getDeviceUniqueID(callback);
};

/**
 * Set the currently logged-in account ID
 * @param {String} accountUid 
 * @param {ForterAccountType} accountType 
 */
forterSDK.setAccountIdentifier = (accountUid, accountType) => {
    return RNForter.setAccountIdentifier(accountUid, accountType);
}

/**
 * Track a user's navigation inside the app
 * @param {String} screenName 
 * @param {ForterNavigationType} navigationType 
 */
forterSDK.trackNavigation = (screenName, navigationType) => {
    return RNForter.trackNavigation(screenName, navigationType);
};

/**
 * Track a user's navigation to product-related screens
 * @param {String} screenName 
 * @param {ForterNavigationType} navigationType 
 * @param {String} itemId 
 * @param {String} itemCategory 
 * @param {String} otherInfo 
 */
forterSDK.trackNavigationWithExtraData = (screenName, navigationType, itemId, itemCategory, otherInfo) => {
    return RNForter.trackNavigationWithExtraData(screenName, navigationType, itemId, itemCategory, otherInfo);
};

/**
 * Track a user's action inside the app
 * @param {ForterActionType} actionType 
 */
forterSDK.trackAction = (actionType) => {
    return RNForter.trackAction(actionType);
};

/**
 * Track a user's action with additional information
 * @param {ForterActionType} actionType 
 * @param {String} message 
 */
forterSDK.trackActionWithMessage = (actionType, message) => {
    return RNForter.trackActionWithMessage(actionType, message);
};

/**
 * Track a user's action with additional information
 * @param {ForterActionType} actionType 
 * @param {object} dictionary 
 */
forterSDK.trackActionWithJSON = (actionType, dictionary) => {
    return RNForter.trackActionWithJSON(actionType, dictionary);
};

forterSDK.trackCurrentLocation = (longitude, latitude) => {
    return RNForter.trackCurrentLocation(longitude, latitude);
};

forterSDK.setDevLogsEnabled = () => {
    return RNForter.setDevLogsEnabled();
};

forterSDK.getSDKVersionSignature = (callback) => {
    return RNForter.getSDKVersionSignature(callback);
};

export { forterSDK, ForterNavigationType, ForterActionType, ForterAccountType };