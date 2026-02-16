import 'package:flutter/material.dart';

class NotifiHistoryContainer extends StatelessWidget {
  final String blackText;
  final String blueText;
  final String time;
  const NotifiHistoryContainer(
      {super.key,
      required this.blackText,
      required this.blueText,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ListTile(
            title: Center(
              child: Text.rich(
                style: Theme.of(context).textTheme.bodyMedium,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "$blackText ",
                    ),
                    TextSpan(
                        text: blueText,
                        style: const TextStyle(
                          color: Colors.blue,
                        )),
                  ],
                ),
              ),
            ),
            titleAlignment: ListTileTitleAlignment.center,
            minVerticalPadding: 10,
            trailing: Text(
              time,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
