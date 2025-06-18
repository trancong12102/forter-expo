# ForterSDK React Native Wrapper

This wrapper simplifies the initialization and integration of Forter's SDK for **React Native** applications, supporting both **iOS** and **Android** platforms.

## Supported Platforms

- Forter iOS SDK
- Forter Android SDK

---

## 📦 Installation

### Step 1: Add to `package.json`

```json
{
  "dependencies": {
    "react-native-forter": "git+https://bitbucket.org/forter-mobile/forter-react-plugin.git"
  }
}
```

If you are running ReactNative < 0.60 (this should work for 0.60 and above), you must also have the React dependencies defined in the Podfile as described [here](https://facebook.github.io/react-native/docs/next/troubleshooting.html#missing-libraries-for-react).

And finally execute `pod install` (inside `ios` directory).

### Step 2: Android 

#### modify `android/settings.gradle`:

```gradle
include ':react-native-forter'
project(':react-native-forter').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-forter/android')
```

#### Add Forter's private Maven repository to your `android/app/build.gradle` or `settings.gradle` if you are using central declaration of repositories:

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

#### Add the project to your dependencies\
```gradle
dependencies {
   ...
   implementation project(':react-native-forter')
}
```

#### if Autolink is disabled add the following code to your Application to register Forter's module

```java
import com.forter.mobile.reactnative.RNForterPackage;

public class MainApplication extends Application implements ReactApplication {

        ... 
        
        @Override
        protected List<ReactPackage> getPackages() {
          @SuppressWarnings("UnnecessaryLocalVariable")
          List<ReactPackage> packages = new PackageList(this).getPackages();
          
          packages.add(new RNForterPackage(MainApplication.this));
          return packages;
        }
        
        ...
```

### Step 3: iOS setup

Add the `ForterSDK` pod and the React Native pod to `ios/Podfile`:

```podspec
pod 'ForterSDK', :git => 'https://bitbucket.org/forter-mobile/forter-ios-sdk.git'
pod 'react-native-forter', :path => '../node_modules/react-native-forter'
```


### Step 4: JavaScript setup

Add the following code to your apps `index.js`, this example
uses `react-native-logger`, which is optional. To use it, add
the following line to `package.json` : `{"react-native-logger": "1.0.3"}` and then execute `yarn install`.

``` javascript
import {logger} from 'react-native-logger';
import {forterSDK, ForterActionType, ForterNavigationType} from 'react-native-forter';

AppRegistry.registerComponent(appName, () => App);

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

// Exaples for custom tracking
forterSDK.trackNavigation('mainpage', ForterNavigationType.PRODUCT);
forterSDK.trackAction(ForterActionType.ACCOUNT_LOGIN)

// Examples for custom tracking
forterSDK.trackNavigation('mainpage', ForterNavigationType.PRODUCT);
forterSDK.trackAction(ForterActionType.ACCOUNT_LOGIN)
```

#### Register Forter Token updates:
```
forterSDK.registerForterTokenListener(forterTokenUID => {
  //Forter token updated
  console.warn('token: ' + forterTokenUID);
});
```

#### Get the latest Forter token:
```
forterSDK.getForterToken(forterTokenUID => {
     console.warn('token: ' + forterTokenUID);
   },
   error => {},
);
```
