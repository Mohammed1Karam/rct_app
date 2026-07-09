import 'package:flutter/material.dart';
import 'package:rct/constants/constants.dart';

class CustomDropDownList extends StatelessWidget {
  final List<String> list;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String hint;
  const CustomDropDownList(
      {super.key,
      required this.list,
      this.selectedValue,
      required this.onChanged,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    // String? _selectedType = selectedValue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: DropdownButton(
          underline: SizedBox.shrink(),
          dropdownColor: Colors.white,
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              fontFamily: 'URW-DIN-Arabic',
              fontSize: 10,
              color: Colors.black,
            ),
          ),
          style: TextStyle(
            fontSize: 10,
            fontFamily: 'URW-DIN-Arabic',
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(10),
          onChanged: onChanged,
          items: [
            ...list.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }),
          ],
        ),
      ),
    );
  }
}
