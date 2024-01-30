import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.name,
    required this.author,
    required this.releaseDate,
  });

  Book.empty()
      : this(
          id: '',
          name: '',
          author: '',
          releaseDate: DateTime.fromMillisecondsSinceEpoch(1704099600000),
        );

  final String id;
  final String name;
  final String author;
  final DateTime releaseDate;

  // NORMALY ID SHOULD BE IN THIS ARRAY!!
  @override
  List<Object?> get props => [name];
}
