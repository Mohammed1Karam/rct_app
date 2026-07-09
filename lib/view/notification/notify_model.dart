class NotificationModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String messageAr;
  final String messageEn;
  final String type;
  final NotificationData data;
  final DateTime createdAt;
  final DateTime? readAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.messageAr,
    required this.messageEn,
    required this.type,
    required this.data,
    required this.createdAt,
    this.readAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      messageAr: json['message_ar'] ?? '',
      messageEn: json['message_en'] ?? '',
      type: json['type'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'message_ar': messageAr,
      'message_en': messageEn,
      'type': type,
      'data': data.toJson(),
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'is_read': isRead,
    };
  }

  // Helper method to get title based on current locale
  String getTitle(String locale) {
    return locale == 'ar' ? titleAr : titleEn;
  }

  // Helper method to get message based on current locale
  String getMessage(String locale) {
    return locale == 'ar' ? messageAr : messageEn;
  }

  NotificationModel copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? messageAr,
    String? messageEn,
    String? type,
    NotificationData? data,
    DateTime? createdAt,
    DateTime? readAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      messageAr: messageAr ?? this.messageAr,
      messageEn: messageEn ?? this.messageEn,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
class NotificationData {
  final String type;
  final String? title;
  final String? body;
  final String? titleAr;
  final String? titleEn;
  final String? messageAr;
  final String? messageEn;
  final String? action;
  final dynamic actionData; // Changed to dynamic to handle both Map and List
  final String? timestamp;
  final String? amount;
  final int? returnId;
  final int? opportunityId;
  final int? userId;
  final String? oldStatus;
  final String? newStatus;
  final int? orderId;
  final int? contractId;
  final int? installmentId;
  final int? installmentNumber;
  final String? dueDate;
  final ExtraData? extra; // New field for rawland_notification

  NotificationData({
    required this.type,
    this.title,
    this.body,
    this.titleAr,
    this.titleEn,
    this.messageAr,
    this.messageEn,
    this.action,
    this.actionData,
    this.timestamp,
    this.amount,
    this.returnId,
    this.opportunityId,
    this.userId,
    this.oldStatus,
    this.newStatus,
    this.orderId,
    this.contractId,
    this.installmentId,
    this.installmentNumber,
    this.dueDate,
    this.extra,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      type: json['type'] ?? '',
      title: json['title'],
      body: json['body'],
      titleAr: json['title_ar'],
      titleEn: json['title_en'],
      messageAr: json['message_ar'],
      messageEn: json['message_en'],
      action: json['action'],
      actionData: json['action_data'],
      timestamp: json['timestamp'],
      amount: json['amount'],
      returnId: json['return_id'] != null ? int.tryParse(json['return_id'].toString()) : null,
      opportunityId: json['opportunity_id'] != null ? int.tryParse(json['opportunity_id'].toString()) : null,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      oldStatus: json['old_status'],
      newStatus: json['new_status'],
      orderId: json['order_id'] != null ? int.tryParse(json['order_id'].toString()) : null,
      contractId: json['contract_id'] != null ? int.tryParse(json['contract_id'].toString()) : null,
      installmentId: json['installment_id'] != null ? int.tryParse(json['installment_id'].toString()) : null,
      installmentNumber: json['installment_number'] != null ? int.tryParse(json['installment_number'].toString()) : null,
      dueDate: json['due_date'],
      extra: json['extra'] != null ? ExtraData.fromJson(json['extra']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'body': body,
      'title_ar': titleAr,
      'title_en': titleEn,
      'message_ar': messageAr,
      'message_en': messageEn,
      'action': action,
      'action_data': actionData,
      'timestamp': timestamp,
      'amount': amount,
      'return_id': returnId,
      'opportunity_id': opportunityId,
      'user_id': userId,
      'old_status': oldStatus,
      'new_status': newStatus,
      'order_id': orderId,
      'contract_id': contractId,
      'installment_id': installmentId,
      'installment_number': installmentNumber,
      'due_date': dueDate,
      'extra': extra?.toJson(),
    };
  }

  // Helper method to get parsed action data
  ActionData? getParsedActionData() {
    if (actionData is Map<String, dynamic>) {
      return ActionData.fromJson(actionData as Map<String, dynamic>);
    }
    return null;
  }

  // Helper method to check if action data is a list
  bool get isActionDataList => actionData is List;
}
class ExtraData {
  final String? fileUrl;
  final int? rawlandId;

  ExtraData({
    this.fileUrl,
    this.rawlandId,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(
      fileUrl: json['file_url'],
      rawlandId: json['rawland_id'] != null ? int.tryParse(json['rawland_id'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_url': fileUrl,
      'rawland_id': rawlandId,
    };
  }
}
class ActionData {
  final int? returnId;
  final int? opportunityId;
  final int? orderId;
  final int? contractId;
  final int? installmentId;
  final int? renterId;

  ActionData({
    this.returnId,
    this.opportunityId,
    this.orderId,
    this.contractId,
    this.installmentId,
    this.renterId,
  });

  factory ActionData.fromJson(Map<String, dynamic> json) {
    return ActionData(
      returnId: json['return_id'] != null ? int.tryParse(json['return_id'].toString()) : null,
      opportunityId: json['opportunity_id'] != null ? int.tryParse(json['opportunity_id'].toString()) : null,
      orderId: json['order_id'] != null ? int.tryParse(json['order_id'].toString()) : null,
      contractId: json['contract_id'] != null ? int.tryParse(json['contract_id'].toString()) : null,
      installmentId: json['installment_id'] != null ? int.tryParse(json['installment_id'].toString()) : null,
      renterId: json['renter_id'] != null ? int.tryParse(json['renter_id'].toString()) : null,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'return_id': returnId,
      'opportunity_id': opportunityId,
      'order_id': orderId,
      'contract_id': contractId,
      'installment_id': installmentId,
      'renter_id': renterId,
    };
  }
}
class NotificationTypes {
  static const String opportunityReturnStatus = 'opportunity_return_status';
  static const String partialPayment = 'partial_payment';
  static const String rentalPaymentReminder = 'rental_payment_reminder';
  static const String rawlandNotification = 'rawland_notification';
  static const String orderStatusUpdate = 'order_status_update';
  static const String houseStatusUpdate = 'house_status_update';

  static List<String> get all => [
    opportunityReturnStatus,
    partialPayment,
    rentalPaymentReminder,
    orderStatusUpdate,
    rawlandNotification,
    houseStatusUpdate,
  ];
}