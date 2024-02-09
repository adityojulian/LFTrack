import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const purple = Color(0xFF6E5DE7);
const background = Color(0xFFF6F9FF);
const darkGrey = Color(0xFFBFBFBF);
const grey = Color(0xFFC7C9D9);
const darkerBlack = Color(0xFF404040);
const lineStroke = Color(0xFFDDE5E9);
const backgroundBlue = Color(0xFFC9E7FF);
const subtleRed = Color(0xFFE28173);
const lighRed = Color(0xFFFF6A88);

TextStyle regular = GoogleFonts.poppins(
  fontWeight: FontWeight.w400,
);

TextStyle medium = GoogleFonts.poppins(
  fontWeight: FontWeight.w500,
);

TextStyle semibold = GoogleFonts.poppins(
  fontWeight: FontWeight.w600,
);

TextStyle bold = GoogleFonts.poppins(
  fontWeight: FontWeight.w700,
);

enum ColorSelectionMethod {
  colorSeed,
  image,
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}
