extension StringExtension on String{
  bool get hasUpperCase{
    String pattern = r'^(?=.*?[A-Z])';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(this);
  }

  bool get isValidEmail{
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(this);
  }
}