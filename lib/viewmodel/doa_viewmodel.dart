import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muslim_app/model/doa_model.dart';

class DoaListViewModel extends ChangeNotifier {
  List<DoaModel>? _doaList;
  bool _isLoading = false;
  String? _errorMessage;

  List<DoaModel>? get doaList => _doaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDoaData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = "https://doa-doa-api-ahmadramadhan.fly.dev/api";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData is List) {
          _doaList = jsonData.map<DoaModel>((json) => DoaModel.fromJson(json)).toList();
        } else {
          _errorMessage = "Data tidak valid atau bukan list.";
        }
      } else {
        _errorMessage = "Gagal memuat data. Status code: ${response.statusCode}";
      }
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
