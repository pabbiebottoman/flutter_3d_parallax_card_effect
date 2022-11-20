import 'package:flutter/widgets.dart';

import '../constants/colors.dart';

class FooterText extends StatelessWidget {
  const FooterText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SizedBox(
        height: 40,
        child: Center(
          child: Text(
            '@pabbiebottoman\n',
            style: TextStyle(
              color: AppColor.darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
