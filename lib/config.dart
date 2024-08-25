class Config {
  static const String appName = "TripFlow";

  static const apiUrl = "localhost:8080";

  //User
  static const loginAPI = "/user/login"; //로그인
  static const signupAPI = "/user/register"; //회원가입

  //Board
  static const getBoardListAPI = "/list"; //게시물 리스트 조회 (콘테스트, 전체)
  static const getBoardInfoAPI = "/post/"; //게시물 상세 조회 + {postid} path 파라미터로 추가
  static const registerCommentAPI = "/post/comment"; //댓글 작성
  static const registerReviewAPI = "/board/saveReview"; //게시물(후기) 작성
  static const savePostAPI = "/post/board/saveReview"; //게시물(후기) 작성
  static const updateLikesListAPI = "/list/"; //좋아요 업데이트
  static const updateLikesAPI = "/changelike"; //좋아요 업데이트

  //My
  static const getUserBoardListAPI = "/myinfo/review/list"; //내가 쓴 후기 리스트
  static const getMyTravelListAPI = "/my/mySavedTravel"; //내가 저장한 여행일정 리스트
  static const getMyLikesListAPI = "/mylist"; //나의 좋아요 리스트

  //Travel
  static const getResponseForCreateScheduleAPI = "/making"; //여행 일정 요청 전달 및 응답 받아오기

  //Chat
  static const getChatConnectionAPI = "/chat/start"; //챗봇 연결 여부 받아오기
  static const getChatConversationAPI = "/chat/conversation"; //메세지 전송 및 챗 메세지 받아오기
  static const sendUserResponseAPI = "/chat/userResponse"; //생성된 여행 일정 결과에 대한 사용자 반응 전달하기

  //Sample
  static const sampleAPI = "/sample";
}
