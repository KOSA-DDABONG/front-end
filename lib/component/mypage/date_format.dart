String changeDateFormat(String date) {
  // 정규식을 이용해 날짜를 '2000-01-29' 형태로 변환
  final regex = RegExp(r'(\d{4})(\d{2})(\d{2})');
  final match = regex.firstMatch(date);

  if (match != null) {
    return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
  } else {
    // 변환이 실패할 경우 원본 날짜를 반환
    return date;
  }
}