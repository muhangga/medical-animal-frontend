import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Permission permission = Permission.location;

  Future<void> checkPermission(BuildContext context) async {
    if (await permission.isGranted) {
      print('permission granted');
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Aktifkan Lokasi untuk menggunakan fitur ini',
          style: whiteTextStyle,
        ),
      ));
      print(statuses[Permission.location]);
    }
  }
}
