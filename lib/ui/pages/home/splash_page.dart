import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/ui/pages/home/get_started_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      backgroundColor: kSecondaryColor,
      logo: Image.asset('assets/veterinarian.png'),
      logoWidth: 80,
      loaderColor: Colors.white,
      loadingText: Text('Pencarian Klinik Hewan Terdekat',
          style: whiteTextStyle.copyWith(fontSize: 12)),
      navigator: const GetStarted(),
      durationInSeconds: 10,
    );
  }
}
