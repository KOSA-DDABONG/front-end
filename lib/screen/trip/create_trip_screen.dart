import 'package:flutter/material.dart';
import 'package:front/component/dialog/detail_trip_dialog.dart';
import 'package:front/component/snack_bar.dart';
import 'package:front/key/key.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../dto/chat/chat_data_model.dart';
import '../../responsive.dart';
import '../../service/chat_service.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool showMoreButton = false;
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

    await Future.delayed(const Duration(milliseconds: 1000)); // 1초 추가 지연
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
        if (conversationResult.isSuccess && conversationResult.value?.status == 200) {
          if (conversationResult.value?.message == "Please Request Next User Input") { // 일정 생성 전
            setState(() {
              _messages.add({'text': conversationResult.value?.data.chatbotMessage, 'isUser': false});
            });
          } else { // 일정 생성 완료
            // JSON 문자열을 Map으로 변환
            travelScheduleMap = parseTravelSchedule(conversationResult.value!.data.travelSchedule);
            final travelScheduleString = formatTravelSchedule(travelScheduleMap);

            setState(() {
              _messages.add({'text': '생성된 일정:', 'isUser': false});
              _messages.add({'text': travelScheduleString, 'isUser': false, 'isMore': true});
              _messages.add({'text': "${conversationResult.value!.data.chatbotMessage}\n의견을 작성해주세요~😄", 'isUser': false});
              showMoreButton = true; // 더보기 버튼 표시
            });
          }
        } else {
          setState(() {
            _messages.add({'text': '응답을 불러올 수 없습니다. 다시 시도해주세요.', 'isUser': false});
          });
        }
      } catch (e) {
        print(e);
        showCustomSnackBar(context, "에러가 발생하였습니다. 다시 시도해주세요.");
      }
    }
  }

  String formatTravelSchedule(Map<String, dynamic> schedule) {
    final buffer = StringBuffer();

    // 첫 번째 날의 일정만 표시
    final firstDay = schedule.keys.first;
    final activities = schedule[firstDay];

    buffer.writeln('Day $firstDay');

    // Helper 함수: 리스트나 맵에서 이름 추출
    void extractNames(String category, dynamic activity) {
      if (activity is List) {
        if (activity.isEmpty) return;

        // Check if activity is a list of lists
        if (activity[0] is List) {
          buffer.writeln('($category)');
          for (var item in activity) {
            if (item is List && item.isNotEmpty) {
              // 첫 번째 항목이 장소 이름이라고 가정
              buffer.writeln(item[0]);
            }
          }
        } else {
          // 단일 리스트일 경우
          buffer.writeln('($category)');
          for (var item in activity) {
            if (item is List && item.isNotEmpty) {
              // 첫 번째 항목이 장소 이름이라고 가정
              buffer.writeln(item[0]);
            } else if (item is String) {
              // 문자열일 경우 직접 출력
              buffer.writeln(item);
            }
          }
        }
      } else if (activity is String) {
        buffer.writeln('($category)');
        buffer.writeln(activity); // 장소 이름만 출력
      }
    }

    // Extracting names for specific activities
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
    showDetailTripDialog(context, GOOGLE_MAP_KEY, travelScheduleMap); // travelScheduleMap 전달
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
              ));
        });
  }

  Widget _buildChatBubble({
    required Alignment alignment,
    required Color? color,
    required String text,
    bool isMore = false,
    VoidCallback? onMorePressed,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            if (isMore)
              TextButton(
                onPressed: onMorePressed,
                child: Text(
                  '더보기',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
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