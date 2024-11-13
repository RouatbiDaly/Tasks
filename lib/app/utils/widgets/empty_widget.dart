import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/empty.json",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 2,
      ),
    );
  }
}
