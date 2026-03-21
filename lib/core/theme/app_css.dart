import 'package:skolo_driver/config.dart';

part 'scale.dart';

class AppCss {
  //Outfit font
  static TextStyle lexend = TextStyle(
      fontFamily: GoogleFonts.lexend().fontFamily, letterSpacing: 0, height: 1);

//Text Style lexend extra bold
  static TextStyle get lexendExtraBold65 =>
      lexend.extraThickBold.size(FontSizes.f65);

  static TextStyle get lexendExtraBold60 =>
      lexend.extraThickBold.size(FontSizes.f60);

  static TextStyle get lexendExtraBold40 =>
      lexend.extraThickBold.size(FontSizes.f40);

  static TextStyle get lexendExtraBold30 =>
      lexend.extraThickBold.size(FontSizes.f30);

  //Text Style lexend black 900
  static TextStyle get lexendBlack28 => lexend.black.size(FontSizes.f28);

  static TextStyle get lexendBlack22 => lexend.black.size(FontSizes.f22);

  static TextStyle get lexendBlack24 => lexend.black.size(FontSizes.f24);

  static TextStyle get lexendBlack20 => lexend.black.size(FontSizes.f20);

  static TextStyle get lexendBlack18 => lexend.black.size(FontSizes.f18);

  static TextStyle get lexendBlack16 => lexend.black.size(FontSizes.f16);

  static TextStyle get lexendBlack14 => lexend.black.size(FontSizes.f14);

  //Text Style lexend extra bold 800
  static TextStyle get lexendExtraBold22 =>
      lexend.extraBold.size(FontSizes.f22);

  static TextStyle get lexendExtraBold20 =>
      lexend.extraBold.size(FontSizes.f20);

  static TextStyle get lexendExtraBold18 =>
      lexend.extraBold.size(FontSizes.f18);

  static TextStyle get lexendExtraBold16 =>
      lexend.extraBold.size(FontSizes.f16);

  static TextStyle get lexendExtraBold14 =>
      lexend.extraBold.size(FontSizes.f14);

  static TextStyle get lexendExtraBold12 =>
      lexend.extraBold.size(FontSizes.f12);

  //Text Style semi lexend bold 700
  static TextStyle get lexendBold50 => lexend.bold.size(FontSizes.f50);

  static TextStyle get lexendBold35 => lexend.bold.size(FontSizes.f35);

  static TextStyle get lexendBold30 => lexend.bold.size(FontSizes.f30);

  static TextStyle get lexendBold24 => lexend.bold.size(FontSizes.f24);

  static TextStyle get lexendBold20 => lexend.bold.size(FontSizes.f20);

  static TextStyle get lexendBold18 => lexend.bold.size(FontSizes.f18);

  static TextStyle get lexendBold16 => lexend.bold.size(FontSizes.f16);

  static TextStyle get lexendBold17 => lexend.bold.size(FontSizes.f17);

  static TextStyle get lexendBold14 => lexend.bold.size(FontSizes.f14);

  static TextStyle get lexendBold12 => lexend.bold.size(FontSizes.f12);

  static TextStyle get lexendBold10 => lexend.bold.size(FontSizes.f10);

  //600
  static TextStyle get lexendSemiBold24 => lexend.semiBold.size(FontSizes.f24);

  static TextStyle get lexendSemiBold22 => lexend.semiBold.size(FontSizes.f22);

  static TextStyle get lexendSemiBold20 => lexend.semiBold.size(FontSizes.f20);

  static TextStyle get lexendSemiBold18 => lexend.semiBold.size(FontSizes.f18);

  static TextStyle get lexendSemiBold16 => lexend.semiBold.size(FontSizes.f16);

  static TextStyle get lexendSemiBold17 => lexend.semiBold.size(FontSizes.f17);

  static TextStyle get lexendSemiBold15 => lexend.semiBold.size(FontSizes.f15);

  static TextStyle get lexendSemiBold14 => lexend.semiBold.size(FontSizes.f14);

  static TextStyle get lexendSemiBold12 => lexend.semiBold.size(FontSizes.f12);

  static TextStyle get lexendSemiBold10 => lexend.semiBold.size(FontSizes.f10);

  static TextStyle get lexendSemiBold40 => lexend.semiBold.size(FontSizes.f40);

  //Text Style lexend medium 500
  static TextStyle get lexendMedium28 => lexend.medium.size(FontSizes.f28);

  static TextStyle get lexendMedium22 => lexend.medium.size(FontSizes.f22);

  static TextStyle get lexendMedium20 => lexend.medium.size(FontSizes.f20);

  static TextStyle get lexendMedium18 => lexend.medium.size(FontSizes.f18);

  static TextStyle get lexendMedium17 => lexend.medium.size(FontSizes.f17);

  static TextStyle get lexendMedium16 => lexend.medium.size(FontSizes.f16);

  static TextStyle get lexendMedium14 => lexend.medium.size(FontSizes.f14);

  static TextStyle get lexendMedium15 => lexend.medium.size(FontSizes.f15);

  static TextStyle get lexendMedium12 => lexend.medium.size(FontSizes.f12);

  static TextStyle get lexendMedium13 => lexend.medium.size(FontSizes.f13);

  static TextStyle get lexendMedium10 => lexend.medium.size(FontSizes.f10);

  static TextStyle get lexendMedium9 => lexend.medium.size(FontSizes.f10);

  //Text Style lexend regular 400
  static TextStyle get lexendRegular18 => lexend.regular.size(FontSizes.f18);

  static TextStyle get lexendRegular16 => lexend.regular.size(FontSizes.f16);

  static TextStyle get lexendRegular15 => lexend.regular.size(FontSizes.f15);

  static TextStyle get lexendRegular14 => lexend.regular.size(FontSizes.f14);

  static TextStyle get lexendRegular13 => lexend.regular.size(FontSizes.f13);

  static TextStyle get lexendRegular12 => lexend.regular.size(FontSizes.f12);

  static TextStyle get lexendRegular11 => lexend.regular.size(FontSizes.f11);

  //300
  static TextStyle get lexendLight15 => lexend.light.size(FontSizes.f15);

  static TextStyle get lexendLight16 => lexend.light.size(FontSizes.f16);

  static TextStyle get lexendLight14 => lexend.light.size(FontSizes.f14);

  static TextStyle get lexendLight13 => lexend.light.size(FontSizes.f13);

  static TextStyle get lexendLight12 => lexend.light.size(FontSizes.f12);

  static TextStyle get lexendLight11 => lexend.light.size(FontSizes.f11);

  //200
  static TextStyle get lexendExtraLight14 =>
      lexend.extraLight.size(FontSizes.f14);

  static TextStyle get lexendExtraLight12 =>
      lexend.extraLight.size(FontSizes.f12);

  static TextStyle get lexendExtraLight11 =>
      lexend.extraLight.size(FontSizes.f11);
}
