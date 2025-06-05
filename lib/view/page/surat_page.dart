import 'package:flutter/material.dart';
import 'package:muslim_app/view/page/detail_doa.dart';
import 'package:muslim_app/viewmodel/doa_viewmodel.dart';
import 'package:provider/provider.dart';


class DoaPage extends StatefulWidget {
  @override
  _DoaPageState createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DoaListViewModel>(context, listen: false).fetchDoaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Consumer<DoaListViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            } else if (viewModel.doaList == null || viewModel.doaList!.isEmpty) {
              return Center(child: Text("Tidak ada data doa."));
            }

            return ListView.builder(
              itemCount: viewModel.doaList!.length,
              itemBuilder: (context, index) {
                final doa = viewModel.doaList![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDoaPage(
                          doaId: doa.id ?? '',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                                            color: Color.fromARGB(44, 255, 153, 0),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: 'Poppins',
                                                  color: Color.fromARGB(255, 255, 153, 0),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            doa.doa ?? '',
                                            style: TextStyle(
                                              color: Color(0xff464646),
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doa.latin ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color.fromARGB(255, 126, 126, 126),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          doa.artinya ?? '',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            color: Color.fromARGB(255, 126, 126, 126),
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
