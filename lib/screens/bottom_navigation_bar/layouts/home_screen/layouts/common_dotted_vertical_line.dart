import '../../../../../config.dart';

class DottedVerticalLine extends StatelessWidget {
  final int? index;

  const DottedVerticalLine({super.key, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            index!,
            (index) => Container(
                width: Insets.i1,
                height: Insets.i4,
                color: index % 2 == 0 ? appTheme.textClr : appTheme.trans)));
  }
}
