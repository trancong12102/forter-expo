# ForterSDK ReactNative wrapper

We provide this wrapper for you to be able to maintain a single 
point of initialization for your app, instead of doing native 
initialization of our SDK in IOS and Android.

This plugin is built for:
- Forter's iOS SDK
- Forter's Android SDK

## Installation
Add the Forter dependency to your `package.json`:


```json
{
 "dependencies": {
       "react-native-forter": "git+https://forter-mobile-git:zvGKcVtDhkfj4asNekSn@bitbucket.org/forter-mobile/forter-react-plugin.git#v0.1.20-auth-rc1"
  },
}
```

### iOS specific implementation

First add the `ForterSDK` pod and the React Native pod to `ios/Podfile`:


```podspec
pod 'ForterSDK', :git => 'https://forter-mobile-git:zvGKcVtDhkfj4asNekSn@bitbucket.org/forter-mobile/forter-ios-sdk.git'
pod 'react-native-forter', :path => '../node_modules/react-native-forter'
```

If you are running ReactNative < 0.60 (this should work for 0.60 and above), you must also have the React dependencies defined in the Podfile as described [here](https://facebook.github.io/react-native/docs/next/troubleshooting.html#missing-libraries-for-react).

And finally execute `pod install` (inside `ios` directory).

### Android specific implementation

First step is to modify `android/settings.gradle`

```gradle
include ':react-native-forter'
project(':react-native-forter').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-forter/android')
```

Add Forter's private Maven repository to your `android/app/build.gradle` or `settings.gradle` if you are using central declaration of repositories:
``` gradle
repositories {
  maven {
    url "https://mobile-sdks.forter.com/android"
    credentials {
      username "forter-android-sdk"
      password "HvYumAfjVQYQFyoGsmNAefGdR84Esqig"
    }
  }
}
```

Following steps are not needed on ReactNative 0.60 and above.

You need to link the project: excute from the shell `react-native link react-native-forter` from of the project root or add manually:

Add the project to your dependencies
```gradle
dependencies {
   ...
   implementation project(':react-native-forter')
}
```

Finally add the following code to your app to register Forter's module

```java
import com.forter.mobile.reactnative.RNForterPackage;


    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            //...
            new RNForterPackage(MainApplication.this)
            //...
      );
    }
```
## JavaScript setup

Add the following code to your apps `index.js`, this example
uses `react-native-logger`, which is optional. To use it, add
the following line to `package.json` : `{"react-native-logger": "1.0.3"}` and then execute `yarn install`.


### Add Forter imports:
``` javascript
import {logger} from 'react-native-logger';
import {forterSDK, ForterActionType, ForterNavigationType} from 'react-native-forter';
```

### Init Forter SDK:
``` javascript
// Modify this with your merchant ID
var myForterID = "1234556789" 

forterSDK.setDevLogsEnabled();
forterSDK.getDeviceUniqueID( (deviceID) => {
    console.warn("deviceID = " + deviceID + " merchange=" + myForterID);
    forterSDK.init(myForterID, deviceID, (successResult) => {
        console.warn("OK: " + successResult);
    }, (errorResult) => {
        console.warn("FAIL: " + errorResult);
    });
});
```

### Get the latest Forter token:
``` Javascript
forterSDK.getForterToken(forterTokenUID => {
     console.warn('token: ' + forterTokenUID);
   },
   error => {},
);
```

### Register Forter Token updates:
``` Javascript
forterSDK.registerForterTokenListener(forterTokenUID => {
  //Forter token updated
  console.warn('token: ' + forterTokenUID);
});
```

### Optional, Add your custom tracking:
``` Javascript
// Examples for custom tracking
forterSDK.trackNavigation('mainpage', ForterNavigationType.PRODUCT);
forterSDK.trackAction(ForterActionType.ACCOUNT_LOGIN)
```
