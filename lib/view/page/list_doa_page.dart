import 'package:flutter/material.dart';
import 'package:muslim_app/view/page/detail_doa.dart';
import 'package:muslim_app/viewmodel/doa_viewmodel.dart';
import 'package:provider/provider.dart';

class DoaPage extends StatefulWidget {
  @override
  _DoaPageState createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<DoaListViewModel>(context, listen: false).fetchDoaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E16),
      body: SafeArea(
        child: Column(
          children: [
            // Header tanpa AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Daily Doa',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xff181820),
                  hintText: 'Cari doa...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // List doa
            Expanded(
              child: Consumer<DoaListViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  } else if (viewModel.errorMessage != null) {
                    return Center(child: Text(viewModel.errorMessage!));
                  } else if (viewModel.doaList == null || viewModel.doaList!.isEmpty) {
                    return Center(child: Text("Tidak ada data doa."));
                  }

                  final filteredList = viewModel.doaList!.where((doa) {
                    final doaText = doa.doa?.toLowerCase() ?? '';
                    return doaText.contains(_searchQuery);
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "Doa tidak ditemukan.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final doa = filteredList[index];
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Color(0xff181820),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
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
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.30,
                                            child: Text(
                                              doa.doa ?? '',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_right_rounded,
                                              color: Colors.white, size: 18)
                                        ],
                                      ),
                                      SizedBox(height: 11),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '| Doa Harian',
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
                                            'Lihat selengkapnya ...',
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
