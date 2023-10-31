import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hashtags_app/chat_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  var text = '';

  final List<ChatMessage> message = [];
  final chatGpt =
      ChatGpt(apiKey: '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');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'ASK MEE',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff343541),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    // physics: const BouncingScrollPhysics(),
                    // controller: scrollController,
                    shrinkWrap: true,
                    itemCount: message.length,
                    itemBuilder: (context, index) {
                      var chat = message[index];

                      return chatBubble(
                        chatText: chat.text,
                        type: chat.type,
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xff00A67E),
                    ),
                    onPressed: () async {
                      setState(() {
                        text = _controller.text;
                        loading = true;
                      });

                      message.add(
                          ChatMessage(text: text, type: ChatMessageType.user));

                      final testRequest = CompletionRequest(
                        prompt: text,
                        model: ChatGptModel.textDavinci003.key,
                      );
                      final msg = await chatGpt.createCompletion(testRequest);

                      // var msg = await ApiServices.sendMessage(text);
                      setState(() {
                        loading = false;
                        message.add(
                            ChatMessage(text: msg, type: ChatMessageType.bot));
                      });

                      _controller.clear();
                    },
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff00A67E)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff00A67E)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                ),
              ),
            ),
            Text(
              'Develop By Waris Waheed'.toUpperCase(),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble(
      {required String? chatText, required ChatMessageType? type}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xff00A67E),
            child: Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "$chatText",
                style: const TextStyle(
                  color: Color(0xff343541),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
