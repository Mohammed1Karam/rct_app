import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_dropdownlist.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';
import 'package:rct/model/order_model.dart';
import 'package:rct/model/realEstatemodel.dart';

import 'package:rct/view-model/functions/snackbar.dart';

import 'package:rct/view-model/cubits/final_orders/final_orders_cubit.dart';
import 'package:rct/view-model/cubits/final_orders/final_orders_states.dart';
import 'package:rct/view/home_screen.dart';

class SketchForm extends StatefulWidget {
  final dynamic id;
  final dynamic price;
  SketchForm({super.key, required this.id, required this.price});

  @override
  State<SketchForm> createState() => _SketchFormState();
}

class _SketchFormState extends State<SketchForm> {
  final TextEditingController controller = TextEditingController();
  String? _selectedType;
  List<String> items = [];
  bool _noOrderNumber = false;

  @override
  void initState() {
    super.initState();
    OrderModel orderModel = Provider.of<OrderModel>(context, listen: false);
    items = orderModel.orderNumbers;
  }

  Future<void> _submitOrder() async {
    var local = S.of(context);
    if (!_noOrderNumber && (_selectedType == null || _selectedType!.isEmpty)) {
      showSnackBar(context, local.pleaseChooseRequestNumber, redColor);
      return;
    }
    _noOrderNumber
        ? context.read<FinalOrdersCubit>().PostSketchWithoutOrderNum(
              id: widget.id.toString(),
              price: widget.price.toString(),
            )
        : await context.read<FinalOrdersCubit>().PostSketch(context);
  }

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);
    HouseModel housemodel = Provider.of<HouseModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocConsumer<FinalOrdersCubit, FinalOrdersStates>(
        listener: (context, state) {
          if (state is SketchLoading22) {
            setState(() {});
          } else if (state is SketchFaild22) {
            showSnackBar(context, state.message, redColor);
          } else if (state is SketchSuccess22) {
            showDialog(
              context: context,
              builder: (context) {
                return ShowPopUp(
                  title: Center(
                    child: Image.asset(
                      "assets/icons/popUp-icon.png",
                      height: 50.h,
                      width: 50.w,
                    ),
                  ),
                  content: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(local.requestSentSuccessfully,
                        textAlign: TextAlign.center),
                    subtitle: Text(local.requestWillBeReviewed,
                        textAlign: TextAlign.center),
                  ),
                  ontap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false,
                  ),
                );
              },
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(local.otherDetailsOrInformation,
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(height: 10),
                  TextFormFieldCustom(
                    context: context,
                    border: false,
                    length: 100,
                    labelText: local.pleaseWriteOtherDetails,
                    controller: controller,
                    onChanged: (String) {},
                  ),
                  SizedBox(height: 20),
                  if (!_noOrderNumber) ...[
                    Text(local.enterRequestNumber,
                        style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: 10),
                    CustomDropDownList(
                      list: items,
                      selectedValue: _selectedType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue ?? '';
                        });
                      },
                      hint: local.pleaseChooseRequestNumber,
                    ),
                    SizedBox(height: 10),
                  ],
                  /*CheckboxListTile(
                    title: Text(local.noordernumber),
                    value: _noOrderNumber,
                    onChanged: (bool? value) {
                      setState(() {
                        _noOrderNumber = value ?? false;
                        if (_noOrderNumber) _selectedType = null;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),*/
                  SizedBox(height: 10),
                  Center(
                    child: MainButton(
                        text: local.submitRequest,
                        backGroundColor: primaryColor,
                        onTap: () async {
                          housemodel.orderNumber = _selectedType.toString();

                          housemodel.description =
                              controller.text.isEmpty ? "..." : controller.text;
                          housemodel.design_id = widget.id.toString();

                          print(housemodel.orderNumber);
                          if(!_noOrderNumber && (housemodel.orderNumber == null || housemodel.orderNumber!.isEmpty)){
                            showSnackBar(context, local.pleaseChooseRequestNumber, redColor);
                            return;
                          }
                          await _submitOrder();
                        }),
                  ),
                  if (state is SketchLoading22)
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
