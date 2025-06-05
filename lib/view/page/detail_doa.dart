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
                    padding: const EdgeInsets.all(16),
                    children: [
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
