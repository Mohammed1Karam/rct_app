import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/model/renter_model.dart';
import 'package:rct/shared_pref.dart';
import 'package:rct/view/ownership/renters_cubit.dart';

import '../../generated/l10n.dart';
import '../privacy_screen.dart';
import '../terms_conditions_screen.dart';

class ContractScreen extends StatefulWidget {
  ContractScreen({
    super.key,
    required this.renterModel, required this.numOfUnits,

  });
  final RenterModel renterModel;
  final int numOfUnits;

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RentersCubit, RentersState>(
  listener: (context, state) {
    if (state is PayContractError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message.toString()),
        ),
      );
    }
  },
  builder: (context, state) {
    return ModalProgressHUD(
      inAsyncCall: state is PayContractLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: BackButtonAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(S.of(context).renter_contract,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
                SizedBox(height: 20),
                Text(S.of(context).contract_m1,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                Text(S.of(context).contract_m2,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(height: 10),
                Text(
                    S.of(context).contract_m9 + "${AppPreferences.getData(key: "username")}- ${S.of(context).phone} ${AppPreferences.getData(key: "phone")}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                Text(S.of(context).contract_m3,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(height: 10),
                ContractFields(
                  title: S.of(context).renter_details,
                  subtitle: "",
                ),
                ContractFields(
                  title: S.of(context).renter_value,
                  subtitle: widget.renterModel.price.toString(),
                ),
                ContractFields(
                  title: S.of(context).renter_type,
                  subtitle: S.of(context).renter,
                ),
                ContractFields(
                  title: S.of(context).renter_location,
                  subtitle: "${widget.renterModel.city}" +
                      "-" +
                      "${widget.renterModel.district}",
                ),
                ContractFields(
                  title: S.of(context).renter_area,
                  subtitle: widget.renterModel.area.toString(),
                ),
                ContractFields(
                  title: S.of(context).renter_age,
                  subtitle: widget.renterModel.age.toString(),
                ),
                ContractFields(
                  title: S.of(context).first_batch,
                  subtitle: widget.renterModel.firstPayment.toString(),
                ),
                ContractFields(
                  title: S.of(context).first_batch_date,
                  subtitle: "",
                ),
                ContractFields(
                  title: S.of(context).first_batch_value,
                  subtitle: widget.renterModel.firstPayment.toString(),
                ),
                ContractFields(
                  title: S.of(context).num_of_units,
                  subtitle: widget.numOfUnits.toString(),
                ),
                ContractFields(
                  title: S.of(context).payment_duration,
                  subtitle: widget.renterModel.paymentDuration.toString(),
                ),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    children: [
                      TextSpan(text: S.of(context).payment_plan),
                      TextSpan(text: " : "),
                      TextSpan(text: S.of(context).monthly_value),
                      TextSpan(
                        text: "${widget.renterModel.paymentPlan} ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: S.of(context).sar),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                    S.of(context).contract_m4,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                SizedBox(height: 20),
                Text(S.of(context).logecl_note,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                Text(
                    S.of(context).contract_m5,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text:
                              S.of(context).contract_m6),
                      TextSpan(text: " "),
                      TextSpan(
                        text: S.of(context).termsConditions,
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()));
                          },
                      ),
                      TextSpan(
                        text: " , ",
                      ),
                      TextSpan(
                        text: S.of(context).privacyPolicy,
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PrivacysScreen()));
                          },
                      ),
                      TextSpan(text: " "),
                      TextSpan(text: S.of(context).contract_m7),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Checkbox(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        value: value,
                        onChanged: (onChanged) {
                          setState(() {
                            value = onChanged!;
                          });
                        }),
                    Expanded(
                      child: Text(S.of(context).contract_m8,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(child: Image.asset("assets/images/logo.png", height: 100)),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    if (value) {
                        BlocProvider.of<RentersCubit>(context).PayContract(
                          context: context,
                          model: widget.renterModel,
                          unitsCount: widget.numOfUnits
                        );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).agree_the_contract),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: value ? Color(0xff263238) : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).continue_to_pay,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }
}

class ContractFields extends StatelessWidget {
  const ContractFields({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
        children: [
          TextSpan(text: title),
          TextSpan(text: " : "),
          TextSpan(
            text: subtitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
