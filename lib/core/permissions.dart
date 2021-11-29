import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void managePermission({
  required BuildContext context,
  required List<Permission> permissions,
  required Function onGranted,
}) async {
  var grantedFlags = <bool>[];
  var deniedPermissions = <Permission>[];

  await Future.forEach<Permission>(permissions, (permission) async {
    if (await permission.isPermanentlyDenied) {
      grantedFlags.add(false);
      deniedPermissions.add(permission);
    } else if (!await permission.isGranted) {
      grantedFlags.add(false);
      final status = await permission.request();
      if (status.isPermanentlyDenied)
        deniedPermissions.add(permission);
      if (status.isGranted || status.isLimited)
        grantedFlags[grantedFlags.length - 1] = true;
    }
  });
  if (!grantedFlags.contains(false)) onGranted.call();
  if (deniedPermissions.length > 0) {
    _showPermissionSettingsDialog(
      context: context,
      message: await _getRationalePermissions(permissions: deniedPermissions),
    );
  }
}

Future<bool?> _showPermissionSettingsDialog(
    {required BuildContext context, required String message}) async {
  return showCupertinoDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text('Permission required'),
        content: Text('You need to allow $message permission from settings'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          CupertinoDialogAction(
            child: Text('Go to Settings'),
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
          )
        ],
      );
    },
  );
}

Future<String> _getRationalePermissions(
    {List<Permission> permissions = const []}) async {
  List<String> stringList = [];
  for (var permission in permissions) {
    if (await permission.isPermanentlyDenied || await permission.isDenied)
      stringList.add(permission.toString().substring(11));
  }
  return stringList.toString().substring(1, stringList.toString().length - 1);
}
