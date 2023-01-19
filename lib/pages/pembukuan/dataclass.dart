
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
