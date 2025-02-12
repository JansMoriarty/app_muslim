import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingJadwalPage extends StatelessWidget {
  const LoadingJadwalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E0E16),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildShimmerText(width: 120, height: 16),
              const SizedBox(height: 8),
              _buildShimmerText(width: 180, height: 24),
              const SizedBox(height: 18),
              _buildShimmerCard(height: 100),
              const SizedBox(height: 40),
              _buildShimmerText(width: 140, height: 16),
              const SizedBox(height: 22),
              _buildShimmerCard(height: 160),
              const SizedBox(height: 16),
              _buildShimmerPrayerTimes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerText({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget _buildShimmerPrayerTimes() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(23, 255, 160, 77),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(7, (index) => _buildShimmerPrayerRow()),
      ),
    );
  }

  Widget _buildShimmerPrayerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[600]!,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 12,
                ),
              ),
              const SizedBox(width: 12),
              _buildShimmerText(width: 60, height: 14),
            ],
          ),
          _buildShimmerText(width: 50, height: 14),
        ],
      ),
    );
  }
}
