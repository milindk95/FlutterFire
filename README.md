# FlutterFire

Fantasy Cricket App developed in Flutter framework

## Getting Started

Clone Repository: **git clone https://github.com/milindk95/FlutterFire.git**

Use github token to clone this repository

**Preferable IDE** : Android Studio and further instructions are only for android studio

## Project setup in Android Studio

**Total Environments:**

local | staging | live
----- | ------- | ----
With local server API url | Staging server url: http://staging.com/api/v1/ | Live server url: https://live.com/api/v1/

Steps to set all environments
  * Go to Edit Configurations
  * Add Flutter and name it `main:local`
  * Set Dart entrypoint : `../flutter_fire/lib/main_local.dart`
  * Set Additional run args: `--flavor live`
  * Repeat for local and staging flavor

## Run and build app
To run release app with flavor

```
flutter run -t lib/main_live.dart --release --flavor=live
```

To build apk with flavor
```
flutter build apk -t lib/main_live.dart --flavor=live
```
