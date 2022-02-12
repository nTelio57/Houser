import 'package:flutter/material.dart';

class WGDropdown extends StatefulWidget {
  final List<String> values;
  String selectedValue = '';
  final String label;

  WGDropdown({
    Key? key,
    required this.values,
    required this.label,
  }) : super(key: key);

  @override
  _WGDropdownState createState() => _WGDropdownState();
}

class _WGDropdownState extends State<WGDropdown> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body(){
    return dropdown();
  }

  Widget dropdown()
  {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
              hintText: widget.label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: widget.selectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              onChanged: (String? newValue) {
                setState(() {
                  if(newValue != null) {
                    widget.selectedValue = newValue;
                  }
                });
              },
              items: widget.values.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
