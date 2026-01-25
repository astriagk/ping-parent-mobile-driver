# Google Maps API Setup Guide

This document explains how to configure Google Maps API keys for the Ping Parent mobile application.

## Prerequisites

- Google Cloud Console account
- Billing enabled on your Google Cloud project

## Step 1: Get Google Maps API Key

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:

   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API** (if using address lookup)
   - **Places API** (if using place search)

4. Go to **APIs & Services > Credentials**
5. Click **Create Credentials > API Key**
6. Copy the generated API key
7. (Recommended) Click **Restrict Key** and add restrictions:
   - For Android: Add your app's package name and SHA-1 certificate fingerprint
   - For iOS: Add your app's bundle identifier

## Step 2: Configure Android

### Update AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Replace the placeholder API key on line 12:

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_GOOGLE_MAPS_API_KEY"/>
```

### Get SHA-1 Certificate Fingerprint (for API key restriction)

Run this command in the project root:

```bash
# For debug keystore
cd android
./gradlew signingReport
```

Look for the SHA-1 fingerprint under `Variant: debug` and add it to your API key restrictions in Google Cloud Console.

## Step 3: Configure iOS

### Update AppDelegate.swift

File: `ios/Runner/AppDelegate.swift`

Add the Google Maps API key:

```swift
import UIKit
import Flutter
import GoogleMaps  // Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_ACTUAL_GOOGLE_MAPS_API_KEY")  // Add this line
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

### Update Podfile (if needed)

File: `ios/Podfile`

Ensure the deployment target is at least iOS 13.0:

```ruby
platform :ios, '13.0'
```

## Step 4: Install Dependencies

Run the following commands:

```bash
# Get Flutter packages
flutter pub get

# For iOS, install pods
cd ios
pod install
cd ..
```

## Step 5: Test the Map

1. Run the app on a physical device or emulator
2. Navigate to the Add Location screen
3. Verify that the map loads correctly

## Troubleshooting

### Map not showing on Android

1. **Check API key**: Ensure the key is correctly placed in AndroidManifest.xml
2. **Enable APIs**: Verify Maps SDK for Android is enabled in Google Cloud Console
3. **Check restrictions**: If you added restrictions, ensure your app's package name and SHA-1 are correct
4. **Internet permission**: Verify `INTERNET` permission is in AndroidManifest.xml (already added)

### Map not showing on iOS

1. **Check API key**: Ensure GMSServices.provideAPIKey is called in AppDelegate.swift
2. **Enable APIs**: Verify Maps SDK for iOS is enabled in Google Cloud Console
3. **Check restrictions**: If you added restrictions, ensure your app's bundle identifier is correct
4. **Rebuild**: Clean and rebuild the iOS project:
   ```bash
   cd ios
   rm -rf Pods Podfile.lock
   pod install
   cd ..
   flutter clean
   flutter run
   ```

### Billing Issues

If you see a "This page didn't load Google Maps correctly" error:

- Ensure billing is enabled on your Google Cloud project
- Check that you haven't exceeded your API quota
- Verify the API key has no payment issues in Google Cloud Console

## Security Best Practices

1. **Restrict API Keys**: Always add restrictions to your API keys
2. **Use separate keys**: Use different API keys for development and production
3. **Environment Variables**: Consider using environment variables to manage API keys
4. **Don't commit keys**: Add API keys to `.gitignore` if stored in separate config files

## Additional Resources

- [Google Maps Platform Documentation](https://developers.google.com/maps/documentation)
- [Flutter Google Maps Plugin](https://pub.dev/packages/google_maps_flutter)
- [API Key Best Practices](https://developers.google.com/maps/api-security-best-practices)

## API Keys

## API Payments

It needs initial payment of 1000/-
