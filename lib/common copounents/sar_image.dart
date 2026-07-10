import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SarImage extends StatelessWidget {
  const SarImage({super.key, this.color, this.height});
  final Color? color;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Image.asset("assets/images/sar.png", color: color?? Color.fromARGB(255, 5, 97, 50),),
      child: SvgPicture.asset("assets/icons/sar.svg",colorFilter: ColorFilter.mode(color??Colors.black , BlendMode.srcIn),),
      height: height?? 13,
    );
  }
}

class BlackSarImage extends StatelessWidget {
  const BlackSarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/blackSar.jpg"),
      height: 13,
    );
  }
}

class RedSarImage extends StatelessWidget {
  const RedSarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset("assets/images/blackSar.jpg"),
      height: 13,
    );
  }
}
