// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:muslim_app/viewmodel/jadwal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hijri/hijri_calendar.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  String lokasi = '1206'; // ID lokasi

  late String tahun;
  late String bulan;
  late String tanggal;

  late Timer _timer;
  String _currentTime = '';

  String getGreetingMessage() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning!";
    } else if (hour < 18) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  String convertToHijri(String tanggalMasehi) {
    DateTime date = DateTime.parse(tanggalMasehi);
    HijriCalendar hijri = HijriCalendar.fromDate(date);

    return '${hijri.hDay} ${hijri.getLongMonthName()} ${hijri.hYear} H';
  }

  String formatTanggal(String tanggal) {
    // Mengubah string tanggal menjadi DateTime
    DateTime date = DateTime.parse(tanggal);

    // Format tanggal sesuai dengan format yang diinginkan
    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);
  }

  @override
  void initState() {
    super.initState();

    // Inisialisasi tanggal saat ini
    DateTime now = DateTime.now();
    tahun = now.year.toString();
    bulan =
        now.month.toString().padLeft(2, '0'); // Format dua digit, misalnya "02"
    tanggal =
        now.day.toString().padLeft(2, '0'); // Format dua digit, misalnya "04"

    // Timer untuk memperbarui waktu setiap detik
    _currentTime = _getCurrentTime();
    setState(() {}); // Tambahkan ini untuk menampilkan waktu langsung

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _getCurrentTime();
      });
    });

    // Memanggil fetchJadwal ketika widget pertama kali dibangun
    Future.microtask(() {
      context
          .read<JadwalViewmodel>()
          .fetchJadwal(lokasi, tahun, bulan, tanggal);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer untuk mencegah memory leak
    super.dispose();
  }

  String _getCurrentTime() {
    return DateFormat('HH.mm').format(
      DateTime.now().toUtc().add(const Duration(hours: 7)), // GMT+7
    );
  }

  // Fungsi yang akan dipanggil ketika di-refresh
  Future<void> _onRefresh() async {
    DateTime now = DateTime.now();
    tahun = now.year.toString();
    bulan = now.month.toString().padLeft(2, '0');
    tanggal = now.day.toString().padLeft(2, '0');

    // Memanggil fetchJadwal saat di-refresh
    await context
        .read<JadwalViewmodel>()
        .fetchJadwal(lokasi, tahun, bulan, tanggal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E0E16),
      body: Consumer<JadwalViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.orange,
            ));
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          } else if (viewModel.jadwal?.data?.jadwal == null) {
            return const Center(child: Text('No schedule available.'));
          } else {
            final jadwal = viewModel.jadwal!.data!.jadwal!;
            final lokasi =
                viewModel.jadwal!.data!.lokasi ?? 'Lokasi tidak tersedia';

            // Konversi tanggal Masehi ke Hijriah
            HijriCalendar hijriDate = HijriCalendar.fromDate(DateTime.now());
            String hijriFormatted =
                '${hijriDate.hDay} ${hijriDate.getLongMonthName()} ${hijriDate.hYear} H';

            return RefreshIndicator(
              onRefresh: _onRefresh, // Fungsi refresh
              color: const Color.fromARGB(255, 255, 255, 255), // Mengubah warna indikator (misalnya putih)
              backgroundColor: Colors.orange, // Mengubah background indikator
              displacement: 80,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Assalamu'alaikum,",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        color: Color.fromARGB(255, 180, 180, 180)),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    getGreetingMessage(), // Menampilkan pesan berdasarkan waktu
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  size: 28,
                                ),
                                onPressed: () {
                                  showMenu(
                                    context: context,
                                    position: RelativeRect.fromLTRB(
                                        100.0, 50.0, 0.0, 0.0), // Posisi menu
                                    items: [
                                      PopupMenuItem(
                                        value: 'settings',
                                        child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 0,
                                              minHeight:
                                                  50), // Atur ukuran menu
                                          child: Row(
                                            children: [
                                              Icon(Icons.settings,
                                                  color: Colors.white, size: 20,),
                                              SizedBox(width: 10),
                                              Text('Settings',
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.white, fontSize: 14)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'about',
                                        child: Row(
                                          children: [
                                            Icon(Icons.info,
                                                color: Colors.white, size: 20,),
                                            SizedBox(width: 10),
                                            Text('About App',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white, fontSize: 14),),
                                          ],
                                        ),
                                      ),
                                    ],
                                    color: Color(0xff181820)
                                  );
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Color(0xff181820),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Read Qur`an',
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 223, 223, 223),
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right_rounded,
                                            color: Color(0xfffffffff),
                                            size: 18,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 24),
                                      Text(
                                        'Last read Al Fatihah',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color.fromARGB(255, 172, 172, 172)),
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                    'assets/images/quran.png',
                                    height: 150,
                                    width: 120, // Sesuaikan tinggi gambar
                                    fit: BoxFit
                                        .cover, // Agar gambar memenuhi area
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Prayer Time",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xfff0f0f0),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins'),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 20,
                                      color: Color.fromARGB(183, 244, 67, 54)),
                                  const SizedBox(width: 4),
                                  Text(
                                    lokasi,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 194, 194, 194),
                                        fontFamily: 'POppins'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Container(
                            width: double.infinity,
                            height: 160,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hijriFormatted,
                                          style: TextStyle(
                                              fontFamily: 'POppins',
                                              color: Color.fromARGB(255, 194, 194, 194),
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${jadwal.tanggal}',
                                          style: TextStyle(
                                              fontFamily: 'POppins',
                                              color: Color.fromARGB(
                                                  255, 163, 163, 163),
                                              fontSize: 11),
                                        ),
                                        SizedBox(
                                          height: 38,
                                        ),
                                        Text(
                                          '$_currentTime WIB',
                                          style: TextStyle(
                                              fontFamily: 'POppins',
                                              color: Color.fromARGB(
                                                  255, 163, 163, 163),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        18), // Menggunakan border radius yang sama dengan Container
                                    child: Image.asset(
                                      'assets/images/mosque.png',
                                      width: 100, // Sesuaikan ukuran gambar
                                      height: 1000,
                                      fit: BoxFit
                                          .cover, // Sesuaikan ukuran gambar
                                    ),
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(20, 255, 160, 77),
                              borderRadius: BorderRadius.circular(18),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(23, 255, 160, 77),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          _buildJadwalRow(
                              "Fajr", jadwal.subuh ?? "N/A", Icons.wb_twilight),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                          _buildJadwalRow("Dhuha", jadwal.dhuha ?? "N/A",
                              Icons.wb_sunny_outlined),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                          _buildJadwalRow(
                              "Dzuhur", jadwal.dzuhur ?? "N/A", Icons.sunny),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                          _buildJadwalRow(
                              "Asr", jadwal.ashar ?? "N/A", Icons.cloud),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                          _buildJadwalRow("Maghrib", jadwal.maghrib ?? "N/A",
                              Icons.nightlight),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                          _buildJadwalRow(
                              "Isha", jadwal.isya ?? "N/A", Icons.nights_stay),
                          Divider(
                            color: const Color.fromARGB(255, 164, 164, 164),
                            thickness: 0.3,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildJadwalRow(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color.fromARGB(255, 161, 161, 161)),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xfff0f0f0),
                  fontFamily: 'Poppins',
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xfff0f0f0),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.notifications,
                color: Color(0xffF77C25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
