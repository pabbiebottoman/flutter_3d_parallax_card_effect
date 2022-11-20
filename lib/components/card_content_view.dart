import 'package:flutter/material.dart';

import '../constants/buttons.dart';
import '../constants/colors.dart';
import '../constants/texts.dart';

class CardContentView extends StatelessWidget {
  const CardContentView({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -150,
          right: -width * 0.5,
          child: CircleAvatar(
            radius: width * .5,
            backgroundColor: AppColor.lightMilitaryGreen,
          ),
        ),
        Positioned(
          top: 135,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                LargeNikeText,
                const SizedBox(height: 40),
                const Align(alignment: Alignment.centerLeft, child: NikeText),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [ShoeNameText, ShoePriceText],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [SloganText, BuyButton],
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 20,
                  color: AppColor.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
