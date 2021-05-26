
import 'package:param_quiz_app/enums/difficulty.dart';
import 'package:param_quiz_app/models/question_model.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    int numQuestions,
    int categoryId,
    Difficulty difficulty,
  });
}
