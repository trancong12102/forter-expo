package com.forter.mobile.reactnative;


import android.app.Application;
import android.os.Build;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.forter.mobile.fortersdk.ForterSDK;
import com.forter.mobile.fortersdk.integrationkit.ForterIntegrationUtils;
import com.forter.mobile.fortersdk.interfaces.IForterSDK;
import com.forter.mobile.fortersdk.models.ForterAccountIDType;
import com.forter.mobile.fortersdk.models.NavigationType;
import com.forter.mobile.fortersdk.models.TrackType;

import org.json.JSONException;
import org.json.JSONObject;

import static com.forter.mobile.reactnative.RNForterConstants.NO_MOBILE_UID_FOUND;
import static com.forter.mobile.reactnative.RNForterConstants.NO_SITE_ID_FOUND;
import static com.forter.mobile.reactnative.RNForterConstants.SUCCESS;

public class RNForterModule extends ReactContextBaseJavaModule  {

    private ReactApplicationContext reactContext;
    private Application application;

    public RNForterModule(ReactApplicationContext reactContext, Application application) {
        super(reactContext);
        this.reactContext = reactContext;
        this.application = application;
    }

    @Override
    public String getName() {
        return "RNForter";
    }

    @ReactMethod
    public void initSdk(
            String siteId,
            String mobileUid,
            Callback successCallback,
            Callback errorCallback
            ) {

        try {

            if (siteId == null || siteId.isEmpty()) {
                errorCallback.invoke(new Exception(NO_SITE_ID_FOUND).getMessage());
                return;
            }else if (mobileUid == null || mobileUid.isEmpty()) {
                errorCallback.invoke(new Exception(NO_MOBILE_UID_FOUND).getMessage());
                return;
            }

            sdk().init(this.application, siteId, mobileUid);
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
                // RN Activity events already happened on launch before we got a chance to register
                // lifecycle callbacks - mark as foreground or we might not get events!
                sdk().getActivityLifecycleCallbacks().onActivityResumed(reactContext.getCurrentActivity());
                this.application.registerActivityLifecycleCallbacks(sdk().getActivityLifecycleCallbacks());
            }

            sdk().trackAction(TrackType.APP_ACTIVE, "RNForter");
            successCallback.invoke(SUCCESS);
        } catch (Exception e) {
            errorCallback.invoke(e.getMessage());
        }
    }

    @ReactMethod
    public void getDeviceUniqueID(Callback callback) {
        callback.invoke(ForterIntegrationUtils.getDeviceUID(this.application));
    }

    @ReactMethod
    public void setAccountIdentifier(String accountIdentifier, String accountType) {
        sdk().setAccountUID(getMatchingAccountIDType(accountType), accountIdentifier);
    }

    @ReactMethod
    public void trackNavigation(String screenName, String navigationType) {
        sdk().trackNavigation(getMatchingNavigationType(navigationType),
                screenName);
    }

    @ReactMethod
    public void trackNavigationWithExtraData(String screenName, String navigationType, String itemId, String itemCategory, String otherInfo) {
        sdk().trackNavigation(getMatchingNavigationType(navigationType),
                screenName,
                itemId,
                itemCategory,
                otherInfo);
    }

    @ReactMethod
    public void trackAction(String actionType) {
        sdk().trackAction(getMatchingActionType(actionType));
    }

    @ReactMethod
    public void trackActionWithMessage(String actionType, String message) {
        sdk().trackAction(getMatchingActionType(actionType),
                message);
    }

    @ReactMethod
    public void trackActionWithJSON(String actionType, ReadableMap actionData) {
        JSONObject data = RNUtil.readableMapToJson(actionData);
        if (data == null) { // In case of no values
            data = new JSONObject();
        }

        sdk().trackAction(getMatchingActionType(actionType), data);
    }

    @ReactMethod
    public void trackCurrentLocation(float longitude, float latitude) {
        JSONObject data = new JSONObject();
        try {
            data.put("eventType", "locationUpdate");
            data.put("latitude", latitude);
            data.put("longitude", longitude);
        } catch (JSONException e) {
            return;
        }
        sdk().trackAction(TrackType.OTHER, data);
    }

    @ReactMethod
    public void setDevLogsEnabled() {
        sdk().setDevLogsEnabled(true);
    }

    @ReactMethod
    public void getSDKVersionSignature(Callback callback) {
        callback.invoke(ForterSDK.BUILD_SIGNATURE);
    }

    private NavigationType getMatchingNavigationType(String type) {
        try {
            return NavigationType.valueOf(type);
        } catch (IllegalArgumentException ex) {
            return NavigationType.APP;
        }
    }

    private TrackType getMatchingActionType(String type) {
        try {
            return TrackType.valueOf(type);
        } catch (IllegalArgumentException ex) {
            return TrackType.OTHER;
        }
    }

    private ForterAccountIDType getMatchingAccountIDType(String type) {
        if (type.equals("MERCHANT")) {
            return ForterAccountIDType.MERCHANT_ACCOUNT_ID;
        } else if (type.equals("FACEBOOK")) {
            return ForterAccountIDType.FACEBOOK_ID;
        } else if (type.equals("GOOGLE")) {
            return ForterAccountIDType.GOOGLE_ID;
        } else if (type.equals("TWITTER")) {
            return ForterAccountIDType.TWITTER_ID;
        } else {
        // "APPLE_IDFA" or  "OTHER"
            return ForterAccountIDType.OTHER;
        }
    }

    private IForterSDK sdk() {
        return ForterSDK.getInstance();
    }
}