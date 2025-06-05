import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tentang Qolbu',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 237, 107, 14), // oranye aksen
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Qolbu adalah aplikasi Muslim yang dirancang untuk membantu kamu menjalani aktivitas ibadah sehari-hari dengan lebih mudah dan terorganisir. Dengan Qolbu, kamu bisa:\n',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '• Melihat jadwal sholat lengkap sesuai lokasi dan waktu setempat.\n'
                  '• Mengakses jadwal sholat bulanan dengan tampilan kalender yang interaktif.\n'
                  '• Membaca surah dan doa-doa populer lengkap dengan tafsir dan audio.\n'
                  '• Mendapatkan pengingat waktu sholat agar ibadah tidak terlewat.\n'
                  '• Mengikuti inspirasi dan artikel singkat yang menenangkan hati dan memperkuat iman.\n',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'Qolbu hadir dengan desain modern dan warna yang nyaman di mata, khususnya di malam hari, agar pengalaman menggunakan aplikasi tetap menyenangkan kapan pun dan di mana pun.\n',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  '“Hati yang tenang, hidup yang berkah.”\nItulah semangat kami dalam membangun Qolbu.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Color.fromARGB(255, 237, 107, 14),
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Terima kasih telah memilih Qolbu sebagai sahabat spiritualmu. Semoga aplikasi ini menjadi jalan untuk meningkatkan kualitas ibadah dan keseharianmu.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
