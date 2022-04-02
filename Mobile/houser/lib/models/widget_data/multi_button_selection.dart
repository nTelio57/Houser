import 'package:flutter/material.dart';

class MultiButtonSelection
{
  String title;
  Icon? icon;
  bool isSelected;

  MultiButtonSelection(this.title, this.icon, {this.isSelected = false});
}