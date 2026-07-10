class InvestorStatusModel {
  final bool isQualifiedInvestor;
  final String requestStatus;
  final bool hasPendingRequest;
  final bool canSubmit;
  final String? rejectionReason;

  InvestorStatusModel({
    required this.isQualifiedInvestor,
    required this.requestStatus,
    required this.hasPendingRequest,
    required this.canSubmit,
    this.rejectionReason,
  });

  factory InvestorStatusModel.fromJson(Map<String, dynamic> json) {
    return InvestorStatusModel(
      isQualifiedInvestor: json['is_qualified_investor'] ?? false,
      requestStatus: json['request_status'] ?? "none",
      hasPendingRequest: json['has_pending_request'] ?? false,
      canSubmit: json['can_submit'] ?? true,
      rejectionReason: json['rejection_reason'],
    );
  }
}
