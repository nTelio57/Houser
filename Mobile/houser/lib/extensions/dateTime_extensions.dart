extension DateTimeExtension on DateTime{
  int get age{
    var today = DateTime.now();
    var age = today.year - year;

    var compareYear = DateTime(today.year-1, today.month, today.day);
    if(today.isAfter(this)) {
      age -= 1;
    }
    return age;
  }
}