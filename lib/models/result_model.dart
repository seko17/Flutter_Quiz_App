import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Results extends Equatable {
  final String category;
  final String score;


  const Results({
    @required this.category,
    @required this.score,
 
 
  });

  @override
  List<Object> get props => [
        category,
        score,
     
      ];

  factory Results.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Results(
      category: map['category'] ?? '',
      score: map['score'] ?? '',
    );
  }
}
