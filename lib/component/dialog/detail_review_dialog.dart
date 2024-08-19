import 'package:flutter/material.dart';
import 'package:front/dto/board/board_detail_response_model.dart';
import 'package:front/dto/board/board_model.dart';
import 'package:front/dto/comment/comment_request_model.dart';
import 'package:front/dto/hashtag/hashtag_model.dart';
import 'package:front/responsive.dart';
import 'package:front/service/result.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../dto/comment/comment_model.dart';
import '../map/get_map.dart';

void showDetailReviewDialog(
    BuildContext context,
    String imageUrl,
    String apiKey,
    Board review,
    Result<BoardDetailResponseModel> result
  ) {
  final PageController pageController = PageController();
  final TextEditingController commentController = TextEditingController();
  List<Comment>? commentList = result.value?.commentList;
  List<Hashtag>? hashtagList = result.value?.hashtagList;

  List<String> images = [
    imageUrl,
    'assets/images/noImg.jpg',
    'assets/images/login_background.png',
    'assets/images/noImg.jpg',
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isLiked = false;
      bool showComments = false;
      bool isButtonEnabled = false;

      void updateButtonState(String text, StateSetter setState) {
        final RegExp regex = RegExp(r'^\s*$'); // 공백만으로 이루어졌는지 검사
        setState(() {
          isButtonEnabled = !regex.hasMatch(text) && text.trim().isNotEmpty;
        });
      }

      if(Responsive.isNarrowWidth(context)) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  PageView(
                                    controller: pageController,
                                    children: images.map((image) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Image.asset(
                                          image,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Positioned(
                                    bottom: 8.0,
                                    child: SmoothPageIndicator(
                                      controller: pageController,
                                      count: images.length,
                                      effect: const WormEffect(
                                        dotHeight: 8.0,
                                        dotWidth: 8.0,
                                        spacing: 16.0,
                                        activeDotColor: Colors.black,
                                        dotColor: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: GetMap(
                                  apiKey: apiKey,
                                  origin: '37.819929,-122.478255',
                                  destination: '37.787994,-122.407437',
                                  waypoints: '37.76999,-122.44696|37.76899,-122.44596',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                ),
                                // Text('$likesNum'),
                                Text('${result.value!.board.likecount}'),
                                const SizedBox(width: 16),
                                (!showComments)
                                ? IconButton(
                                    icon: Icon(Icons.comment_outlined),
                                    onPressed: () {
                                      setState(() {
                                        showComments = !showComments;
                                      });
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.comment),
                                    onPressed: () {
                                      setState(() {
                                        showComments = !showComments;
                                      });
                                    },
                                  ),
                                const SizedBox(width: 8),
                                // Text('$commentsNum'),
                                Text('${result.value!.board.comcontentcount}'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!showComments) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                // "$commentContent",
                                                "${result.value?.board.content}",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            )
                                          ),
                                          const SizedBox(height: 10),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                "#힐링 #호캉스 #해운대",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ],
                                  if (showComments) ...[
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 100,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: const CircleAvatar(
                                                backgroundImage: AssetImage('assets/images/profile_pic.png'),
                                              ),
                                              title: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Nickname $index',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text('Comment $index'),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.grey[200]),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  onChanged: (text) {
                                    updateButtonState(text, setState);
                                  },
                                  decoration: InputDecoration(
                                    hintText: '댓글을 입력하세요...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: isButtonEnabled ? () {
                                  try {
                                  //   result.value?.commentList,
                                  // result.value?.hashtagList,
                                  //   final model = CommentRequestModel(postid: postid, travelid: travelid, commentid2: commentid2, memberid: memberid, comcontent: comcontent);
                                    // final result = await UserService.login(model);
                                    //
                                    // if (result.value != null) {
                                    //   savePreferences();
                                    //
                                    //   setState(() {
                                    //     isApiCallProcess = false;
                                    //   });
                                    //
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => LandingScreen()),
                                    //   );
                                    //
                                    // }
                                    // else {
                                    //   setState(() {
                                    //     isApiCallProcess = false;
                                    //   });
                                    //
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //       content: Text('로그인에 실패하였습니다. 아이디와 비밀번호를 다시 확인해주세요.'),
                                    //     ),
                                    //   );
                                    // }
                                  } catch (e) {
                                    // setState(() {
                                    //   isApiCallProcess = false;
                                    // });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('에러가 발생했습니다: $e'),
                                      ),
                                    );
                                  }
                                } : null
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      else {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    PageView(
                                      controller: pageController,
                                      children: images.map((image) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(5.0),
                                          child: Image.asset(
                                            image,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    Positioned(
                                      bottom: 8.0,
                                      child: SmoothPageIndicator(
                                        controller: pageController,
                                        count: images.length,
                                        effect: const WormEffect(
                                          dotHeight: 8.0,
                                          dotWidth: 8.0,
                                          spacing: 16.0,
                                          activeDotColor: Colors.black,
                                          dotColor: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                                child: PageView(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: GetMap(
                                        apiKey: apiKey,
                                        origin: '37.819929,-122.478255', // 출발지 좌표
                                        destination: '37.787994,-122.407437', // 도착지 좌표
                                        waypoints: '37.76999,-122.44696|37.76899,-122.44596', // 경유지 좌표
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                        child: Text(
                                          // "$commentContent",
                                          "${result.value?.board.content}",
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                        child: Text(
                                          hashtagList != null
                                              ? hashtagList.map((hashtag) => '#${hashtag.hashname}').toSet().join(' ')
                                              : '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child:
                                    // Text('$likesNum'),
                                    Text('${result.value?.board.likecount}'),
                                  ),
                                  const Icon(Icons.comment),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child:
                                    // Text('$commentsNum'),
                                    Text('${result.value?.board.comcontentcount}'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: ListView.builder(
                                // shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: commentList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final comment = commentList![index];
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: const CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/profile_pic.png'),
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '사용자 아이디 ${comment.memberid}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(comment.comcontent),
                                          ],
                                        ),
                                      ),
                                      Divider(color: Colors.grey[200]),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        onChanged: (text) {
                                          updateButtonState(text, setState);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: '댓글을 입력하세요...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: isButtonEnabled ? () {
                                        //
                                      } : null,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    },
  );
}