class Config {
  static const String appName = "TripFlow";

  static const apiUrl = "localhost:8080";

  //User
  static const loginAPI = "/user/login"; //로그인
  static const signupAPI = "/user/register"; //회원가입

  //Board
  static const getBoardListAPI = "/list"; //게시물 리스트 조회 (콘테스트, 전체)
  static const getBoardInfoAPI = "/list/"; //게시물 상세 조회 + {postid} path 파라미터로 추가
  static const registerCommentAPI = "/list/savecomment"; //댓글 작성
  static const registerReviewAPI = "/board/saveReview"; //게시물(후기) 작성

  //My
  static const getMyReviewListAPI = "/my/myReviewList"; //내가 쓴 후기 리스트
  static const getMyTravelListAPI = "/my/mySavedTravel"; //내가 저장한 여행일정 리스트

  //Travel
  static const getCreatedTravelDetailAPI = ""; //여행 일정 생성 결과 불러오기

  //Sample
  static const sampleAPI = "/sample";
}
