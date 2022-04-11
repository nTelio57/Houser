import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WGSlider extends StatefulWidget {
  double min, max;
  double selectedValue = 0;
  bool canBeMoreThanMax;
  String label = '';
  Function() onValueChange = (){};

  WGSlider({Key? key,
    this.min = 0,
    this.max = 5,
    this.canBeMoreThanMax = false,
  }) : super(key: key){
    selectedValue = (min + (max - min)/2).floorToDouble();
    label = selectedValue.toInt().toString();
  }

  @override
  _WGSliderState createState() => _WGSliderState();
}

class _WGSliderState extends State<WGSlider> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      child: slider(),
    );
  }

  Widget slider()
  {
    return Slider(
      value: widget.selectedValue,
      max: widget.max,
      min: widget.min,
      divisions: widget.max.toInt(),
      activeColor: const Color.fromRGBO(0, 153, 204, 1),
      label: label(),
      onChanged: (value) {
        setState(() {
          widget.selectedValue = value;
        });
        widget.label = label();
        widget.onValueChange();
      },
    );
  }

  String label()
  {

    if(widget.selectedValue == widget.max && widget.canBeMoreThanMax) {
      return '>'+widget.selectedValue.toInt().toString();
    }
    return widget.selectedValue.toInt().toString();
  }
}
