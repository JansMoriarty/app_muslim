import 'package:flutter/material.dart';
import 'package:muslim_app/view/page/about.dart';
import 'package:muslim_app/view/page/design_for_surat.dart';
import 'package:muslim_app/view/page/jadwal_page.dart'; // Mengimpor JadwalPage
import 'package:muslim_app/view/page/month_jadwal_page.dart';
import 'package:muslim_app/view/page/list_doa_page.dart';
import 'package:muslim_app/view/page/qibla_page.dart';


class AnimatedNavBar extends StatefulWidget {
  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar> {
  int _selectedIndex = 0; // Menyimpan indeks tab yang dipilih
  PageController _pageController = PageController(); // Kontroler untuk mengelola perpindahan halaman

  // Fungsi untuk menangani tab yang dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update indeks tab saat halaman berubah
          });
        },
        children: [
          JadwalPage(),  // Halaman 0: JadwalPage
          NewHome(),   // Halaman 1: SuratPage
          MonthSchedulePage(),
          DummyQiblaPage()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff0E0E16),
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (index) {
            bool isSelected = _selectedIndex == index; // Mengecek apakah tab ini dipilih
            List<IconData> icons = [
              Icons.home_rounded,            // Ikon untuk JadwalPage
              Icons.menu_book,       // Ikon untuk SuratPage
              Icons.event,  // Ikon untuk Favorites
              Icons.info,          // Ikon untuk Profile
            ];
            List<String> labels = [
              "Home",
              "Surah",
              "Jadwal",
              "About"
            ];
            return GestureDetector(
              onTap: () => _onItemTapped(index), // Memilih tab saat ditekan
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? const Color.fromARGB(100, 255, 255, 255).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index], // Menampilkan ikon yang sesuai dengan tab
                      color: isSelected ? Color(0xffF77C25): Colors.grey, // Warna ikon
                      size: isSelected ? 30 : 24, // Mengubah ukuran ikon saat dipilih
                    ),
                    SizedBox(height: 4), // Jarak antara ikon dan teks
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: isSelected ? Color(0xffF77C25) : Colors.grey, // Warna teks
                        fontSize: 12, // Ukuran teks
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500, // Ketebalan teks
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
