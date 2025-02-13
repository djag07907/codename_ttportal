import 'package:cdbi/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: white.withOpacity(0.5),
      child: const Center(
        child: SizedBox(
          width: 200.0,
          child: SpinKitRipple(
            color: tectransblue,
            size: 150.0,
            borderWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
