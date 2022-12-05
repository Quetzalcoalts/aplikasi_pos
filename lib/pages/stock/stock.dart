//ignore_for_file: todo
import 'package:aplikasi_pos/services/class/dataclass.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage>
    with AutomaticKeepAliveClientMixin {
  // late TabController _tabController;

  final _controllerSearchBar = TextEditingController();
  final _controllerScrollBar = ScrollController();

  int _selectedIndexChipsFilter = 0;
  String tesIsiStock = "";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    addStockBarang();
    filterAscending();
    // TODO: implement initState
    // _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    // TODO: implement dispose
    _controllerSearchBar.dispose();

    super.dispose();
  }

  final List<Filter> _chipsFilterList = [
    Filter("Ascending", Colors.white),
    Filter("Descending", Colors.white),
    Filter("Newest", Colors.white),
    Filter("Oldest", Colors.white),
  ];

  List<StockBarang> stockBarangList = [];
  List<StockBarang> displayStockBarangList = [];

  void addStockBarang() {
    for (int i = 0; i < 100; i++) {
      stockBarangList.add(
        StockBarang("P00${i * i * i * i}", "Twistko", "${1000 * (i + 1)}",
            "${2400000 * (i + 1)}"),
      );
    }

    // for (int i = 0; i < 5; i++) {
    //   print("hai ${stockBarangList[i].idStockBarang}");
    //   print("hai ${stockBarangList[i].namaStockBarang}");
    //   print("hai ${stockBarangList[i].jumlahStockBarang}");
    // }
  }

  void filterAscending() {
    displayStockBarangList.clear();
    for (int i = 0; i < stockBarangList.length; i++) {
      displayStockBarangList.add(stockBarangList[i]);
    }
  }

  void filterDescending() {
    displayStockBarangList.clear();
    for (int i = stockBarangList.length - 1; i >= 0; i--) {
      displayStockBarangList.add(stockBarangList[i]);
    }
  }

  //FUNGSI UNTUK MEMISAHKAN ANGKA RIBUAN, JUTAAN, DST
  String numberFormatDotSeparator(String inputParameter) {
    String input = inputParameter;
    String inputInText = "";
    int counter = 0;
    for (int i = (input.length - 1); i >= 0; i--) {
      counter++;
      String str = input[i];
      if ((counter % 3) != 0 && i != 0) {
        inputInText = "$str$inputInText";
      } else if (i == 0) {
        inputInText = "$str$inputInText";
      } else {
        inputInText = ".$str$inputInText";
      }
    }
    return inputInText.trim();
  }

  //GENERATE CHIPS BERDASARKAN LIST DATA CLASS FILTER -> List<Filter> _chipsFilterList
  List<Widget> generateFilterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsFilterList.length; i++) {
      Widget item = ChoiceChip(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: Text(_chipsFilterList[i].label),
        labelStyle: GoogleFonts.nunito(
            fontSize: 13,
            letterSpacing: 0.125,
            fontWeight: FontWeight.w700,
            color: _selectedIndexChipsFilter == i ? Colors.white : darkText),
        backgroundColor: _chipsFilterList[i].color,
        selectedColor: buttonColor,
        selected: _selectedIndexChipsFilter == i,
        onSelected: (bool value) {
          setState(() {
            tesIsiStock = _chipsFilterList[i].label;
            _selectedIndexChipsFilter = i;

            if (_selectedIndexChipsFilter == 0) {
              filterAscending();
            } else if (_selectedIndexChipsFilter == 1) {
              filterDescending();
            }
          });
        },
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  isScrollable: false,
                  labelColor: Colors.white,
                  unselectedLabelColor: darkText,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: buttonColor,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                  labelStyle: GoogleFonts.nunito(
                      color: lightText,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.125),
                  tabs: const [
                    Tab(
                      text: "Stock Barang",
                    ),
                    Tab(
                      text: "Stock Masuk",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //TAB BAR VIEW STOCK BARANG
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SEARCH BAR
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 4,
                            child: TextField(
                              onChanged: (value) {
                                // updateGrid(value)
                                setState(() {});
                              },
                              controller: _controllerSearchBar,
                              cursorColor: Colors.lightBlueAccent,
                              decoration: InputDecoration(
                                suffixIcon: Visibility(
                                  visible: _controllerSearchBar.text == ""
                                      ? false
                                      : true,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controllerSearchBar.clear();
                                        // updateGrid("");
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: darkText,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                filled: true,
                                isDense: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: darkText,
                                  size: 28,
                                ),
                                hintText: "Cari Stock",
                                hintStyle: GoogleFonts.nunito(
                                  color: Colors.black45,
                                  fontSize: 14,
                                  letterSpacing: 0.125,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //FILTER
                        Wrap(
                          spacing: 6,
                          direction: Axis.horizontal,
                          children: generateFilterChips(),
                        ),

                        //ISI DARI STOCK
                        // Expanded(
                        //   child: Center(
                        //     child: Text(tesIsiStock),
                        //   ),
                        // ),

                        Expanded(
                          child: Column(
                            children: [
                              //ISI HEADER TABEL STOCK
                              Card(
                                color: buttonColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "ID",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            letterSpacing: 0.125,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Nama Barang",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            letterSpacing: 0.125,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Jumlah",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            letterSpacing: 0.125,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Harga",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            letterSpacing: 0.125,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Scrollbar(
                                  radius: const Radius.circular(8),
                                  thumbVisibility: true,
                                  controller: _controllerScrollBar,
                                  child: ListView.builder(
                                    controller: _controllerScrollBar,
                                    itemCount: displayStockBarangList.length,
                                    itemBuilder: (context, indexStockBarang) {
                                      return SizedBox(
                                        width: deviceWidth,
                                        child: Column(
                                          children: [
                                            //ISI TABEL STOCK BARANG
                                            Card(
                                              color: indexStockBarang % 2 == 0
                                                  ? cardInfoColor1
                                                  : cardInfoColor2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        displayStockBarangList[
                                                                indexStockBarang]
                                                            .idStockBarang,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        displayStockBarangList[
                                                                indexStockBarang]
                                                            .namaStockBarang,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        numberFormatDotSeparator(
                                                          displayStockBarangList[
                                                                  indexStockBarang]
                                                              .jumlahStockBarang,
                                                        ),
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        NumberFormat
                                                                .simpleCurrency(
                                                                    locale:
                                                                        'id-ID',
                                                                    name:
                                                                        "Rp. ")
                                                            .format(double.parse(
                                                                displayStockBarangList[
                                                                        indexStockBarang]
                                                                    .hargaStockBarang)),
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //TAB BAR VIEW STOCK MASUK
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Center(
                        child: Text(
                          "Stock Masuk",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SizedBox(
            height: deviceHeight / 7,
            width: deviceWidth / 7,
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              onPressed: () {},
              child: const Expanded(
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
