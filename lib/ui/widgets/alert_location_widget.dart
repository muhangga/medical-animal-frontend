import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_animal/core/common/theme.dart';

showAlertLocation(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
            width: double.maxFinite,
            height: 280,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/lottie/error.json",
                    animate: true,
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    "Mohon Aktifkan Lokasi Anda",
                    style:
                        blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Untuk Menampilkan Lokasi Klinik Hewan Terdekat",
                    style: blackTextStyle.copyWith(
                        fontSize: 14, fontWeight: light),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
