import 'package:flutter/material.dart';
import 'package:houser/models/widget_data/multi_button_selection.dart';

class MultiButton extends StatefulWidget {

  final List<MultiButtonSelection> selections;
  final List<bool> _isButtonSelected = [];

  MultiButton({Key? key, required this.selections}) : super(key: key)
  {
    for(int i = 0; i < selections.length; i++)
      {
        _isButtonSelected.add(false);
      }
    _isButtonSelected[0] = true;
  }

  @override
  _MultiButtonState createState() => _MultiButtonState();
}

class _MultiButtonState extends State<MultiButton> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      child: ToggleButtons(
        isSelected: widget._isButtonSelected,
        color: Colors.black54,
        onPressed: (int index) {
          setState(() {
            for (int buttonIndex = 0; buttonIndex < widget._isButtonSelected.length; buttonIndex++) {
              if (buttonIndex == index) {
                widget._isButtonSelected[buttonIndex] = true;
              } else {
                widget._isButtonSelected[buttonIndex] = false;
              }
            }
          });
        },
        children: widget.selections.map((e) => singleButton(e)).toList()
      ),
    );
  }

  Widget singleButton(MultiButtonSelection selection)
  {
    return SizedBox(
        width: (MediaQuery.of(context).size.width-64)/widget.selections.length,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selection.icon != null) selection.icon!,
            if (selection.icon != null) const SizedBox(width: 10),
            Text(selection.title),
          ],
        )
    );
  }
}
