//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://kostsoda.onthewifi.com:38600/";

class ServicesStock {
  //STOCK
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

  Future postStock(nama, jumlah, harga) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}invent/input-stock?nama_barang=$nama&jumlah_barang=$jumlah&harga_barang=$harga"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];

      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal Mengirim data");
    }
  }

  Future putStock(kode, nama, jumlah, harga) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}invent/update-stock?kode_stock=$kode&nama_barang=$nama&jumlah_barang=$jumlah&harga_barang=$harga"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];

      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal Mengirim data");
    }
  }

  Future checkStock(kode, nama) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}invent/check-nama?kode_stock=$kode&nama_barang=$nama"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //STOCK MASUK
  Future postStockIn(
      kodeSup, namaSup, kodeStock, namaStock, jumlah, harga) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}stk-m/input-stock-masuk?kode_supplier=$kodeSup&kode_stock=$kodeStock&nama_stock=$namaStock&nama_supplier=$namaSup&jumlah_barang=$jumlah&harga_barang=$harga"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];

      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal Mengirim data");
    }
  }

  Future getStockIn() async {
    final response = await http.get(
      Uri.parse("${_linkPath}stk-m/stock-masuk"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
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
}
