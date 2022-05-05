import 'package:flutter/material.dart';
import 'package:houser/models/multi_button_selection.dart';

// ignore: must_be_immutable
class WGMultiButton extends StatefulWidget {

  final List<MultiButtonSelection> selections;
  List<bool> isButtonSelected = [];
  bool multiSelection;
  bool canHaveNull;

  WGMultiButton({Key? key, required this.selections, this.multiSelection = false, this.canHaveNull = false}) : super(key: key)
  {
    for(int i = 0; i < selections.length; i++)
      {
        isButtonSelected.add(false);
      }
    isButtonSelected[0] = true;
  }

  @override
  _WGMultiButtonState createState() => _WGMultiButtonState();
}

class _WGMultiButtonState extends State<WGMultiButton> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      child: ToggleButtons(
        isSelected: widget.isButtonSelected,
        color: Colors.black54,
        onPressed: (int index) {
          setState(() {
            if(widget.multiSelection)
              {
                widget.isButtonSelected[index] = !widget.isButtonSelected[index];
              }
            else
              {
                for (int buttonIndex = 0; buttonIndex < widget.isButtonSelected.length; buttonIndex++) {
                  if (buttonIndex == index) {
                    if(widget.canHaveNull)
                      {
                        widget.isButtonSelected[buttonIndex] = !widget.isButtonSelected[buttonIndex];
                      }
                    else
                      {
                        widget.isButtonSelected[buttonIndex] = true;
                      }
                  } else {
                    widget.isButtonSelected[buttonIndex] = false;
                  }
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
    return Container(
        width: (MediaQuery.of(context).size.width-64)/widget.selections.length,
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selection.icon != null) selection.icon!,
            if (selection.icon != null) const SizedBox(width: 10),
            Expanded(
              child: Text(selection.title)
            ),
          ],
        )
    );
  }
}
