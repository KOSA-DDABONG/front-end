String formatPhoneNumber(String phoneNumber) {
  // 정규식을 이용해 전화번호를 '010-3333-2222' 형태로 변환
  final regex = RegExp(r'(\d{3})(\d{4})(\d{4})');
  final match = regex.firstMatch(phoneNumber);

  if (match != null) {
    return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
  } else {
    // 변환이 실패할 경우 원본 번호를 반환
    return phoneNumber;
  }
}