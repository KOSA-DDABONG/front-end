import 'package:flutter/material.dart';

import '../../service/board_service.dart';
import '../snack_bar.dart';

void showDeleteMyReviewDialog(BuildContext context, int postid) {
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
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '작성한 후기 삭제하기',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '정말 삭제하시겠습니까?',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 20),
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
                            onPressed: () async {
                              //삭제 구현
                              try {
                                final result = await BoardService.deleteReview(postid);
                                if(result.value?.status==200) {
                                  Navigator.of(context).pop();
                                  showCustomSnackBar(context, '해당 게시물이 삭제되었습니다.');
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => LandingScreen()),
                                  // );
                                }
                                else{
                                  showCustomSnackBar(context, "게시물 삭제에 실패하였습니다.");
                                }
                              }
                              catch(e) {
                                showCustomSnackBar(context, "에러가 발생하였습니다. 잠시 후 다시 시도해주세요.");
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
                              '확인',
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
