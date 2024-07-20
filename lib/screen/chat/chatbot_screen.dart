// import 'package:flutter/material.dart';
//
// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);
//
//   @override
//   _ChatbotScreenState createState() => _ChatbotScreenState();
// }
//
// class _ChatbotScreenState extends State<ChatbotScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Text('챗봇 페이지');
//   }
// }

import 'package:flutter/material.dart';

import '../../component/header.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: Row(
        children: [
          // Itinerary Section
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(child: Text('1')),
                  title: Text('점심'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('YODA 파스타'),
                      Text('양식 ⭐ 4.9 (36,771)'),
                      Text('OPEN 수 오전 11:00 - 오후 9:00'),
                    ],
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(child: Text('2')),
                  title: Text('액티비티'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('뽀로로앤타요 테마파크 제주'),
                      Text('테마파크 ⭐ 4.8 (6,253)'),
                      Text('OPEN 수 오전 11:00 - 오후 9:00'),
                    ],
                  ),
                ),
                // More ListTiles can be added here
              ],
            ),
          ),
          // Chatbot Section
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('어떤여행지를 추천해 드릴까요?'),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('부산여행으로 2박3일 추천해줘'),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('부산여행지를 추천해드렸어요.'),
                              ),
                              SizedBox(height: 5),
                              Image.network('../assets/images/noImg.jpg'), // Replace with the actual image URL
                              TextButton(
                                onPressed: () {},
                                child: Text('더보기'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tr',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}