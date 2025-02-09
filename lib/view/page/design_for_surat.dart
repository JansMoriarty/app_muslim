import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/viewmodel/surat_viewmodel.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = "";
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    Provider.of<SuratViewModel>(context, listen: false).fetchSuratData();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        if (!_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = true;
          });
        }
      } else {
        if (_showBackToTopButton) {
          setState(() {
            _showBackToTopButton = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Lottie di atas
          Positioned(
            top: -150,
            left: 0,
            right: 0,
            child: Container(
              height: 600,
              color: Color(0xffF77C25),
              child: SizedBox(
                height: 1000, // Atur tinggi area Lottie
                child: Center(
                  child: Lottie.asset(
                    'assets/images/read.json',
                    width: 1200, // Sesuaikan ukuran animasi
                    height: 1000,
                    fit: BoxFit.contain, 
                  ),
                ),
              ),
            ),
          ),

          // Container list surat + search bar
          Positioned(
            top: 260, // Pastikan ada jarak dari Lottie
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(34),
              ),
              child: Container(
                color: Color(0xff0E0E16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Cari surat...",
                          hintStyle: TextStyle(color: Colors.white60),
                          prefixIcon: Icon(Icons.search, color: Colors.white60),
                          filled: true,
                          fillColor: Color(0xff1E1E2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Consumer<SuratViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Colors.orange),
                            );
                          } else if (viewModel.errorMessage != null) {
                            return Center(child: Text(viewModel.errorMessage!));
                          } else if (viewModel.suratModel?.data == null) {
                            return Center(child: Text("Tidak ada data."));
                          }

                          final filteredSurat = viewModel.suratModel!.data!
                              .where((surat) => surat.namaLatin!
                                  .toLowerCase()
                                  .contains(_searchQuery))
                              .toList();

                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.zero,
                            itemCount: filteredSurat.length,
                            itemBuilder: (context, index) {
                              final surat = filteredSurat[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Color(0xff181820),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Container(
                                                    width: 22,
                                                    height: 22,
                                                    color: Colors.orange
                                                        .withOpacity(0.2),
                                                    child: Center(
                                                      child: Text(
                                                        surat.nomor.toString(),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontFamily: 'Poppins',
                                                          color: Colors.orange,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  surat.namaLatin ?? '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_right_rounded,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 11),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${surat.jumlahAyat} Ayat',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  '| ${surat.arti}',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Opacity(
                                          opacity: 0.4,
                                          child: Image.asset(
                                            'assets/images/quran.png',
                                            height: 150,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button untuk kembali ke atas
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 255, 106, 0),
              onPressed: _scrollToTop,
              shape: CircleBorder(),
              child: Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }
}
