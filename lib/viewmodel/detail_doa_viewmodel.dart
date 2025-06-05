import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muslim_app/model/doa_model.dart';

class DetailDoaViewModel extends ChangeNotifier {
  DoaModel? detailDoa;
  bool isLoading = false;
  String? error;

  Future<void> fetchDetailDoa(String doaId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final url = "https://doa-doa-api-ahmadramadhan.fly.dev/api/$doaId";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        detailDoa = DoaModel.fromJson(jsonData);
      } else {
        error = "Gagal memuat data. Status code: ${response.statusCode}";
      }
    } catch (e) {
      error = "Terjadi kesalahan: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
