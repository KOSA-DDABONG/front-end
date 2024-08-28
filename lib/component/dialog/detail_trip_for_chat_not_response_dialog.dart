import 'package:flutter/material.dart';
import 'package:front/responsive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants.dart';
import '../map/get_map_for_chat.dart';

void showDetailTripForChatNotResponseDialog(BuildContext context, String apiKey, List<dynamic>? scheduleInfo) {
  int selectedDay = 1;
  int? selectedIndex;
  int scheduleDayLength = scheduleInfo?.length ?? 0;
  List<List<dynamic>>  aDayScheduleSequence = [];

  print("여행일정 상세 다이어로그 시작");
  print(scheduleInfo);
  print("--------------------------");

  List<dynamic> findHotelInfo(int dayIndex) {
    if (scheduleInfo == null || dayIndex >= scheduleDayLength || scheduleInfo.isEmpty) {
      print("Day ${dayIndex} 호텔 없음");
      return [];
    } else {
      if(scheduleInfo[dayIndex]['hotel'] == null) {
        return [];
      }
      else {
        return scheduleInfo[dayIndex]['hotel'];
      }
    }
  }

  List<dynamic> findBreakfast(int dayIndex) {
    if (scheduleInfo == null || dayIndex >= scheduleDayLength || scheduleInfo.isEmpty) {
      print("Day ${dayIndex} 아침 없음");
      return [];
    } else {
      return scheduleInfo[dayIndex]['breakfast'];
    }
  }

  List<List<dynamic>> findTouristSpots(int dayIndex) {
    if (scheduleInfo == null || dayIndex >= scheduleDayLength || scheduleInfo.isEmpty) {
      print("Day ${dayIndex} 관광지 없음");
      return [];
    } else {
      return scheduleInfo[dayIndex]['tourist_spots'].map<List<Object>>((spot) => List<Object>.from(spot)).toList();
    }
  }

  List<dynamic> findLunch(int dayIndex) {
    if (scheduleInfo == null || dayIndex >= scheduleDayLength || scheduleInfo.isEmpty) {
      print("Day ${dayIndex} 점심 없음");
      return [];
    } else {
      return scheduleInfo[dayIndex]['lunch'];
    }
  }

  List<dynamic> findDinner(int dayIndex) {
    if (scheduleInfo == null || dayIndex >= scheduleDayLength || scheduleInfo.isEmpty) {
      print("Day ${dayIndex} 저녁 없음");
      return [];
    } else {
      return scheduleInfo[dayIndex]['dinner'];
    }
  }

  List<List<dynamic>> daySchedule(int dayIndex, int spotsLength) {
    List<List<dynamic>> list = [];
    if (spotsLength == 1) {
      list.add(findBreakfast(dayIndex));
      list.add(findLunch(dayIndex));
      list.add(findTouristSpots(dayIndex)[0]);
      list.add(findDinner(dayIndex));
      list.add(findHotelInfo(dayIndex));
    } else if (spotsLength == 2) {
      list.add(findBreakfast(dayIndex));
      list.add(findTouristSpots(dayIndex)[0]);
      list.add(findLunch(dayIndex));
      list.add(findTouristSpots(dayIndex)[1]);
      list.add(findDinner(dayIndex));
      list.add(findHotelInfo(dayIndex));
    } else if (spotsLength == 3) {
      list.add(findBreakfast(dayIndex));
      list.add(findTouristSpots(dayIndex)[0]);
      list.add(findLunch(dayIndex));
      list.add(findTouristSpots(dayIndex)[1]);
      list.add(findDinner(dayIndex));
      list.add(findTouristSpots(dayIndex)[2]);
      list.add(findHotelInfo(dayIndex));
    }
    aDayScheduleSequence = list;
    aDayScheduleSequence.removeWhere((element) => element.isEmpty);
    print("Day ${dayIndex+1}, 관광지 개수 ${spotsLength}, $aDayScheduleSequence");
    return aDayScheduleSequence;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (Responsive.isNarrowWidth(context)) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GetMapForChat(
                            dayScheduleData: List.generate(
                              scheduleDayLength,
                                  (index) => daySchedule(index, findTouristSpots(index).length),
                            ),
                            selectedDay: selectedDay,
                            selectedPlace: selectedIndex != null
                                ? LatLng(
                              aDayScheduleSequence[selectedDay][1],
                              aDayScheduleSequence[selectedDay][2],
                            )
                                : null,
                            selectedIndex: selectedIndex, // 추가된 부분
                          ),

                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(scheduleDayLength, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = index + 1;
                                          selectedIndex = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == index + 1 ? pointColor : Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      child: Text(
                                        '${index + 1}일차',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length).length,
                                itemBuilder: (context, index) {
                                  if(daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length)[index] != []) {
                                    return Stack(
                                      children: [
                                        Positioned.fill(
                                          left: 12,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: DashedLine(
                                              height: double.infinity,
                                              color: Colors.grey,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                radius: 12,
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIndex = index;
                                                      // 지도 중앙으로 이동
                                                    });
                                                  },
                                                  child: Card(
                                                    color: selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                                                    child: ListTile(
                                                      title: Text(
                                                        daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length)[index][0],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    //
                                  }

                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          ///
          ///
          ///
          ///
          else {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GetMapForChat(
                            dayScheduleData: List.generate(
                              scheduleDayLength,
                                  (index) => daySchedule(index, findTouristSpots(index).length),
                            ),
                            selectedDay: selectedDay,
                            selectedPlace: selectedIndex != null
                                ? LatLng(
                              aDayScheduleSequence[selectedDay][1],
                              aDayScheduleSequence[selectedDay][2],
                            )
                                : null,
                            selectedIndex: selectedIndex, // 추가된 부분
                          ),

                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 25, 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(scheduleDayLength, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = index + 1;
                                          selectedIndex = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == index + 1 ? pointColor : Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      child: Text(
                                        '${index + 1}일차',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length).length,
                                itemBuilder: (context, index) {
                                  if(daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length)[index] != []) {
                                    return Stack(
                                      children: [
                                        Positioned.fill(
                                          left: 12,
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: DashedLine(
                                              height: double.infinity,
                                              color: Colors.grey,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                radius: 12,
                                                child: Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIndex = index;
                                                      // 지도 중앙으로 이동
                                                    });
                                                  },
                                                  child: Card(
                                                    color: selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                                                    child: ListTile(
                                                      title: Text(
                                                        daySchedule(selectedDay - 1, findTouristSpots(selectedDay - 1).length)[index][0],
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  else {
                                    ///
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    },
  );
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;

  DashedLine({
    required this.height,
    required this.color,
    this.strokeWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(strokeWidth, height),
      painter: _DashedLinePainter(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}