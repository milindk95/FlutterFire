part of 'resources.dart';

ThemeData themeData(BuildContext context, ThemeMode themeMode) {
  bool isDark = themeMode == ThemeMode.dark;
  const colorTheme = Color(0xFF30A0DB);

  /// Light colors
  const colorWhite = Colors.white;
  const colorWhiteVariant = Color(0xFFEEEEEE);

  /// Dark colors
  const colorBlack = Color(0xFF202020);
  const colorBlackVariant = Color(0xFF2A2A2A);

  return ThemeData(
    primaryColor: colorTheme,
    fontFamily: 'SFProDisplay',
    scaffoldBackgroundColor: isDark ? colorBlack : colorWhite,

    /// Color scheme
    colorScheme: themeMode == ThemeMode.dark
        ? ColorScheme.dark(
            primary: colorTheme,
            primaryVariant: colorWhite,
            secondary: colorBlackVariant,
            secondaryVariant: colorWhiteVariant,
            onSecondary: colorBlack,
          )
        : ColorScheme.light(
            primary: colorTheme,
            primaryVariant: colorBlack,
            secondary: colorWhiteVariant,
            secondaryVariant: colorBlackVariant,
            onSecondary: colorWhite,
          ),

    /// Card bar theme
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: (isDark ? Color(0xFF2D2D2D) : Color(0xFFF4F4F4)),
    ),

    /// Radio button theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(colorTheme),
    ),
  );
}
