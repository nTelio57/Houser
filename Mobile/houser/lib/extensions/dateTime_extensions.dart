import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime{
  int get age{
    var today = DateTime.now();
    var age = today.year - year;

    if(today.isAfter(this)) {
      age -= 1;
    }
    return age;
  }

  String dateToString({String format='MM/dd/yyyy'}){
    return DateFormat(format).format(this);
  }
}

extension DateTimeExtensionNullable on DateTime?{
  String dateToString({String format='MM/dd/yyyy'}){
    if(this == null) {
      return '';
    }
    return DateFormat(format).format(this!);
  }
}