import 'package:skolo_driver/config.dart';

class PopupItemRowCommon extends StatelessWidget {
  final dynamic data;
  final int? index;
  final List? list;
  final GestureTapCallback? onTap;
  const PopupItemRowCommon({super.key,this.index,this.data,this.list,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      SizedBox(
        width: Sizes.s90,
        child: Text(language(context, data),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppCss.lexendMedium12.textColor(appColor(context).appTheme.darkText))
      ),
      if(index != list!.length - 1)
        Divider(height: 1,color: appColor(context).appTheme.stroke, thickness: 1)
            .paddingOnly(top: Insets.i15, bottom: Insets.i15)
    ]).inkWell(onTap: onTap);
  }
}
