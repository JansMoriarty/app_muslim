import 'package:flutter/material.dart';
import 'package:muslim_app/view/page/design_for_surat.dart';
import 'package:muslim_app/main_page.dart';
import 'package:muslim_app/view/page/detail_surah_page.dart';

import 'package:muslim_app/view/page/home.dart';
import 'package:muslim_app/view/page/jadwal_page.dart';
import 'package:muslim_app/view/loading%20design/loading_design.dart';
import 'package:muslim_app/view/page/month_jadwal_page.dart';
import 'package:muslim_app/view/page/splash.dart';
import 'package:muslim_app/view/page/list_doa_page.dart';
import 'package:muslim_app/viewmodel/detail_doa_viewmodel.dart';
import 'package:muslim_app/viewmodel/doa_viewmodel.dart';
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
        ChangeNotifierProvider(create: (_) => DoaListViewModel()),
        ChangeNotifierProvider(create: (_) => DetailDoaViewModel()),
      ],
      child: MaterialApp(
        title: 'Muslim App',
        debugShowCheckedModeBanner: false, 
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => AnimatedNavBar(),
          // route lain tetap sama
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail-surah') {
            final surahNo = settings.arguments as int?;
            if (surahNo == null) {
              return MaterialPageRoute(builder: (_) => AnimatedNavBar());
            }
            return MaterialPageRoute(
              builder: (_) => DetailSurahPage(surahNo: surahNo),
            );
          }
          return null;
        },
      ),
    );
  }
}
