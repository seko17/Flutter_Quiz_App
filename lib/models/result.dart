import 'package:meta/meta.dart';

final String tableResult = 'result';

class ResultField {
  static final List<String> values = [
    /// Add all fields
    id, category, score, time
  ];

  static final String id = '_id';
  static final String category = 'category';
  static final String score = 'score';
  static final String time = 'time';
}

class Result {
  final int id;
  final String category;
  final String score;
  final DateTime createdTime;

  const Result({
    this.id,
    @required this.category,
    @required this.score,
    @required this.createdTime,
  });

  Result copy({
    int id ,
    String category,
    String score,
    DateTime createdTime,
  }) =>
      Result(
        id: id ?? this.id,
        category: category ?? this.category,
        score: score ?? this.score,
        createdTime: createdTime ?? this.createdTime,
      );

  static Result fromJson(Map<String, Object> json) => Result(
        id: json[ResultField.id] as int,
        category: json[ResultField.category] as String,
        score: json[ResultField.score] as String,
        createdTime: DateTime.parse(json[ResultField.time] as String),
      );

  Map<String, Object> toJson() => {
        ResultField.id: id,
        ResultField.category: category,
        ResultField.score: score,
        ResultField.time: createdTime.toIso8601String(),
      };
}