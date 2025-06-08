import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/viewmodel/month_schedule_viewmodel.dart';

class MonthSchedulePage extends StatefulWidget {
  final String lokasi;
  final String tahun;
  final String bulan;

  const MonthSchedulePage({
    this.lokasi = '1206',
    this.tahun = '2025',
    this.bulan = '06',
  });

  @override
  _MonthSchedulePageState createState() => _MonthSchedulePageState();
}

class _MonthSchedulePageState extends State<MonthSchedulePage> {
  int selectedIndex = 0;

  static const List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MonthScheduleViewModel()
        ..fetchMonthSchedule(widget.lokasi, widget.tahun, widget.bulan),
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0E16),
        body: Consumer<MonthScheduleViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xffF77C25)));
            }
            if (vm.errorMessage != null) {
              return Center(
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final jadwalList = vm.monthSchedule?.data?.jadwal;
            if (jadwalList == null || jadwalList.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada data jadwal.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final monthIndex = int.tryParse(widget.bulan) ?? 1;
            final monthName = _monthNames[(monthIndex.clamp(1, 12)) - 1];

            final today = DateTime.now();

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Bulan & Icon Kalender
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20, top: 12, left: 20, bottom: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bulan Ini,',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '$monthName ${widget.tahun}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(57, 247, 125, 37),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.calendar_month,
                              color: Color.fromARGB(255, 237, 107, 14)),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal Calendar Picker
                  Container(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: jadwalList.length,
                      itemBuilder: (context, index) {
                        final dt = DateTime.parse(jadwalList[index].date!);
                        final isSelected = index == selectedIndex;
                        final dayAbbrev = [
                          'MIN',
                          'SEN',
                          'SEL',
                          'RAB',
                          'KAM',
                          'JUM',
                          'SAB'
                        ][dt.weekday % 7];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color.fromARGB(255, 237, 107, 14)
                                  : Color.fromARGB(0, 31, 31, 31),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dt.day.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white60,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dayAbbrev,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white60,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Jadwal Cards
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      children: _buildPrayerCards(jadwalList[selectedIndex]),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildPrayerCards(jadwal) {
  final List<Map<String, dynamic>> prayers = [
    {'name': 'Fajr', 'time': jadwal.subuh, 'icon': Icons.wb_twilight},
    {'name': 'Dhuha', 'time': jadwal.dhuha, 'icon': Icons.wb_sunny_outlined},
    {'name': 'Dzuhur', 'time': jadwal.dzuhur, 'icon': Icons.wb_sunny},
    {'name': 'Asr', 'time': jadwal.ashar, 'icon': Icons.wb_cloudy},
    {'name': 'Maghrib', 'time': jadwal.maghrib, 'icon': Icons.nightlight},
    {'name': 'Isha', 'time': jadwal.isya, 'icon': Icons.nights_stay},
  ];

  return prayers.map((p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xff181820),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Garis vertikal kecil di kiri
          Container(
            width: 4,
            height: 48,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 107, 14),
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Icon waktu
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(56, 237, 107, 14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              p['icon'],
              color: const Color.fromARGB(255, 237, 107, 14),
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Nama dan waktu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p['time'] ?? '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Tambahan icon di kanan (opsional)
          Icon(
            Icons.notifications_none,
            color: Colors.white24,
            size: 20,
          ),
        ],
      ),
    );
  }).toList();
}

}
