import 'package:flutter/material.dart';

import '../../dto/board/board_model.dart';
import '../../service/board_service.dart';

class ReviewProvider with ChangeNotifier {
  bool _isLoading = true;
  List<AllBoardList> _allReviews = [];
  List<AllBoardList> _rankReviews = [];

  bool get isLoading => _isLoading;
  List<AllBoardList> get allReviews => _allReviews;
  List<AllBoardList> get rankReviews => _rankReviews;

  Future<void> loadReviews() async {
    _isLoading = true;
    notifyListeners(); // 상태가 변경되었음을 UI에 알림

    try {
      final result = await BoardService.getReviewList();
      if (result.isSuccess) {
        _allReviews = result.value?.boardList ?? [];
        _rankReviews = result.value?.topList ?? [];
      }
    } catch (e) {
      // 에러 처리
    } finally {
      _isLoading = false;
      notifyListeners(); // 상태가 변경되었음을 UI에 알림
    }
  }

  // 추가적인 메소드 예제: 실시간 데이터 업데이트
  Future<void> refreshData() async {
    await loadReviews(); // 데이터 다시 로드
  }
}
