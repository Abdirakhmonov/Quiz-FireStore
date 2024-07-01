import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import '../sevices/quiz_firestore.dart';

class QuestionController extends ChangeNotifier {
  final _quizFirestore = QuizFirestore();

  Stream<QuerySnapshot> get list {
    return _quizFirestore.getQuestions();
  }

  void addQuestion(List<String> answers, int correct, String question) {
    _quizFirestore.addQuestion(answers, correct, question);
    notifyListeners();
  }

}
