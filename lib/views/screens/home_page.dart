import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson_65/sevices/firebase_auth_service.dart';
import 'package:provider/provider.dart';

import '../../controllers/question_controller.dart';
import '../../models/question.dart';
import '../../providers/select_index.dart';
import '../widgets/custom_drawer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final firebaseAuthService = FirebaseAuthService();
  late PageController _pageController;
  int correctAnswers = 0;
  int length = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionController = context.read<QuestionController>();

    return Scaffold(
      backgroundColor: const Color(0xff7F80DB),
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Accountdan chiqib ketishga aminmisiz?"),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                FirebaseAuth.instance.signOut();
                              },
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.logout))
        ],
        // title: const Text("Animation"),
      ),
      body: StreamBuilder(
        stream: questionController.list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text("Bunday malumot mavjud emas"),
            );
          }
          final quizes = snapshot.data!.docs;
          length = quizes.length;
          return quizes.isEmpty
              ? const Center(
                  child: Text("List bo'sh"),
                )
              : PageView.builder(
                  onPageChanged: (value) {
                    _pageController.initialPage;
                  },
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: quizes.length,
                  itemBuilder: (context, questionIndex) {
                    final data = Question.fromJson(quizes[questionIndex]);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          data.question,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.answers.length,
                            itemBuilder: (context, answerIndex) {
                              final data1 = data.answers[answerIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 3,
                                ),
                                child: Consumer<SelectedAnswerProvider>(
                                  builder:
                                      (context, selectedAnswerProvider, child) {
                                    final selectedAnswer =
                                        selectedAnswerProvider
                                            .selectedAnswers[questionIndex];
                                    return FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            selectedAnswer == answerIndex
                                                ? Colors.green
                                                : Colors.white.withOpacity(0.1),
                                      ),
                                      onPressed: () {
                                        selectedAnswerProvider.selectAnswer(
                                            questionIndex, answerIndex);
                                        if (data.correct == answerIndex) {
                                          correctAnswers++;
                                        }
                                        _pageController.nextPage(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve: Curves.easeInOut,
                                        );

                                        if (selectedAnswerProvider
                                                .selectedAnswers.length ==
                                            quizes.length) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Savollar yakunlandi"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "Siz ${quizes.length} ta savoldan ${correctAnswers} tasiga to'gri javob berdingiz!"),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                          selectedAnswerProvider.selectedAnswers
                                              .clear();
                                          _pageController.jumpToPage(0);
                                        }
                                      },
                                      child: Text(
                                        textAlign: TextAlign.start,
                                        data1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
        },
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
