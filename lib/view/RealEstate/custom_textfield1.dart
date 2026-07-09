import 'package:flutter/material.dart';

import 'package:rct/constants/constants.dart';

// ignore: must_be_immutable
class Custom_textField extends StatelessWidget {
  String textt;
  String hintText;
  TextInputType? keyboardType;
  TextEditingController controller = TextEditingController();
  Custom_textField({
    super.key,
    required this.hintText,
    required this.textt,
    required this.controller,
    required String? Function(dynamic value) validator,
    this.keyboardType,
    required Null Function(dynamic value) onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                textt,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              keyboardType: keyboardType,
              controller: controller,
              decoration: InputDecoration(
                floatingLabelAlignment: FloatingLabelAlignment.start,
                fillColor: grey.withOpacity(0.5),
                filled: true,
                labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: darkGrey,
                      overflow: TextOverflow.clip,
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 0),
                ),
                // labelStyle: const TextStyle(color: Colors.black45),
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.25), fontSize: 10),
                iconColor: Colors.grey,
              )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
