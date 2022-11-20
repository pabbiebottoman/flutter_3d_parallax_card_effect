// ignore_for_file: non_constant_identifier_names

import 'package:flutter/widgets.dart';

import 'colors.dart';

final BuyButton = Container(
  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
  decoration: BoxDecoration(
    color: AppColor.lightBrown,
    borderRadius: BorderRadius.circular(8.0),
  ),
  child: const Text(
    'BUY',
    style: TextStyle(
      color: AppColor.white,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  ),
);
