import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rct/common%20copounents/custom_text.dart';
import 'package:rct/common%20copounents/main_button.dart';
import 'package:rct/common%20copounents/sharewepview.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/model/investor_upgrade_model.dart';
import 'package:rct/view/share_rct/details_repository.dart';
import 'package:rct/view/share_rct/investor_upgrade_cubit.dart';
import 'package:rct/view/share_rct/investor_upgrade_state.dart';

class QualifiedInvestorBottomSheet extends StatefulWidget {
  final String? opportunityId;
  final int? count;
  const QualifiedInvestorBottomSheet({
    super.key,
    this.opportunityId,
    this.count,
  });

  @override
  State<QualifiedInvestorBottomSheet> createState() =>
      _QualifiedInvestorBottomSheetState();
}

class _QualifiedInvestorBottomSheetState extends State<QualifiedInvestorBottomSheet> {
  // Map of question ID to response (0: No, 1: Yes)
  Map<int, int> answersMap = {};
  List<File> selectedFiles = [];
  late InvestorUpgradeCubit _cubit;
  List<InvestorQuestion> _currentQuestions = [];
  String? _pendingPaymentUrl;

  @override
  void initState() {
    super.initState();
    _cubit = InvestorUpgradeCubit(ShareDetailsRepository())..getQuestions();
  }

  void _showSuccessDialog(BuildContext context) {
    final local = S.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Icon(Icons.close, color: Colors.black, size: 24.sp),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.r),
              decoration: const BoxDecoration(
                color: Color(0xFFE5E7EB),
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF20262F),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 30.sp),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: local.requestSentSuccessfully,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF20262F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            CustomText(
              text: local.requestWillBeReviewed,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF8A8A8A),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            MainButton(
              width: 120.w,
              text: local.ok,
              backGroundColor: const Color(0xFF20262F),
              onTap: () => Navigator.pop(dialogContext),
            ),
          ],
        ),
      ),
    ).then((_) {
      if (mounted) {
        if (_pendingPaymentUrl != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SharePaymentWebViewScreen(paymentUrl: _pendingPaymentUrl!),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  void _onUpgradeSubmitted() {
    _showSuccessDialog(context);
    if (widget.opportunityId != null && widget.opportunityId!.isNotEmpty && widget.count != null) {
      _cubit.initiatePayment(
        type: "opportunity",
        id: widget.opportunityId!,
        count: widget.count!,
      );
    }
  }

  void _handleResponse(int questionId, int value) {
    setState(() {
      if (value == 1) {
        // If 'Yes' is selected, set all others to 'No' (0)
        answersMap.forEach((id, _) {
          answersMap[id] = 0;
        });
        answersMap[questionId] = 1;
      } else {
        // If 'No' is selected, just update this one
        answersMap[questionId] = 0;
      }
    });
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = S.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<InvestorUpgradeCubit, InvestorUpgradeState>(
        listener: (context, state) {
          if (state is InvestorUpgradeSubmitSuccess) {
            _onUpgradeSubmitted();
          } else if (state is InvestorUpgradePaymentInitiated) {
            _pendingPaymentUrl = state.paymentUrl;
          } else if (state is InvestorUpgradePaymentError) {
            // No snackbar for payment errors as per user request
          } else if (state is InvestorUpgradeSubmitError || state is InvestorUpgradeError) {
            String message = "";
            if (state is InvestorUpgradeSubmitError) message = state.message;
            if (state is InvestorUpgradeError) message = state.message;

            if (answersMap.isNotEmpty && message.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Spacer for centering title
                  CustomText(
                    text: local.upgrade_to_qualified_investor,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF20262F),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: const Color(0xFF8A8A8A), size: 24.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              const Divider(color: Color(0xFFEEEEEE)),
              Expanded(
                child: BlocBuilder<InvestorUpgradeCubit, InvestorUpgradeState>(
                  builder: (context, state) {
                    if (state is InvestorUpgradeLoading) {
                      return const Center(child: CircularProgressIndicator(color: Colors.black));
                    } else if (state is InvestorUpgradeError && answersMap.isEmpty) {
                      return Center(child: CustomText(text: state.message));
                    } else if (state is InvestorUpgradeSuccess || 
                               state is InvestorUpgradeSubmitting || 
                               state is InvestorUpgradeSubmitSuccess ||
                               (state is InvestorUpgradeError && answersMap.isNotEmpty) ||
                               state is InvestorUpgradePaymentInitiated) {
                      
                      if (state is InvestorUpgradeSuccess) {
                        _currentQuestions = state.questions;
                        for (var q in _currentQuestions) {
                          answersMap.putIfAbsent(q.id, () => 0);
                        }
                      }

                      if (_currentQuestions.isEmpty) {
                        return Center(child: CustomText(text: "No questions available"));
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._currentQuestions.map((question) {
                              return _buildQuestionItem(question);
                            }).toList(),
                            SizedBox(height: 24.h),
                            _buildUploadSection(local),
                            SizedBox(height: 24.h),
                            _buildSelectedFilesList(),
                            SizedBox(height: 32.h),
                            if (state is InvestorUpgradeSubmitting)
                              const Center(child: CircularProgressIndicator(color: Colors.black))
                            else
                              MainButton(
                                width: double.infinity,
                                text: local.submit_upgrade_request,
                                backGroundColor: selectedFiles.isNotEmpty ? const Color(0xFF20262F) : const Color(0xFFE0E0E0),
                                textColor: selectedFiles.isNotEmpty ? Colors.white : const Color(0xFF8A8A8A),
                                onTap: () {
                                  if (selectedFiles.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(local.please_upload_document),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  int yesId = -1;
                                  answersMap.forEach((id, value) {
                                    if (value == 1) yesId = id;
                                  });

                                  if (yesId == -1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(local.please_answer_yes_condition),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  Map<int, List<File>> questionFiles = {
                                    yesId: selectedFiles
                                  };

                                  _cubit.submitUpgrade(
                                    answers: answersMap,
                                    questionFiles: questionFiles,
                                  );
                                },
                              ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionItem(InvestorQuestion question) {
    final local = S.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: question.question,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildRadioButton(
                  label: local.yes,
                  isSelected: answersMap[question.id] == 1,
                  onTap: () => _handleResponse(question.id, 1),
                ),
                SizedBox(width: 40.w),
                _buildRadioButton(
                  label: local.no,
                  isSelected: answersMap[question.id] == 0,
                  onTap: () => _handleResponse(question.id, 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? const Color(0xFF20262F) : const Color(0xFF8A8A8A),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF20262F) : const Color(0xFFD0D0D0),
                width: isSelected ? 6.r : 2.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection(S local) {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/icons/cloudIcon.svg",
              width: 32.w,
              height: 32.h,
              colorFilter: const ColorFilter.mode(Color(0xFF2E7D32), BlendMode.srcIn),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: CustomText(
                text: local.upload_portfolio_reports,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF8A8A8A),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: local.supported_formats,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xFFBCBCBC),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFilesList() {
    return Column(
      children: selectedFiles.map((file) {
        String fileName = file.path.split('/').last;
        bool isPdf = fileName.toLowerCase().endsWith('.pdf');
        
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Row(
            children: [
              Icon(
                isPdf ? Icons.picture_as_pdf : Icons.image,
                color: const Color(0xFF8A8A8A),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF20262F),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${(file.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB",
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: const Color(0xFF8A8A8A),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFiles.remove(file);
                  });
                },
                child: Icon(Icons.close, color: const Color(0xFF8A8A8A), size: 20.sp),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
