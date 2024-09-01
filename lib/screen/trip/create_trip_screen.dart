import 'package:flutter/material.dart';
import 'package:front/component/dialog/detail_trip_for_chat_not_response_dialog.dart';
import 'package:front/component/mypage/my_menu.dart';
import 'package:front/component/snack_bar.dart';
import 'package:front/key/key.dart';
import '../../component/dialog/detail_trip_for_chat_dialog.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../responsive.dart';
import '../../service/chat_service.dart';
import 'dart:async';

//2 타이핑 형식
class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypingText({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 30),
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  late String _displayedText;
  late Timer _timer;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayedText = '';
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (_charIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_charIndex];
          _charIndex++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: widget.style,
    );
  }
}

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool showMoreButton = false;
  bool getResponseOfTripSchedule = false;
  List<dynamic> scheduleInfo = [];
  String explanation = "";

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _messages.add({'text': '안녕하세요!', 'isUser': false});
    });

    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _messages.add({'text': '저는 당신만의 여행 플래너 TripFlow의 "립플"입니다😄\n당신이 생각한 여행일정을 공유해주세요!', 'isUser': false});
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if(!getResponseOfTripSchedule) {
      if (text.isNotEmpty) {
        setState(() {
          _messages.add({'text': text, 'isUser': true});
          _controller.clear();
        });
        _scrollToBottom();

        try {
          final conversationResult = await ChatService.getChatConversation(text);

          if (conversationResult.isSuccess && conversationResult.value?.status == 200) {
            if (conversationResult.value!.data.travelSchedule.is_valid == 0) { //일정 생성 전
              setState(() {
                _messages.add({'text': conversationResult.value?.data.travelSchedule!.response, 'isUser': false});
              });
            } else {
              setState(() {
                _messages.add({'text': '다음은 추천된 일정입니다!', 'isUser': false});
              });
              _scrollToBottom();

              scheduleInfo = conversationResult.value!.data.travelSchedule.scheduler!;
              explanation = conversationResult.value!.data.travelSchedule.explain!;

              print("================scheduleInfo================");
              print(conversationResult.value?.data.travelSchedule.scheduler);
              print(scheduleInfo);
              print("============================================");

              await Future.delayed(const Duration(milliseconds: 1000));
              setState(() {
                _messages.add({'text': conversationResult.value?.data.travelSchedule.explain, 'isUser': false, 'isMore': true});
              });

              await Future.delayed(const Duration(milliseconds: 5000));
              setState(() {
                _messages.add({'text': "${conversationResult.value!.data.chatbotMessage}\n의견을 작성해주세요~😄", 'isUser': false});
                showMoreButton = true;
                getResponseOfTripSchedule = true;
              });
              _scrollToBottom();
            }
          } else {
            setState(() {
              _messages.add({'text': '응답을 불러올 수 없습니다. 다시 시도해주세요.', 'isUser': false});
            });
          }
        } catch (e) {
          showCustomSnackBar(context, "에러가 발생하였습니다. 다시 시도해주세요.");
        }

        _scrollToBottom();
      }
    }
    else{
      if (text.isNotEmpty) {
        setState(() {
          _messages.add({'text': text, 'isUser': true});
          _controller.clear();
        });

        _scrollToBottom();

        try {
          final sendResponseResult = await ChatService.sendUserResponse(text);
          if (sendResponseResult.isSuccess && sendResponseResult.value?.status == 200 && sendResponseResult.value?.message?.toUpperCase()=="GOOD") {
            setState(() {
              _messages.add({'text': '의견 감사합니다!!!\n마음에 들어하신 일정이 저장되었습니다! 마이페이지에서 확인 가능합니다.', 'isUser': false});
            });
            await Future.delayed(const Duration(milliseconds: 6000));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyMenuScreen()),
            );
            getResponseOfTripSchedule = true;
          }
          else if (sendResponseResult.isSuccess && sendResponseResult.value?.status == 200 && sendResponseResult.value?.message?.toUpperCase()=="OTHER"){
            //이어서 정보 받기
            setState(() {
              _messages.add({'text': '일정을 다시 생성합니다~ 잠시만 기다려주세요!', 'isUser': false});
            });
          }
          else if (sendResponseResult.isSuccess && sendResponseResult.value?.status == 200 && sendResponseResult.value?.message?.toUpperCase()=="AGAIN"){
            //아예 처음 부터 입력
            //날짜 유지
            setState(() {
              _messages.add({'text': '지금까지 입력하신 정보가 초기화됩니다! 다시 여행 일정을 공유해주세요!', 'isUser': false});
            });
          }
          else {
            setState(() {
              _messages.add({'text': '전송에 실패하였습니다.. 다시 시도해주세요.', 'isUser': false});
            });
          }
        } catch (e) {
          print(e);
          showCustomSnackBar(context, "에러가 발생하였습니다. 다시 시도해주세요.");
        }

        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String formatTravelSchedule(Map<String, dynamic> schedule) {
    final buffer = StringBuffer();

    final firstDay = schedule.keys.first;
    final activities = schedule[firstDay];

    buffer.writeln('Day $firstDay');

    void extractNames(String category, dynamic activity) {
      if (activity is List) {
        if (activity.isEmpty) return;

        if (activity[0] is List) {
          buffer.writeln('($category)');
          for (var item in activity) {
            if (item is List && item.isNotEmpty) {
              buffer.writeln(item[0]);
            }
          }
        } else {
          buffer.writeln('($category)');
          for (var item in activity) {
            if (item is List && item.isNotEmpty) {
              buffer.writeln(item[0]);
            } else if (item is String) {
              buffer.writeln(item);
            }
          }
        }
      } else if (activity is String) {
        buffer.writeln('($category)');
        buffer.writeln(activity);
      }
    }

    if (activities is Map<String, dynamic>) {
      extractNames('breakfast', activities['breakfast']);
      extractNames('lunch', activities['lunch']);
      extractNames('dinner', activities['dinner']);
      extractNames('tourist_spots', activities['tourist_spots']);
      extractNames('hotel', activities['hotel']);
    }

    return buffer.toString();
  }

  void _showTripDetailDialog() {
    print("다이어로그가 시작되었습니다.");
    showDetailTripForChatNotResponseDialog(context, GOOGLE_MAP_KEY, scheduleInfo, explanation);
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
                    controller: _scrollController,
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
                        isMore: message['isMore'] ?? false,
                        onMorePressed: showMoreButton
                            ? _showTripDetailDialog
                            : null,
                      );
                    },
                  ),
                ),
                _buildInputArea(),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildChatBubble({
    required Alignment alignment,
    required Color? color,
    required String text,
    bool isMore = false,
    VoidCallback? onMorePressed,
  }) {

    double maxWidth = MediaQuery.of(context).size.width * 3 / 5;
    String truncatedText = _truncateTextToThreeLines(text);

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypingText(
              text: truncatedText,
              style: const TextStyle(fontSize: 18),
              duration: const Duration(milliseconds: 50), // 타이핑 속도 조절
            ),
            if (isMore)
              TextButton(
                onPressed: onMorePressed,
                child: const Text(
                  '더보기',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _truncateTextToThreeLines(String text) {
    return text.length > 100 ? '${text.substring(0, 100)}...' : text;
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
              onSubmitted: (value) => _sendMessage(),
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