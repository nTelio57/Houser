import 'package:flutter/material.dart';

class WGToggleIconButton extends StatefulWidget {

  Color enabledColor;
  Color disabledColor;
  IconData icon;
  bool isEnabled;

  WGToggleIconButton({
    Key? key,
    required this.icon,
    this.enabledColor = Colors.black,
    this.disabledColor = Colors.white38,
    this.isEnabled = false
  }) : super(key: key);

  @override
  _WGToggleIconButtonState createState() => _WGToggleIconButtonState();
}

class _WGToggleIconButtonState extends State<WGToggleIconButton> {
  @override
  Widget build(BuildContext context) {
    widget.enabledColor = Theme.of(context).primaryColorDark;
    widget.disabledColor = Theme.of(context).primaryColorLight;

    return circleBase();
  }

  Widget circleBase()
  {
    var radius = 8.0;
    var buttonSize = 50.0;
    var iconSize = 40.0;

    return TextButton(
      onPressed: () {
        setState(() {
          widget.isEnabled = !widget.isEnabled;
        });
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(width: 4, color: widget.isEnabled ? widget.enabledColor : widget.disabledColor),
        ),
      ),
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: Icon(
          widget.icon,
          size: iconSize,
          color: widget.isEnabled ? widget.enabledColor : widget.disabledColor,
        ),
      ),
    );
  }
}
