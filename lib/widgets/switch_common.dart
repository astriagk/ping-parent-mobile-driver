import 'package:flutter/cupertino.dart';

import '../config.dart';

//common switch layout
class SwitchCommon extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool>? onToggle;

  const SwitchCommon({super.key, this.value, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Transform.scale(
          scale: .7,
          child: CupertinoSwitch(
              autofocus: true,
              // activeTrackColor: appColor(context).appTheme.primary,
              // trackColor: MaterialStatePropertyAll(
              //     appColor(context).appTheme.gray.withValues(alpha:0.4)),
              activeColor: appColor(context).appTheme.primary,
              // inactiveThumbColor: appColor(context).appTheme.gray,
              value: value!,
              onChanged: onToggle)),
    );
  }
}
