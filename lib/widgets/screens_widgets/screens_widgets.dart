import '../../config.dart';

class ScreensWidgets {
  ratingCounting(rating, userRating) {
    return Row(children: [
      SvgPicture.asset(svgAssets.star),
      HSpace(Insets.i4),
      RichText(
          text: TextSpan(children: [
        TextSpan(
            text: rating.toString(),
            style: AppCss.lexendRegular12.textColor(appTheme.primary)),
        TextSpan(
            text: ' (${userRating.toString()})',
            style: AppCss.lexendRegular12.textColor(appTheme.textClr))
      ]))
    ]);
  }

  priceText(price,
      {topMargin = 0.0,
      leftMargin = 0.0,
      rightMargin = 0.0,
      bottomMargin = 0.0}) {
    return Text('\$$price',
            style: AppCss.lexendRegular16.textColor(appTheme.priceClr))
        .marginOnly(
            top: topMargin,
            left: leftMargin,
            right: rightMargin,
            bottom: bottomMargin);
  }

  userName(userName, {style}) {
    return Text(userName,
        style: style ?? AppCss.lexendRegular13.textColor(appTheme.primary));
  }

  userProfileImage() {
    return Container(
        height: Insets.i50,
        width: Insets.i50,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: appTheme.borderColor),
            borderRadius: BorderRadius.all(Radius.circular(Insets.i7)),
            image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/image/home/user1.png'))));
  }

  customToggle({required onToggle, isToggled}) {
    return GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: Insets.i32,
            height: Insets.i20,
            decoration: BoxDecoration(
                border:
                    Border.all(color: appTheme.borderColor, width: Insets.i1),
                borderRadius: BorderRadius.circular(AppRadius.r50),
                color: isToggled ? Colors.black : Colors.white),
            child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment:
                    isToggled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.all(Insets.i3),
                    width: Insets.i12,
                    height: Insets.i12,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isToggled ? appTheme.white : appTheme.primary)))));
  }
}
