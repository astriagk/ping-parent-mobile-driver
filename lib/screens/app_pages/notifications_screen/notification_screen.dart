import '../../../config.dart';
import 'notification_widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor(context).appTheme.screenBg,
        body: Consumer<NotificationProvider>(
            builder: (context, notificationCtrl, child) {
          return StatefulWrapper(
              onInit: () => Future.delayed(DurationClass.ms150)
                  .then((value) => notificationCtrl.init()),
              child: Column(children: [
                Row(children: [
                  HSpace(Sizes.s20),
                  CommonIconButton(
                      icon: svgAssets.back,
                      bgColor: appColor(context).appTheme.bgBox,
                      onTap: () => route.pop(context)),
                  HSpace(Sizes.s70),
                  TextWidgetCommon(
                      text: appFonts.notification,
                      style: AppCss.lexendMedium18
                          .textColor(appColor(context).appTheme.primary))
                ]).padding(top: Sizes.s50, bottom: Sizes.s20),
                ...notificationCtrl.notification.map((e) => Row(children: [
                      // title and subtitle layout
                      NotificationWidgets().titleSubtitle(e, context),
                      HSpace(Sizes.s6),
                      //notification icon layout
                      NotificationWidgets().iconLayout(e, context)
                    ])
                        .padding(vertical: Sizes.s15, horizontal: Sizes.s15)
                        .width(MediaQuery.of(context).size.width)
                        .notificationExtension(context, e)
                        .padding(bottom: Sizes.s15, horizontal: Sizes.s15))
              ]));
        }));
  }
}
