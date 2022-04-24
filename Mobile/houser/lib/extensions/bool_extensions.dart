import 'package:flutter/material.dart';

extension BoolExtension on bool{
  IconData get iconByStudying
  {
    switch(this){
      case false:
        return Icons.home;
      case true:
      default:
        return Icons.school;
    }
  }

  IconData get iconByWorking
  {
    switch(this){
      case false:
        return Icons.work_off;
      case true:
      default:
        return Icons.work;
    }
  }

  IconData get iconBySmoking
  {
    switch(this){
      case false:
        return Icons.smoke_free;
      case true:
      default:
        return Icons.smoking_rooms;
    }
  }
}