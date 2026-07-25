import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rct/view/share_rct/details_repository.dart';
import 'package:rct/view/share_rct/investor_upgrade_state.dart';

class InvestorUpgradeCubit extends Cubit<InvestorUpgradeState> {
  final ShareDetailsRepository repository;

  InvestorUpgradeCubit(this.repository) : super(InvestorUpgradeInitial());

  Future<void> getQuestions() async {
    emit(InvestorUpgradeLoading());
    try {
      final questions = await repository.getInvestorUpgradeQuestions();
      emit(InvestorUpgradeSuccess(questions));
    } catch (e) {
      emit(InvestorUpgradeError(e.toString()));
    }
  }

  Future<void> submitUpgrade({
    required Map<int, int> answers,
    required Map<int, List<File>> questionFiles,
  }) async {
    emit(InvestorUpgradeSubmitting());
    try {
      final result = await repository.submitInvestorUpgrade(
        answers: answers,
        questionFiles: questionFiles,
      );
      if (result['status'] == 200 || result['status'] == 201 || result['status'] == "success") {
        emit(InvestorUpgradeSubmitSuccess(result['message'] ?? "Upgrade request submitted successfully"));
      } else {
        emit(InvestorUpgradeSubmitError(result['message'] ?? "Failed to submit upgrade request"));
      }
    } catch (e) {
      emit(InvestorUpgradeSubmitError(e.toString()));
    }
  }

  Future<void> initiatePayment({
    required String type,
    required String id,
    required int count,
  }) async {
    emit(InvestorUpgradeSubmitting()); // Reuse submitting state for loading
    try {
      final result = await repository.initiatePayment(
        type: type,
        id: id,
        count: count,
      );
      if (result['status'] == 200 || result['status'] == 201 || result['status'] == "success") {
        emit(InvestorUpgradePaymentInitiated(
          result['message'] ?? "Payment initiated successfully",
          paymentUrl: result['data']?['payment_url'],
        ));
      } else {
        emit(InvestorUpgradePaymentError(result['message'] ?? "Failed to initiate payment"));
      }
    } catch (e) {
      emit(InvestorUpgradePaymentError(e.toString()));
    }
  }
}
