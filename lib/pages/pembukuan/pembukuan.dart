//ignore_for_file: todo

import 'package:aplikasi_pos/services/class/dataclass.dart';
import 'package:aplikasi_pos/themes/colors.dart';
import 'package:aplikasi_pos/widgets/stringextension.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

enum RadioFilterTanggal { harian, mingguan, bulanan, tahunan }

enum RadioFilterStatus { sukses, pending, none }

class PembukuanPage extends StatefulWidget {
  const PembukuanPage({super.key});

  @override
  State<PembukuanPage> createState() => _PembukuanPageState();
}

class _PembukuanPageState extends State<PembukuanPage>
    with AutomaticKeepAliveClientMixin {
  final _controllerSearchBar = TextEditingController();
  final _controllerScrollBar = ScrollController();
  int _selectedIndexChipsFilter = 0;

  List<PembukuanTransaksi> pembukuanTransaksi = [];
  List<IsiPembukuanTransaksi> displayTransaksi = [];
  final List<Filter> _chipsFilterList = List.empty(growable: true);

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;
    addPembukuanTransaksi();
    addIsiPembukuanTransaksi();
    _chipsFilterList.add(Filter("Semua", Colors.white));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerSearchBar.dispose();
    _controllerScrollBar.dispose();
  }

  String formatDateToString(DateTime value) {
    selectedDate = value;
    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;
    return date;
  }

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
    for (int i = 0; i < 50; i++) {
      pembukuanTransaksi.add(
        PembukuanTransaksi(
            "P00${i * i * i * i}",
            formatDateToString(
              DateTime.now().add(
                const Duration(days: 1),
              ),
            ),
            "${2400000 * (i + 1)}",
            "Selesai"),
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
    RadioFilterStatus? radioFilterStatus;
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
                                fontSize: 16,
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
                              vertical: 24, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Filter Sesuai Tanggal",
                                style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    letterSpacing: 0.125,
                                    color: filterText,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
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
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterTanggal.mingguan,
                                          groupValue: radioFilterTanggal,
                                          activeColor: filterText,
                                          onChanged: (value) {
                                            radioFilterTanggal =
                                                value as RadioFilterTanggal;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Mingguan",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Wrap(
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
                                  ),
                                  Expanded(
                                    child: Wrap(
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
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(
                                "Filter Sesuai Status",
                                style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    letterSpacing: 0.125,
                                    color: filterText,
                                    fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterStatus.sukses,
                                          groupValue: radioFilterStatus,
                                          activeColor: filterText,
                                          onChanged: (value) {
                                            radioFilterStatus =
                                                value as RadioFilterStatus;
                                            _chipsFilterList.add(Filter(
                                                value.name.capitalize(),
                                                Colors.white));
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "Sukses",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterStatus.pending,
                                          groupValue: radioFilterStatus,
                                          activeColor: filterText,
                                          onChanged: (value) {
                                            radioFilterStatus =
                                                value as RadioFilterStatus;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
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
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Radio(
                                          value: RadioFilterStatus.none,
                                          groupValue: radioFilterStatus,
                                          activeColor: filterText,
                                          onChanged: (value) {
                                            radioFilterStatus =
                                                value as RadioFilterStatus;
                                            if (mounted) {
                                              debugPrint(value.name);
                                              setState(() {});
                                            }
                                          },
                                        ),
                                        Text(
                                          "None",
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              letterSpacing: 0.125,
                                              color: darkText,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
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
                                  onPressed: () {},
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
    );
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
                          children: generateFilterChips(),
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
                            child: Scrollbar(
                              radius: const Radius.circular(8),
                              thumbVisibility: true,
                              controller: _controllerScrollBar,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                controller: _controllerScrollBar,
                                itemCount: pembukuanTransaksi.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: deviceWidth,
                                    child: Column(
                                      children: [
                                        //ISI TABEL PEMBUKUAN
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 4,
                                          color: index % 2 == 0
                                              ? cardInfoColor1
                                              : cardInfoColor2,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Theme(
                                              data: theme,
                                              child: ExpansionTile(
                                                key: UniqueKey(),
                                                collapsedTextColor: darkText,
                                                textColor: darkText,
                                                collapsedIconColor: darkText,
                                                iconColor: darkText,
                                                initiallyExpanded: false,
                                                maintainState: true,
                                                childrenPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                tilePadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                title: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        pembukuanTransaksi[
                                                                index]
                                                            .idTransaksi,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        pembukuanTransaksi[
                                                                index]
                                                            .tanggalTransaksig,
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 13,
                                                          letterSpacing: 0.125,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        NumberFormat
                                                                .simpleCurrency(
                                                                    locale:
                                                                        'id-ID',
                                                                    name:
                                                                        "Rp. ")
                                                            .format(
                                                          double.parse(
                                                            pembukuanTransaksi[
                                                                    index]
                                                                .totalTransaksi,
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
                                                children: [
                                                  Column(
                                                    children: [
                                                      Divider(
                                                        color: dividerColor,
                                                        thickness: 2,
                                                        height: 2,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 16),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                "Nama Barang",
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
                                                                "Jumlah",
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
                                                                "Harga",
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
                                                                "Sub Total",
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
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: DottedLine(
                                                          lineThickness: 2,
                                                          dashGapLength: 2,
                                                          dashLength: 3,
                                                          dashColor:
                                                              dividerColor,
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            displayTransaksi
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return SizedBox(
                                                            width: deviceWidth,
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(
                                                                    displayTransaksi[
                                                                            index]
                                                                        .namaBarang,
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
                                                                  child: Text(
                                                                    displayTransaksi[
                                                                            index]
                                                                        .jumlahBarang,
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
                                                                  child: Text(
                                                                    displayTransaksi[
                                                                            index]
                                                                        .hargaBarang,
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
                                                                  child: Text(
                                                                    NumberFormat.simpleCurrency(
                                                                            locale:
                                                                                'id-ID',
                                                                            name:
                                                                                "")
                                                                        .format(
                                                                      double
                                                                          .parse(
                                                                        displayTransaksi[index]
                                                                            .subTotalBarang,
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
                                                          );
                                                        },
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8),
                                                        child: DottedLine(
                                                          lineThickness: 2,
                                                          dashGapLength: 2,
                                                          dashLength: 3,
                                                          dashColor:
                                                              dividerColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 12),
                                                        child: Row(
                                                          children: [
                                                            const Expanded(
                                                              flex: 4,
                                                              child: Center(),
                                                            ),
                                                            const Expanded(
                                                              flex: 2,
                                                              child: Center(),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                "Total :",
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
                                                                            "")
                                                                    .format(
                                                                  double.parse(
                                                                    "50000",
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
