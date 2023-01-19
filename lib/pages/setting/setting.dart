import 'dart:ui';

import 'package:aplikasi_pos/pages/setting/services.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  _showLogout(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(15, 35, 15, 0),
                              child: Text(
                                "Apakah anda yakin ingin keluar?",
                                style: GoogleFonts.inter(
                                  color: darkText,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 50,
                                child: VerticalDivider(thickness: 1)),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Ok",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    color: darkText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Profil",
              style: GoogleFonts.inter(
                color: darkText,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: darkText,
                ))),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 10),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.amber),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: Text(
                          "Herry Kusmanto",
                          style: GoogleFonts.inter(
                            color: darkText,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Version 1.0",
                            style: GoogleFonts.inter(
                              color: darkText,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 20,
                  color: Color(0xffF5F5F5),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Image(
                                image: AssetImage(
                                  'lib/assets/images/Paper.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Text(
                              "Retur",
                              style: GoogleFonts.inter(
                                color: darkText,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Image(
                                image: AssetImage(
                                  'lib/assets/images/Profile.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Text(
                              "Edit Profile",
                              style: GoogleFonts.inter(
                                color: darkText,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SupplierPage()));
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Image(
                                image: AssetImage(
                                  'lib/assets/images/3User.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Text(
                              "Pilih Supplier",
                              style: GoogleFonts.inter(
                                color: darkText,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _showLogout(deviceWidth, deviceHeight);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xffD9D9D9),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Image(
                                image: AssetImage(
                                  'lib/assets/images/Logout.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 25),
                            Text(
                              "Logout",
                              style: GoogleFonts.inter(
                                color: darkText,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String password = "apaantuh";
  String _tempPassword = "";
  bool _passwordVisible = true;

  final _controllerUpdate = TextEditingController();

  _ubahBintang(val) {
    for (int i = 0; i < val.length; i++) {
      _tempPassword = _tempPassword + "*";
    }
  }

  @override
  void initState() {
    _ubahBintang(password);
    super.initState();
  }

  void _passwordVisibility() {
    if (mounted) {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }
  }

  _showEditNama(dw, dh, type, pw) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Edit $type",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type,
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerUpdate,
                                  obscureText: pw ? _passwordVisible : false,
                                  showCursor: false,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input $type',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    suffixIcon: pw == true
                                        ? IconButton(
                                            color: buttonColor,
                                            onPressed: () {
                                              _passwordVisibility();
                                            },
                                            icon: Icon(_passwordVisible == true
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 50,
                                child: VerticalDivider(thickness: 1)),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Ok",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    color: darkText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Edit Profil",
              style: GoogleFonts.inter(
                color: darkText,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: darkText,
                ))),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: ScrollController(),
            child: Container(
                padding: EdgeInsets.fromLTRB(20, 35, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama",
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                color: darkText,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Herry Kusmanto",
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    color: darkText,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _showEditNama(deviceWidth, deviceHeight,
                                        "Nama", false);
                                  },
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_outlined))
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Color(0xffF5F5F5),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                color: darkText,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "JamesSmith",
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    color: darkText,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _showEditNama(deviceWidth, deviceHeight,
                                        "Username", false);
                                  },
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_outlined))
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Color(0xffF5F5F5),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password",
                            style: GoogleFonts.inter(
                                fontSize: 17,
                                color: darkText,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _tempPassword,
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    color: darkText,
                                    fontWeight: FontWeight.w400),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _showEditNama(deviceWidth, deviceHeight,
                                        "Password", true);
                                  },
                                  icon: const Icon(
                                      Icons.arrow_forward_ios_outlined))
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Color(0xffF5F5F5),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  ServicesSetting servicesUser = ServicesSetting();
  late Future getSupplier;

  final _controllerNamaSup = TextEditingController();
  final _controllerNoSup = TextEditingController();
  final _controllerEmailSup = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getSupplier = servicesUser.getSupplier();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future postSupplier(namaSup, noSup, emailSup, context) async {
    var response = await servicesUser.inputSupplier(namaSup, noSup, emailSup);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  Future deleteSupplier(kodeSup, context) async {
    var response = await servicesUser.deleteSupplier(kodeSup);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  _showTambahSupplier(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Tambah Supplier",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 20,
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nama Supplier",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerNamaSup,
                                  showCursor: false,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Nama Supplier',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "No HP",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerNoSup,
                                  showCursor: false,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input No HP Supplier',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Email",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerEmailSup,
                                  showCursor: false,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Email Supplier',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _controllerNamaSup.clear();
                                  _controllerNoSup.clear();
                                  _controllerEmailSup.clear();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 50,
                                child: VerticalDivider(thickness: 1)),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      postSupplier(
                                              _controllerNamaSup.text,
                                              _controllerNoSup.text,
                                              _controllerEmailSup.text,
                                              context)
                                          .then((value) {
                                        _controllerNamaSup.clear();
                                        _controllerNoSup.clear();
                                        _controllerEmailSup.clear();
                                        Navigator.pop(context);
                                      });
                                    });
                                  }
                                },
                                child: Text(
                                  "Ok",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    color: darkText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        getSupplier = servicesUser.getSupplier();
      });
    });
  }

  _showDeleteSupplier(dw, dh, indexDeleteSup, nama) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
                              child: Text(
                                "Apakah anda yakin ingin menghapus supplier $nama?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    height: 1.8),
                              )),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 50,
                                child: VerticalDivider(thickness: 1)),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  deleteSupplier(indexDeleteSup, context)
                                      .whenComplete(() {
                                    getSupplier = servicesUser.getSupplier();
                                    setState(() {});
                                  });
                                  setState(() {
                                    getSupplier = servicesUser.getSupplier();
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Ok",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    color: darkText,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        getSupplier = servicesUser.getSupplier();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Supplier",
            style: GoogleFonts.inter(
              color: darkText,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: darkText,
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTambahSupplier(deviceWidth, deviceHeight);
        },
        backgroundColor: buttonColor,
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 35, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 15,
              shadowColor: Colors.black87,
              child: TextField(
                //controller: _controllerSearch,
                showCursor: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: primaryColor,
                  hintText: 'Cari Supplier',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: secondaryColorVariant,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              elevation: 15,
              shadowColor: Colors.black87,
              color: buttonColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "ID",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          letterSpacing: 0.125,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Nama",
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              letterSpacing: 0.125,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "No HP",
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            letterSpacing: 0.125,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            letterSpacing: 0.125,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "a",
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          letterSpacing: 0.125,
                          fontWeight: FontWeight.w700,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              future: getSupplier,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List snapData = snapshot.data! as List;
                  if (snapData[0] != 404) {
                    return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapData[1].length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                              ),
                              color: lightText,
                              //masih ada masalah di title card
                              child: ListTile(
                                  title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapData[1][index]['kode_supplier'],
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          snapData[1][index]['nama_supplier'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: darkText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapData[1][index]['nomor_telpon'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapData[1][index]['email_supplier'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        onPressed: () {
                                          _showDeleteSupplier(
                                              deviceWidth,
                                              deviceHeight,
                                              snapData[1][index]
                                                  ['kode_supplier'],
                                              snapData[1][index]
                                                  ['nama_supplier']);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                            );
                          },
                        ));
                  } else if (snapData[0] == 404) {
                    return Column();
                  }
                }

                return Column();
              },
            ),
          ],
        ),
      ),
    );
  }
}
