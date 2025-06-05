class DescQuranModel {
  final DataSurah data;

  DescQuranModel({required this.data});

  factory DescQuranModel.fromJson(Map<String, dynamic> json) {
    return DescQuranModel(
      data: DataSurah.fromJson(json['data'] ?? {}),
    );
  }
}

class DataSurah {
  final String namaLatin;
  final int jumlahAyat;
  final List<Ayat> ayat;

  // Properti baru, hanya ambil audioFull["01"]
  final String audio01;

  DataSurah({
    required this.namaLatin,
    required this.jumlahAyat,
    required this.ayat,
    required this.audio01,
  });

  factory DataSurah.fromJson(Map<String, dynamic> json) {
    // Ambil map audioFull
    final audioFullMap = json['audioFull'] as Map<dynamic, dynamic>?;

    return DataSurah(
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      ayat: json['ayat'] != null
          ? List<Ayat>.from(json['ayat'].map((x) => Ayat.fromJson(x)))
          : [],
      audio01: audioFullMap != null && audioFullMap.containsKey('01')
          ? audioFullMap['01'].toString()
          : '',
    );
  }
}

class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksIndonesia;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksIndonesia,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
    );
  }
}
