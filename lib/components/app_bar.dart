import 'package:flutter/material.dart';

import '../constants/colors.dart';

PreferredSizeWidget customAppBar() => AppBar(
  shadowColor: AppColor.lightMilitaryGreen,
  backgroundColor: AppColor.lightBrown,
  elevation: 15,
  centerTitle: true,
  title: const Text(
    '3D Parallax Card Effect',
    style: TextStyle(color: AppColor.militaryGreen),
  ),
);
