import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screen/start/login_screen.dart';
import 'package:front/service/board_service.dart';
import 'package:front/service/session_service.dart';

import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/passed_trip_dialog.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/check_login_state.dart';
import '../../dto/board/board_model.dart';
import '../../key/key.dart';
import '../../responsive.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({Key? key}) : super(key: key);

  @override
  _AllReviewScreenState createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> with SingleTickerProviderStateMixin {
  List<String> allReviews = List.generate(15, (index) => 'assets/images/noImg.jpg');

  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isContestExpanded = false;

  bool _isLoading = true;
  bool _isLoadFailed = false;
  List<Board> _allReviews = [];
  List<Board> _rankReviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadReviewLists();
  }

  Future<void> _loadReviewLists() async {
    // 로딩 실패를 감지할 타이머
    final timer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isLoadFailed = _isLoading;
        });
      }
    });

    try {
      final result = await BoardService.getReviewList();
      print("@@@!!" + result.value!.boardList.toString());

      if (result.isSuccess) {
        setState(() {
          _allReviews = result.value?.boardList ?? [];
          print("@@@!!1" + _allReviews.toString());
          _rankReviews = result.value?.topList ?? [];
          print("@@@!!2" + _rankReviews.toString());
          _isLoading = false;
        });
      }
      else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('데이터를 불러오는 데 실패하였습니다.'),
          ),
        );
      }
    }
    catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadFailed = true; // 실패 상태로 설정
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('문제가 발생했습니다. 잠시 후 다시 시도해주세요.'),
        ),
      );
    }
    finally {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckLoginStateWidget(
      builder: (context, isLoggedIn) {
        PreferredSizeWidget currentAppBar;
        Widget? currentDrawer;
        if (isLoggedIn) {
          currentAppBar = Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null;
        }
        else {
          currentAppBar = Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : NotLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
              ? NotLoginHeaderDrawer()
              : null;
        }

        return Scaffold(
            appBar: currentAppBar,
            drawer: currentDrawer,
            body: _allReviewPageUI()
        );
      }
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (_rankReviews.isEmpty)
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
                  final result = await BoardService.getReviewInfo(review.postid.toString());
                  final accessToken = await SessionService.getAccessToken();
                  if (result.value?.status == 200 /*result.value != null*/) {
                    showDetailReviewDialog(
                      context,
                      'assets/images/noImg.jpg',
                      GOOGLE_MAP_KEY,
                      result.value!.board.likecount,
                      result.value!.board.comcontentcount,
                      result.value?.board.content,
                      result.value?.commentList,
                      result.value?.hashtagList
                    );
                  } else {
                    if (accessToken == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('메세지'),
                            content: Text('로그인 후 이용 가능한 서비스입니다. 로그인 하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text('로그인'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.'),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('에러가 발생했습니다. 잠시 후 다시 시도해주세요.'),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/noImg.jpg',
                      fit: BoxFit.cover,
                      width: 150,
                      height: 100,
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }
    else if (_isLoadFailed) {
      return const Center(
        child: Text(
          '정보를 불러올 수 없습니다.\n',
        ),
      );
    }
    else {
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
                    final result = await BoardService.getReviewInfo(review.postid.toString());
                    final accessToken = await SessionService.getAccessToken();
                    if (result.value?.status == 200 /*result.value != null*/) {
                      showDetailReviewDialog(
                        context,
                        'assets/images/noImg.jpg',
                        GOOGLE_MAP_KEY,
                        result.value!.board.likecount,
                        result.value!.board.comcontentcount,
                        result.value?.board.content,
                        result.value?.commentList,
                        result.value?.hashtagList
                      );
                    } else {
                      if (accessToken == null) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('메세지'),
                              content: Text('로그인 후 이용 가능한 서비스입니다. 로그인 하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Text('로그인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '상세 정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.'),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('에러가 발생했습니다. 잠시 후 다시 시도해주세요.'),
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/noImg.jpg',
                              fit: BoxFit.cover,
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * 3 / 4,
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
  }

  //게시물 정보(좋아요수, 댓글수)
  Widget _reviewInfoUI(Board review) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: Colors.grey),
              SizedBox(width: 4),
              Text(review.likecount.toString()),
            ],
          ),
          Row(
            children: [
              Icon(Icons.comment, color: Colors.grey),
              SizedBox(width: 4),
              Text(review.comcontentcount?.toString() ?? '0'),
            ],
          ),
        ],
      ),
    );
  }

}