import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSuratList extends StatelessWidget {
  const LoadingSuratList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 6, // Jumlah shimmer card sementara
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[800]!,
            highlightColor: Colors.grey[600]!,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.grey[850],
              ),
            ),
          ),
        );
      },
    );
  }
}
