import 'dart:async';
import 'dart:io';

import 'package:simple_permissions/simple_permissions.dart';

class DevicePermissions {

  ///
  Future<bool> checkWriteExternalStorage() async {
    bool externalStoragePermissionOkay = false;
    //todo tbm deve dar permissoes para ler
    if (Platform.isAndroid) {
      SimplePermissions
          .checkPermission(Permission.WriteExternalStorage)
          .then((checkOkay) {
        if (!checkOkay) {
          SimplePermissions
              .requestPermission(Permission.WriteExternalStorage)
              .then((okDone) {
            if (okDone) {
              print("$okDone");
              externalStoragePermissionOkay = okDone;
            }
          });
        } else {
          externalStoragePermissionOkay = checkOkay;
        }
      });
    }
    return externalStoragePermissionOkay;
  }

  ///
  Future<bool> checkReadExternalStorage() async {
    bool externalStoragePermissionOkay = false;
    //todo tbm deve dar permissoes para ler
    if (Platform.isAndroid) {
      SimplePermissions
          .checkPermission(Permission.ReadExternalStorage)
          .then((checkOkay) {
        if (!checkOkay) {
          SimplePermissions
              .requestPermission(Permission.ReadExternalStorage)
              .then((okDone) {
            if (okDone) {
              print("$okDone");
              externalStoragePermissionOkay = okDone;
            }
          });
        } else {
          externalStoragePermissionOkay = checkOkay;
        }
      });
    }
    return externalStoragePermissionOkay;
  }



}