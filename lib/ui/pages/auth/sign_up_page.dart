import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/ui/pages/auth/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isNamaValid = false;
  bool isUsernameValid = false;
  bool isPasswordValid = false;
  bool isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 60),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daftar Akun",
                        style: secondaryTextStyle.copyWith(
                            fontSize: 24, fontWeight: bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "Daftar akun untuk mencari lokasi klinik hewan terdekat",
                          style: greyTextStyle.copyWith(fontSize: 16)),
                    ],
                  ),
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      isNamaValid = text.length >= 4;
                    });
                  },
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Nama Lengkap",
                      hintText: "Nama Lengkap"),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      isUsernameValid = text.length >= 3;
                    });
                  },
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Username",
                      hintText: "Input Username"),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      isPasswordValid = text.length >= 6;
                    });
                  },
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Password",
                      hintText: "Password"),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Belum punya akun? ",
                      style:
                          greyTextStyle.copyWith(fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignInPage();
                        }));
                      },
                      child: Text(
                        "Masuk!",
                        style: mainTextStyle,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kSecondaryColor,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Daftar Akun",
                      style: whiteTextStyle.copyWith(
                          fontWeight: bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
