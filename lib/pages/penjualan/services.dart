//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://kostsoda.onthewifi.com:38600/";

class ServicesPenjualan {
  //Transaksi
  //TODO: Input Transaksi
  Future inputPenjualanTransaksi(
      kode_stock_tran,
      nama_barang_tran,
      jumlah_barang_tran,
      harga_barang_tran,
      tanggal_pelunasan_tran,
      status_transaksi_tran,
      sub_total_harga_tran) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}tr/input-transaksi?kode_stock=$kode_stock_tran&nama_barang=$nama_barang_tran&jumlah_barang=$jumlah_barang_tran&harga_barang=$harga_barang_tran&tanggal_pelunasan=$tanggal_pelunasan_tran&status_transaksi=$status_transaksi_tran&sub_total_harga=$sub_total_harga_tran"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Transaksi
  Future getPenjualanTransaksi(tanggal) async {
    final response = await http.get(
      Uri.parse("${_linkPath}tr/transaksi?tanggal_transaksi=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Filter
  Future getFilter(tanggal, tipestatus) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}flt/fil-transaksi?tipe_status=$tipestatus&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Detail Transaksi
  Future getDetailPenjualanTransaksi(kodeTransaksi) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}tr/read-detail-transaksi?kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Tanggal Transaksi
  Future getTanggal(tanggalTGL, statusTGL) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}tr/tgl-penjualan?tanggal=$tanggalTGL&status=$statusTGL"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //Supplier
  //TODO: Input supplier
  Future inputSupplier(namaSup, noSup, emailSup) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}sup/input-supplier?nama_supplier=$namaSup&nomor_telpon=$noSup&email_supplier=$emailSup"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get supplier
  Future getSupplier() async {
    final response = await http.get(
      Uri.parse("${_linkPath}sup/supplier"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Delete supplier
  Future deleteSupplier(kodeSup) async {
    final response = await http.delete(
      Uri.parse("${_linkPath}sup/delete-supplier?kode_supplier=$kodeSup"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal menghapus data");
    }
  }

  //Stock
  //TODO: Get stock
  Future getStock() async {
    final response = await http.get(
      Uri.parse("${_linkPath}invent/stock"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}
