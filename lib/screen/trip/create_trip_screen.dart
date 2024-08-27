import 'package:flutter/material.dart';
import 'package:front/component/snack_bar.dart';
import 'package:front/key/key.dart';
import '../../component/dialog/detail_trip_for_chat_dialog.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../dto/chat/chat_data_model.dart';
import '../../responsive.dart';
import '../../service/chat_service.dart';
import 'dart:async';


//1 Origin
// class CreateTripScreen extends StatefulWidget {
//   @override
//   _CreateTripScreenState createState() => _CreateTripScreenState();
// }
//
// class _CreateTripScreenState extends State<CreateTripScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController(); // ScrollController 추가
//   final List<Map<String, dynamic>> _messages = [];
//   bool showMoreButton = false;
//   Map<String, dynamic> travelScheduleMap = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMessages();
//   }
//
//   void _initializeMessages() async {
//     await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 지연
//     setState(() {
//       _messages.add({'text': '안녕하세요!', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 1000)); // 1초 추가 지연
//     setState(() {
//       _messages.add({'text': '저는 당신만의 여행 플래너 TripFlow의 "립플"입니다😄\n당신이 생각한 여행일정을 공유해주세요!', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         _messages.add({'text': text, 'isUser': true});
//         _controller.clear();
//       });
//
//       _scrollToBottom(); // 메시지 추가 후 스크롤
//
//       try {
//         final conversationResult = await ChatService.getChatConversation(text);
//         if (conversationResult.isSuccess && conversationResult.value?.status == 200) {
//           if (conversationResult.value?.message == "Please Request Next User Input") { // 일정 생성 전
//             setState(() {
//               _messages.add({'text': conversationResult.value?.data.chatbotMessage, 'isUser': false});
//             });
//           } else { // 일정 생성 완료
//             travelScheduleMap = parseTravelSchedule(conversationResult.value!.data.travelSchedule);
//             final travelScheduleString = formatTravelSchedule(travelScheduleMap);
//
//             setState(() {
//               _messages.add({'text': '생성된 일정:', 'isUser': false});
//               _messages.add({'text': travelScheduleString, 'isUser': false, 'isMore': true});
//               _messages.add({'text': "${conversationResult.value!.data.chatbotMessage}\n의견을 작성해주세요~😄", 'isUser': false});
//               showMoreButton = true; // 더보기 버튼 표시
//             });
//           }
//         } else {
//           setState(() {
//             _messages.add({'text': '응답을 불러올 수 없습니다. 다시 시도해주세요.', 'isUser': false});
//           });
//         }
//       } catch (e) {
//         print(e);
//         showCustomSnackBar(context, "에러가 발생하였습니다. 다시 시도해주세요.");
//       }
//
//       _scrollToBottom(); // 메시지 추가 후 스크롤
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   String formatTravelSchedule(Map<String, dynamic> schedule) {
//     final buffer = StringBuffer();
//
//     // 첫 번째 날의 일정만 표시
//     final firstDay = schedule.keys.first;
//     final activities = schedule[firstDay];
//
//     buffer.writeln('Day $firstDay');
//
//     // Helper 함수: 리스트나 맵에서 이름 추출
//     void extractNames(String category, dynamic activity) {
//       if (activity is List) {
//         if (activity.isEmpty) return;
//
//         // Check if activity is a list of lists
//         if (activity[0] is List) {
//           buffer.writeln('($category)');
//           for (var item in activity) {
//             if (item is List && item.isNotEmpty) {
//               // 첫 번째 항목이 장소 이름이라고 가정
//               buffer.writeln(item[0]);
//             }
//           }
//         } else {
//           // 단일 리스트일 경우
//           buffer.writeln('($category)');
//           for (var item in activity) {
//             if (item is List && item.isNotEmpty) {
//               // 첫 번째 항목이 장소 이름이라고 가정
//               buffer.writeln(item[0]);
//             } else if (item is String) {
//               // 문자열일 경우 직접 출력
//               buffer.writeln(item);
//             }
//           }
//         }
//       } else if (activity is String) {
//         buffer.writeln('($category)');
//         buffer.writeln(activity); // 장소 이름만 출력
//       }
//     }
//
//     // Extracting names for specific activities
//     if (activities is Map<String, dynamic>) {
//       extractNames('breakfast', activities['breakfast']);
//       extractNames('lunch', activities['lunch']);
//       extractNames('dinner', activities['dinner']);
//       extractNames('tourist_spots', activities['tourist_spots']);
//       extractNames('hotel', activities['hotel']);
//     }
//
//     return buffer.toString();
//   }
//
//   void _showTripDetailDialog() {
//     showDetailTripForChatDialog(context, GOOGLE_MAP_KEY, travelScheduleMap); // travelScheduleMap 전달
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CheckLoginStateWidget(
//         builder: (context, isLoggedIn) {
//           PreferredSizeWidget currentAppBar;
//           Widget? currentDrawer;
//           if (isLoggedIn) {
//             currentAppBar = Responsive.isNarrowWidth(context)
//                 ? ShortHeader(automaticallyImplyLeading: false)
//                 : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
//             currentDrawer = Responsive.isNarrowWidth(context)
//                 ? AfterLoginHeaderDrawer()
//                 : null;
//           } else {
//             currentAppBar = Responsive.isNarrowWidth(context)
//                 ? ShortHeader(automaticallyImplyLeading: false)
//                 : NotLoginHeader(automaticallyImplyLeading: false, context: context);
//             currentDrawer = Responsive.isNarrowWidth(context)
//                 ? NotLoginHeaderDrawer()
//                 : null;
//           }
//
//           return Scaffold(
//               appBar: currentAppBar,
//               drawer: currentDrawer,
//               body: Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: ListView.builder(
//                         controller: _scrollController, // ScrollController 사용
//                         padding: const EdgeInsets.all(8.0),
//                         itemCount: _messages.length,
//                         itemBuilder: (context, index) {
//                           final message = _messages[index];
//                           return _buildChatBubble(
//                             alignment: message['isUser']
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             color: message['isUser']
//                                 ? Colors.blue[100]
//                                 : Colors.grey[200],
//                             text: message['text'],
//                             isMore: message['isMore'] ?? false,
//                             onMorePressed: showMoreButton
//                                 ? _showTripDetailDialog
//                                 : null,
//                           );
//                         },
//                       ),
//                     ),
//                     _buildInputArea(),
//                   ],
//                 ),
//               ));
//         });
//   }
//
//   Widget _buildChatBubble({
//     required Alignment alignment,
//     required Color? color,
//     required String text,
//     bool isMore = false,
//     VoidCallback? onMorePressed,
//   }) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 2 / 3, // 화면 가로 길이의 2/3까지만 차지
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         padding: const EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(fontSize: 18),
//             ),
//             if (isMore)
//               TextButton(
//                 onPressed: onMorePressed,
//                 child: Text(
//                   '더보기',
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputArea() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: '메세지를 입력하세요.',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//               onSubmitted: (value) => _sendMessage(), // Enter 키 입력 시 메시지 전송
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }


//2 타이핑 형식
class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypingText({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 50),
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
  Map<String, dynamic> travelScheduleMap = {};

  @override
  void initState() {
    super.initState();
    _initializeMessages();
  }

  void _initializeMessages() async {
    await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 지연
    setState(() {
      _messages.add({'text': '안녕하세요!', 'isUser': false});
    });

    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1000)); // 1초 추가 지연
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
                _messages.add({'text': conversationResult.value?.data.travelSchedule.explain, 'isUser': false, 'isMore': true});
                _messages.add({'text': "${conversationResult.value!.data.chatbotMessage}\n의견을 작성해주세요~😄", 'isUser': false});
                showMoreButton = true;
                getResponseOfTripSchedule = true;
              });
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

          if (sendResponseResult.isSuccess && sendResponseResult.value?.status == 200) {
            setState(() {
              _messages.add({'text': '반응 전달에 성공하였습니다.', 'isUser': false});
            });
            //조건 추가 계속해서 받을 수 있음
            getResponseOfTripSchedule = false;
          } else {
            setState(() {
              _messages.add({'text': '반응 전송에 실패하였습니다.. 다시 시도해주세요.', 'isUser': false});
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
    showDetailTripForChatDialog(context, GOOGLE_MAP_KEY, travelScheduleMap);
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
    // 말풍선의 최대 너비를 설정
    double maxWidth = MediaQuery.of(context).size.width * 2 / 3;

    // 텍스트가 3줄까지만 표시되도록 조정
    String truncatedText = _truncateTextToThreeLines(text, maxWidth, const TextStyle(fontSize: 18));

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
            if (isMore) // "더보기" 버튼을 표시
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

  String _truncateTextToThreeLines(String text, double maxWidth, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    if (textPainter.didExceedMaxLines) {
      final position = textPainter.getPositionForOffset(Offset(maxWidth, textPainter.height));
      final endOffset = textPainter.getOffsetBefore(position.offset) ?? text.length;
      return '${text.substring(0, endOffset)}...';
    }

    return text; // 3줄 이하일 때는 원래 텍스트를 반환
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




//3 hard Coding
// import 'package:flutter/material.dart';
//
// import '../../component/header/header.dart';
// import '../../component/header/header_drawer.dart';
// import '../../responsive.dart';
//
// class CreateTripScreen extends StatefulWidget {
//   @override
//   _CreateTripScreenState createState() => _CreateTripScreenState();
// }
//
// class _CreateTripScreenState extends State<CreateTripScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Map<String, dynamic>> _messages = [];
//   bool showMoreButton = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeMessages();
//   }
//
//   void _initializeMessages() async {
//     await Future.delayed(const Duration(milliseconds: 500)); // 0.5초 지연
//     setState(() {
//       _messages.add({'text': '안녕하세요!', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 1000)); // 1초 추가 지연
//     setState(() {
//       _messages.add({'text': '저는 당신만의 여행 플래너 TripFlow의 "립플"입니다.\n당신이 생각한 여행일정을 공유해주세요!', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 1500)); // 1.5초 추가 지연
//     setState(() {
//       _messages.add({'text': '안녕', 'isUser': true});
//     });
//
//     _scrollToBottom();
//
//     await Future.delayed(const Duration(milliseconds: 1500)); // 1.5초 추가 지연
//     setState(() {
//       _messages.add({'text': '여행에 대한 더 많은 정보를 알려주시면 좋겠어요! 며칠 동안 여행하고 싶으신가요?\n어떤 교통수단을 이용하실 건가요?\n누구와 함께 가실 건가요?\n어떤 테마를 선호하시나요?\n어떤 음식을 좋아하시나요?', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 2000)); // 2초 추가 지연
//     setState(() {
//       _messages.add({'text': '친구들하고 3일동안 갈만한 곳 추천해줘', 'isUser': true});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 1500)); // 1.5초 추가 지연
//     setState(() {
//       _messages.add({'text': '어떤 교통수단을 이용할 계획이신가요? 그리고 어떤 음식을 선호하시나요?', 'isUser': false});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//
//     await Future.delayed(const Duration(milliseconds: 1500)); // 1.5초 추가 지연
//     setState(() {
//       _messages.add({'text': '대중교통이용해야하고, 한식', 'isUser': true});
//     });
//
//     _scrollToBottom(); // 메시지 추가 후 스크롤
//   }
//
//   Future<void> _sendMessage() async {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       setState(() {
//         _messages.add({'text': text, 'isUser': true});
//         _controller.clear();
//       });
//
//       _scrollToBottom(); // 메시지 추가 후 스크롤
//
//       // 실제 API 호출을 통한 메시지 처리 부분은 생략되었습니다.
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Responsive.isNarrowWidth(context)
//           ? ShortHeader(automaticallyImplyLeading: false)
//           : AfterLoginHeader(automaticallyImplyLeading: false, context: context),
//       drawer: Responsive.isNarrowWidth(context)
//           ? AfterLoginHeaderDrawer()
//           : null,
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 padding: const EdgeInsets.all(8.0),
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return _buildChatBubble(
//                     alignment: message['isUser']
//                         ? Alignment.centerRight
//                         : Alignment.centerLeft,
//                     color: message['isUser']
//                         ? Colors.blue[100]
//                         : Colors.grey[200],
//                     text: message['text'],
//                   );
//                 },
//               ),
//             ),
//             _buildInputArea(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChatBubble({
//     required Alignment alignment,
//     required Color? color,
//     required String text,
//   }) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 2 / 3,
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//         padding: const EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInputArea() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: '메세지를 입력하세요.',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//               onSubmitted: (value) => _sendMessage(),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }