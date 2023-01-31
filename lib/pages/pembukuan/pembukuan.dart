//ignore_for_file: todo

import 'package:aplikasi_pos/pages/pembukuan/dataclass.dart';
import 'package:aplikasi_pos/pages/pembukuan/services.dart';
import 'package:aplikasi_pos/class/dataclass.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

enum RadioFilterTanggal { harian, bulanan, tahunan }

enum RadioFilterUrutan { ascending, descending }

class PembukuanPage extends StatefulWidget {
  const PembukuanPage({super.key});

  @override
  State<PembukuanPage> createState() => _PembukuanPageState();
}

class _PembukuanPageState extends State<PembukuanPage>
    with AutomaticKeepAliveClientMixin {
  ServicesPembukuan servicesPembukuan = ServicesPembukuan();

  final _controllerSearchBar = TextEditingController();
  final _controllerScrollBar = ScrollController();

  int _selectedIndexChipsFilter = 0;
  int _filterTanggalIndex = 0;
  bool _filterTanggalCheck = false;

  late Future _pembukuanTransaksi;
  List<PembukuanTransaksi> pembukuanTransaksi = [];
  List<IsiPembukuanTransaksi> displayTransaksi = [];
  final List<Filter> _chipsFilterList = List.empty(growable: true);

  DateTime _selectedDateFrom = DateTime.now();
  String _formattedDateFrom = "";
  String _dateFrom = "Date";

  DateTime _selectedDateTo = DateTime.now();
  String _formattedDateTo = "";
  String _dateTo = "Date";

  DateTime _selectedDateBulan = DateTime.now();
  String _formattedDateBulan = "";
  String _dateBulan = "Date";

  DateTime _selectedDateTahun = DateTime.now();
  String _formattedDateTahun = "";
  String _dateTahun = "Date";

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pembukuanTransaksi = servicesPembukuan.getPembukuan(DateTime.now());
    addPembukuanTransaksi();
    addIsiPembukuanTransaksi();
    initialSelectedDate();
    _selectedIndexChipsFilter = 0;
    _filterTanggalIndex = 0;
    _filterTanggalCheck = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerSearchBar.dispose();
    _controllerScrollBar.dispose();
  }

  void initialSelectedDate() {
    _formattedDateFrom = DateFormat('dd-MM-yyyy').format(_selectedDateFrom);
    _dateFrom = _formattedDateFrom;

    _formattedDateTo = DateFormat('dd-MM-yyyy').format(_selectedDateTo);
    _dateTo = _formattedDateTo;

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

        setState(() {});
      }
    }
  }

  Future<void> selectFilterDateTo(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTo,
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
    if (picked != null && picked != _selectedDateTo) {
      if (mounted) {
        _selectedDateTo = picked;
        _formattedDateTo = DateFormat('dd-MM-yyyy').format(_selectedDateTo);
        _dateTo = _formattedDateTo;

        setState(() {});
      }
    }
  }

  // Future<void> selectFilterDateBulan(context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDateBulan,
  //     firstDate: DateTime(DateTime.now().year - 10, 1, 1),
  //     lastDate: DateTime(DateTime.now().year + 10, 12, 31),
  //     builder: (context, child) {
  //       return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: buttonColor, // header background color
  //               onPrimary: lightText, // header text color
  //               onSurface: darkText, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: navButtonPrimary, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!);
  //     },
  //   );
  //   if (picked != null && picked != _selectedDateBulan) {
  //     if (mounted) {
  //       _selectedDateBulan = picked;
  //       var tempBulan = _selectedDateBulan.month;
  //       var tempTahun = _selectedDateBulan.year;
  //       _dateBulan = "$tempBulan-$tempTahun";

  //       setState(() {});
  //     }
  //   }
  // }

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

        setState(() {});
      }
    }
  }

  // Future<void> selectFilterDateTahun(context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDateTahun,
  //     firstDate: DateTime(DateTime.now().year - 10, 1, 1),
  //     lastDate: DateTime(DateTime.now().year + 10, 12, 31),
  //     builder: (context, child) {
  //       return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: buttonColor, // header background color
  //               onPrimary: lightText, // header text color
  //               onSurface: darkText, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: navButtonPrimary, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!);
  //     },
  //   );
  //   if (picked != null && picked != _selectedDateTahun) {
  //     if (mounted) {
  //       _selectedDateTahun = picked;
  //       var tempTahun = _selectedDateTahun.year;
  //       _dateTahun = "$tempTahun";

  //       setState(() {});
  //     }
  //   }
  // }

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

  // String formatDateToString(DateTime value) {
  //   _selectedDate = value;
  //   _formattedDate = DateFormat('dd-MM-yyyy').format(_selectedDate);
  //   _date = _formattedDate;
  //   return _date;
  // }

  void filterBulanan() {
    debugPrint("Filter Bulanan");
  }

  void filterTahunan() {
    debugPrint("Filter Tahunan");
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
            color: _selectedIndexChipsFilter == i ? lightText : darkText),
        backgroundColor: _chipsFilterList[i].color,
        selectedColor: buttonColor,
        selected: _selectedIndexChipsFilter == i,
        onSelected: (bool value) {
          if (mounted) {
            setState(() {
              _selectedIndexChipsFilter = i;
            });
          }
        },
      );
      chips.add(item);
    }
    return chips;
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

  void addPembukuanTransaksi() {
    for (int i = 0; i < 10; i++) {
      pembukuanTransaksi.add(
        PembukuanTransaksi("P00${i * i * i * i}", "09-12-2022",
            "${2400000 * (i + 1)}", "Selesai"),
      );
    }
  }

  void addIsiPembukuanTransaksi() {
    int subTotal = 0;
    for (int i = 0; i < 5; i++) {
      displayTransaksi.add(
        IsiPembukuanTransaksi("Barang $i", "${i + 1}", "${2400000 * (i + 1)}",
            "${(i + 1) * (int.parse("2400000") * (i + 1))}"),
      );
    }
  }

  //FUNGSI FILTERING PEMBUKUAN
  void filterPembukuanTransaksi(dw, dh) {
    RadioFilterTanggal? radioFilterTanggal;
    RadioFilterUrutan? radioFilterUrutan;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
                              vertical: 18, horizontal: 10),
                          child: Text(
                            "Filter",
                            style: GoogleFonts.nunito(
                                fontSize: 18,
                                letterSpacing: 0.125,
                                color: darkText,
                                fontWeight: FontWeight.w800),
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
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 16),
                              //   child: Text(
                              //     "Filter Sesuai Urutan",
                              //     style: GoogleFonts.nunito(
                              //         fontSize: 14,
                              //         letterSpacing: 0.125,
                              //         color: filterText,
                              //         fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              // Wrap(
                              //   crossAxisAlignment: WrapCrossAlignment.center,
                              //   children: [
                              //     Wrap(
                              //       crossAxisAlignment:
                              //           WrapCrossAlignment.center,
                              //       children: [
                              //         Radio(
                              //           value: RadioFilterUrutan.ascending,
                              //           groupValue: radioFilterUrutan,
                              //           activeColor: filterText,
                              //           onChanged: (value) {
                              //             radioFilterUrutan =
                              //                 value as RadioFilterUrutan;

                              //             if (mounted) {
                              //               debugPrint(value.name);
                              //               setState(() {});
                              //             }
                              //           },
                              //         ),
                              //         Text(
                              //           "Ascending",
                              //           style: GoogleFonts.nunito(
                              //               fontSize: 14,
                              //               letterSpacing: 0.125,
                              //               color: darkText,
                              //               fontWeight: FontWeight.w600),
                              //         )
                              //       ],
                              //     ),
                              //     Wrap(
                              //       crossAxisAlignment:
                              //           WrapCrossAlignment.center,
                              //       children: [
                              //         Radio(
                              //           value: RadioFilterUrutan.descending,
                              //           groupValue: radioFilterUrutan,
                              //           activeColor: filterText,
                              //           onChanged: (value) {
                              //             radioFilterUrutan =
                              //                 value as RadioFilterUrutan;
                              //             if (mounted) {
                              //               debugPrint(value.name);
                              //               setState(() {});
                              //             }
                              //           },
                              //         ),
                              //         Text(
                              //           "Descending",
                              //           style: GoogleFonts.nunito(
                              //               fontSize: 14,
                              //               letterSpacing: 0.125,
                              //               color: darkText,
                              //               fontWeight: FontWeight.w600),
                              //         )
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "Filter Sesuai Tanggal",
                                  style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      letterSpacing: 0.125,
                                      color: filterText,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Radio(
                                        value: RadioFilterTanggal.harian,
                                        groupValue: radioFilterTanggal,
                                        activeColor: filterText,
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
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Radio(
                                        value: RadioFilterTanggal.bulanan,
                                        groupValue: radioFilterTanggal,
                                        activeColor: filterText,
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
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Radio(
                                        value: RadioFilterTanggal.tahunan,
                                        groupValue: radioFilterTanggal,
                                        activeColor: filterText,
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
                              // const SizedBox(
                              //   height: 25,
                              // ),
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
                                  initialSelectedDate();
                                  _selectedIndexChipsFilter = 0;
                                  _filterTanggalIndex = 0;
                                  _filterTanggalCheck = false;
                                  _chipsFilterList
                                      .add(Filter("All", Colors.white));
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
                                    if (_filterTanggalIndex == 0) {
                                      print(_dateFrom + " " + _dateTo);
                                      _pembukuanTransaksi =
                                          servicesPembukuan.getFilterPembukuan(
                                              _dateFrom, _dateTo, 1);
                                    } else if (_filterTanggalIndex == 1) {
                                      print(_dateBulan);
                                      _pembukuanTransaksi =
                                          servicesPembukuan.getFilterPembukuan(
                                              _dateBulan, "", 2);
                                    } else if (_filterTanggalIndex == 2) {
                                      print(_dateTahun);
                                      _pembukuanTransaksi =
                                          servicesPembukuan.getFilterPembukuan(
                                              _dateTahun, "", 3);
                                    }
                                    initialSelectedDate();
                                    _selectedIndexChipsFilter = 0;
                                    _filterTanggalIndex = 0;
                                    _filterTanggalCheck = false;
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

  filterTanggalWidget(context, index, StateSetter setState, dw, dh) {
    if (index == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dari Tanggal",
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
            const SizedBox(
              height: 16,
            ),
            Text(
              "Sampai Tanggal",
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
                selectFilterDateTo(context).then((value) => setState(() {}));
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
                    Text(_dateTo),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: Column(
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
                            hintText: "Cari ID Transaksi",
                            hintStyle: GoogleFonts.nunito(
                              color: darkText.withOpacity(0.45),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 6,
                          direction: Axis.horizontal,
                          // children: generateFilterChips(),
                        ),
                        IconButton(
                          onPressed: () {
                            filterPembukuanTransaksi(deviceWidth, deviceHeight);
                          },
                          icon: const Icon(Icons.filter_alt_outlined),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //ISI HEADER TABEL STOCK
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: buttonColor,
                            child: ExpansionTile(
                              iconColor: Colors.transparent,
                              collapsedIconColor: Colors.transparent,
                              title: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "ID Transaksi",
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        letterSpacing: 0.125,
                                        fontWeight: FontWeight.w700,
                                        color: lightText,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Tanggal",
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        letterSpacing: 0.125,
                                        fontWeight: FontWeight.w700,
                                        color: lightText,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Total",
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        letterSpacing: 0.125,
                                        fontWeight: FontWeight.w700,
                                        color: lightText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: _pembukuanTransaksi,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List snapData = snapshot.data! as List;
                                  if (snapData[0] != 404) {
                                    return Scrollbar(
                                      radius: const Radius.circular(8),
                                      thumbVisibility: true,
                                      controller: _controllerScrollBar,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: _controllerScrollBar,
                                        itemCount: snapData[1].length,
                                        itemBuilder: (context, index) {
                                          print(snapData[1]);
                                          return SizedBox(
                                            width: deviceWidth,
                                            child: Column(
                                              children: [
                                                //ISI TABEL PEMBUKUAN
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  elevation: 4,
                                                  color: index % 2 == 0
                                                      ? cardInfoColor1
                                                      : cardInfoColor2,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8),
                                                    child: Theme(
                                                      data: theme,
                                                      child: ExpansionTile(
                                                        key: UniqueKey(),
                                                        collapsedTextColor:
                                                            darkText,
                                                        textColor: darkText,
                                                        collapsedIconColor:
                                                            darkText,
                                                        iconColor: darkText,
                                                        initiallyExpanded:
                                                            false,
                                                        maintainState: true,
                                                        childrenPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        tilePadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        title: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 5,
                                                              child: Text(
                                                                // pembukuanTransaksi[
                                                                //         index]
                                                                //     .idTransaksi,
                                                                snapData[1]
                                                                        [index][
                                                                    'id_pembukuan_transaksi'],
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
                                                              flex: 5,
                                                              child: Text(
                                                                // pembukuanTransaksi[
                                                                //         index]
                                                                //     .tanggalTransaksig,
                                                                snapData[1]
                                                                        [index][
                                                                    'tanggal_pelunasan'],
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
                                                              flex: 5,
                                                              child: Text(
                                                                NumberFormat.simpleCurrency(
                                                                        locale:
                                                                            'id-ID',
                                                                        name:
                                                                            "Rp. ")
                                                                    .format(
                                                                  double.parse(
                                                                    // pembukuanTransaksi[
                                                                    //         index]
                                                                    //     .totalTransaksi,
                                                                    snapData[1][index]
                                                                            [
                                                                            'total_harga_penjualan']
                                                                        .toString(),
                                                                  ),
                                                                ),
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
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Divider(
                                                                color:
                                                                    dividerColor,
                                                                thickness: 2,
                                                                height: 2,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            16),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Text(
                                                                        "Nama Barang",
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0.125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Text(
                                                                        "Jumlah",
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0.125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    // Expanded(
                                                                    //   flex: 2,
                                                                    //   child:
                                                                    //       Text(
                                                                    //     "Harga",
                                                                    //     style: GoogleFonts
                                                                    //         .nunito(
                                                                    //       fontSize:
                                                                    //           13,
                                                                    //       letterSpacing:
                                                                    //           0.125,
                                                                    //     ),
                                                                    //   ),
                                                                    // ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Text(
                                                                        "Sub Total",
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0.125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    DottedLine(
                                                                  lineThickness:
                                                                      2,
                                                                  dashGapLength:
                                                                      2,
                                                                  dashLength: 3,
                                                                  dashColor:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount: snapData[1]
                                                                            [
                                                                            index]
                                                                        [
                                                                        'kode_stock']
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        idx) {
                                                                  return SizedBox(
                                                                    width:
                                                                        deviceWidth,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Text(
                                                                            // displayTransaksi[index].namaBarang,
                                                                            snapData[1][index]['nama_barang'][idx],
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0.125,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Text(
                                                                            // displayTransaksi[index].jumlahBarang,
                                                                            snapData[1][index]['jumlah_barang'][idx].toString(),
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0.125,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Expanded(
                                                                        //   flex:
                                                                        //       2,
                                                                        //   child:
                                                                        //       Text(
                                                                        //     displayTransaksi[index].hargaBarang,
                                                                        //     style:
                                                                        //         GoogleFonts.nunito(
                                                                        //       fontSize: 13,
                                                                        //       letterSpacing: 0.125,
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Text(
                                                                            NumberFormat.simpleCurrency(locale: 'id-ID', name: "").format(
                                                                              double.parse(
                                                                                snapData[1][index]['harga_barang'][idx].toString(),
                                                                              ),
                                                                            ),
                                                                            style:
                                                                                GoogleFonts.nunito(
                                                                              fontSize: 13,
                                                                              letterSpacing: 0.125,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    DottedLine(
                                                                  lineThickness:
                                                                      2,
                                                                  dashGapLength:
                                                                      2,
                                                                  dashLength: 3,
                                                                  dashColor:
                                                                      dividerColor,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            12),
                                                                child: Row(
                                                                  children: [
                                                                    const Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          Center(),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Text(
                                                                        "Total :",
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0.125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          Text(
                                                                        NumberFormat.simpleCurrency(
                                                                                locale: 'id-ID',
                                                                                name: "")
                                                                            .format(
                                                                          double
                                                                              .parse(
                                                                            snapData[1][index]['total_harga_penjualan'].toString(),
                                                                          ),
                                                                        ),
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontSize:
                                                                              13,
                                                                          letterSpacing:
                                                                              0.125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (snapData[0] == 404) {
                                    return Center();
                                  }
                                }
                                return Center();
                              },
                            ),
                          ),
                        ],
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
