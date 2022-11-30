import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/ui/pages/home/main_page.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ic_user.png', width: 190, height: 190),
            const SizedBox(height: 50),
            Text(
              "Klinik Hewan Terdekat",
              style: blackTextStyle.copyWith(fontSize: 24, fontWeight: bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Cari Klinik Hewan Terdekat dari posisi anda sekarang",
              style: greyTextStyle,
            ),
            const SizedBox(height: 30),
            Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => MainPage())),
                style: ElevatedButton.styleFrom(
                  primary: kRedColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Get Started"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
