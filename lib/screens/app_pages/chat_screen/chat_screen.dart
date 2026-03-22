import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji_picker;
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';
import 'package:skolo_driver/core/utils/stateful_wrapper.dart';

import '../../../config.dart';
import 'layout/chat_appbar_layout.dart';
import 'layout/chat_layout.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatCtrl, child) {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('hh:mm a').format(now);
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 100), () => chatCtrl.onReady()),
          child: Scaffold(
              body: Column(children: [
            ChatAppBarLayout(
                onTap: () => chatCtrl.chatList.removeAt,
                isSvg: chatCtrl.homeChat != true,
                title: chatCtrl.homeChat == true
                    ? appFonts.templetonPeck
                    : appFonts.chatSupport),
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: chatCtrl.scrollController,
                    itemCount: chatCtrl.chatList.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Center(
                                child: Text("Today $formattedTime",
                                    style: AppCss.lexendMedium14
                                        .textColor(appTheme.hintText))));
                      }

                      if (index == chatCtrl.chatList.length + 1) {
                        return Container(height: Sizes.s20);
                      }

                      final message = chatCtrl.chatList[index - 1];

                      return ChatLayout(
                          isHomeChat: chatCtrl.homeChat == true,
                          title: message.message,
                          isSentByMe: message.type == "source");
                    }).alignment(Alignment.bottomCenter)),
            Row(children: [
              Expanded(
                  child: ChatTextFieldCommon(
                      prefixTap: () => chatCtrl.toggleEmojiKeyboard(),
                      controller: chatCtrl.controller,
                      focusNode: chatCtrl.chatFocus,
                      hintText: appFonts.typeHere,
                      hintStyle:
                          AppCss.lexendRegular14.textColor(appTheme.hintText),
                      prefixIcon: svgAssets.emoji,
                      suffixIcon: SvgPicture.asset(svgAssets.microphone,
                          height: Sizes.s15,
                          width: Sizes.s15,
                          fit: BoxFit.scaleDown))),
              HSpace(Sizes.s8),
              SvgPicture.asset(svgAssets.send)
                  .paddingAll(Insets.i8)
                  .decorated(
                      color: appColor(context).appTheme.primary,
                      allRadius: Sizes.s6)
                  .inkWell(onTap: () => chatCtrl.setMessage())
            ])
                .paddingOnly(right: Insets.i5)
                .boxBorderExtension(context, isShadow: true)
                .padding(horizontal: Insets.i20, bottom: Insets.i20),
            if (chatCtrl.isEmojiKeyboardVisible)
              SizedBox(
                  height: Insets.i250,
                  child: emoji_picker.EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        chatCtrl.controller.text += emoji.emoji;
                      },
                      config: emoji_picker.Config(
                          height: 256,
                          checkPlatformCompatibility: true,
                          emojiViewConfig: emoji_picker.EmojiViewConfig(
                              emojiSizeMax: 28 *
                                  (foundation.defaultTargetPlatform ==
                                          TargetPlatform.iOS
                                      ? 1.20
                                      : 1.0)),
                          viewOrderConfig: const emoji_picker.ViewOrderConfig(
                              top: emoji_picker.EmojiPickerItem.categoryBar,
                              middle: emoji_picker.EmojiPickerItem.emojiView,
                              bottom: emoji_picker.EmojiPickerItem.searchBar),
                          categoryViewConfig:
                              const emoji_picker.CategoryViewConfig(),
                          bottomActionBarConfig:
                              const emoji_picker.BottomActionBarConfig(),
                          searchViewConfig:
                              const emoji_picker.SearchViewConfig())))
          ])));
    });
  }
}
