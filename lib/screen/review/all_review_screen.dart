import 'package:flutter/material.dart';
import 'package:front/constants.dart';

import '../../component/dialog/passed_trip_dialog.dart';
import '../../component/dialog/detail_review_dialog.dart';
import '../../component/header/header.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({Key? key}) : super(key: key);

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> with SingleTickerProviderStateMixin {
  List<String> allReviews = List.generate(20, (index) => '../assets/images/noImg.jpg');

  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isContestExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AfterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: _allReviewPageUI()
    );
  }

  //리뷰 조회 페이지 UI
  Widget _allReviewPageUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        children: [
          _searchBarUI(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _subTitleTextUI('콘테스트'),
                    TextButton(
                      onPressed: _toggleContestSection,
                      child: Text(
                        _isContestExpanded ? '접기' : '펼치기',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _contestContentUI(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _subTitleTextUI('전체 후기'),
                    _addReviewBtnUI(),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _allReviewContentUI(),
        ],
      ),
    );
  }

  //서브 타이틀 UI
  Widget _subTitleTextUI(String subtitle) {
    return Text(
        subtitle,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        )
    );
  }

  //검색창 UI
  Widget _searchBarUI() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const Spacer(),
          Expanded(
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '검색 키워드를 입력하세요.',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
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
    );
  }

  //검색 기능
  void _onSearch() {
    print("Searching for: ${_searchController.text}");
  }

  //탭 선택
  void _toggleContestSection() {
    setState(() {
      _isContestExpanded = !_isContestExpanded;
    });
  }

  //탭 선택에 따른 순위 내용
  Widget _buildContestTab() {
    List<Map<String, dynamic>> rankings = [
      {'icon': Icons.looks_one, 'image': '../assets/images/noImg.jpg'}, //1st
      {'icon': Icons.looks_two, 'image': '../assets/images/noImg.jpg'}, //2nd
      {'icon': Icons.looks_3, 'image': '../assets/images/noImg.jpg'}, //3rd
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rankings.map((ranking) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                showDetailReviewDialog(context, ranking['image']);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(ranking['icon'], size: 40),
                  const SizedBox(height: 5),
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

  //콘테스트 영역 내용
  Widget _contestContentUI() {
    return _isContestExpanded
        ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: '후기 콘테스트'),
              Tab(text: '주간 콘테스트'),
              Tab(text: '월간 콘테스트'),
              Tab(text: '시즌 콘테스트'),
            ],
          ),
          Container(
            height: 200,
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
    ) : const SizedBox.shrink();
  }

  //후기 작성 버튼
  Widget _addReviewBtnUI() {
    return ElevatedButton(
      onPressed: () {
        showPassedTripDialog(context);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: pointColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
      child: const Text('나의 후기 작성하기'),
    );
  }

  //전체 후기 내용 영역
  Widget _allReviewContentUI() {
    return Expanded(
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
                showDetailReviewDialog(context, allReviews[index]);
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
                  _reviewInfoUI(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //게시물 정보(좋아요수, 댓글수)
  Widget _reviewInfoUI() {
    return Padding(
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
    );
  }
}
