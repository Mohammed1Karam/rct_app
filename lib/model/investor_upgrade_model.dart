class InvestorQuestion {
  final int id;
  final String question;
  final String questionAr;
  final String questionEn;

  InvestorQuestion({
    required this.id,
    required this.question,
    required this.questionAr,
    required this.questionEn,
  });

  factory InvestorQuestion.fromJson(Map<String, dynamic> json) {
    return InvestorQuestion(
      id: json['id'],
      question: json['question'] ?? "",
      questionAr: json['question_ar'] ?? "",
      questionEn: json['question_en'] ?? "",
    );
  }
}
