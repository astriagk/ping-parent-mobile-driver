import '../../config.dart';
import '../../models/chat_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode chatFocus = FocusNode();
  bool? homeChat;

  onReady() {
    chatList = appArray.chatList.map((e) => ChatModel.fromJson(e)).toList();
    notifyListeners();
  }

  bool isEmojiKeyboardVisible = false;

  void toggleEmojiKeyboard() {
    isEmojiKeyboardVisible = !isEmojiKeyboardVisible;
    if (isEmojiKeyboardVisible) {
      chatFocus.unfocus(); // Hide system keyboard
    } else {
      chatFocus.requestFocus(); // Show system keyboard
    }
    notifyListeners();
  }

  //send message
  setMessage() {
    if (controller.text.isNotEmpty) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      ChatModel messageModel =
          ChatModel(type: "source", message: controller.text);

      chatList.add(messageModel);
      controller.text = "";
      notifyListeners();
    }
  }
}
