import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/common%20copounents/custom_textformfield.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/pop_up.dart';
import 'package:rct/constants/constants.dart';

import 'package:rct/model/receipts_model.dart';
import 'package:rct/view-model/cubits/receipts/receipts_cubit.dart';

import 'package:rct/view-model/functions/image_picker.dart';
import 'package:rct/view-model/functions/snackbar.dart';
import 'package:rct/view/home_screen.dart';

class PaymentReciptScreen extends StatefulWidget {
  final String screenId = "PaymentReciptScreen";
  const PaymentReciptScreen({super.key});

  @override
  State<PaymentReciptScreen> createState() => _PaymentReciptScreenState();
}

class _PaymentReciptScreenState extends State<PaymentReciptScreen> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var local = S.of(context);

    ReceiptsModel receiptsModel =
        Provider.of<ReceiptsModel>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: BlocListener<ReceiptsCubit, ReceiptsState>(
        listener: (context, state) {
          setState(() {
            if (state is ReceiptsFailure) {
              isLoading = false;
              showSnackBar(context, local.errorPleaseTryAgain, redColor);
            } else if (state is ReceiptsSuccess) {
              isLoading = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
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
                      title: Text(local.requestSentSuccessfully),
                      subtitle: Text(local.requestWillBeReviewed),
                    ),
                    ontap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false),
                  );
                },
              );
            } else if (state is ReceiptsLoading) {
              isLoading = true;
            }
          });
        },
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  local.attachTransferReceipt,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: constVerticalPadding),
                InkWell(
                  child: Image.asset("$imagePath/upload-photo.png"),
                  onTap: () => pickImageFromGallery(context)
                      .then((value) => receiptsModel.file = value),
                ),
                SizedBox(height: constVerticalPadding),
                Text(
                  local.otherDetailsOrInformation,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: constVerticalPadding),
                TextFormFieldCustom(
                  context: context,
                  border: false,
                  length: 100,
                  labelText: local.pleaseWriteOtherDetails,
                  onChanged: (value) {
                    receiptsModel.description = value;
                  },
                  controller: controller,
                ),
                SizedBox(height: constVerticalPadding),
                Center(
                  child: MainButton(
                    text: local.submitRequest,
                    backGroundColor: primaryColor,
                    onTap: () async => await context
                        .read<ReceiptsCubit>()
                        .sendReceipt(receiptsModel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
