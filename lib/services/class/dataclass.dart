import 'package:flutter/material.dart';

class Filter {
  String label;
  Color color;
  Filter(this.label, this.color);
}

// DATACLASS PEMBUKUAN

class PembukuanTransaksi {
  String idTransaksi;
  String tanggalTransaksig;
  String totalTransaksi;
  String statusTransaksi;

  PembukuanTransaksi(this.idTransaksi, this.tanggalTransaksig,
      this.totalTransaksi, this.statusTransaksi);
}

class IsiPembukuanTransaksi {
  String namaBarang;
  String jumlahBarang;
  String hargaBarang;
  String subTotalBarang;

  IsiPembukuanTransaksi(this.namaBarang, this.jumlahBarang, this.hargaBarang,
      this.subTotalBarang);
}

// DATACLASS STOCK

class StockBarang {
  String idStockBarang;
  String namaStockBarang;
  String jumlahStockBarang;
  String hargaStockBarang;

  StockBarang(this.idStockBarang, this.namaStockBarang, this.jumlahStockBarang,
      this.hargaStockBarang);
}
