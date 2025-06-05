import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muslim_app/model/desc_surah_model.dart';


class DetailSurahViewModel extends ChangeNotifier {
  DescQuranModel? _surahDetail;
  bool _isLoading = false;
  String? _error;

  DescQuranModel? get surahDetail => _surahDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSurahDetail(int surahNo) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = "https://equran.id/api/v2/surat/$surahNo";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _surahDetail = DescQuranModel.fromJson(json.decode(response.body));
      } else {
        _error = "Gagal memuat data.";
      }
    } catch (e) {
      _error = "Terjadi kesalahan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
