import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';

Widget locationOffWidget() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(Icons.location_off_rounded, size: 100, color: kRedColor),
      SizedBox(height: 10),
      Text('Lokasi Tidak ditemukan', style: TextStyle(color: kBlackColor))
    ],
  ));
}
