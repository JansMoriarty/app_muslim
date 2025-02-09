import 'package:flutter/material.dart';
import 'package:muslim_app/view/page/design_for_surat.dart';
import 'package:muslim_app/main_page.dart';
import 'package:muslim_app/view/page/home.dart';
import 'package:muslim_app/view/page/jadwal_page.dart';
import 'package:muslim_app/view/page/month_jadwal_page.dart';
import 'package:muslim_app/view/page/surat_page.dart';
import 'package:muslim_app/viewmodel/doa_viewmodel.dart';
import 'package:muslim_app/view/page/doa_page.dart';
import 'package:muslim_app/viewmodel/jadwal_viewmodel.dart';
import 'package:muslim_app/viewmodel/month_schedule_viewmodel.dart';
import 'package:muslim_app/viewmodel/surat_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JadwalViewmodel()),
        ChangeNotifierProvider(create: (_) => SuratViewModel()),
      ],
      child: MaterialApp(
        title: 'Muslim App',
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false, // Menonaktifkan debug banner
        initialRoute: '/doa',
        routes: {
          '/doa': (context) => AnimatedNavBar(),
        },
      ),
    );
  }
}
