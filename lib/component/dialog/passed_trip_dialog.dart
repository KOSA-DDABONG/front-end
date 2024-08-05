import 'package:flutter/material.dart';

import '../../screen/review/add_review_screen.dart';

void showPassedTripDialog(BuildContext context) {
  final List<Map<String, String>> trips = [
    {
      'image': '../assets/images/noImg.jpg',
      'dates': '2024.08.01 - 2024.08.07 (여행 7일) D-3'
    },
    {
      'image': '../assets/images/noImg.jpg',
      'dates': '2024.08.01 - 2024.08.07 (여행 7일) D-3'
    },
    {
      'image': '../assets/images/noImg.jpg',
      'dates': '2024.08.01 - 2024.08.07 (여행 7일) D-3'
    },
    {
      'image': '../assets/images/noImg.jpg',
      'dates': '2024.08.01 - 2024.08.07 (여행 7일) D-3'
    },
    {
      'image': '../assets/images/noImg.jpg',
      'dates': '2024.08.01 - 2024.08.07 (여행 7일) D-3'
    },
  ];

  int? selectedIndex;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      '후기를 작성하실 여행을 선택해주세요',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedIndex == index ? Colors.blue : Colors.grey,
                                  width: selectedIndex == index ? 3.0 : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Image.asset(
                                      trips[index]['image']!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(trips[index]['dates']!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.blue, width: 1.0),
                              ),
                            ),
                            child: const Text(
                              '취소',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedIndex == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('후기를 작성할 일정을 선택해주세요.')),
                                );
                              } else {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddReviewScreen()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.blue, width: 1.0),
                              ),
                            ),
                            child: const Text(
                              '선택',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
