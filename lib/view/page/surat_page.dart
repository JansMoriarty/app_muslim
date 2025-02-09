import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/viewmodel/surat_viewmodel.dart';

class SuratPage extends StatefulWidget {
  @override
  _SuratPageState createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SuratViewModel>(context, listen: false).fetchSuratData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Stack(
        children: [Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Consumer<SuratViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return Center(child: CircularProgressIndicator(color: Colors.orange,));
              } else if (viewModel.errorMessage != null) {
                return Center(child: Text(viewModel.errorMessage!));
              } else if (viewModel.suratModel?.data == null) {
                return Center(child: Text("Tidak ada data."));
              }
        
              return ListView.builder(
                itemCount: viewModel.suratModel!.data!.length,
                itemBuilder: (context, index) {
                  final surat = viewModel.suratModel!.data![index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(94, 0, 0, 0)
                                .withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            width: 22,
                                            height: 22,
                                            color: const Color.fromARGB(
                                                44, 255, 153, 0),
                                            child: Center(
                                              child: Text(
                                                surat.nomor.toString(),
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'Poppins',
                                                    color: const Color.fromARGB(
                                                        255, 255, 153, 0),
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          surat.namaLatin ?? '',
                                          style: TextStyle(
                                            color: Color(0xff464646),
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 11),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${surat.jumlahAyat} Ayat',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '| ${surat.arti}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126),
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
                                  opacity: 1,
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
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        ]
      ),
    );
  }
}
