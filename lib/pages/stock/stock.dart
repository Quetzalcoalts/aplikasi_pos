//ignore_for_file: todo
import 'dart:ui';
import 'package:aplikasi_pos/pages/stock/dataclass.dart';
import 'package:aplikasi_pos/class/dataclass.dart';
import 'package:aplikasi_pos/pages/stock/services.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

int _selectedIndexChipsFilter = 0;
int _filterTanggalIndex = 0;
bool _filterTanggalCheck = false;

String ikiSatuanCok = "";

int _satuanKirim = 0;
String _dateKirim = "";
String _TanggalKirim = "";

enum RadioFilterUrutan { Ascending, Descending }

enum RadioFilterTanggal { Harian, Bulanan, Tahunan }

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage>
    with AutomaticKeepAliveClientMixin {
  ServicesStock servicesStock = ServicesStock();
  // late TabController _tabController;

  final _controllerSearchBar = TextEditingController();
  final _controllerScrollBar = ScrollController();

  final _controllerNamaBarangStock = TextEditingController();
  final _controllerJumlahBarangStock = TextEditingController();
  final _controllerHargaBarangStock = TextEditingController();
  final _controllerSatuanBarangStock = TextEditingController();

  late Future listStock;
  late Future listStockMasuk;

  int _selectedIndexChipsFilter = 0;
  String tesIsiStock = "";
  int statusFloat = 0;

  DateTime _selectedDate = DateTime.now();
  String _formattedDate = "";
  String _date = "";

  DateTime _selectedDateFrom = DateTime.now();
  String _formattedDateFrom = "";
  String _dateFrom = "";

  DateTime _selectedDateBulan = DateTime.now();
  String _formattedDateBulan = "";
  String _dateBulan = "";

  DateTime _selectedDateTahun = DateTime.now();
  String _formattedDateTahun = "";
  String _dateTahun = "";

  final isDialOpen = ValueNotifier(false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // addStockBarang();
    // filterAscending();
    // TODO: implement initState
    // _tabController = TabController(length: 2, vsync: this);

    listStock = servicesStock.getStock();
    listStockMasuk = servicesStock.getStockIn();
  }

  @override
  void dispose() {
    super.dispose();

    // _tabController.dispose();
    // TODO: implement dispose
    _controllerNamaBarangStock.dispose();
    _controllerJumlahBarangStock.dispose();
    _controllerHargaBarangStock.dispose();
    _controllerSatuanBarangStock.dispose();
    _controllerSearchBar.dispose();
  }

  final List<Filter> _chipsFilterList = [
    Filter("Ascending", Colors.white),
    Filter("Descending", Colors.white),
  ];

  List<StockBarang> stockBarangList = [];
  List<StockBarang> displayStockBarangList = [];

  void addStockBarang() {
    for (int i = 0; i < 10; i++) {
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

  Future postStockBarang(nama, jumlah, harga, satuan, context) async {
    var response = await servicesStock.postStock(nama, jumlah, harga, satuan);
    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Barang Sudah Ada DiStock"),
        ),
      );
    }
  }

  _showTambahBarang(dw, dh) {
    _controllerNamaBarangStock.clear();
    _controllerJumlahBarangStock.clear();
    _controllerHargaBarangStock.clear();
    _controllerSatuanBarangStock.clear();
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
                            "Tambah Barang",
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
                                  "Nama Barang",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerNamaBarangStock,
                                  cursorColor: Colors.lightBlueAccent,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Nama Barang',
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Jumlah",
                                            style: GoogleFonts.inter(
                                              color: buttonColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller:
                                                _controllerJumlahBarangStock,
                                            cursorColor: Colors.lightBlueAccent,
                                            keyboardType: TextInputType.number,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffE5E5E5),
                                              hintText: 'Input Jumlah',
                                              hintStyle: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Satuan",
                                            style: GoogleFonts.inter(
                                              color: buttonColor,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          TextField(
                                            controller:
                                                _controllerSatuanBarangStock,
                                            cursorColor: Colors.lightBlueAccent,
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  const Color(0xffE5E5E5),
                                              hintText: 'Input Satuan',
                                              hintStyle: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 10),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Harga",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerHargaBarangStock,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.lightBlueAccent,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Harga Barang',
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
                                  postStockBarang(
                                          _controllerNamaBarangStock.text,
                                          _controllerJumlahBarangStock.text,
                                          _controllerHargaBarangStock.text,
                                          "/${_controllerSatuanBarangStock.text}",
                                          context)
                                      .whenComplete(() => setState(() {
                                            listStock =
                                                servicesStock.getStock();
                                          }))
                                      .then((value) => Navigator.pop(context));
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

  _showDeleteStokMasuk(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "ID Barang : xxx",
                                    style: GoogleFonts.inter(
                                        color: darkText,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        height: 1.8),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Tanggal : xxx",
                                    style: GoogleFonts.inter(
                                        color: darkText,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        height: 1.8),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Nama Supplier : xxx",
                                    style: GoogleFonts.inter(
                                        color: darkText,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        height: 1.8),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "Apakah anda yakin ingin menghapus barang ini ?",
                                    style: GoogleFonts.inter(
                                        color: darkText,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Divider(
                          height: 0,
                          color: dividerColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 56,
                              child: VerticalDivider(
                                width: 0.1,
                                color: dividerColor,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Ok",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
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

  Future<void> selectFilterDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 10, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: buttonColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != _selectedDate) {
      if (mounted) {
        _selectedDate = picked;
        _formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);
        _date = _formattedDate;

        setState(() {});
      }
    }
  }

  void initialSelectedDate() {
    _formattedDateFrom = DateFormat('dd-MM-yyyy').format(_selectedDateFrom);
    _dateFrom = _formattedDateFrom;

    _formattedDateBulan = DateFormat('MM-yyyy').format(_selectedDateBulan);
    _dateBulan = _formattedDateBulan;

    _formattedDateTahun = DateFormat('yyyy').format(_selectedDateTahun);
    _dateTahun = _formattedDateTahun;
  }

  Future<void> selectFilterDateFrom(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateFrom,
      firstDate: DateTime(DateTime.now().year - 10, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: buttonColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != _selectedDateFrom) {
      if (mounted) {
        _selectedDateFrom = picked;
        _formattedDateFrom = DateFormat('dd-MM-yyyy').format(_selectedDateFrom);
        _dateFrom = _formattedDateFrom;
        _dateKirim = _dateFrom;
        setState(() {});
      }
    }
  }

  Future<void> selectFilterDateBulan(context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedDateBulan,
      firstDate: DateTime(DateTime.now().year - 10, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: buttonColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != _selectedDateBulan) {
      if (mounted) {
        _selectedDateBulan = picked;
        _formattedDateBulan = DateFormat('MM-yyyy').format(_selectedDateBulan);
        _dateBulan = _formattedDateBulan;
        _dateKirim = _dateBulan;
        setState(() {});
      }
    }
  }

  Future selectFilterDateTahun(context, dw, dh) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "SELECT YEAR",
                  style: GoogleFonts.nunito(
                      fontSize: 14,
                      letterSpacing: 0.125,
                      color: filterText,
                      fontWeight: FontWeight.w600),
                ),
              ),
              content: Container(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(DateTime.now().year - 10, 1),
                  lastDate: DateTime(DateTime.now().year + 10, 1),
                  initialDate: DateTime.now(),
                  currentDate: _selectedDateTahun,
                  selectedDate: _selectedDateTahun,
                  onChanged: (DateTime dateTime) {
                    _selectedDateTahun = dateTime;
                    print(_selectedDateTahun.year);
                    setState(() {});
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _dateKirim = "";
                    _dateTahun = "";
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CANCEL",
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        letterSpacing: 0.125,
                        color: navButtonPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _dateTahun = "${_selectedDateTahun.year}";
                    _dateKirim = _dateTahun;
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.nunito(
                        fontSize: 14,
                        letterSpacing: 0.125,
                        color: navButtonPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  filterTanggalWidget(context, index, StateSetter setState, dw, dh) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Tanggal",
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  letterSpacing: 0.125,
                  color: filterText,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                _TanggalKirim = "0";
                selectFilterDateFrom(context).then((value) => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: cardInfoColor2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_dateFrom),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (index == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Bulan",
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  letterSpacing: 0.125,
                  color: filterText,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                _TanggalKirim = "1";
                selectFilterDateBulan(context).then((value) => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: cardInfoColor2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_dateBulan),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else if (index == 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Tahun",
              style: GoogleFonts.nunito(
                  fontSize: 14,
                  letterSpacing: 0.125,
                  color: filterText,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                _TanggalKirim = "2";
                selectFilterDateTahun(context, dw, dh)
                    .whenComplete(() => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: cardInfoColor2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_dateTahun),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  //FUNGSI FILTERING STOK MASUK
  void filterStokMasuk(dw, dh) {
    RadioFilterUrutan? radioFilterUrutan;
    RadioFilterTanggal? radioFilterTanggal;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                  child: SizedBox(
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Text(
                              "Filter",
                              style: GoogleFonts.nunito(
                                  fontSize: 23,
                                  letterSpacing: 0.125,
                                  color: darkText,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Filter Sesuai Status",
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      letterSpacing: 0.125,
                                      color: buttonColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterUrutan.Ascending,
                                          groupValue: radioFilterUrutan,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterUrutan =
                                                value as RadioFilterUrutan;
                                            _satuanKirim = 0;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Ascending",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterUrutan.Descending,
                                          groupValue: radioFilterUrutan,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterUrutan =
                                                value as RadioFilterUrutan;
                                            _satuanKirim = 1;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Descending",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Filter Sesuai Tanggal",
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      letterSpacing: 0.125,
                                      color: buttonColor,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterTanggal.Harian,
                                          groupValue: radioFilterTanggal,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterTanggal =
                                                value as RadioFilterTanggal;
                                            _filterTanggalCheck = true;
                                            _filterTanggalIndex = 0;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Harian",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterTanggal.Bulanan,
                                          groupValue: radioFilterTanggal,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterTanggal =
                                                value as RadioFilterTanggal;
                                            _filterTanggalCheck = true;
                                            _filterTanggalIndex = 1;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Bulanan",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    const SizedBox(width: 5),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterTanggal.Tahunan,
                                          groupValue: radioFilterTanggal,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterTanggal =
                                                value as RadioFilterTanggal;
                                            _filterTanggalCheck = true;
                                            _filterTanggalIndex = 2;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Tahunan",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              Visibility(
                                visible: _filterTanggalCheck,
                                child: filterTanggalWidget(context,
                                    _filterTanggalIndex, setState, dw, dh),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: dividerColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  _satuanKirim = 0;
                                  _TanggalKirim = "";
                                  _dateKirim = "";
                                  _dateFrom = "";
                                  _dateBulan = "";
                                  _dateTahun = "";
                                  _filterTanggalCheck = false;
                                  _selectedDateFrom = DateTime.now();
                                  _selectedDateBulan = DateTime.now();
                                  _selectedDateTahun = DateTime.now();
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 56,
                              child: VerticalDivider(
                                  width: 0.1, color: dividerColor),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  onPressed: () {
                                    listStockMasuk = servicesStock
                                        .getFilterStockMasuk(
                                            _dateKirim.toString(),
                                            _satuanKirim.toString(),
                                            _TanggalKirim.toString())
                                        .whenComplete(() {
                                      _satuanKirim = 0;
                                      _TanggalKirim = "";
                                      _dateKirim = "";
                                      _dateFrom = "";
                                      _dateBulan = "";
                                      _dateTahun = "";
                                      _filterTanggalCheck = false;
                                      _selectedDateFrom = DateTime.now();
                                      _selectedDateBulan = DateTime.now();
                                      _selectedDateTahun = DateTime.now();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text(
                                    "Ok",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
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
    ).whenComplete(() => setState(() {}));
  }

  //GENERATE CHIPS BERDASARKAN LIST DATA CLASS FILTER -> List<Filter> _chipsFilterList
  List<Widget> generateFilterChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsFilterList.length; i++) {
      Widget item = ChoiceChip(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
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
              // filterAscending();
              setState(() {
                listStock = servicesStock.getFilterStock(0);
              });
            } else if (_selectedIndexChipsFilter == 1) {
              setState(() {
                listStock = servicesStock.getFilterStock(1);
              });
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
                          padding: const EdgeInsets.only(top: 8),
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
                        const SizedBox(height: 10),
                        //FILTER
                        Wrap(
                          spacing: 6,
                          direction: Axis.horizontal,
                          children: generateFilterChips(),
                        ),
                        const SizedBox(height: 10),

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
                              Material(
                                borderRadius: BorderRadius.circular(10),
                                elevation: 15,
                                shadowColor: Colors.black87,
                                color: buttonColor,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                                        flex: 2,
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
                              const SizedBox(height: 10),
                              Expanded(
                                child: Scrollbar(
                                  radius: const Radius.circular(10),
                                  thumbVisibility: true,
                                  controller: _controllerScrollBar,
                                  child: FutureBuilder(
                                    future: listStock,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List snapData = snapshot.data! as List;
                                        if (snapData[0] != 404) {
                                          return ListView.builder(
                                            controller: _controllerScrollBar,
                                            itemCount: snapData[1].length,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                width: deviceWidth,
                                                child: Column(
                                                  children: [
                                                    //ISI TABEL STOCK BARANG
                                                    Card(
                                                      // color: indexStockBarang % 2 == 0
                                                      //     ? cardInfoColor1
                                                      //     : cardInfoColor2,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      color: cardInfoColor2,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 15,
                                                                bottom: 15,
                                                                left: 10,
                                                                right: 8),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                snapData[1]
                                                                        [index][
                                                                    'kode_inventory'],
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.125,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                snapData[1]
                                                                        [index][
                                                                    'nama_barang'],
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.125,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                numberFormatDotSeparator(
                                                                      snapData[1][index]
                                                                              [
                                                                              'jumlah_barang']
                                                                          .toString(),
                                                                    ) +
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'satuan_barang'],
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.125,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                NumberFormat.simpleCurrency(
                                                                        locale:
                                                                            'id-ID',
                                                                        name:
                                                                            "Rp. ")
                                                                    .format(snapData[1]
                                                                            [
                                                                            index]
                                                                        [
                                                                        'harga_barang']),
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 13,
                                                                  letterSpacing:
                                                                      0.125,
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
                                          );
                                        } else if (snapData[0] == 404) {
                                          return const Center();
                                        }
                                      }
                                      return const Center();
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
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
                        const SizedBox(
                          height: 5,
                        ),
                        //FILTER
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _satuanKirim = 0;
                                _TanggalKirim = "";
                                _dateKirim = "";
                                _dateFrom = "";
                                _dateBulan = "";
                                _dateTahun = "";
                                _filterTanggalCheck = false;
                                _selectedDateFrom = DateTime.now();
                                _selectedDateBulan = DateTime.now();
                                _selectedDateTahun = DateTime.now();
                                listStockMasuk = servicesStock
                                    .getStockIn()
                                    .whenComplete(() => setState(() {}));
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                                backgroundColor: lightText,
                                side: BorderSide(
                                  color: buttonColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                "Clear Filter",
                                style: GoogleFonts.inter(
                                  color: buttonColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                filterStokMasuk(deviceWidth, deviceHeight);
                              },
                              icon: const Icon(Icons.filter_alt_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 15,
                          shadowColor: Colors.black87,
                          color: buttonColor,
                          child: IgnorePointer(
                            ignoring: true,
                            child: ExpansionTile(
                              maintainState: true,
                              initiallyExpanded: false,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.centerLeft,
                              iconColor: buttonColor,
                              collapsedIconColor: buttonColor,
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        flex: 2,
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
                                        flex: 3,
                                        child: Text(
                                          "Tanggal",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            letterSpacing: 0.125,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          "Nama Supplier",
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
                                ],
                              ),
                              children: [],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            controller: ScrollController(),
                            child: Container(
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                }),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: FutureBuilder(
                                    future: listStockMasuk,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List snapData = snapshot.data! as List;
                                        if (snapData[0] != 404) {
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            controller: ScrollController(),
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: snapData[1].length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                color: const Color(0xffF4F4F4),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: ExpansionTile(
                                                  maintainState: true,
                                                  initiallyExpanded: false,
                                                  expandedCrossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  expandedAlignment:
                                                      Alignment.centerLeft,
                                                  childrenPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 0, 0),
                                                  textColor: darkText,
                                                  iconColor: darkText,
                                                  collapsedTextColor: darkText,
                                                  collapsedIconColor: darkText,
                                                  title: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(5, 0, 0, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'id_stock_masuk'],
                                                                    style: GoogleFonts.inter(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            darkText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'tanggal_masuk'],
                                                                    style: GoogleFonts.inter(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            darkText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Text(
                                                                    snapData[1][
                                                                            index]
                                                                        [
                                                                        'nama_penanggung_jawab'],
                                                                    style: GoogleFonts.inter(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            darkText,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15, 5, 15, 0),
                                                          child: Column(
                                                            children: [
                                                              const Divider(
                                                                thickness: 1,
                                                                color: Color(
                                                                    0xFF7A7A7A),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        10,
                                                                        20,
                                                                        10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Text(
                                                                            "Nama Barang",
                                                                            style: GoogleFonts.inter(
                                                                                fontSize: 12,
                                                                                color: darkText,
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Jumlah",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Harga",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Sub Total",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              FDottedLine(
                                                                color: darkText,
                                                                width:
                                                                    deviceWidth,
                                                                strokeWidth: 1,
                                                                dottedLength: 8,
                                                                space: 2,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        10,
                                                                        20,
                                                                        10),
                                                                child: Column(
                                                                  children: [
                                                                    ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      controller:
                                                                          ScrollController(),
                                                                      physics:
                                                                          const ClampingScrollPhysics(),
                                                                      itemCount:
                                                                          snapData[1][index]['kode_stock']
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              idx) {
                                                                        return Column(
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  flex: 3,
                                                                                  child: Text(
                                                                                    snapData[1][index]['nama_barang'][idx],
                                                                                    style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      snapData[1][index]['jumlah_barang'][idx].toString(),
                                                                                      style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      snapData[1][index]['harga_barang'][idx].toString(),
                                                                                      style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  flex: 1,
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "${snapData[1][index]['jumlah_barang'][idx] * snapData[1][index]['harga_barang'][idx]}",
                                                                                      style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 3,
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              FDottedLine(
                                                                color: darkText,
                                                                width:
                                                                    deviceWidth,
                                                                strokeWidth: 1,
                                                                dottedLength: 8,
                                                                space: 2,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15,
                                                                        10,
                                                                        20,
                                                                        10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            child:
                                                                                Text(
                                                                              "Total Jumlah : ",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              snapData[1][index]['total_jumlah_barang'].toString(),
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "Total : ",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "${snapData[1][index]['total_jumlah_barang'] * snapData[1][index]['total_harga_barang']}",
                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 15),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else if (snapData[0] == 404) {
                                          return Center();
                                        }
                                      }
                                      return Center();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   backgroundColor: buttonColor,
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          backgroundColor: buttonColor,
          overlayColor: darkText,
          overlayOpacity: 0.4,
          spaceBetweenChildren: 10,
          openCloseDial: isDialOpen,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: buttonColor),
                label: "Stock Barang",
                onTap: () {
                  _showTambahBarang(deviceWidth, deviceHeight);
                }),
            SpeedDialChild(
              child: Icon(Icons.add, color: buttonColor),
              label: "Stock Masuk",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahStokMasuk(),
                  ),
                ).whenComplete(() {
                  listStockMasuk = servicesStock
                      .getStockIn()
                      .whenComplete(() => setState(() {}));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class TambahStokMasuk extends StatefulWidget {
  const TambahStokMasuk({super.key});

  @override
  State<TambahStokMasuk> createState() => _TambahStokMasukState();
}

class _TambahStokMasukState extends State<TambahStokMasuk> {
  ServicesStock servicesStock = ServicesStock();

  final List<String> _supplierList = List.empty(growable: true);
  final List<String> _inventoryList = List.empty(growable: true);
  String _valKodeSup = '';
  String _valNamaSup = '';

  String _valKodeBarang = '';
  String _valNamaBarang = '';

  final _ctrlNamaBarang = TextEditingController();
  final _ctrlJumlahBarang = TextEditingController();
  final _ctrlHargaBarang = TextEditingController();

  final List _listStockIn = List.empty(growable: true);
  List totalTemp = [0, 0];

  var stateOfDisable = true;
  DateTime selectedDateBatasPending = DateTime.now();
  String formattedDateBatasPending = "";
  String dateBatasPending = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool cekHeader = true;
  bool cekBawah = true;
  bool cekJumlah = false;

  final List<String> _namaStockArray = [];
  int total_Harga_Simpan = 0;
  int harga_Simpan = 0;

  bool _readOnly = true;

  int total_Jumlah_Depan = 0;
  int total_Harga_Depan = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSupplierList();
    getInventoryList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getSupplierList() async {
    var response = await servicesStock.getSupplier();
    if (response[0] != 404) {
      for (var val in response[1]) {
        _supplierList.add("${val['kode_supplier']} ~ ${val['nama_supplier']}");
        print(_supplierList);
      }
    } else {
      debugPrint("Gagal");
    }
    print(_supplierList);
  }

  Future _getSatuan(kode) async {
    var response = await servicesStock.getStock();
    if (response[0] != 404) {
      for (var element in response[1]) {
        if (element['kode_inventory'] == kode.toString()) {
          setState(() {
            ikiSatuanCok = "${element['satuan_barang']}";
          });
          break;
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  Future getInventoryList() async {
    var response = await servicesStock.getStock();
    if (response[0] != 404) {
      for (var val in response[1]) {
        _inventoryList.add("${val['kode_inventory']} ~ ${val['nama_barang']}");
        print(_inventoryList);
      }
    } else {
      debugPrint("Gagal");
    }
    print(_inventoryList);
  }

  //popUp Twisko, Jumlah Harga
  _showYambahPenjualan(dw, dh) {
    List temp = List.empty(growable: true);

    _ctrlNamaBarang.clear();
    _ctrlJumlahBarang.clear();
    _ctrlHargaBarang.clear();
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Pilih Barang",
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pilih Barang",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  child: Card(
                                    color: const Color(0xffE5E5E5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: DropdownSearch<String>(
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              textAlign: TextAlign.left,
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    const Color(0xffE5E5E5),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              )),
                                      popupProps: const PopupProps.menu(
                                        fit: FlexFit.loose,
                                        showSelectedItems: false,
                                        menuProps: MenuProps(
                                          backgroundColor: Color(0xffE5E5E5),
                                        ),
                                      ),
                                      items: _inventoryList,
                                      onChanged: (val) {
                                        _valKodeBarang =
                                            _splitStringSup(val)[0];
                                        _valNamaBarang =
                                            _splitStringSup(val)[1];
                                        print(_valKodeBarang);
                                        print(_valNamaBarang);
                                        setState(() {
                                          _getSatuan(_valKodeBarang)
                                              .whenComplete(
                                                  () => setState(() {}));
                                        });
                                      },
                                      selectedItem: "Pilih Barang",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Jumlah",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        readOnly: false,
                                        cursorColor: Colors.lightBlueAccent,
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                        controller: _ctrlJumlahBarang,
                                        onChanged: (value) {},
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: const Color(0xffE5E5E5),
                                          hintText: 'Input Jumlah Barang',
                                          hintStyle: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 10),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        ikiSatuanCok,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  "Harga",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextField(
                                  readOnly: false,
                                  cursorColor: Colors.lightBlueAccent,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  controller: _ctrlHargaBarang,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Harga Barang',
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
                          height: 30,
                        ),
                        Divider(
                          height: 0,
                          color: dividerColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  ikiSatuanCok = "";
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 56,
                              child: VerticalDivider(
                                width: 0.1,
                                color: dividerColor,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  onPressed: () {
                                    temp.add(_valKodeBarang);
                                    temp.add(_valNamaBarang);
                                    temp.add(_ctrlJumlahBarang.text);
                                    temp.add(_ctrlHargaBarang.text);
                                    var total =
                                        int.parse(_ctrlJumlahBarang.text) *
                                            int.parse(_ctrlHargaBarang.text);
                                    temp.add(total.toString());
                                    totalTemp[0] +=
                                        int.parse(_ctrlJumlahBarang.text);
                                    totalTemp[1] += total;
                                    _listStockIn.add(temp);
                                    ikiSatuanCok = "";
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Ok",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
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

  Future postStockIn(
      kodeSup, namaSup, kodeStock, namaStock, jumlah, harga, context) async {
    var response = await servicesStock.postStockIn(
        kodeSup, namaSup, kodeStock, namaStock, jumlah, harga);
    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Barang Gagal Ditambahkan"),
        ),
      );
    }
  }

  _showInputSudahBenar(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
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
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(30, 35, 30, 0),
                            child: Center(
                              child: Text(
                                "Apakah Barang yang Di Input Sudah Benar?",
                                style: GoogleFonts.inter(
                                    color: darkText,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    height: 1.8),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        const SizedBox(
                          height: 25,
                        ),
                        Divider(
                          height: 0,
                          color: dividerColor,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 56,
                              child: VerticalDivider(
                                width: 0.1,
                                color: dividerColor,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextButton(
                                  onPressed: () async {
                                    String tKode = "";
                                    String tNama = "";
                                    String tJumlah = "";
                                    String tHarga = "";

                                    for (int i = 0;
                                        i < _listStockIn.length;
                                        i++) {
                                      tKode += "|${_listStockIn[i][0]}|";
                                      tNama += "|${_listStockIn[i][1]}|";
                                      tJumlah += "|${_listStockIn[i][2]}|";
                                      tHarga += "|${_listStockIn[i][3]}|";
                                    }
                                    await postStockIn(
                                            _valKodeSup,
                                            _valNamaSup,
                                            tKode,
                                            tNama,
                                            tJumlah,
                                            tHarga,
                                            context)
                                        .then(
                                      (value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    );

                                    // debugPrint(tKode);
                                    // debugPrint(tNama);
                                    // debugPrint(tJumlah);
                                    // debugPrint(tHarga);
                                  },
                                  child: Text(
                                    "Ok",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 0.125,
                                        color: darkText,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
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

  _splitStringSup(val) {
    var value = val.toString();
    var split = value.indexOf("~");
    var temp1 = value.substring(0, split - 1);
    var temp2 = value.substring(split + 2, val.length);
    return [temp1, temp2];
  }

  // _splitString(val) {
  //   var value = val.toString();
  //   var split = value.indexOf(" ");
  //   var temp = value.substring(split, val.length);
  //   return temp;
  // }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah Stok Masuk",
          style:
              GoogleFonts.inter(color: darkText, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: darkText,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          controller: ScrollController(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pilih Supplier",
                  style: GoogleFonts.inter(
                    color: buttonColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  child: Card(
                    color: const Color(0xffE5E5E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    child: DropdownSearch<String>(
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          textAlign: TextAlign.left,
                          dropdownSearchDecoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffE5E5E5),
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
                          )),
                      popupProps: const PopupProps.menu(
                        fit: FlexFit.loose,
                        showSelectedItems: false,
                        menuProps: MenuProps(
                          backgroundColor: Color(0xffE5E5E5),
                        ),
                      ),
                      items: _supplierList,
                      onChanged: (val) {
                        _valKodeSup = _splitStringSup(val)[0];
                        _valNamaSup = _splitStringSup(val)[1];
                      },
                      selectedItem: "Pilih Supplier",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Masukkan Barang",
                  style: GoogleFonts.inter(
                    color: buttonColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  child: Card(
                    color: const Color(0xffF0F0F0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: cekHeader,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: buttonColor,
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                              child: Column(
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          "Nama Barang",
                                          style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: lightText,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "Jumlah",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: lightText,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "Harga",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: lightText,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "Total Harga",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                                fontSize: 11,
                                                color: lightText,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            physics: const ClampingScrollPhysics(),
                            itemCount: _listStockIn.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                                        flex: 8,
                                        child: Text(
                                          _listStockIn[index][1],
                                          style: GoogleFonts.inter(
                                            color: darkText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            _listStockIn[index][2],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: darkText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            _listStockIn[index][3],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: darkText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            _listStockIn[index][4],
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: darkText,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Visibility(
                            visible: cekBawah,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                                    flex: 8,
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 15),
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "Total Jumlah :",
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      totalTemp[0].toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: darkText,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        " Total : ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        totalTemp[1].toString(),
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                //primary: Colors.white,
                                backgroundColor: buttonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _showYambahPenjualan(deviceWidth, deviceHeight);
                              },
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "Tambah",
                                    style: GoogleFonts.inter(
                                      color: lightText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(top: 18, bottom: 18),
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _showInputSudahBenar(deviceWidth, deviceHeight);
                        },
                        child: Text(
                          "Submit",
                          style: GoogleFonts.inter(
                            color: lightText,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
