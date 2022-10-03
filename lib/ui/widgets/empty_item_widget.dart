import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';

class EmptyItemWidget extends StatelessWidget {
  const EmptyItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.explore_off_outlined, size: 130, color: Colors.red),
          const SizedBox(
            height: 10,
          ),
          Text("Data tidak ditemukan",
              style: blackTextStyle.copyWith(fontSize: 20, fontWeight: bold)),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Mohon maaf, tidak ada klinik yang tersedia di sekitar anda',
            style: greyTextStyle.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
