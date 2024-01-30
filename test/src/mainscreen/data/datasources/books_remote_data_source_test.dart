import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:storyways/core/errors/exception.dart';
import 'package:storyways/core/utils/constants.dart';
import 'package:storyways/src/mainscreen/data/datasources/books_remote_data_source.dart';
import 'package:storyways/src/mainscreen/data/models/book_model.dart';

import 'books_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient client;
  late BooksRemoteDatasrc remoteDatasrc;

  setUp(() async {
    client = MockClient();
    remoteDatasrc = BooksRemoteDatasrcImpl(client);
  });

  final tBookModelList = [BookModel.empty()];
  final tBookModelToMappedList = [BookModel.empty().toMap()];

  group('fetchAllBooks', () {
    test('should fetch Books and return valid [List<BookMode>]', () async {
      when(client.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(tBookModelToMappedList), 200),
      );

      final result = await remoteDatasrc.fetchAllBooks();

      expect(result, tBookModelList);
      verify(client.get(Uri.parse(kUrl))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw a [ServerException]', () async {
      when(client.get(any)).thenThrow(
        const ServerException(
          message: "Error",
          statusCode: 400,
        ),
      );

      final call = remoteDatasrc.fetchAllBooks;

      expect(() => call(), throwsA(isA<ServerException>()));
      verify(client.get(Uri.parse(kUrl))).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('searchBooks', () {
    test('should fetch Books and return valid [List<BookMode>]', () async {
      when(client.get(any)).thenAnswer(
        (_) async => http.Response(jsonEncode(tBookModelToMappedList), 200),
      );

      final result = await remoteDatasrc.searchBooks("Kant");

      expect(result, tBookModelList);
      verify(client.get(Uri.parse("${kUrl}Kant"))).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw a [ServerException]', () async {
      when(client.get(any)).thenThrow(
        const ServerException(
          message: "Error",
          statusCode: 400,
        ),
      );

      final call = remoteDatasrc.searchBooks;

      expect(() => call("Kant"), throwsA(isA<ServerException>()));
      verify(client.get(Uri.parse("${kUrl}Kant"))).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
