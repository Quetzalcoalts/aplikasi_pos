//ignore_for_file: todo
import 'package:aplikasi_pos/pages/authentication/auth.dart';
import 'package:aplikasi_pos/pages/pembukuan/pembukuan.dart';
import 'package:aplikasi_pos/pages/penjualan/penjualan.dart';
import 'package:aplikasi_pos/pages/stock/stock.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "A",
          style: TextStyle(
            color: darkText,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AuthPage();
              }));
            },
            icon: Icon(
              Icons.settings,
              color: darkText,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelColor: lightText,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: darkText,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: buttonColor,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                labelStyle: GoogleFonts.nunito(
                    color: lightText,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.125),
                tabs: const <Widget>[
                  Tab(
                    text: "Stock",
                  ),
                  Tab(
                    text: "Penjualan",
                  ),
                  Tab(
                    text: "Pembukuan",
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    StockPage(),
                    PenjualanPage(),
                    PembukuanPage(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
