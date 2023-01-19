//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://kostsoda.onthewifi.com:38600/";

class ServicesPembukuan {
  Future getPembukuan(tanggal) async {
    final response = await http.get(
      Uri.parse("${_linkPath}pmb/read-pembukuan?tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future postPembukuan(tanggal) async {
    final response = await http.post(
      Uri.parse("${_linkPath}pmb/read-pembukuan?tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal memasukan data");
    }
  }

  Future getFilterPembukuan(tanggal, tanggal2, tipe) async {
    final response = await http.get(
      Uri.parse("${_linkPath}flt/fil-pembukuan?tanggal=$tanggal&tanggal2=$tanggal2&tipe_tanggal=$tipe"),
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