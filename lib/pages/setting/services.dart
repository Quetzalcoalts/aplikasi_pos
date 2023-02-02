//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://kostsoda.onthewifi.com:38600/";

class ServicesSetting {
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

  //RETUR
  Future getRetur() async {
    final response = await http.get(
      Uri.parse("${_linkPath}rtr/read-retur"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future postRetur(idSup, namaSup, kodeStock, nama, jumlah) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}rtr/input-retur?id_supplier=$idSup&nama_supplier=$namaSup&kode_stock=$kodeStock&nama_barang=$nama&jumlah_barang=$jumlah"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];

      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal Mengirim data");
    }
  }

  Future getKodeBarang(idSup) async {
    final response = await http.get(
      Uri.parse("${_linkPath}rtr/read-kode-nama-barang?kode_supplier=$idSup"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getMaxJumlahBarang(idSup, kodeStock) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}rtr/read-max-jumlah?kode_supplier=$idSup&kode_stock=$kodeStock"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TUTUP BUKU
  Future tutupPembukuan(tanggal) async {
    final response = await http.get(
      Uri.parse("${_linkPath}pmb/penutupan-pembukuan?tanggal=$tanggal"),
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
