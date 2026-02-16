import 'package:flutter/material.dart';
import 'package:rct/common%20copounents/app_bar_back_button.dart';
import 'package:rct/generated/l10n.dart';
import 'package:rct/l10n/app_localizations.dart';

class CommonQuestions extends StatefulWidget {
  CommonQuestions({super.key});

  @override
  State<CommonQuestions> createState() => _CommonQuestionsState();
}

class _CommonQuestionsState extends State<CommonQuestions> {
  var local;
  List<Questions> questionsList =[];
  @override
  Widget build(BuildContext context) {
    local = S.of(context);
    questionsList = [
      Questions(question: local.q1, answer: local.a1),
      Questions(question: local.q2, answer: local.a2),
      Questions(question: local.q3, answer: local.a3),
      Questions(question: local.q4, answer: local.a4),
      Questions(question: local.q5, answer: local.a5),
      Questions(question: local.q6, answer: local.a6),
      Questions(question: local.q7, answer: local.a7),
      Questions(question: local.q8, answer: local.a8),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButtonAppBar(context),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                  local.common_questions,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: questionsList.length,
                itemBuilder: (context, index) => CommonQuestionsItem(
                  question: questionsList[index].question,
                  answer: questionsList[index].answer,
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}

class CommonQuestionsItem extends StatefulWidget {
  const CommonQuestionsItem({
    super.key, required this.question, required this.answer,
  });
  final String question;
  final String answer;


  @override
  State<CommonQuestionsItem> createState() => _CommonQuestionsItemState();
}

class _CommonQuestionsItemState extends State<CommonQuestionsItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xff3f342b).withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.question,
                    style: const TextStyle(
                      color: Color(0xffC5C7CB),
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: isExpanded,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.answer,
                style: const TextStyle(
                    color: Color(0xff20262F),
                    fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Questions{
  String question;
  String answer;

  Questions({required this.question, required this.answer});
}
