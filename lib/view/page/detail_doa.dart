import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/viewmodel/detail_doa_viewmodel.dart';

class DetailDoaPage extends StatefulWidget {
  final String doaId;

  const DetailDoaPage({Key? key, required this.doaId}) : super(key: key);

  @override
  State<DetailDoaPage> createState() => _DetailDoaPageState();
}

class _DetailDoaPageState extends State<DetailDoaPage> {
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
      duration: const Duration(milliseconds: 500),
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
      create: (_) => DetailDoaViewModel()..fetchDetailDoa(widget.doaId),
      child: Scaffold(
        backgroundColor: const Color(0xff0E0E16),
        body: Consumer<DetailDoaViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xffF77C25)),
              );
            } else if (viewModel.error != null) {
              return Center(
                child: Text(
                  viewModel.error!,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (viewModel.detailDoa == null) {
              return const Center(
                child: Text(
                  "Data kosong",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final doa = viewModel.detailDoa!;

            return Column(
              children: [
                // Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Detail Doa",
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

                // Content ListView
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    children: [
                      // CARD PREVIEW DOA
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0xff181820),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            color: const Color.fromARGB(
                                                44, 255, 153, 0),
                                            child: Center(
                                              child: Text(
                                                doa.id ??
                                                    "1", // Gunakan ID dari doa
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Poppins',
                                                  color: Color.fromARGB(
                                                      255, 255, 153, 0),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          child: Text(
                                            doa.doa ?? '',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: Colors.white,
                                            size: 18)
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '| Doa Harian',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Lihat selengkapnya ...',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Opacity(
                                  opacity: 0.3,
                                  child: Image.asset(
                                    'assets/images/doa.png',
                                    height: 150,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // KONTAINER UTAMA ISI DETAIL DOA
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xff181820),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doa.doa ?? "Doa",
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              doa.ayat ?? "",
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily: 'Amiri',
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              doa.latin ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              doa.artinya ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: _showBackToTopButton
            ? FloatingActionButton(
                backgroundColor: const Color(0xffF77C25),
                onPressed: _scrollToTop,
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_upward, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
