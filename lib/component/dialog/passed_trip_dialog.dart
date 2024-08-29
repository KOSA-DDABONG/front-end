import 'package:flutter/material.dart';
import 'package:front/dto/travel/my_travel_list_data_model.dart';

import '../../screen/review/add_review_screen.dart';
import '../mypage/date_format.dart';

void showPassedTripDialog(BuildContext context, List<MyTravelListDataModel>? data) {
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
                      child: (data!.isEmpty || data?.length == 0)
                      ? const Center(child: Text("선택하실 여행 일정이 없습니다."))
                      : ListView.builder(
                        itemCount: data?.length,
                        itemBuilder: (context, index) {
                          if(data[index].isWrite != false) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 120,
                                height: 120,
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
                                        "assets/images/travel_schedule_default.jpg",
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "시작일: ${changeDateFormat(data[index].startTime)}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "종료일: ${changeDateFormat(data[index].endTime)}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 15,),
                                          Text(
                                            data[index].dayAndNights,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
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
                                  MaterialPageRoute(builder: (context) => AddReviewScreen(data[selectedIndex!.toInt()].travelId)),
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
