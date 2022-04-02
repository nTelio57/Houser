import 'package:flutter/material.dart';

class LanguageBubble extends StatefulWidget {

  bool isSelected = false;
  String language;
  Color unselectedColor = Colors.green;
  Color selectedColor = const Color(0xFF087f23);

  LanguageBubble({Key? key, required this.language, bool isSelected = false}) : super(key: key);

  @override
  _LanguageBubbleState createState() => _LanguageBubbleState();
}

class _LanguageBubbleState extends State<LanguageBubble> {
  @override
  Widget build(BuildContext context) {
    return languageTag();
  }

  Widget languageTag()
  {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.isSelected = !widget.isSelected;
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.selectedColor,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              width: 2,
              color: const Color.fromRGBO(0, 153, 204, 1),//widget.selectedColor
            )
          ),
          child: Text(
            widget.language.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
