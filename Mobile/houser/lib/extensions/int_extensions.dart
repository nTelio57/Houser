import 'package:flutter/material.dart';

extension IntExtension on int{
  bool get isSuccessStatusCode {
    return (this >= 200) && (this <= 299);
  }

  String get sexToString {
    switch(this)
    {
      case 0:
        return 'Vyras';
      case 1:
        return 'Moteris';
      default:
        return 'Kita';
    }
  }

  String get animalCountToString {
    if(this == 1) {
      return 'Turiu $this gyvūną';
    }
    if(this > 1) {
      return 'Turiu $this gyvūnus';
    }
    return 'Neturiu gyvūnų';
  }

  String get guestCountToString {
    switch(this ~/ 2)
    {
      case 5:
        return 'Svečių turiu labai dažnai';
      case 4:
      case 3:
        return 'Svečių turiu dažnai';
      case 2:
      case 1:
        return 'Svečių turiu retai';
      default:
        return 'Svečių beveik neturiu';
    }
  }

  String get partyCountToString {
    switch(this)
    {
      case 5:
        return 'Mėgstu labai dažnus vakarėlius';
      case 4:
      case 3:
        return 'Vakarėlius turėčiau dažnai';
      case 2:
        return 'Vakarėlių turėčiau mažai';
      case 1:
        return 'Vakarėlių turėčiau labai mažai';
      default:
        return 'Vakarėlių beveik neturėčiau';
    }
  }

  String get sleepTypeToString {
    switch(this)
    {
      case 2:
        return 'Esu pelėda';
      case 0:
        return 'Esu vyturys';
      case 1:
      default:
        return 'Nesu nei pelėda, nei vyturys';
    }
  }

  IconData get iconBySex
  {
    switch(this){
      case 0:
        return Icons.male;
      case 1:
        return Icons.female;
      case 2:
        return Icons.transgender;
      default:
        return Icons.male;
    }
  }

  IconData get iconBySleepType
  {
    switch(this){
      case 2:
        return Icons.nights_stay;
      case 0:
        return Icons.wb_sunny;
      case 1:
      default:
        return Icons.compare_arrows;
    }
  }
}