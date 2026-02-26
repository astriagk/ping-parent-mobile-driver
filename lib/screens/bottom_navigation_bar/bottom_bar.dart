import 'package:skolo_driver/config.dart';
import 'package:skolo_driver/screens/bottom_navigation_bar/layouts/common_app_bar.dart';
import 'package:flutter/services.dart';

class CommonBottomNavigationBar extends StatefulWidget {
  const CommonBottomNavigationBar({super.key});

  @override
  State<CommonBottomNavigationBar> createState() =>
      _CommonBottomNavigationBarState();
}

class _CommonBottomNavigationBarState extends State<CommonBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, bottomCtrl, child) {
      return StatefulWrapper(
          onInit: () {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              bottomCtrl.onInit();
              final userDetailsPvr = context.read<UserDetailsUpdateProvider>();
              await userDetailsPvr.fetchAndPopulateProfile();
              bottomCtrl.setAvailability(userDetailsPvr.isAvailable);
            });
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: appTheme.screenBg,
              extendBody: true,
              bottomNavigationBar:
                  _buildBottomNavigationBar(context, bottomCtrl),
              appBar: DashAppBar(index: bottomCtrl.currentTab),
              body: SafeArea(
                  child: IndexedStack(
                      index: bottomCtrl.currentTab,
                      children: bottomCtrl.screens))));
    });
  }

  Widget _buildBottomNavigationBar(
      BuildContext context, BottomBarProvider bottomCtrl) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: appTheme.primary.withValues(alpha: 0.03),
                    blurRadius: 20,
                    spreadRadius: 7)
              ],
              borderRadius: BorderRadius.circular(20),
              border: Border(
                  top: BorderSide(color: appTheme.borderColor, width: 1))),
          child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: BottomAppBar(
                  shadowColor: appTheme.primary,
                  color: appTheme.primary,
                  height: 70,
                  elevation: 50,
                  child: _buildNavItems(context, bottomCtrl)))),
    );
  }

  Widget _buildNavItems(BuildContext context, BottomBarProvider bottomCtrl) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            bottomCtrl.bottomNavigationBarList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = bottomCtrl.currentTab == index;

          return InkWell(
              onTap: () => bottomCtrl.tabChange(index),
              radius: 10,
              focusColor: appTheme.trans,
              highlightColor: appTheme.trans,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        isSelected
                            ? (item['iconDark'] ?? '')
                            : (item['icon'] ?? ''),
                        width: 24,
                        height: 24),
                    const SizedBox(height: 2),
                    Text(language(context, item['title'] ?? ''),
                        style: isSelected
                            ? AppCss.lexendLight14.textColor(appTheme.white)
                            : AppCss.lexendMedium14
                                .textColor(appTheme.lightText),
                        overflow: TextOverflow.ellipsis)
                  ]));
        }).toList());
  }
}
