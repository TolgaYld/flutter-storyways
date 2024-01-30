import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:storyways/core/utils/typedefs.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';
import 'package:uuid/uuid.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.name,
    required super.author,
    required super.releaseDate,
  });

  BookModel.empty()
      : this(
          id: '',
          name: '',
          author: '',
          releaseDate: DateTime.fromMillisecondsSinceEpoch(1704099600000),
        );

  static List<BookModel> bookModelFromJson(String jsonString) =>
      List<BookModel>.from(
        (json.decode(jsonString) as List)
            .map((bookModel) => BookModel.fromMap(bookModel))
            .toList(),
      );

  BookModel.fromMap(DataMap map)
      : super(
          id: const Uuid().v4(),
          name: map['name'] as String,
          author: faker.person.name(),
          releaseDate:
              faker.date.dateTimeBetween(DateTime(2001), DateTime(2023)),
        );

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'releaseDate': releaseDate.toIso8601String(),
    };
  }

  BookModel copyWith({
    String? id,
    String? name,
    String? author,
    DateTime? releaseDate,
  }) {
    return BookModel(
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      releaseDate: releaseDate ?? this.releaseDate,
    );
  }
}
