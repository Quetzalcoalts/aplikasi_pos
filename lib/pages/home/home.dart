//ignore_for_file: todo
import 'package:aplikasi_pos/pages/pembukuan/pembukuan.dart';
import 'package:aplikasi_pos/pages/penjualan/penjualan.dart';
import 'package:aplikasi_pos/pages/setting/setting.dart';
import 'package:aplikasi_pos/pages/stock/stock.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      //KELUAR DARI INPUT KEYBOARD DENGAN MENEKAN HALAMAN/SCAFFOLD SAAT MELAKUKAN SEARCH
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _tabController.index == 0
                ? "Penjualan"
                : _tabController.index == 1
                    ? "Stock"
                    : _tabController.index == 2
                        ? "Pembukuan"
                        : "",
            style: TextStyle(
              color: darkText,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingPage(),
                  ),
                );
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
                  onTap: (index) {
                    setState(() {});
                  },
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
                      text: "Penjualan",
                    ),
                    Tab(
                      text: "Stock",
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
                      PenjualanPage(),
                      StockPage(),
                      PembukuanPage(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
