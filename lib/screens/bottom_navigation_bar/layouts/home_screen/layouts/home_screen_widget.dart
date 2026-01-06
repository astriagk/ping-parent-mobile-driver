import '../../../../../config.dart';

class HomeScreenWidget {
  dottedLineCommon({double vertical = 0, dashColor}) {
    return DottedLine(
            dashLength: 4.0,
            dashColor: dashColor ?? appTheme.stroke,
            lineThickness: 2.0,
            dashGapLength: 4.0)
        .marginSymmetric(vertical: vertical);
  }
}
