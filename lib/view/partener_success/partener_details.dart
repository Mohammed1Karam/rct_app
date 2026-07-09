import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/partener_success/partener_states.dart';

// ignore: must_be_immutable
class PartenerDetailsScreen extends StatefulWidget {
  PartenerDetailsScreen({super.key,required this.name, required this.image, required this.description});
  final String? name,description,image;

  @override
  State<PartenerDetailsScreen> createState() => _PartenerDetailsScreenState();
}

class _PartenerDetailsScreenState extends State<PartenerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when the screen initializes
    // context.read<ParetenerCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            if (widget.image != null)
              Container(
                  height: 200,
                  width: 200,
                  child: Image.network(
                      "${linkServerName}/${widget.image}")),
           Text(widget.name??""),
            const SizedBox(height: 20),
              Text(
                widget.description??"",
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
