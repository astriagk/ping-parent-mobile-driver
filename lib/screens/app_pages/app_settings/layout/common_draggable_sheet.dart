import '../../../../config.dart';
import '../app_setting_widget.dart';

//COMMON DraggableSheet layout
class CommonDraggableSheet {
  settingModelLayout(context, {int? index, List? arrayList, bool? isSvg}) {
    return showModalBottomSheet(
        useRootNavigator: false,
        isScrollControlled: true,
        context: context,
        builder: (_) => DraggableScrollableSheet(
            expand: false,
            snap: true,
            builder: (_, controller) => Consumer<SettingProvider>(
                    builder: (context, settingCtrl, child) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Container(
                        decoration: ShapeDecoration(
                            shape: SmoothRectangleBorder(
                                borderRadius: SmoothBorderRadius.only(
                                    topLeft: SmoothRadius(
                                        cornerRadius: AppRadius.r20,
                                        cornerSmoothing: 1),
                                    topRight: SmoothRadius(
                                        cornerRadius: AppRadius.r20,
                                        cornerSmoothing: 0.4))),
                            color: appColor(context).appTheme.trans),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                              //draggable title layout
                              AppSettingScreenWidget()
                                  .draggableTitleLayout(context, index),
                              VSpace(Sizes.s20),
                              ...arrayList!.asMap().entries.map((e) {
                                return Column(children: [
                                  //draggable list title and icon layout
                                  AppSettingScreenWidget()
                                      .draggableListTitleIconLayout(
                                          e, isSvg, index, context, setState),
                                  if (e.key != arrayList.length - 1)
                                    Divider(
                                        color:
                                            appColor(context).appTheme.stroke,
                                        height: 0)
                                ]);
                              }),
                              CommonButton(
                                  text: language(context, appFonts.update),
                                  onTap: () {
                                    settingCtrl.commonModelUpdateOnTap(
                                        index, context);
                                    route.pop(context);
                                  })
                            ]))).paddingDirectional(all: Sizes.s20);
                  });
                })));
  }
}
