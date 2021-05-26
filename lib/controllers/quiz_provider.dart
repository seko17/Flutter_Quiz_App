import 'dart:math';

import 'package:param_quiz_app/enums/difficulty.dart';
import 'package:param_quiz_app/models/question_model.dart';
import 'package:param_quiz_app/repositories/quiz/quiz_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:param_quiz_app/repositories/quiz/quiz_repository.dart';

class QuizProvider {

  final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
        numQuestions: 10,
        categoryId: Random().nextInt(24) + 9,
        difficulty: Difficulty.any,
      ),
);

}