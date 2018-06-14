
## <a id="this-plugin-is-built-for"> This plugin is built for

- Forter's iOS SDK
- Forter's Android SDK

## <a id="installation"> Installation
Add the Forter dependency to your `package.json`
`"react-native-forter": "git+https://forter-mobile-git:zvGKcVtDhkfj4asNekSn@bitbucket.org:forter-mobile/forter-react-plugin.git"`

### <a id="installation_ios"> iOS


1. Add the `ForterSDK` pod and the React Native pod to your `Podfile` and run `pod install`.


Example:

```
pod 'ForterSDK', :git => 'https://forter-mobile-git:zvGKcVtDhkfj4asNekSn@bitbucket.org/forter-mobile/forter-ios-sdk.git'
pod 'react-native-forter', :path => '../node_modules/react-native-forter'
```

This assumes your `Podfile` is located in `ios` directory.

You must also have the React dependencies defined in the Podfile as described [here](https://facebook.github.io/react-native/docs/next/troubleshooting.html#missing-libraries-for-react).

2. Run `pod install` (inside `ios` directory).


### <a id="installation_android"> Android

##### **android/app/build.gradle**


Run `react-native link react-native-forter` from of the project root or add manually:

Add the project to your dependencies
```gradle
dependencies {
...
compile project(':react-native-forter')
}
```

##### **android/settings.gradle**

Add the project

```gradle
include ':react-native-forter'
project(':react-native-forter').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-forter/android')
```


##### **MainApplication.java**
Add:


1. `import com.forter.mobile.reactnative.RNForterPackage;`

2.  In the `getPackages()` method register the module:
`new RNForterPackage(MainApplication.this)`

So `getPackages()` should look like:

```java
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

