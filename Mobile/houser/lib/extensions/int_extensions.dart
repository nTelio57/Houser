extension IntExtension on int{
  bool get isSuccessStatusCode {
    return (this >= 200) && (this <= 299);
  }
}