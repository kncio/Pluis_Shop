import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PluisAppTheme {
  //colors
  static Color get primaryColor => const MaterialColor(0xFFDD1010, {
    50: Color.fromRGBO(221, 16, 16, .1),
    100: Color.fromRGBO(221, 16, 16, .2),
    200: Color.fromRGBO(221, 16, 16, .3),
    300: Color.fromRGBO(221, 16, 16, .4),
    400: Color.fromRGBO(221, 16, 16, .5),
    500: Color.fromRGBO(221, 16, 16, .6),
    600: Color.fromRGBO(221, 16, 16, .7),
    700: Color.fromRGBO(221, 16, 16, .8),
    800: Color.fromRGBO(221, 16, 16, .9),
    900: Color.fromRGBO(221, 16, 16, 1),
  });
  static Color get primarySwatch => const MaterialColor(0xff4d3e3b, {
    50: Color.fromRGBO(77, 62, 59, .1),
    100: Color.fromRGBO(77, 62, 59, .2),
    200: Color.fromRGBO(77, 62, 59, .3),
    300: Color.fromRGBO(77, 62, 59, .4),
    400: Color.fromRGBO(77, 62, 59, .5),
    500: Color.fromRGBO(77, 62, 59, .6),
    600: Color.fromRGBO(77, 62, 59, .7),
    700: Color.fromRGBO(77, 62, 59, .8),
    800: Color.fromRGBO(77, 62, 59, .9),
    900: Color.fromRGBO(77, 62, 59, 1),
  });
  static Color get thirdColor => const MaterialColor(0xffeeec7e, {
    50: Color.fromRGBO(238, 236, 126, .1),
    100: Color.fromRGBO(238, 236, 126, .2),
    200: Color.fromRGBO(238, 236, 126, .3),
    300: Color.fromRGBO(238, 236, 126, .4),
    400: Color.fromRGBO(238, 236, 126, .5),
    500: Color.fromRGBO(238, 236, 126, .6),
    600: Color.fromRGBO(238, 236, 126, .7),
    700: Color.fromRGBO(238, 236, 126, .8),
    800: Color.fromRGBO(238, 236, 126, .9),
    900: Color.fromRGBO(238, 236, 126, 1),
  });
  static Color get fourthColor => const MaterialColor(0xfffafade, {
    50: Color.fromRGBO(250, 250, 222, .1),
    100: Color.fromRGBO(250, 250, 222, .2),
    200: Color.fromRGBO(250, 250, 222, .3),
    300: Color.fromRGBO(250, 250, 222, .4),
    400: Color.fromRGBO(250, 250, 222, .5),
    500: Color.fromRGBO(250, 250, 222, .6),
    600: Color.fromRGBO(250, 250, 222, .7),
    700: Color.fromRGBO(250, 250, 222, .8),
    800: Color.fromRGBO(250, 250, 222, .9),
    900: Color.fromRGBO(250, 250, 222, 1),
  });
  static Color get cdGrey => const MaterialColor(0xffababab, {
    50: Color.fromRGBO(171, 171, 171, .1),
    100: Color.fromRGBO(171, 171, 171, .2),
    200: Color.fromRGBO(171, 171, 171, .3),
    300: Color.fromRGBO(171, 171, 171, .4),
    400: Color.fromRGBO(171, 171, 171, .5),
    500: Color.fromRGBO(171, 171, 171, .6),
    600: Color.fromRGBO(171, 171, 171, .7),
    700: Color.fromRGBO(171, 171, 171, .8),
    800: Color.fromRGBO(171, 171, 171, .9),
    900: Color.fromRGBO(171, 171, 171, 1),
  });
  //
  static Color get statusBarColor => primarySwatch;
  static Color get colorIconsInputText => cdGrey;
  static Color get backButtonColor => primarySwatch;
  static Color get scaffoldBackgroundColor => Colors.white;
  static Color get iconsColor => Colors.white;
  //
  static Color get colorInputMethodNavigationGuard => Colors.black;
  static Color get colorSearchUrlTextNormal => const Color(0x7fa87f);
  static Color get colorSearchUrlTextPressed => Colors.black;
  static Color get colorSearchUrlTextSelected => Colors.black;
  // static Color get coloraccentMaterialDark=> Color@color/material_deep_teal_200;
  // static Color get coloraccentMaterialLight=> Color@color/material_deep_teal_500;
  static Color get colorBackgroundFloatingMaterialDark =>
      const Color(0xff424242);
  static Color get colorBackgroundFloatingMaterialLight =>
      const Color(0xffeeeeee);
  static Color get colorBackgroundMaterialDark => const Color(0xff303030);
  static Color get colorBackgroundMaterialLight => const Color(0xffeeeeee);
  static Color get colorBrightForegroundDisabledMaterialDark =>
      const Color(0x80ffffff);
  static Color get colorcolorbrightForegroundDisabledMaterialLight =>
      const Color(0x80000000);
  // static Color get colorbrightForeground_inverseMaterialDark=> Color@color/brightForegroundMaterialLight;
  // static Color get colorbrightForeground_inverseMaterialLight=> Color@color/brightForegroundMaterialDark;
  static Color get colorBrightForegroundMaterialDark => Colors.white;
  static Color get colorBrightForegroundMaterialLight => Colors.black;
  static Color get colorButtonMaterialDark => const Color(0xff5a595b);
  static Color get colorButtonMaterialLight => const Color(0xffd6d7d7);
  static Color get colorDimForegroundDisabledMaterialDark =>
      const Color(0x80bebebe);
  static Color get colorDimForegroundDisabledMaterialLight =>
      const Color(0x80323232);
  static Color get colorDimForegroundMaterialDark => const Color(0xffbebebe);
  static Color get colorDimForegroundMaterialLight => const Color(0xff323232);
  static Color get colorHighlightedTextMaterialDark => const Color(0x6680cbc4);
  static Color get colorHighlightedTextMaterialLight => const Color(0x66009688);
  // static Color get colorhintForegroundMaterialDark=> Color@color/brightForegroundDisabledMaterialDark;
  // static Color get colorhintForegroundMaterialLight=> Color@color/brightForegroundDisabledMaterialLight;
  // static Color get colorlinkTextMaterialDark=> Color@color/material_deep_teal_200;
  // static Color get colorlinkTextMaterialLight=> Color@color/material_deep_teal_500;
  static Color get colorMaterialBlueGrey_800 => const Color(0xff37474f);
  static Color get colorMaterialBlueGrey_900 => const Color(0xff263238);
  static Color get colorMaterialBlueGrey_950 => const Color(0xff21272b);
  static Color get colorMaterialDeepTeal_200 => const Color(0xff80cbc4);
  static Color get colorMaterialDeepTeal_500 => const Color(0xff009688);
  static Color get colorPrimaryDarkMaterialDark => const Color(0xff000000);
  static Color get colorPrimaryDarkMaterialLight => const Color(0xff757575);
  static Color get colorPrimaryMaterialDark => const Color(0xff212121);
  static Color get colorPrimaryMaterialLight => const Color(0xffefefef);
  static Color get colorPrimaryTextDefaultMaterialDark =>
      const Color(0xffffffff);
  static Color get colorPrimaryTextDefaultMaterialLight =>
      const Color(0xde000000);
  static Color get colorPrimaryTextDisabledMaterialDark =>
      const Color(0x4Dffffff);
  static Color get colorPrimaryTextDisabledMaterialLight =>
      const Color(0x39000000);
  static Color get colorRippleMaterialDark => const Color(0x4dffffff);
  static Color get colorRippleMaterialLight => const Color(0x1f000000);
  static Color get colorSecondaryTextDefaultMaterialDark =>
      const Color(0xb3ffffff);
  static Color get colorSecondaryTextDefaultMaterialLight =>
      const Color(0x8a000000);
  static Color get colorSecondaryTextDisabledMaterialDark =>
      const Color(0x36ffffff);
  static Color get colorSecondaryTextDisabledMaterialLight =>
      const Color(0x24000000);
  static Color get colorSwitchThumbDisabledMaterialDark =>
      const Color(0xff616161);
  static Color get colorSwitchThumbDisabledMaterialLight =>
      const Color(0xffbdbdbd);
  static Color get colorSwitchThumbNormalMaterialDark =>
      const Color(0xffbdbdbd);
  static Color get colorSwitchThumbNormalMaterialLight =>
      const Color(0xfff1f1f1);
  //end-colors
  //styles
  static ThemeData get themeDataLight {
    return ThemeData(
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
      buttonColor: colorButtonMaterialLight,
      backgroundColor: scaffoldBackgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
      ),
      snackBarTheme: SnackBarThemeData(
        actionTextColor: thirdColor,
        backgroundColor: primarySwatch,
      ),
      iconTheme: IconThemeData(
        color: iconsColor,
        size: 34,
      ),
      textTheme: TextTheme(
        bodyText1: const TextStyle(fontSize: 14),
        bodyText2: const TextStyle(fontSize: 14),
        button: const TextStyle(fontSize: 14),
        caption: const TextStyle(fontSize: 12),
        headline1: const TextStyle(fontSize: 24),
        subtitle1: const TextStyle(
          fontSize: 14,
          // fontFamily: 'Consola',
        ),
        subtitle2: const TextStyle(fontSize: 16), //toolbar
        overline: const TextStyle(fontSize: 16),

      ),
      dialogTheme: DialogTheme(),
    );
  }

  static InputDecoration textFormFieldDecoration({
    String labelText,
    String hintText,
    Icon prefixIconData,
    IconButton suffixIcon
  }) =>
      InputDecoration(labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIconData,
        suffixIcon: suffixIcon ,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black54)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
      );
}
