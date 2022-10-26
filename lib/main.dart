//ignore_for_file: todo
import 'package:animations/animations.dart';
import 'package:aplikasi_pos/globals.dart';
import 'package:aplikasi_pos/pages/authentication/auth.dart';
import 'package:aplikasi_pos/pages/home/home.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserAuth(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserAuthentication(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Aplikasi POS",
        builder: (context, child) => ResponsiveWrapper.builder(
          child,
          maxWidth: 2460,
          minWidth: 480,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K")
          ],
          background: Container(
            color: const Color(0xFFF5F5F5),
          ),
        ),
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.125),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          cardColor: cardColor,
          textTheme: GoogleFonts.nunitoTextTheme(
            TextTheme(
              headline1: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 101,
                letterSpacing: -0.15,
              ),
              headline2: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 63,
                letterSpacing: -0.015,
              ),
              headline3: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 50,
                letterSpacing: 0.0,
              ),
              headline4: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 36,
                letterSpacing: 0.025,
              ),
              headline5: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                letterSpacing: 0,
              ),
              headline6: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w700,
                fontSize: 21,
                letterSpacing: 0.015,
              ),
              subtitle1: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 17,
                letterSpacing: 0.015,
              ),
              subtitle2: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                letterSpacing: 0.01,
              ),
              bodyText1: GoogleFonts.nunito(
                color: lightText,
                fontWeight: FontWeight.normal,
                fontSize: 17,
                letterSpacing: 0.05,
              ),
              bodyText2: GoogleFonts.nunito(
                  color: darkText,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  letterSpacing: 0.025),
              button: GoogleFonts.nunito(
                color: primaryColorVariant,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.125,
              ),
              caption: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 12,
                letterSpacing: 0.04,
              ),
              overline: GoogleFonts.nunito(
                color: darkText,
                fontWeight: FontWeight.normal,
                fontSize: 10,
                letterSpacing: 0.15,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(primary: primaryColor, secondary: primaryColorVariant),
        ).copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal),
            },
          ),
        ),
        home: const MyApp(),
      ),
    ),
  );
}

class UserAuth with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setIsLoggedIn(val) {
    _isLoggedIn = val;
    notifyListeners();
  }
}

class UserAuthentication with ChangeNotifier {
  String _loginStatus = "false";
  String _idUser = "";

  String get loginStatus => _loginStatus;
  String get kodeUser => _idUser;

  void setUserAuthentication(loginStatus, idUser) {
    _loginStatus = loginStatus;
    _idUser = kodeUser;
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    getPrefAuth().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<UserAuth>().setIsLoggedIn(loginStatus);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getPrefAuth() async {
    final prefs = await SharedPreferences.getInstance();
    loginStatus = prefs.getBool('userStatus') ?? false;
    idUser = prefs.getString('idUser') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<UserAuth>().isLoggedIn) {
      debugPrint(context.watch<UserAuth>().isLoggedIn.toString());
      debugPrint("$loginStatus, $idUser");
      return const HomePage();
    } else {
      debugPrint(context.watch<UserAuth>().isLoggedIn.toString());
      debugPrint("$loginStatus, $idUser");
      return const HomePage();
    }
  }
}
