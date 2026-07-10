import 'package:rct/model/investor_upgrade_model.dart';

abstract class InvestorUpgradeState {}

class InvestorUpgradeInitial extends InvestorUpgradeState {}

class InvestorUpgradeLoading extends InvestorUpgradeState {}

class InvestorUpgradeSuccess extends InvestorUpgradeState {
  final List<InvestorQuestion> questions;
  InvestorUpgradeSuccess(this.questions);
}

class InvestorUpgradeError extends InvestorUpgradeState {
  final String message;
  InvestorUpgradeError(this.message);
}

class InvestorUpgradeSubmitError extends InvestorUpgradeState {
  final String message;
  InvestorUpgradeSubmitError(this.message);
}

class InvestorUpgradePaymentError extends InvestorUpgradeState {
  final String message;
  InvestorUpgradePaymentError(this.message);
}

class InvestorUpgradeSubmitting extends InvestorUpgradeState {}

class InvestorUpgradeSubmitSuccess extends InvestorUpgradeState {
  final String message;
  InvestorUpgradeSubmitSuccess(this.message);
}

class InvestorUpgradePaymentInitiated extends InvestorUpgradeState {
  final String message;
  final String? paymentUrl;
  InvestorUpgradePaymentInitiated(this.message, {this.paymentUrl});
}
