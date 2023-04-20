import 'package:flutter/material.dart';
import 'package:nu_link_shortener/presentation/views/fake_item.dart';

class RecentURLsList extends StatelessWidget {
  const RecentURLsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: 25,
        itemBuilder: (context, index) {
          return FakeItem(isBig: index.isOdd);
        },
      );
  }
}