package com.forter.mobile.expo

import android.app.Application
import android.os.Build
import androidx.core.os.bundleOf
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import com.forter.mobile.fortersdk.ForterSDK
import com.forter.mobile.fortersdk.integrationkit.ForterIntegrationUtils
import com.forter.mobile.fortersdk.integrationkit.ForterTokenListener
import com.forter.mobile.fortersdk.models.ForterAccountIDType
import com.forter.mobile.fortersdk.models.NavigationType
import com.forter.mobile.fortersdk.models.TrackType
import android.location.Location
import org.json.JSONObject

class ForterModule : Module() {
  private var isInitialized = false

  override fun definition() = ModuleDefinition {
    Name("ForterModule")

    Events("onForterTokenUpdate")

    AsyncFunction("init") { siteId: String, mobileUid: String ->
      if (isInitialized) return@AsyncFunction

      if (siteId.isEmpty()) throw Exception("SiteID is empty or missing")
      if (mobileUid.isEmpty()) throw Exception("MobileUID is empty or missing")

      val app = appContext.reactContext?.applicationContext as Application

      sdk().registerForterTokenListener(object : ForterTokenListener() {
        override fun onForterTokenUpdate(forterMobileUID: String) {
          this@ForterModule.sendEvent("onForterTokenUpdate", bundleOf(
            "forterMobileUID" to forterMobileUID
          ))
        }
      })

      sdk().init(app, siteId, mobileUid)

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
        appContext.currentActivity?.let { activity ->
          sdk().activityLifecycleCallbacks.onActivityResumed(activity)
          app.registerActivityLifecycleCallbacks(sdk().activityLifecycleCallbacks)
        }
      }

      sdk().trackAction(TrackType.APP_ACTIVE, "ForterModule")
      isInitialized = true
    }

    AsyncFunction("getForterToken") {
      return@AsyncFunction sdk().forterToken
    }

    AsyncFunction("getDeviceUniqueID") {
      val app = appContext.reactContext?.applicationContext as Application
      return@AsyncFunction ForterIntegrationUtils.getDeviceUID(app)
    }

    Function("getSDKVersionSignature") {
      return@Function "de844806cd013126370e6440aa3c2eb9"
    }

    Function("setAccountIdentifier") { accountUid: String, accountType: String ->
      sdk().setAccountUID(getMatchingAccountIDType(accountType), accountUid)
    }

    Function("trackNavigation") { screenName: String, navigationType: String ->
      sdk().trackNavigation(getMatchingNavigationType(navigationType), screenName)
    }

    Function("trackNavigationWithExtraData") { screenName: String, navigationType: String, itemId: String, itemCategory: String, otherInfo: String ->
      sdk().trackNavigation(
        getMatchingNavigationType(navigationType),
        screenName,
        itemId,
        itemCategory,
        otherInfo
      )
    }

    Function("trackAction") { actionType: String ->
      sdk().trackAction(getMatchingActionType(actionType))
    }

    Function("trackActionWithMessage") { actionType: String, message: String ->
      sdk().trackAction(getMatchingActionType(actionType), message)
    }

    Function("trackActionWithJSON") { actionType: String, json: Map<String, Any?> ->
      val data = JSONObject(json)
      sdk().trackAction(getMatchingActionType(actionType), data)
    }

    Function("trackCurrentLocation") { longitude: Double, latitude: Double ->
      val location = Location("forter").apply {
        this.latitude = latitude
        this.longitude = longitude
      }
      sdk().onLocationChanged(location)
    }

    Function("setDevLogsEnabled") {
      sdk().setDevLogsEnabled(true)
    }

    OnStartObserving {}

    OnStopObserving {}
  }

  private fun sdk() = ForterSDK.getInstance()

  private fun getMatchingNavigationType(type: String): NavigationType {
    return try {
      NavigationType.valueOf(type)
    } catch (e: IllegalArgumentException) {
      NavigationType.APP
    }
  }

  private fun getMatchingActionType(type: String): TrackType {
    return try {
      TrackType.valueOf(type)
    } catch (e: IllegalArgumentException) {
      TrackType.OTHER
    }
  }

  private fun getMatchingAccountIDType(type: String): ForterAccountIDType {
    return when (type) {
      "MERCHANT" -> ForterAccountIDType.MERCHANT_ACCOUNT_ID
      "FACEBOOK" -> ForterAccountIDType.FACEBOOK_ID
      "GOOGLE" -> ForterAccountIDType.GOOGLE_ID
      "TWITTER" -> ForterAccountIDType.TWITTER_ID
      else -> ForterAccountIDType.OTHER
    }
  }
}
