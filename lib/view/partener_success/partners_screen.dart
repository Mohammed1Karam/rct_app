import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/constants/linkapi.dart';
import 'package:rct/view/partener_success/cubit.dart';
import 'package:rct/view/partener_success/partener_details.dart';
import 'package:rct/view/partener_success/partener_states.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<ParetenerCubit, PartenerStates>(
        listener: (context, state) {
          if (state is PartenerFailed) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.message!)),
            // );
          }
        },
        builder: (context, state) {
          if (state is PartenerLoading) {
            return const Center(
              child: Text(""),
            );
          } else if (state is PartenerSuccess) {
            final list = [...?state.data];
            print(list![0].image!);

            if (list!.isEmpty) {
              return const Center(
                child: Text(''),
              );
            }

            return Center(
              child: Column(
                children: [
                  Text(local.successPartners,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.9 / 3,
                        ),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(15),
                        itemCount: list.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PartenerDetailsScreen(
                                          name: list[index].name,
                                          description: list[index].description,
                                          image: list[index].image,
                                        )));
                          },
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.black,
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 199, 195, 195),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "${linkServerName}/${list[index].image!}",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PartenerFailed) {
            return Center(
              child: Text(''),
            );
          } else {
            return const Center(
              child: Text(''),
            );
          }
        },
      ),
    );
  }
}
