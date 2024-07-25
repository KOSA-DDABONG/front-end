import 'package:flutter/material.dart';
import 'package:front/screen/review/add_review_screen.dart';

import '../../component/dialog/review_detail_dialog.dart';
import '../../component/header.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({Key? key}) : super(key: key);

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> with SingleTickerProviderStateMixin {
  List<String> rankingReviews = [
    '../assets/images/noImg.jpg',
    '../assets/images/noImg.jpg',
    '../assets/images/noImg.jpg',
  ];

  List<String> allReviews = List.generate(20, (index) => '../assets/images/noImg.jpg');

  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;
  bool _isContestExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  // void _showImageModal(BuildContext context, String imageUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.8,
  //           height: MediaQuery.of(context).size.height * 0.8,
  //           child: Column(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: BorderRadius.circular(10),
  //                 child: Image.network(imageUrl),
  //               ),
  //               SizedBox(height: 10),
  //               Text("여름 휴가로 부산에 놀러 왔습니다. 재미지네요."),
  //               SizedBox(height: 10),
  //               Expanded(
  //                 child: ListView(
  //                   children: List.generate(100, (index) {
  //                     return ListTile(
  //                       title: Text('Comment $index'),
  //                     );
  //                   }),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _onSearch() {
    print("Searching for: ${_searchController.text}");
  }

  void _toggleContestSection() {
    setState(() {
      _isContestExpanded = !_isContestExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AfterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Spacer(),
                  Expanded(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.2,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '검색 키워드를 입력하세요.',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: _onSearch,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Contest Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('콘테스트', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: _toggleContestSection,
                        child: Text(
                          _isContestExpanded ? '접기' : '펼치기',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _isContestExpanded
                      ? Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          tabs: [
                            Tab(text: '후기 콘테스트'),
                            Tab(text: '주간 콘테스트'),
                            Tab(text: '월간 콘테스트'),
                            Tab(text: '시즌 콘테스트'),
                          ],
                        ),
                        Container(
                          height: 200, // Adjust height as needed
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildContestTab(),
                              _buildContestTab(),
                              _buildContestTab(),
                              _buildContestTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : SizedBox.shrink(),
                  SizedBox(height: 20),
                  // 전체 후기 Section with 나의 후기 작성하기 Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('전체 후기', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context!,
                            MaterialPageRoute(builder: (context) => AddReviewScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF005AA7), // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Button corner radius
                          ),
                          elevation: 0,
                        ),
                        child: Text('나의 후기 작성하기'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: allReviews.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showReviewDetailDialog(context, allReviews[index]);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    allReviews[index],
                                    fit: BoxFit.cover,
                                    width: constraints.maxWidth,
                                    height: constraints.maxWidth * 3 / 4,
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('45'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.comment, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text('13'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestTab() {
    List<Map<String, dynamic>> rankings = [
      {'icon': Icons.looks_one, 'image': '../assets/images/noImg.jpg'}, // 1st place
      {'icon': Icons.looks_two, 'image': '../assets/images/noImg.jpg'}, // 2nd place
      {'icon': Icons.looks_3, 'image': '../assets/images/noImg.jpg'}, // 3rd place
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rankings.map((ranking) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showReviewDetailDialog(context, ranking['image']);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(ranking['icon'], size: 40),
                  SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      ranking['image'],
                      fit: BoxFit.cover,
                      width: 150, //MediaQuery.of(context).size.width
                      height: 100
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
