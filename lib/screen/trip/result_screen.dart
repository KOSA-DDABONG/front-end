import 'package:flutter/material.dart';

import '../../component/header.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int selectedDay = 1;

  List<List<Map<String, String>>> itinerary = [
    [
      {'title': '부산역', 'time': '오전 07:48 - 오전 10:03', 'image': '../assets/images/noImg.jpg'},
      {'title': '부산 돼지 국밥', 'time': '오전 10:10 - 오전 10:45', 'image': '../assets/images/noImg.jpg'},
      {'title': '감천 문화 마을', 'time': '오전 10:45 - 오전 12:00', 'image': '../assets/images/noImg.jpg'},
    ],
    [
      {'title': '해운대 해수욕장', 'time': '오전 09:00 - 오후 12:00', 'image': '../assets/images/noImg.jpg'},
      {'title': '광안리 해수욕장', 'time': '오후 01:00 - 오후 03:00', 'image': '../assets/images/noImg.jpg'},
    ],
    [
      {'title': '해동 용궁사', 'time': '오전 08:00 - 오전 10:00', 'image': '../assets/images/noImg.jpg'},
      {'title': '태종대', 'time': '오전 11:00 - 오후 01:00', 'image': '../assets/images/noImg.jpg'},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: Stack(
                      children: [
                        // Replace with a real map widget if available
                        Center(child: Image.asset('../assets/images/noImg.jpg')),
                        ...itinerary[selectedDay - 1].asMap().entries.map((entry) {
                          int idx = entry.key;
                          var place = entry.value;
                          // Dummy positions for the markers
                          return Positioned(
                            top: 50.0 + (idx * 30),
                            left: 50.0 + (idx * 30),
                            child: Icon(Icons.location_on, color: Colors.red, size: 40),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('저장'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF58C8E1), // Custom color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('재생성'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF005AA7), // Custom color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDay = index + 1;
                        });
                      },
                      child: Text('${index + 1}일차'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDay == index + 1 ? Colors.blue : Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: itinerary[selectedDay - 1].length,
                    itemBuilder: (context, index) {
                      var place = itinerary[selectedDay - 1][index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(place['image']!, width: 60, height: 60, fit: BoxFit.cover),
                          title: Text(place['title']!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Text(place['time']!, style: TextStyle(fontSize: 14)),
                        ),
                      );
                    },
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