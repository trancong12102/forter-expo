package com.forter.mobile.reactnative;

import android.app.Application;
import android.content.Context;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

public class RNForterPackage implements ReactPackage {

    private Application application;

    // Required for autolinking
    public RNForterPackage() {
        this.application = null; // Will fallback to reactContext later
    }

    // Manual constructor (if ever needed)
    public RNForterPackage(Application application) {
        this.application = application;
    }

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        Application app = this.application != null
            ? this.application
            : (Application) reactContext.getApplicationContext();

        return Arrays.<NativeModule>asList(
            RNForterModule.getInstance(reactContext, app)
        );
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
