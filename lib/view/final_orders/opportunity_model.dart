class OpportunityModel {
  final Opportunity opportunity;
  final MyInvestmentSummary myInvestmentSummary;

  OpportunityModel({
    required this.opportunity,
    required this.myInvestmentSummary,
  });

  factory OpportunityModel.fromMap(Map<String, dynamic> json) => OpportunityModel(
    opportunity: Opportunity.fromMap(json["opportunity"]),
    myInvestmentSummary: MyInvestmentSummary.fromMap(json["my_investment_summary"]),
  );

  Map<String, dynamic> toMap() => {
    "opportunity": opportunity.toMap(),
    "my_investment_summary": myInvestmentSummary.toMap(),
  };
}

class MyInvestmentSummary {
  final int totalInvested;
  final int transactionsCount;
  final int totalReturnsCreated;
  final double totalReturnsAmount;
  final int paidReturns;
  final int pendingReturns;
  final int lateReturns;
  final NextReturn? nextReturn;

  MyInvestmentSummary({
    required this.totalInvested,
    required this.transactionsCount,
    required this.totalReturnsCreated,
    required this.totalReturnsAmount,
    required this.paidReturns,
    required this.pendingReturns,
    required this.lateReturns,
    required this.nextReturn,
  });

  factory MyInvestmentSummary.fromMap(Map<String, dynamic> json) => MyInvestmentSummary(
    totalInvested: json["total_invested"] ?? 0,
    transactionsCount: json["transactions_count"] ?? 0,
    totalReturnsCreated: json["total_returns_created"] ?? 0,
    totalReturnsAmount: (json["total_returns_amount"] ?? 0).toDouble(),
    paidReturns: json["paid_returns"] ?? 0,
    pendingReturns: json["pending_returns"] ?? 0,
    lateReturns: json["late_returns"] ?? 0,
    nextReturn: json["next_return"] != null ? NextReturn.fromMap(json["next_return"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "total_invested": totalInvested,
    "transactions_count": transactionsCount,
    "total_returns_created": totalReturnsCreated,
    "total_returns_amount": totalReturnsAmount,
    "paid_returns": paidReturns,
    "pending_returns": pendingReturns,
    "late_returns": lateReturns,
    "next_return": nextReturn?.toMap(),
  };
}

class Opportunity {
  final int id;
  final String name;
  final String type;
  final String projectDuration;
  final int typeOfReturn;
  final String status;
  final String description;
  final String location;
  final String totalPrice;
  final String opportunityPrice;
  final String percentNumber;
  final String opportunityCount;
  final dynamic numberTime;
  final int numberOpportunityPay;
  final int userId;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Opportunity({
    required this.id,
    required this.name,
    required this.type,
    required this.projectDuration,
    required this.typeOfReturn,
    required this.status,
    required this.description,
    required this.location,
    required this.totalPrice,
    required this.opportunityPrice,
    required this.percentNumber,
    required this.opportunityCount,
    required this.numberTime,
    required this.numberOpportunityPay,
    required this.userId,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.image4,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Opportunity.fromMap(Map<String, dynamic> json) => Opportunity(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? '',
    type: json["type"]?.toString() ?? '',
    projectDuration: json["project_duration"]?.toString() ?? '',
    typeOfReturn: json["type_of_return"] ?? 0,
    status: json["status"]?.toString() ?? '',
    description: json["description"]?.toString() ?? '',
    location: json["location"]?.toString() ?? '',
    totalPrice: json["total_price"]?.toString() ?? '',
    opportunityPrice: json["opportunity_price"]?.toString() ?? '',
    percentNumber: json["percent_number"]?.toString() ?? '',
    opportunityCount: json["opportunity_count"]?.toString() ?? '',
    numberTime: json["number_time"],
    numberOpportunityPay: json["number_opportunity_pay"] ?? 0,
    userId: json["user_id"] ?? 0,
    image1: json["image1"]?.toString() ?? '',
    image2: json["image2"]?.toString() ?? '',
    image3: json["image3"]?.toString() ?? '',
    image4: json["image4"]?.toString() ?? '',
    createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
    updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "type": type,
    "project_duration": projectDuration,
    "type_of_return": typeOfReturn,
    "status": status,
    "description": description,
    "location": location,
    "total_price": totalPrice,
    "opportunity_price": opportunityPrice,
    "percent_number": percentNumber,
    "opportunity_count": opportunityCount,
    "number_time": numberTime,
    "number_opportunity_pay": numberOpportunityPay,
    "user_id": userId,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "image4": image4,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class NextReturn {
  final int id;
  final int installmentNumber;
  final String amount;
  final String dueDate;
  final String status;
  final dynamic paidAt;
  final User user;
  final PaymentTransaction paymentTransaction;
  final DateTime createdAt;
  final DateTime updatedAt;

  NextReturn({
    required this.id,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.paidAt,
    required this.user,
    required this.paymentTransaction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NextReturn.fromMap(Map<String, dynamic> json) => NextReturn(
    id: json["id"] ?? 0,
    installmentNumber: json["installment_number"] ?? 0,
    amount: json["amount"]?.toString() ?? '',
    dueDate: json["due_date"]?.toString() ?? '',
    status: json["status"]?.toString() ?? '',
    paidAt: json["paid_at"],
    user: User.fromMap(json["user"]),
    paymentTransaction: PaymentTransaction.fromMap(json["payment_transaction"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "installment_number": installmentNumber,
    "amount": amount,
    "due_date": dueDate,
    "status": status,
    "paid_at": paidAt,
    "user": user.toMap(),
    "payment_transaction": paymentTransaction.toMap(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"]?.toString() ?? '',
    email: json["email"]?.toString() ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
  };
}

class PaymentTransaction {
  final int id;
  final String transId;
  final String amount;
  final String opportunityCount;

  PaymentTransaction({
    required this.id,
    required this.transId,
    required this.amount,
    required this.opportunityCount,
  });

  factory PaymentTransaction.fromMap(Map<String, dynamic> json) => PaymentTransaction(
    id: json["id"] ?? 0,
    transId: json["trans_id"]?.toString() ?? '',
    amount: json["amount"]?.toString() ?? '',
    opportunityCount: json["opportunity_Count"]?.toString() ?? '',
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "trans_id": transId,
    "amount": amount,
    "opportunity_Count": opportunityCount,
  };
}