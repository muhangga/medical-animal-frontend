import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Permission permission = Permission.location;
  PermissionStatus? _permissionStatus;

  Future<void> checkPermission(BuildContext context) async {
    if (await permission.isGranted) {
      print('permission granted');
    } else if (await permission.status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Aktifkan Lokasi untuk menggunakan fitur ini',
          style: whiteTextStyle,
        ),
      ));
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();
      print(statuses[Permission.location]);
    }
  }
}
