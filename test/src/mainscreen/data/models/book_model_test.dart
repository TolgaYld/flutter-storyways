import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:storyways/core/utils/typedefs.dart';
import 'package:storyways/src/mainscreen/data/models/book_model.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tBookModel = BookModel.empty();
  test('Should be a subclass of [Book] entity', () {
    expect(tBookModel, isA<Book>());
  });
  final tBookJson = jsonDecode(fixture('book.json')) as DataMap;
  final tBooksJson = fixture('books.json');

  group('fromMap', () {
    test('should return a valid [BookModel] from map', () {
      final result = BookModel.fromMap(tBookJson);

      expect(result, isA<BookModel>());
      expect(result.name, tBookModel.name);
      //normaly implement also this
      // expect(result, tBookModel);
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from [BookModel]', () {
      final result = tBookModel.toMap();

      expect(result, isA<DataMap>());
      expect(result['name'], tBookJson['name']);
      //normaly implement also this
      // expect(result, tBookModel);
    });
  });

  group('bookModelFromJson', () {
    test('should return a valid [List<BookModel>] from map', () {
      final result = BookModel.bookModelFromJson(tBooksJson);

      expect(result, isA<List<BookModel>>());
      expect(result.first.name, tBookModel.name);
    });
  });

  group('copyWith', () {
    test('should return a [BookModel] with updated values', () {
      final result = tBookModel.copyWith(name: 'a');

      expect(result.name, 'a');
    });
  });
}
