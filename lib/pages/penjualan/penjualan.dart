import 'package:aplikasi_pos/pages/penjualan/services.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../widgets/stringextension.dart';

bool cekStatus = false;
bool cekTanggal = false;
bool cekHeaderTransaksi = true;

String _hargaTemp = "0";
String _jumlahTemp = "0";
String _kodeTemp = "";

String _itemSelect = "Pilih Status";

int status = 0;
String namaStatus = "";
String warnaStatus = "";

int _selectedIndexChipsFilter = 0;
int _filterTanggalIndex = 0;
bool _filterTanggalCheck = false;

DateTime _selectedDate = DateTime.now();
String _formattedDate = "";
String _date = "";

int tipeStatusKirim = 2;

enum RadioFilterUrutan { sukses, pending, none }

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage>
    with TickerProviderStateMixin {
  late TabController _tabControllerPenjualanFilter;

  ServicesPenjualan servicesUser = ServicesPenjualan();
  late Future getTransaksi;
  late Future getTanggalTransaksi;

  void initialSelectedDate() {
    _formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);
    _date = _formattedDate;
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

  @override
  void initState() {
    _tabControllerPenjualanFilter = TabController(length: 4, vsync: this);
    getTanggalTransaksi = servicesUser.getTanggal(_date, tipeStatusKirim);
    getTransaksi = servicesUser.getFilter(_selectedDate, tipeStatusKirim);
    super.initState();
  }

  _splitStringRP(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(split, val.length);
    return temp;
  }

  Future _updateStatusPenjualanSelesai(kode, tanggal, context) async {
    var response = await servicesUser.updatePenjualan(kode, tanggal);
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

  filterTanggalWidget(context, index, StateSetter setState) {
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
                color: buttonColor,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              selectFilterDate(context).then((value) => setState(() {}));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xffE5E5E5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_date),
                  const Icon(Icons.calendar_month),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //FUNGSI FILTERING PEMBUKUAN
  void filterPembukuanTransaksi(dw, dh) {
    RadioFilterUrutan? radioFilterUrutan;
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
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
                              Row(),
                              // const SizedBox(
                              //   height: 25,
                              // ),
                              filterTanggalWidget(
                                  context, _filterTanggalIndex, setState),
                              SizedBox(
                                height: 18,
                              ),
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
                                          value: RadioFilterUrutan.sukses,
                                          groupValue: radioFilterUrutan,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterUrutan =
                                                value as RadioFilterUrutan;

                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {
                                                tipeStatusKirim = 1;
                                                print(tipeStatusKirim);
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          "Selesai",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterUrutan.pending,
                                          groupValue: radioFilterUrutan,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterUrutan =
                                                value as RadioFilterUrutan;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {
                                                tipeStatusKirim = 0;
                                                print(tipeStatusKirim);
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          "Pending",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterUrutan.none,
                                          groupValue: radioFilterUrutan,
                                          activeColor: buttonColor,
                                          onChanged: (value) {
                                            radioFilterUrutan =
                                                value as RadioFilterUrutan;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {
                                                tipeStatusKirim = 2;
                                                print(tipeStatusKirim);
                                              });
                                            }
                                          },
                                        ),
                                        Text(
                                          "none",
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
                                  _selectedDate = DateTime.now();
                                  _date = "";
                                  tipeStatusKirim = 2;
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
                                    setState(() {
                                      getTanggalTransaksi = servicesUser
                                          .getTanggal(_date, tipeStatusKirim);
                                      getTransaksi = servicesUser.getFilter(
                                          _date, tipeStatusKirim);
                                    });
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
    ).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      //1 : tambah button penjualan
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TambahPenjualan()));
        },
        backgroundColor: buttonColor,
        child: const Icon(Icons.add),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 15,
                shadowColor: Colors.black87,
                child: TextField(
                  //controller: _controllerSearch,
                  cursorColor: Colors.lightBlueAccent,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Cari ID Transaksi',
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
                height: 5,
              ),
              //FILTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                        _date = "";
                        tipeStatusKirim = 2;
                        getTanggalTransaksi =
                            servicesUser.getTanggal(_date, tipeStatusKirim);
                        getTransaksi =
                            servicesUser.getFilter(_date, tipeStatusKirim);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
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
                      filterPembukuanTransaksi(deviceWidth, deviceHeight);
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Visibility(
                visible: cekHeaderTransaksi,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 15,
                  shadowColor: Colors.black87,
                  color: buttonColor,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "ID",
                            style: GoogleFonts.nunito(
                              fontSize: 15,
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
                              fontSize: 15,
                              letterSpacing: 0.125,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Tgl Lunas",
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              letterSpacing: 0.125,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Status",
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              letterSpacing: 0.125,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "a",
                            style: GoogleFonts.nunito(
                              fontSize: 10,
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
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: FutureBuilder(
                    future: getTanggalTransaksi,
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
                                return Container(
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  // ),
                                  color: scaffoldBackgroundColor,
                                  child: ExpansionTile(
                                    maintainState: true,
                                    initiallyExpanded: true,
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    expandedAlignment: Alignment.centerLeft,
                                    textColor: darkText,
                                    iconColor: lightText,
                                    collapsedTextColor: darkText,
                                    collapsedIconColor: lightText,
                                    title: Text(
                                        snapData[1][index]['tanggal_transaksi'],
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: darkText,
                                            fontWeight: FontWeight.w600)),
                                    children: [
                                      Container(
                                        child: ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(dragDevices: {
                                            PointerDeviceKind.touch,
                                            PointerDeviceKind.mouse,
                                          }),
                                          child: SingleChildScrollView(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              controller: ScrollController(),
                                              child: FutureBuilder(
                                                // future: _date == "" && tipeStatusKirim == 2 ? servicesUser
                                                //     .getPenjualanTransaksi(
                                                //         snapData[1][index][
                                                //             'tanggal_transaksi']) : getTransaksi,
                                                future: getTransaksi =
                                                    servicesUser.getFilter(
                                                        snapData[1][index][
                                                            'tanggal_transaksi'],
                                                        tipeStatusKirim),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    List snapData =
                                                        snapshot.data! as List;
                                                    debugPrint(
                                                        snapData[0].toString());
                                                    if (snapData[0] != 404) {
                                                      //cekHeaderTransaksi = false;
                                                      return ScrollConfiguration(
                                                        behavior:
                                                            ScrollConfiguration
                                                                    .of(context)
                                                                .copyWith(
                                                                    dragDevices: {
                                                              PointerDeviceKind
                                                                  .touch,
                                                              PointerDeviceKind
                                                                  .mouse
                                                            }),
                                                        child:
                                                            SingleChildScrollView(
                                                          physics:
                                                              const ClampingScrollPhysics(),
                                                          controller:
                                                              ScrollController(),
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              controller:
                                                                  ScrollController(),
                                                              physics:
                                                                  const ClampingScrollPhysics(),
                                                              itemCount:
                                                                  snapData[1]
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                if (snapData[1][
                                                                            index]
                                                                        [
                                                                        'status_transaksi'] ==
                                                                    "0") {
                                                                  namaStatus =
                                                                      "Pending";
                                                                  warnaStatus =
                                                                      "0xffC12222";
                                                                } else {
                                                                  namaStatus =
                                                                      "Selesai";
                                                                  warnaStatus =
                                                                      "0xff00B81D";
                                                                }
                                                                return Card(
                                                                  color: const Color(
                                                                      0xffF4F4F4),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  child:
                                                                      ExpansionTile(
                                                                    maintainState:
                                                                        true,
                                                                    initiallyExpanded:
                                                                        false,
                                                                    expandedCrossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    expandedAlignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    childrenPadding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                    textColor:
                                                                        darkText,
                                                                    iconColor:
                                                                        darkText,
                                                                    collapsedTextColor:
                                                                        darkText,
                                                                    collapsedIconColor:
                                                                        darkText,
                                                                    title:
                                                                        Container(
                                                                      padding:
                                                                          const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                SizedBox(
                                                                              child: Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Text(
                                                                                      snapData[1][index]['kode_transaksi'],
                                                                                      style: GoogleFonts.inter(fontSize: 10, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Text(
                                                                                      snapData[1][index]['tanggal_penjualan'],
                                                                                      style: GoogleFonts.inter(fontSize: 10, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: Text(
                                                                                      snapData[1][index]['tanggal_pelunasan'],
                                                                                      style: GoogleFonts.inter(fontSize: 10, color: darkText, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        namaStatus,
                                                                                        style: GoogleFonts.inter(fontSize: 10, color: Color(int.parse(warnaStatus)), fontWeight: FontWeight.w600),
                                                                                      ),
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
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                15,
                                                                                5,
                                                                                15,
                                                                                0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                const Divider(
                                                                                  thickness: 1,
                                                                                  color: Color(0xFF7A7A7A),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            flex: 3,
                                                                                            child: Text(
                                                                                              "Nama Barang",
                                                                                              style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "Jumlah",
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "Harga",
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
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
                                                                                  width: deviceWidth,
                                                                                  strokeWidth: 1,
                                                                                  dottedLength: 8,
                                                                                  space: 2,
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      FutureBuilder(
                                                                                        future: servicesUser.getDetailPenjualanTransaksi(snapData[1][index]['kode_transaksi']),
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
                                                                                                    return Column(
                                                                                                      children: [
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                              flex: 3,
                                                                                                              child: Text(
                                                                                                                snapData[1][index]['nama_barang'],
                                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              flex: 1,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  snapData[1][index]['jumlah_barang'].toString(),
                                                                                                                  style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              flex: 1,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  _splitStringRP(CurrencyFormat.convertToIdr((snapData[1][index]['harga_barang'] / snapData[1][index]['jumlah_barang']), 0)).toString(),
                                                                                                                  style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              flex: 1,
                                                                                                              child: Center(
                                                                                                                child: Text(
                                                                                                                  _splitStringRP(CurrencyFormat.convertToIdr(snapData[1][index]['harga_barang'], 0)).toString(),
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
                                                                                              );
                                                                                            } else if (snapData[0] == 404) {
                                                                                              return Column();
                                                                                            }
                                                                                          }
                                                                                          return Column();
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                FDottedLine(
                                                                                  color: darkText,
                                                                                  width: deviceWidth,
                                                                                  strokeWidth: 1,
                                                                                  dottedLength: 8,
                                                                                  space: 2,
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Row(
                                                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Expanded(
                                                                                            flex: 3,
                                                                                            child: Align(
                                                                                              alignment: Alignment.centerRight,
                                                                                              child: Text(
                                                                                                "Total Jumlah : ",
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                snapData[1][index]['total_jumlah_barang'].toString(),
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                "Total : ",
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Center(
                                                                                              child: Text(
                                                                                                _splitStringRP(CurrencyFormat.convertToIdr(snapData[1][index]['sub_total_harga'], 0)).toString(),
                                                                                                style: GoogleFonts.inter(fontSize: 12, color: darkText, fontWeight: FontWeight.w400),
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: 25),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible: snapData[1][index]['status_transaksi'] == "0"
                                                                                ? true
                                                                                : false,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: ElevatedButton(
                                                                                style: TextButton.styleFrom(
                                                                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                                                                  primary: Colors.white,
                                                                                  backgroundColor: buttonColorabu,
                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                                                                ),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    _updateStatusPenjualanSelesai(snapData[1][index]['kode_transaksi'], DateTime.now(), context).whenComplete(() => setState(() {}));
                                                                                  });
                                                                                },
                                                                                child: Wrap(
                                                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.add_circle_outline_rounded,
                                                                                      color: lightText,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      "Selesaikan",
                                                                                      style: GoogleFonts.inter(
                                                                                        color: lightText,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Visibility(
                                                                            visible: snapData[1][index]['status_transaksi'] == "0"
                                                                                ? false
                                                                                : true,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: ElevatedButton(
                                                                                style: TextButton.styleFrom(
                                                                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                                                                  primary: Colors.white,
                                                                                  backgroundColor: buttonColor,
                                                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                                                                ),
                                                                                onPressed: () {},
                                                                                child: Wrap(
                                                                                  crossAxisAlignment: WrapCrossAlignment.center,
                                                                                  children: [
                                                                                    Icon(
                                                                                      Icons.add_circle_outline_rounded,
                                                                                      color: lightText,
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      "Print Nota",
                                                                                      style: GoogleFonts.inter(
                                                                                        color: lightText,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: 15,
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else if (snapData[0] ==
                                                        404) {
                                                      //cekHeaderTransaksi = true;
                                                      return Column(
                                                        children: const [
                                                          Center(
                                                            child: Text(
                                                                "Transaksi Masih Kosong"),
                                                          )
                                                        ],
                                                      );
                                                    }
                                                  }
                                                  return Column();
                                                },
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapData[0] == 404) {
                          return Column();
                        }
                      }
                      return Column();
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class TambahPenjualan extends StatefulWidget {
  const TambahPenjualan({super.key});

  @override
  State<TambahPenjualan> createState() => _TambahPenjualanState();
}

class _TambahPenjualanState extends State<TambahPenjualan> {
  ServicesPenjualan servicesUser = ServicesPenjualan();

  final List _listNamaBarangTambahPenjualan = [];
  final List _listJumlahBarangTambahPenjualan = [];
  final List _listHargaBarangTambahPenjualan = [];
  final List _listTotalHargaBarangTambahPenjualan = [];
  final List _listTotalHargaBarangTambahPenjualan2 = [];
  final List _listKodeBarangTambahPenjualan = [];

  String _kirimNama = "";
  String _kirimJumlah = "";
  String _kirimKode = "";
  String _kirimHarga = "";

  final _controllerNamaBarangTambahPenjualan = TextEditingController();
  final _controllerJumlahBarangTambahPenjualan = TextEditingController();
  final _controllerHargaBarangTambahPenjualan = TextEditingController();

  final _controllerEditPenjualan = TextEditingController();

  String _tempHargaBarang = "";
  String _tempTotalHargaBarang = "";

  var stateOfDisable = true;
  DateTime selectedDateBatasPending = DateTime.now();
  String formattedDateBatasPending = "";
  String dateBatasPending = DateFormat('dd-MM-yyyy').format(DateTime.now());

  bool cekHeader = false;
  bool cekBawah = false;
  bool cekJumlah = false;

  final List<String> _namaStockArray = [];
  double total_Harga_Simpan = 0;
  double harga_Simpan = 0;

  bool _readOnly = true;

  double total_Jumlah_Depan = 0;
  double total_Harga_Depan = 0;

  //2 : Function pilih tanggal
  Future<void> selectDateBatasPending(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateBatasPending,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100, 12, 31),
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
                  primary: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDateBatasPending) {
      if (mounted) {
        selectedDateBatasPending = picked;
        formattedDateBatasPending =
            DateFormat('dd-MM-yyyy').format(selectedDateBatasPending);
        dateBatasPending = formattedDateBatasPending;
        stateOfDisable = false;
        debugPrint("Selected Date From $selectedDateBatasPending");

        setState(() {});
      }
    }
  }

  //3 : Untuk ngambil data nama barang dari stock
  Future _getStock() async {
    var response = await servicesUser.getStock();
    if (response[0] != 404) {
      _namaStockArray.clear();
      for (var element in response[1]) {
        _namaStockArray.add("${element['nama_barang']}");
      }
    }
  }

  //4 : Buat ngambil data harga, jumlah, kode
  Future _getStockTemp() async {
    var response = await servicesUser.getStock();
    if (response[0] != 404) {
      for (var element in response[1]) {
        if (element['nama_barang'] ==
            _controllerNamaBarangTambahPenjualan.text) {
          _hargaTemp = "${element['harga_barang']}";
          _jumlahTemp = "${element['jumlah_barang']}";
          _kodeTemp = "${element['kode_inventory']}";
          break;
        } else {
          _hargaTemp = "0";
          _jumlahTemp = "0";
          _kodeTemp = "";
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getStock();
    //5: Buat kalo ngesearch dapetin total jumlah yang ada
    _controllerNamaBarangTambahPenjualan.addListener(() {
      setState(() {
        _getStockTemp();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future postTransaksi(
      kode_stock_tran,
      nama_barang_tran,
      jumlah_barang_tran,
      harga_barang_tran,
      tanggal_pelunasan_tran,
      status_transaksi_tran,
      sub_total_harga_tran,
      context) async {
    var response = await servicesUser.inputPenjualanTransaksi(
        kode_stock_tran,
        nama_barang_tran,
        jumlah_barang_tran,
        harga_barang_tran,
        tanggal_pelunasan_tran,
        status_transaksi_tran,
        sub_total_harga_tran);

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

  Future searchData(String param) async {
    List<String> result = _namaStockArray
        .where((Element) => Element.toLowerCase().contains(param.toLowerCase()))
        .toList();
    return result;
  }

  loopTotal(double a, String tipe) {
    if (tipe == "1") {
      total_Jumlah_Depan = a + total_Jumlah_Depan;
    } else if (tipe == "2") {
      total_Harga_Depan = a + total_Harga_Depan;
    }
  }

  loopKurangTotal(double a, double b) {
    total_Jumlah_Depan = total_Jumlah_Depan - a;
    total_Harga_Depan = total_Harga_Depan - b;
  }

  //popUp Twisko, Jumlah Harga
  _showYambahPenjualan(dw, dh) {
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
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                const SizedBox(height: 5),
                                TypeAheadField<String>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller:
                                        _controllerNamaBarangTambahPenjualan,
                                    autofocus: false,
                                    cursorColor: Colors.lightBlueAccent,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xffE5E5E5),
                                      hintText: 'Pilih Nama Barang',
                                      hintStyle: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                  suggestionsCallback: (pattern) async {
                                    return await searchData(pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      leading: Icon(Icons.shopping_cart),
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (String suggestion) {
                                    _controllerNamaBarangTambahPenjualan.text =
                                        suggestion;
                                    print(suggestion);
                                  },
                                  getImmediateSuggestions: true,
                                  hideSuggestionsOnKeyboardHide: false,
                                  hideOnEmpty: false,
                                  noItemsFoundBuilder: (context) =>
                                      const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("Tidak ada barang"),
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
                                Visibility(
                                  visible: cekJumlah,
                                  child: Text(
                                    "*Jumlah stock hanya ada $_jumlahTemp",
                                    style: GoogleFonts.inter(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextField(
                                  readOnly: false,
                                  controller:
                                      _controllerJumlahBarangTambahPenjualan,
                                  cursorColor: Colors.lightBlueAccent,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  onChanged: (value) {
                                    if (value == "") {
                                      setState(() {
                                        total_Harga_Simpan = 0;
                                        harga_Simpan = 0;
                                      });
                                    } else if (value == "0") {
                                      setState(() {
                                        total_Harga_Simpan = 0;
                                        harga_Simpan = 0;
                                      });
                                    } else {
                                      setState(() {
                                        total_Harga_Simpan =
                                            double.parse(value) *
                                                double.parse(_hargaTemp);
                                        harga_Simpan = double.parse(value);
                                      });
                                    }
                                    debugPrint(value);
                                    debugPrint(total_Harga_Simpan.toString());
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Jumlah Barang',
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
                                Container(
                                  width: dw,
                                  padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffE5E5E5),
                                  ),
                                  child: Text(
                                    CurrencyFormat.convertToIdr(
                                        total_Harga_Simpan, 0),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
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
                                  _controllerNamaBarangTambahPenjualan.clear();
                                  _controllerJumlahBarangTambahPenjualan
                                      .clear();
                                  _controllerHargaBarangTambahPenjualan.clear();
                                  total_Harga_Simpan = 0;
                                  _hargaTemp = "0";
                                  _jumlahTemp = "0";
                                  _kodeTemp = "";
                                  cekJumlah = false;
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
                                    if (double.parse(_jumlahTemp) <
                                        harga_Simpan) {
                                      setState(() {
                                        cekJumlah = true;
                                      });
                                    } else {
                                      if (mounted) {
                                        setState(() {
                                          //add
                                          _listNamaBarangTambahPenjualan.add(
                                              _controllerNamaBarangTambahPenjualan
                                                  .text);
                                          _listJumlahBarangTambahPenjualan.add(
                                              _controllerJumlahBarangTambahPenjualan
                                                  .text);
                                          loopTotal(
                                              double.parse(
                                                  _controllerJumlahBarangTambahPenjualan
                                                      .text),
                                              "1");
                                          _listHargaBarangTambahPenjualan.add(
                                              _splitStringRP(
                                                  CurrencyFormat.convertToIdr(
                                                      double.parse(_hargaTemp),
                                                      0)));
                                          _listKodeBarangTambahPenjualan
                                              .add(_kodeTemp);
                                          _listTotalHargaBarangTambahPenjualan
                                              .add(_splitStringRP(
                                                  CurrencyFormat.convertToIdr(
                                                      total_Harga_Simpan, 0)));
                                          _listTotalHargaBarangTambahPenjualan2
                                              .add(total_Harga_Simpan);
                                          loopTotal(total_Harga_Simpan, "2");
                                        });

                                        _controllerNamaBarangTambahPenjualan
                                            .clear();
                                        _controllerJumlahBarangTambahPenjualan
                                            .clear();
                                        _controllerHargaBarangTambahPenjualan
                                            .clear();
                                        total_Harga_Simpan = 0;
                                        cekHeader = true;
                                        cekBawah = true;
                                        cekJumlah = false;
                                        Navigator.pop(context);
                                      }
                                    }
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
                                  onPressed: () {
                                    for (int i = 0;
                                        i <
                                            _listNamaBarangTambahPenjualan
                                                .length;
                                        i++) {
                                      _kirimKode = _kirimKode +
                                          "|" +
                                          _listKodeBarangTambahPenjualan[i] +
                                          "|";
                                      _kirimNama = _kirimNama +
                                          "|" +
                                          _listNamaBarangTambahPenjualan[i] +
                                          "|";
                                      _kirimJumlah = _kirimJumlah +
                                          "|" +
                                          _listJumlahBarangTambahPenjualan[i] +
                                          "|";
                                      _kirimHarga = _kirimHarga +
                                          "|" +
                                          _listTotalHargaBarangTambahPenjualan2[
                                                  i]
                                              .toString() +
                                          "|";
                                    }
                                    print(_kirimHarga);
                                    postTransaksi(
                                        _kirimKode,
                                        _kirimNama,
                                        _kirimJumlah,
                                        _kirimHarga,
                                        dateBatasPending,
                                        status,
                                        total_Harga_Depan,
                                        context);
                                    setState(() {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
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
    ).whenComplete(() {
      setState(() {});
    });
  }

  _splitStringIDR(val) {
    var value = val.toString();
    var split = value.indexOf("R");
    var temp = value.substring(split + 1, val.length);
    return temp;
  }

  _splitStringRP(val) {
    var value = val.toString();
    var split = value.indexOf(" ");
    var temp = value.substring(split, val.length);
    return temp;
  }

  _showEditPenjualan(
      dw, dh, namaBarang, hargaBarang, jumlahBarang, totalHargaBarang, ind) {
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
                            "Edit $namaBarang",
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
                                  "Jumlah",
                                  style: GoogleFonts.inter(
                                    color: buttonColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _controllerEditPenjualan,
                                  cursorColor: Colors.lightBlueAccent,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffE5E5E5),
                                    hintText: 'Input Perubahan Jumlah',
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
                                  _listTotalHargaBarangTambahPenjualan[ind] =
                                      _splitStringRP(
                                          CurrencyFormat.convertToIdr(
                                              double.parse(
                                                      _controllerEditPenjualan
                                                          .text) *
                                                  double.parse(hargaBarang
                                                      .replaceAll(".", "")),
                                              0));
                                  _listJumlahBarangTambahPenjualan[ind] =
                                      _controllerEditPenjualan.text;
                                  if (double.parse(
                                          _controllerEditPenjualan.text) <
                                      double.parse(jumlahBarang)) {
                                    setState(() {
                                      loopKurangTotal(
                                          (double.parse(jumlahBarang) -
                                              double.parse(
                                                  _controllerEditPenjualan
                                                      .text)),
                                          (double.parse(totalHargaBarang
                                                  .replaceAll(".", "")) -
                                              double.parse(
                                                  _listTotalHargaBarangTambahPenjualan[
                                                          ind]
                                                      .replaceAll(".", ""))));
                                    });
                                  } else {
                                    setState(() {
                                      loopTotal(
                                          (double.parse(_controllerEditPenjualan
                                                  .text) -
                                              double.parse(jumlahBarang)),
                                          "1");
                                      loopTotal(
                                          (double.parse(
                                                  _listTotalHargaBarangTambahPenjualan[
                                                          ind]
                                                      .replaceAll(".", "")) -
                                              double.parse(totalHargaBarang
                                                  .replaceAll(".", ""))),
                                          "2");
                                    });
                                  }
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
            "Tambah Penjualan",
            style:
                GoogleFonts.inter(color: darkText, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                cekTanggal = false;
                dateBatasPending =
                    DateFormat('dd-MM-yyyy').format(DateTime.now());
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
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Status",
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
                        items: const ["Selesai", "Pending"],
                        onChanged: (val) {
                          if (val == "Pending") {
                            status = 0;
                            cekTanggal = true;
                          } else {
                            status = 1;
                            selectedDateBatasPending = DateTime.now();
                            dateBatasPending =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());
                            cekTanggal = false;
                          }
                          setState(() {});
                        },
                        selectedItem: "Pilih Status",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Visibility(
                      visible: cekTanggal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pilih Tanggal",
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
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateBatasPending,
                                        style: GoogleFonts.inter(
                                          color: darkText,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            selectDateBatasPending(context);
                                          },
                                          icon:
                                              const Icon(Icons.calendar_month))
                                    ],
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      )),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: buttonColor,
                                ),
                                padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
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
                                              style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: lightText,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              "a",
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: buttonColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              "a",
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: buttonColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(
                                              "a",
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  color: buttonColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        )
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
                              itemCount: _listNamaBarangTambahPenjualan.length,
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
                                          _listNamaBarangTambahPenjualan[index],
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
                                            _listJumlahBarangTambahPenjualan[
                                                index],
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
                                            _listHargaBarangTambahPenjualan[
                                                index],
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
                                            _listTotalHargaBarangTambahPenjualan[
                                                index],
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
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    loopKurangTotal(
                                                        double.parse(
                                                            _listJumlahBarangTambahPenjualan[
                                                                index]),
                                                        double.parse(
                                                            _listTotalHargaBarangTambahPenjualan[
                                                                    index]
                                                                .replaceAll(
                                                                    ".", "")));
                                                    _listNamaBarangTambahPenjualan
                                                        .removeAt(index);
                                                    _listJumlahBarangTambahPenjualan
                                                        .removeAt(index);
                                                    _listHargaBarangTambahPenjualan
                                                        .removeAt(index);
                                                    _listTotalHargaBarangTambahPenjualan
                                                        .removeAt(index);
                                                    if (_listHargaBarangTambahPenjualan
                                                            .length ==
                                                        0) {
                                                      cekHeader = false;
                                                      cekBawah = false;
                                                    }
                                                  });
                                                },
                                                icon:
                                                    const Icon(Icons.delete))),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "a",
                                            style: GoogleFonts.inter(
                                                fontSize: 13,
                                                color: lightText,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  _controllerEditPenjualan
                                                          .text =
                                                      _listJumlahBarangTambahPenjualan[
                                                          index];
                                                  _controllerNamaBarangTambahPenjualan
                                                          .text =
                                                      _listNamaBarangTambahPenjualan[
                                                          index];
                                                  _showEditPenjualan(
                                                      deviceWidth,
                                                      deviceHeight,
                                                      _listNamaBarangTambahPenjualan[
                                                          index],
                                                      _listHargaBarangTambahPenjualan[
                                                          index],
                                                      _listJumlahBarangTambahPenjualan[
                                                          index],
                                                      _listTotalHargaBarangTambahPenjualan[
                                                          index],
                                                      index);
                                                },
                                                icon: const Icon(Icons.edit))),
                                      )
                                    ],
                                  )),
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
                                        padding: EdgeInsets.only(right: 15),
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
                                        total_Jumlah_Depan.toString(),
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
                                          _splitStringRP(
                                              CurrencyFormat.convertToIdr(
                                                  total_Harga_Depan, 0)),
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
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Rp",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: lightText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          "a",
                                          style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: lightText,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Rp",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: lightText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
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
                                  _showYambahPenjualan(
                                      deviceWidth, deviceHeight);
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
                            padding: EdgeInsets.only(top: 18, bottom: 18),
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
            )),
      ),
    );
  }
}
