import 'package:flutter/material.dart';

class PembukuanPage extends StatefulWidget {
  const PembukuanPage({super.key});

  @override
  State<PembukuanPage> createState() => _PembukuanPageState();
}

class _PembukuanPageState extends State<PembukuanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Center(
          child: Text("Pembukuan"),
        ),
      ),
    );
  }
}
