import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muslim_app/model/surat_model.dart';

class SuratViewModel extends ChangeNotifier {
  SuratModel? _suratModel;
  bool _isLoading = false;
  String? _errorMessage;
  List<Data> _favoriteSurat = []; // Menyimpan daftar surat favorit yang menggunakan model Data

  SuratModel? get suratModel => _suratModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Data> get favoriteSurat => _favoriteSurat; // Getter untuk favoriteSurat

  Future<void> fetchSuratData() async {
    const String apiUrl = "https://equran.id/api/v2/surat";
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData is Map<String, dynamic>) {
          _suratModel = SuratModel.fromJson(jsonData);
        } else {
          _errorMessage = "Data tidak valid atau kosong.";
        }
      } else {
        _errorMessage = "Gagal memuat data. Kode status: ${response.statusCode}";
      }
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Menambahkan surat ke favorit (menggunakan model Data)
  void addToFavorites(Data surat) {
    if (!_favoriteSurat.contains(surat)) {
      _favoriteSurat.add(surat);
      notifyListeners();
    }
  }

  // Menghapus surat dari favorit (menggunakan model Data)
  void removeFromFavorites(Data surat) {
    _favoriteSurat.remove(surat);
    notifyListeners();
  }
}
