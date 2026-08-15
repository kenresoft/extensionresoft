// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class AppColors {
  // Major Colors //
  static const primary = Color(0xFF7552CD);
  static const primary1 = Color(0xFF4C3A70);
  static const primary2 = Color(0xFF373148);
  static const darkPrimary = Color(0xFF120F3C);
  static const secondary = Color(0xFF0E1526);

  // Shades of Grey
  static const grey1 = Color(0xFFDFE5ED);
  static const grey2 = Color(0xFF8F9DB5);
  static const grey3 = Color(0xFF8F9EB5);
  static const grey4 = Color(0xFF63738A);
  static const grey5 = Color(0xFF455366);
  static const grey6 = Color(0xFF313E52);
  static const grey7 = Color(0xFF303E51);
  static const grey8 = Color(0xFF1C2638);

  // Shades of White
  static const white = Color(0xFFFFFFFF);
  static const white1 = Color(0xFFFAF5E9);
  static const white2 = Color(0xFFF5EFE6);
  static const white3 = Color(0xFFEDE4DA);
  static const white4 = Color(0xFFECF0F4);
  static const white5 = Color(0xFFC8D2DE);

  // Shades of Black
  static const black = Color(0xFF000000);
  static const black1 = Color(0xFF04090F);
  static const black2 = Color(0xFF121212);
  static const black3 = Color(0xFF191919);
  static const black4 = Color(0x1F000000);
  static const black5 = Color(0xFF212121);

  static const transparent = Color(0x00000000);

  // Light Theme Colors //
  static const Color lightElevatedIcon = white;
  static const Color lightElevatedBg = primary;
  static const Color lightElevatedText = white;

  static const Color lightOutlinedIcon = darkPrimary;
  static const Color lightOutlinedBg = transparent;
  static const Color lightOutlinedText = darkPrimary;
  static const Color lightOutlinedBorder = darkPrimary;
  static const Color lightIndicator = white5;
  static const Color lightTextTitle = Color(0xFF1A1B1E);
  static const Color lightText = Color(0xFF757575);

  static const Color lightFocusedBorder = secondary;
  static const Color lightEnabledBorder = darkPrimary;
  static const Color lightInputText = secondary;
  static const Color lightCard = white1;

  // Dark Theme Colors //
  static const Color darkElevatedIcon = white;
  static const Color darkElevatedBg = primary;
  static const Color darkElevatedText = white;

  static const Color darkOutlinedIcon = primary;
  static const Color darkOutlinedBg = transparent;
  static const Color darkOutlinedText = primary;
  static const Color darkOutlinedBorder = primary;
  static const Color darkIndicator = grey5;
  static const Color darkTextTitle = white;
  static const Color darkText = grey2;

  static const Color darkFocusedBorder = white;
  static const Color darkEnabledBorder = Color(0xFF637289);
  static const Color darkInputText = grey4;
  static const Color darkCard = Color(0xFF1D2738);

  // Other Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
  static const Color success = Color(0xFF0FB780);

  AppColors._();
}
