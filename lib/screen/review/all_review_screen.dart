import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/service/board_service.dart';

import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/passed_trip_dialog.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/login_state_for_header.dart';
import '../../dto/board/board_model.dart';
import '../../key/key.dart';
import '../../responsive.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({Key? key}) : super(key: key);

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> with SingleTickerProviderStateMixin {

  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isContestExpanded = false;

  bool _isLoading = true;
  bool _loginState = false;
  List<AllBoardList> _allReviews = [];
  List<AllBoardList> _rankReviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviewLists();
    _startLoadingTimeout();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadReviewLists() async {
    bool isLoggedIn = await checkLoginState(context);
    if(isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });
    }

    try {
      final result = await BoardService.getReviewList();
      if (result.isSuccess) {
        setState(() {
          _allReviews = result.value?.boardList ?? [];
          _rankReviews = result.value?.topList ?? [];
          _isLoading = false;
        });
      }
      else {
        setState(() {
          _isLoading = false;
        });
      }
    }
    catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_loginState) {//로그인 상태라면
      if(_isLoading) { //
        return Scaffold(
          appBar: Responsive.isNarrowWidth(context)
            ? ShortHeader(automaticallyImplyLeading: false)
            : AfterLoginHeader(automaticallyImplyLeading: false, context: context),
          drawer: Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null,
          body: _loadingUI(context),
        );
      }
      else {
        return Scaffold(
          appBar: Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : AfterLoginHeader(automaticallyImplyLeading: false, context: context),
          drawer: Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null,
          body: _allReviewPageUI(),
        );
      }
    }
    else { // 비로그인 상태라면
      // return Scaffold(
      //   appBar: Responsive.isNarrowWidth(context)
      //       ? ShortHeader(automaticallyImplyLeading: false)
      //       : AfterLoginHeader(automaticallyImplyLeading: false, context: context),
      //   drawer: Responsive.isNarrowWidth(context)
      //       ? AfterLoginHeaderDrawer()
      //       : null,
      //   body: _notLoginAllReviewUI(),
      // );
      return CheckLoginStateWidget(
          builder: (context, isLoggedIn) {
            PreferredSizeWidget currentAppBar;
            Widget? currentDrawer;
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : NotLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? NotLoginHeaderDrawer()
                : null;
            return Scaffold(
                appBar: currentAppBar,
                drawer: currentDrawer,
                body: _notLoginAllReviewUI()
            );
          }
      );
    }
  }

  Widget _loadingUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          const Expanded(
              flex: 1,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue, // 로딩 표시 색상 설정 (파란색)
                ),
              )
          ),
          Expanded(
            flex: 2,
            child: Container(),
          )
        ],
      ),
    );
  }

  Widget _notLoginAllReviewUI() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 200),
          Center(
            child: Text(
              '데이터를 불러올 수 없습니다.',
            ),
          ),
          SizedBox(height: 200),
        ],
      ),
    );
  }

  //리뷰 조회 페이지 UI
  Widget _allReviewPageUI() {
    return Padding(
      padding: Responsive.isNarrowWidth(context)
        ? const EdgeInsets.symmetric(horizontal: 20)
        : const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          _searchBarUI(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
          Expanded(child: _allReviewContentUI()),
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
    if (Responsive.isNarrowWidth(context)) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox()
            ),
            Expanded(
              flex: 7,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '검색 키워드 입력',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _onSearch,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox()
            ),
            Expanded(
              flex: 3,
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
            )
          ],
        ),
      );
    }
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
    print("000999");
    print(_rankReviews);
    print("000999");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (_rankReviews.isEmpty || _rankReviews == null)
            ? [const Text('데이터가 존재하지 않습니다.')]
            : _rankReviews.map((review) {
          int index = _rankReviews.indexOf(review) + 1;
          IconData icon;
          switch (index) {
            case 1:
              icon = Icons.looks_one;
              break;
            case 2:
              icon = Icons.looks_two;
              break;
            case 3:
              icon = Icons.looks_3;
              break;
            default:
              icon = Icons.star_border;
          }
          return Expanded(
            child: GestureDetector(
              onTap: () async {
                try {
                  final result = await BoardService.getReviewDetailInfo(review.postid.toString());
                  if (result.value?.status == 200 /*result.value != null*/) {
                    showDetailReviewDialog(
                      context,
                      GOOGLE_MAP_KEY,
                      review.postid,
                      result,
                    );
                  }
                  else {
                    showCustomSnackBar(context, '정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.');
                  }
                } catch (e) {
                  showCustomSnackBar(context, '에러가 발생했습니다. 잠시 후 다시 시도해주세요.');
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 150,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                          (_rankReviews[index - 1].imgurl != null)
                            ? _rankReviews[index - 1].imgurl.toString()
                            : 'assets/images/noImg.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
                        },
                      ),
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
          Responsive.isNarrowWidth(context)
          ? TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              tabs: const [
                Tab(text: '전체'),
                Tab(text: '주간'),
                Tab(text: '월간'),
                Tab(text: '시즌'),
              ],
            )
          : TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              tabs: const [
                Tab(text: '전체 콘테스트'),
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
                // const Center(
                //     child: Text(
                //         "현재 데이터가 없습니다."
                //     )
                // ),
                const Center(
                  child: Text(
                    "현재 데이터가 없습니다."
                  )
                ),
                const Center(
                  child: Text(
                    "현재 데이터가 없습니다."
                  )
                ),
                const Center(
                  child: Text(
                    "현재 데이터가 없습니다."
                  )
                ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 150).floor();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: _allReviews.length,
          itemBuilder: (context, index) {
            final review = _allReviews[index];
            return GestureDetector(
              onTap: () async {
                try {
                  final result = await BoardService.getReviewDetailInfo(review.postid.toString());
                  if (result.value?.status == 200 /*result.value != null*/) {
                    showDetailReviewDialog(
                      context,
                      GOOGLE_MAP_KEY,
                      review.postid,
                      result,
                    );
                  }
                  else {
                    showCustomSnackBar(context, '상세 정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.');
                  }
                } catch (e) {
                  showCustomSnackBar(context, '에러가 발생했습니다. 잠시 후 다시 시도해주세요.');
                }
              },
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * 3 / 4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 설정
                                child: Image.network(
                                  (_allReviews[index].imgurl != null && _allReviews[index].imgurl!.isNotEmpty)
                                  ? _allReviews[index].imgurl.toString()
                                  : 'assets/images/noImg.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
                                  },
                                ),
                              )
                          ),
                        );
                      },
                    ),
                  ),
                  _reviewInfoUI(review),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //게시물 정보(좋아요수, 댓글수)
  Widget _reviewInfoUI(AllBoardList review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (review.likeflag)
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite, color: Colors.grey),
              const SizedBox(width: 4),
              Text(review.likecount.toString()),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.comment, color: Colors.grey),
              const SizedBox(width: 4),
              Text(review.comcontentcount?.toString() ?? '0'),
            ],
          ),
        ],
      ),
    );
  }
}