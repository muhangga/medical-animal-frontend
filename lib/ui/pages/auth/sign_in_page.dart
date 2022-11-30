import 'package:flutter/material.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/ui/pages/auth/sign_up_page.dart';
import 'package:medical_animal/ui/pages/home/main_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                Center(
                  child: SizedBox(
                    child: Image.asset(
                      "assets/animal_clinic.png",
                      width: 150,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Masuk",
                        style: secondaryTextStyle.copyWith(
                            fontSize: 24, fontWeight: bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Untuk mencari lokasi klinik hewan terdekat",
                          style: greyTextStyle.copyWith(fontSize: 16)),
                    ],
                  ),
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
                const SizedBox(
                  height: 10,
                ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: Text(
                        "Daftar!",
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
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    },
                    child: Text(
                      "Masuk",
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
