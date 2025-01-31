import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class QuizFirestore {
  final _quizCollection = FirebaseFirestore.instance.collection("quizes");

  Stream<QuerySnapshot> getQuestions() async* {
    yield* _quizCollection.snapshots();
  }

  void addQuestion(List<String> answers, int correct, String question) {
    _quizCollection
        .add({"answers": answers, "question": question, "correct": correct});
  }
}
