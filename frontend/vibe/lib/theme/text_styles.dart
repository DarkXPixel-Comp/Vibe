import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
 static TextStyle heading(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      );

  static TextStyle body(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 16,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
