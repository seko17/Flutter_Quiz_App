import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'dart:math';
import 'package:grafpix/pixloaders/pix_loader.dart';

import 'package:flutter/foundation.dart';
import 'package:param_quiz_app/controllers/quiz/quiz_controller.dart';
import 'package:param_quiz_app/controllers/quiz/quiz_state.dart';
import 'package:param_quiz_app/database/db.dart';
import 'package:param_quiz_app/enums/category.dart';
import 'package:param_quiz_app/enums/difficulty.dart';
import 'package:param_quiz_app/models/failure_model.dart';
import 'package:param_quiz_app/models/question_model.dart';
import 'package:param_quiz_app/models/result.dart';
import 'package:param_quiz_app/repositories/quiz/quiz_repository.dart';
import 'package:param_quiz_app/screens/components/answer_card.dart';
import 'package:sqflite/sqflite.dart';

int num;

class QuizScreen extends StatelessWidget {
  int categoryNumber;

  QuizScreen({this.categoryNumber});

  //  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    //  categoryNumber = num;
    return Scaffold(
      backgroundColor: Color(0xFF142850),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // TextButton(onPressed: _controller.nextQuestion, child: Text("Skip")),
        ],
      ),
      body: Body(
        categoryNumber: categoryNumber,
      ),
    );
  }
}
//QUIZ BODY WIDGET
class Body extends HookWidget {
  int categoryNumber;

  Body({this.categoryNumber});

  final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
    (ref) => ref.watch(quizRepositoryProvider).getQuestions(
          numQuestions: 10,
          categoryId: Random().nextInt(24) + 9,
          difficulty: Difficulty.any,
        ),
  );
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final quizQuestions = useProvider(quizQuestionsProvider);
    final pageController = usePageController();
    return Stack(
      children: [
        Container(
          height: 400,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -30,
                  height: 400,
                  width: width,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill)),
                  )),
            ],
          ),
        ),
        SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: quizQuestions.when(
                data: (questions) =>
                    _buildBody(context, pageController, questions),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => QuizError(
                  message: error is Failure
                      ? error.message
                      : 'Something went wrong!',
                ),
              ),
              bottomSheet: quizQuestions.maybeWhen(
                data: (questions) {
                  final quizState = useProvider(quizControllerProvider.state);
                  if (!quizState.answered) return const SizedBox.shrink();
                  return CustomButton(
                    title: pageController.page.toInt() + 1 < questions.length
                        ? 'Next Question'
                        : 'See Results',
                    onTap: () {
                      context
                          .read(quizControllerProvider)
                          .nextQuestion(questions, pageController.page.toInt());
                      if (pageController.page.toInt() + 1 < questions.length) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.linear,
                        );
                      }
                    },
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    PageController pageController,
    List<Question> questions,
  ) {
    if (questions.isEmpty) return QuizError(message: 'No questions found.');

    final quizState = useProvider(quizControllerProvider.state);
    return quizState.status == QuizStatus.complete
        ? QuizResults(state: quizState, questions: questions)
        : QuizQuestions(
            pageController: pageController,
            state: quizState,
            questions: questions,
          );
  }
}

//QUIZ QUESTIONS WIDGET
class QuizQuestions extends StatelessWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;

  const QuizQuestions({
    Key key,
    @required this.pageController,
    @required this.state,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: questions.length,
      itemBuilder: (BuildContext context, int index) {
        final question = questions[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${index + 1} of ${questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 12.0),
              child: Text(
                HtmlCharacterEntities.decode(question.question),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[200],
              height: 32.0,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Column(
              children: question.answers
                  .map(
                    (e) => AnswerCard(
                      answer: e,
                      isSelected: e == state.selectedAnswer,
                      isCorrect: e == question.correctAnswer,
                      isDisplayingAnswer: state.answered,
                      onTap: () => context
                          .read(quizControllerProvider)
                          .submitAnswer(question, e),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}

class QuizError extends StatelessWidget {
  final String message;

  const QuizError({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20.0),
          CustomButton(
            title: 'Retry',
            onTap: () => context.refresh(quizRepositoryProvider),
          ),
        ],
      ),
    );
  }
}

final List<BoxShadow> boxShadow = const [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0, 2),
    blurRadius: 4.0,
  ),
];

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomButton({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow[700],
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class QuizResults extends StatefulWidget {
  final QuizState state;
  final List<Question> questions;

  const QuizResults({Key key, this.state, this.questions}) : super(key: key);
  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {

  String category;
  String score;

  _QuizResultsState({
    this.category,
    this.score,
  });

  @override
  void initState() {
    super.initState();
   
    category = 'Music';
    score = '${widget.state.correct.length} / ${widget.questions.length}';
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${widget.state.correct.length} / ${widget.questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40.0),
        CustomButton(
          title: 'New Quiz',
          onTap: () async {
            context.refresh(quizRepositoryProvider);
            context.read(quizControllerProvider).reset();

            await addResult();
          },
        ),
      ],
    );
  }

  Future addResult() async {
    final res = Result(
      category: category,
      score: score,
      createdTime: DateTime.now(),
    );

    await ResultsDB.instance.create(res);
  }
}
