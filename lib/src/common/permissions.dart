import 'dart:async';

import 'package:simple_permissions/simple_permissions.dart';

class DevicePermissions {

  ///
  Future<bool> checkWriteExternalStorage() async {
    bool externalStoragePermissionOkay = false;
    //todo tbm deve dar permissoes para ler
   // if (Platform.isAndroid) {
      SimplePermissions
          .checkPermission(Permission.WriteExternalStorage)
          .then((checkOkay) async {
        if (!checkOkay) {
          var status = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
          print(status);

              /*.then((PermissionStatus okDone) {
          /*  if (okDone) {
              print("$okDone");
              externalStoragePermissionOkay = okDone;
            }*/
          });*/
        } else {
          externalStoragePermissionOkay = checkOkay;
        }
      });
   // }
    return externalStoragePermissionOkay;
  }

  ///
  Future<bool> checkReadExternalStorage() async {
    bool externalStoragePermissionOkay = false;

    //if (Platform.isAndroid) {
      SimplePermissions
          .checkPermission(Permission.ReadExternalStorage)
          .then((checkOkay)async{
        if (!checkOkay) {
          var status = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
          print(status);

          /*.then((PermissionStatus okDone) {
          /*  if (okDone) {
              print("$okDone");
              externalStoragePermissionOkay = okDone;
            }*/
          });*/
        } else {
          externalStoragePermissionOkay = checkOkay;
        }
      });
   // }
    return externalStoragePermissionOkay;
  }



}