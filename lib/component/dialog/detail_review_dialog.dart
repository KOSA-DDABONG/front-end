import 'package:flutter/material.dart';
import 'package:front/responsive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../map/get_map.dart';

void showDetailReviewDialog(BuildContext context, String imageUrl, String apiKey) {
  final PageController pageController = PageController();

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
                            flex: 6,
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
                            flex: 5,
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
                                const Text('116'),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(Icons.comment),
                                  onPressed: () {
                                    setState(() {
                                      showComments = !showComments;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text('99'),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 9,
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
                                                "여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n",
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
                                    // 댓글 리스트
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
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
                                  decoration: InputDecoration(
                                    hintText: '댓글을 입력하세요...',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {},
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
                                          "여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n여름 휴가로 부산에 놀러 왔습니다. 재미지네요.\n",
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                                        child: Text(
                                          "#힐링 #호캉스 #해운대",
                                          style: TextStyle(
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
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: Text('116'),
                                  ),
                                  const Icon(Icons.comment),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text('99'),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: ListView.builder(
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
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: '댓글을 입력하세요...',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {},
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