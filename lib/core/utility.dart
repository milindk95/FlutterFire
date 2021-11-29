import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/core/preferences.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/ui/screens/auth/login_sign_up_screen.dart';
import 'package:the_super11/ui/screens/home/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static Future<Map<String, dynamic>> getDeviceInfoJson(
      {bool setNotificationToken = false, bool setIpAddress = true}) async {
    final deviceInfoPlugin = new DeviceInfoPlugin();
    final interfaces = await NetworkInterface.list(
        includeLoopback: false, includeLinkLocal: false);
    late String deviceID, deviceOS, deviceVersion, deviceType;
    final firebaseToken = await Preference.getFirebaseToken();
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceType = androidInfo.brand + ' ' + androidInfo.device;
      deviceID = androidInfo.androidId;
      deviceOS = androidInfo.hardware;
      deviceVersion = androidInfo.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceType = iosInfo.name;
      deviceID = iosInfo.identifierForVendor;
      deviceOS = iosInfo.systemName;
      deviceVersion = iosInfo.systemVersion;
    }

    return {
      "deviceID": "$deviceID",
      "deviceOS": "$deviceOS",
      "deviceVersion": "$deviceVersion",
      "appVersion": appVersion,
      "deviceType": "$deviceType",
    }
      ..addAll(setIpAddress
          ? {"ipAddress": "${interfaces[0].addresses[0].address}"}
          : {})
      ..addAll(
          setNotificationToken ? {"notificationToken": firebaseToken} : {});
  }

  static void launchUrl(String url) async {
    if (await canLaunch(url)) launch(url);
  }

  static Future<String> getDeviceId() async {
    final deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.androidId;
    } else {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor;
    }
  }

  static String formatDate(
      {required String? dateTime, String dateFormat = 'dd-MMM-yyyy'}) {
    try {
      final formatter = DateFormat(dateFormat);
      return formatter.format(DateTime.parse(dateTime ?? '').toLocal());
    } catch (e) {
      return '';
    }
  }

  static String getRemainTimeFromCurrent(String utcTime) {
    final difference =
        DateTime.parse(utcTime).toLocal().difference(DateTime.now());
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    if (difference.inSeconds < 60)
      return '${seconds}s';
    else if (difference.inMinutes < 60)
      return '${minutes}m ${seconds}s';
    else if (difference.inHours < 24)
      return '${hours}h' + ' ' + (minutes > 0 ? '${minutes}m' : '${seconds}s');
    else {
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      final suffix = hours > 0
          ? '${hours}h'
          : minutes > 0
              ? '${minutes}m'
              : '${seconds}s';
      return '${difference.inDays}d $suffix';
    }
  }

  static Color getTimerColor(BuildContext context, String utcTime) {
    final difference =
        DateTime.parse(utcTime).toLocal().difference(DateTime.now());
    return difference.inMinutes < 10
        ? Colors.red
        : Theme.of(context).colorScheme.primaryVariant;
  }

  static void initialNavigation(BuildContext context) =>
      Preference.getUserData().then((user) {
        if (user != null) context.read<UserInfo>().setLoggedUserInfo(user);
        Navigator.of(context).pushReplacementNamed(
            user != null ? HomeScreen.route : LoginSignUpScreen.route);
      });
}
