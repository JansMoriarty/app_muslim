import 'package:flutter/material.dart';
import 'package:muslim_app/viewmodel/detail_surah_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailSurahPage extends StatefulWidget {
  final int surahNo;

  const DetailSurahPage({super.key, required this.surahNo});

  @override
  State<DetailSurahPage> createState() => _DetailSurahPageState();
}

class _DetailSurahPageState extends State<DetailSurahPage> {
  late ScrollController _scrollController;
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >= 300 && !_showBackToTopButton) {
        setState(() => _showBackToTopButton = true);
      } else if (_scrollController.offset < 300 && _showBackToTopButton) {
        setState(() => _showBackToTopButton = false);
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          DetailSurahViewModel()..fetchSurahDetail(widget.surahNo),
      child: Scaffold(
        backgroundColor: Color(0xff0E0E16),
        body: Consumer<DetailSurahViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xffF77C25)),
              );
            } else if (viewModel.error != null) {
              return Center(
                child: Text(viewModel.error!,
                    style: TextStyle(color: Colors.white)),
              );
            } else if (viewModel.surahDetail == null) {
              return Center(
                child:
                    Text("Data kosong", style: TextStyle(color: Colors.white)),
              );
            }

            final surah = viewModel.surahDetail!;

            return Column(
              children: [
                // AppBar custom
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "E-Quran",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Expanded ListView
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    children: [
                      // Header Surah
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xff181820),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.data.namaLatin,
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "${surah.data.jumlahAyat} Ayat",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[300],
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Ayat List
                      ...surah.data.ayat.map((ayat) => Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xff181820),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        ayat.teksArab,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Amiri',
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(43, 247, 125, 37),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${ayat.nomorAyat}',
                                        style: TextStyle(
                                          color: Color(0xffF77C25),
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18),
                                Text(
                                  "${ayat.nomorAyat}. ${ayat.teksIndonesia}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey[300],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: _showBackToTopButton
            ? FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 106, 0),
                onPressed: _scrollToTop,
                shape: CircleBorder(),
                child: Icon(Icons.arrow_upward, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
