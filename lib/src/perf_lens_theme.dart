import 'package:flutter/material.dart';

enum PerfLensTheme { dark, light, auto }

class PerfLensThemeData {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final Color warningColor;
  final Color successColor;
  final Color errorColor;

  const PerfLensThemeData({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.iconColor,
    required this.warningColor,
    required this.successColor,
    required this.errorColor,
  });

  static const PerfLensThemeData dark = PerfLensThemeData(
    backgroundColor: Color(0xE6000000),
    // Black with 90% opacity
    borderColor: Colors.green,
    textColor: Colors.white,
    iconColor: Colors.white70,
    warningColor: Colors.orange,
    successColor: Colors.green,
    errorColor: Colors.red,
  );

  static const PerfLensThemeData light = PerfLensThemeData(
    backgroundColor: Color(0xE6FFFFFF),
    // White with 90% opacity
    borderColor: Colors.blue,
    textColor: Colors.black87,
    iconColor: Colors.black54,
    warningColor: Colors.orange,
    successColor: Colors.green,
    errorColor: Colors.red,
  );

  static PerfLensThemeData fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

class PerfLensThemeProvider extends InheritedWidget {
  final PerfLensThemeData theme;
  final PerfLensTheme themeMode;

  const PerfLensThemeProvider({
    Key? key,
    required this.theme,
    required this.themeMode,
    required Widget child,
  }) : super(key: key, child: child);

  static PerfLensThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PerfLensThemeProvider>();
  }

  static PerfLensThemeData getTheme(BuildContext context) {
    final provider = of(context);
    if (provider != null) {
      if (provider.themeMode == PerfLensTheme.auto) {
        final brightness = MediaQuery.of(context).platformBrightness;
        return PerfLensThemeData.fromBrightness(brightness);
      }
      return provider.theme;
    }

    // Fallback to system theme
    final brightness = MediaQuery.of(context).platformBrightness;
    return PerfLensThemeData.fromBrightness(brightness);
  }

  @override
  bool updateShouldNotify(PerfLensThemeProvider oldWidget) {
    return theme != oldWidget.theme || themeMode != oldWidget.themeMode;
  }
}
