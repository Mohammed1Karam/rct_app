import 'package:flutter/material.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

class EmprtScreen extends StatefulWidget {
  const EmprtScreen({super.key});

  @override
  State<EmprtScreen> createState() => _EmprtScreenState();
}

class _EmprtScreenState extends State<EmprtScreen> {
  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Center(
              child: Text(
                local.theserviceiscurrentlyunavailable,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
