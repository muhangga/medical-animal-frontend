import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';

class EmptyLocationWidget extends StatelessWidget {
  const EmptyLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off_rounded, size: 130, color: Colors.red),
          const SizedBox(
            height: 10,
          ),
          Text("Lokasi tidak ditemukan",
              style: blackTextStyle.copyWith(fontSize: 20, fontWeight: bold)),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Aktifkan lokasi anda untuk menemukan klinik terdekat',
            style: greyTextStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
