import 'package:flutter/material.dart';
import 'package:front/component/snack_bar.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../responsive.dart';
import '../../service/chat_service.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  int index = 0;
  bool isStart = true;

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() async {
    await Future.delayed(Duration(milliseconds: 500)); // 0.5초 지연
    setState(() {
      _messages.add({'text': '안녕하세요!', 'isUser': false});
    });

    await Future.delayed(Duration(milliseconds: 1000)); // 0.5초 추가 지연
    setState(() {
      _messages.add({'text': '저는 당신만의 여행 플래너 TripFlow의 "립플"입니다😄\n당신이 생각한 여행일정을 공유해주세요!', 'isUser': false});
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'text': text, 'isUser': true});
        _controller.clear();
      });

      try {
        final conversationResult = await ChatService.getChatConversation(text);
        if(conversationResult.isSuccess && conversationResult.value?.status==200) {
          if(conversationResult.value?.data.travelSchedule == "생성된 일정이 아직 없습니다.") { //일정 생성 전
            setState(() {
              _messages.add({'text': conversationResult.value?.data.chatbotMessage, 'isUser': false}); // 서버 응답 추가
            });
          }
          else { //일정 생성 완료
            setState(() {
              _messages.add({'text': conversationResult.value?.data.travelSchedule, 'isUser': false});
              _messages.add({'text': conversationResult.value?.data.chatbotMessage, 'isUser': false});
              _messages.add({'text': "의견을 작성해주세요!", 'isUser': false});
            });

            // final opinionResult = await ChatService.sendUserResponse(text);
            // if(opinionResult.value) {
            //
            // }

          }
        }
        else {
          setState(() {
            _messages.add({'text': '응답을 불러올 수 없습니다. 다시 시도해주세요.', 'isUser': false}); // 서버 응답 추가
          });
        }
      } catch (e) {
        print(e);
        showCustomSnackBar(context, "에러가 발생하였습니다. 다시 시도해주세요.");
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
          } else {
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
              ));
        });
  }

  Widget _buildChatBubble({
    required Alignment alignment,
    required Color? color,
    required String text,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 2 / 3, // 화면 가로 길이의 2/3까지만 차지
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
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
