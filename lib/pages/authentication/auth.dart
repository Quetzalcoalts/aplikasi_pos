// ignore_for_file: prefer_const_constructors, unnecessary_new, use_build_context_synchronously

import 'dart:convert';

import 'package:aplikasi_pos/pages/home/home.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? usernameA = "";
String? passwordA = "";
String? status;
String? Id;
final userkeyl = GlobalKey<FormState>();
final passkeyl = GlobalKey<FormState>();
bool strok = false;
bool hidePass = true;
final TextEditingController controllerUsername = TextEditingController();
final TextEditingController controllerPassword = TextEditingController();
String usernameSP = "";
String passwordSP = "";
bool statusSP = false;
String IdSP = "";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var berhasiLogin = false;
  final pref = SharedPreferences.getInstance();

  void initState() {
    super.initState();
    checkSP();
  }

  checkSP() async {
    final pref = await SharedPreferences.getInstance();
    statusSP = pref.getBool("statusLogin") ?? false;
    if (statusSP == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext) => HomePage(),
        ),
      );
    } else {
      berhasiLogin = false;
    }
  }

  Login(username, password) async {
    final pref = await SharedPreferences.getInstance();
    var url = Uri.parse(
        "http://kostsoda.onthewifi.com:38600/us/login?username=$username&password=$password");
    var response = await http.get(url);
    if (statusSP == true) {
      berhasiLogin = true;
    } else {
      var jsonStatus = json.decode(response.body)['status'];
      var jsonKode = json.decode(response.body)['data']['kode_user'];
      var jsonUsername = json.decode(response.body)['data']['username'];
      var jsonPassword = json.decode(response.body)['data']['password'];
      if (jsonStatus == 200) {
        if (jsonUsername != "" && jsonPassword != "") {
          berhasiLogin = true;

          pref.setString("namaUser", jsonUsername);
          pref.setString("passwordUser", jsonPassword);
          pref.setBool("statusLogin", berhasiLogin);
          pref.setString("Id_User", jsonKode);

          usernameSP = pref.getString("namaUser") ?? "";
          passwordSP = pref.getString("passwordUser") ?? "";
          statusSP = pref.getBool("statusLogin") ?? false;
          IdSP = pref.getString('Id_User') ?? "";
        } else {
          berhasiLogin = false;
        }
      } else {
        berhasiLogin = false;
      }
    }
    print(usernameSP);
  }

  void clear() {
    controllerUsername.clear();
    controllerPassword.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Text(
                "Selamat Datang",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Silahkan masukkan username dan password yang telah terdaftar untuk lanjut ke halaman berikutnya",
                  style: TextStyle(height: 1.2, fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: Text(
                  "Username",
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Form(
                  key: userkeyl,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        strok = true;
                        return 'Username Kosong';
                      } else if (berhasiLogin == false) {
                        strok = true;
                        return 'Username Salah';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    controller: controllerUsername,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukkan Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: strok == true
                              ? Colors.red
                              : Color.fromRGBO(229, 229, 229, 1),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  "Password",
                  style: TextStyle(
                      color: buttonColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Form(
                  key: passkeyl,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        strok = true;
                        return 'Password Kosong';
                      } else if (berhasiLogin == false) {
                        strok = true;
                        return 'Password Salah';
                      }
                      return null;
                    },
                    controller: controllerPassword,
                    obscureText: hidePass,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Masukkan Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                          color: strok == true ? Colors.red : buttonColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePass = !hidePass;
                          });
                        },
                        icon: hidePass == false
                            ? Icon(Icons.remove_red_eye_outlined)
                            : Icon(Icons.visibility_off_outlined),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Login(
                              controllerUsername.text, controllerPassword.text);
                          if (passkeyl.currentState!.validate()) {}
                          if (userkeyl.currentState!.validate()) {}
                          if (berhasiLogin == true) {
                            clear();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(),
                              ),
                            );
                          } else {
                            clear();
                          }
                        },
                        child: Text("Login"),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
