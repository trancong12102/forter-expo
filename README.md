# forter-expo

Expo Module for the Forter Mobile SDK, supporting **iOS** and **Android**.

Requires **Expo SDK 51+** (New Architecture only).

## Installation

### Step 1: Install the package

```bash
npm install forter-expo
```

### Step 2: Add the config plugin

In your `app.json` (or `app.config.js`):

```json
{
  "expo": {
    "plugins": ["forter-expo"]
  }
}
```

This automatically configures:
- **iOS**: Adds Forter's private CocoaPods spec source to the Podfile
- **Android**: Adds Forter's private Maven repository to the project

### Step 3: Rebuild

```bash
npx expo prebuild --clean
npx expo run:ios
npx expo run:android
```

## Usage

```typescript
import {
  init,
  getForterToken,
  getDeviceUniqueID,
  setDevLogsEnabled,
  trackNavigation,
  trackAction,
  addForterTokenListener,
  ForterNavigationType,
  ForterActionType,
} from 'forter-expo';

// Enable dev logs (optional)
setDevLogsEnabled();

// Initialize the SDK
const deviceId = await getDeviceUniqueID();
await init('YOUR_SITE_ID', deviceId);

// Track navigation and actions
trackNavigation('mainpage', ForterNavigationType.PRODUCT);
trackAction(ForterActionType.ACCOUNT_LOGIN);

// Get the current Forter token
const token = await getForterToken();
console.log('Forter token:', token);

// Listen for token updates
const subscription = addForterTokenListener((token) => {
  console.log('Token updated:', token);
});

// Remove listener when done
subscription.remove();
```

## API

### Async methods

| Method | Returns |
|---|---|
| `init(siteId, mobileUid)` | `Promise<void>` |
| `getForterToken()` | `Promise<string>` |
| `getDeviceUniqueID()` | `Promise<string>` |

### Sync methods

| Method | Returns |
|---|---|
| `getSDKVersionSignature()` | `string` |
| `setAccountIdentifier(accountUid, accountType)` | `void` |
| `trackNavigation(screenName, navigationType)` | `void` |
| `trackNavigationWithExtraData(screenName, navigationType, itemId, itemCategory, otherInfo)` | `void` |
| `trackAction(actionType)` | `void` |
| `trackActionWithMessage(actionType, message)` | `void` |
| `trackActionWithJSON(actionType, dictionary)` | `void` |
| `trackCurrentLocation(longitude, latitude)` | `void` |
| `setDevLogsEnabled()` | `void` |

### Events

| Method | Returns |
|---|---|
| `addForterTokenListener(callback)` | `Subscription` |

### Enums

- `ForterNavigationType`: `PRODUCT`, `ACCOUNT`, `SEARCH`, `CHECKOUT`, `CART`, `HELP`, `APP`
- `ForterActionType`: `TAP`, `CLIPBOARD`, `TYPING`, `ADD_TO_CART`, `REMOVE_FROM_CART`, `ACCEPTED_PROMOTION`, `ACCEPTED_TOS`, `ACCOUNT_LOGIN`, `ACCOUNT_LOGOUT`, `ACCOUNT_ID_ADDED`, `PAYMENT_INFO`, `SHARE`, `CONFIGURATION_UPDATE`, `APP_ACTIVE`, `APP_PAUSE`, `RATE`, `IS_JAILBROKEN`, `SEARCH_QUERY`, `REFERRER`, `WEBVIEW_TOKEN`, `OTHER`
- `ForterAccountType`: `MERCHANT`, `FACEBOOK`, `GOOGLE`, `TWITTER`, `APPLE_IDFA`, `OTHER`

## Migration from v1.x

v2.0 is a breaking change — callbacks are replaced with Promises:

```typescript
// Before (v1.x)
forterSDK.init(siteId, uid, successCb, errorCb);
forterSDK.getForterToken(successCb, errorCb);
forterSDK.getDeviceUniqueID(callback);
forterSDK.registerForterTokenListener(callback);

// After (v2.0)
await init(siteId, uid);
const token = await getForterToken();
const deviceId = await getDeviceUniqueID();
const subscription = addForterTokenListener(callback);
```

Manual native setup (Podfile sources, Maven repos, `RNForterPackage` registration) is no longer needed — the config plugin handles everything.
