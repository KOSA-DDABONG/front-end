import 'package:flutter/material.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../dto/chat/create_trip_request_model.dart';
import '../../responsive.dart';
import '../../service/chat_service.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'text': text, 'isUser': true}); // 사용자 메시지 추가
      });

      try {
        final model = CreateTripRequestModel(question: text);
        print("@@@");
        print(model.question);
        print("@@@");
        final result = await ChatService.getResponseForCreateSchedule(model);
        print("@@@");
        print(result.value);
        print("@@@");
        setState(() {
          _messages.add({'text': result.value.toString(), 'isUser': false}); // 서버 응답 추가
        });
        _controller.clear();
      } catch(e) {
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return CheckLoginStateWidget(
        builder: (context, isLoggedIn) {
          PreferredSizeWidget currentAppBar;
          Widget? currentDrawer;
          if (isLoggedIn) {
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? AfterLoginHeaderDrawer()
                : null;
          }
          else {
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : NotLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? NotLoginHeaderDrawer()
                : null;
          }

          return Scaffold(
              appBar: currentAppBar,
              drawer: currentDrawer,
              body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return _buildChatBubble(
                            alignment: message['isUser']
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            color: message['isUser']
                                ? Colors.blue[100]
                                : Colors.grey[200],
                            text: message['text'],
                          );
                        },
                      ),
                    ),
                    _buildInputArea(),
                  ],
                ),
              )
          );
        }
    );
  }

  Widget _buildChatBubble({
    required Alignment alignment,
    required Color? color,
    required String text,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '메세지를 입력하세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
