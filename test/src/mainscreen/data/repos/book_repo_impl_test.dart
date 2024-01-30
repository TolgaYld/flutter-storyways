import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:storyways/core/errors/exception.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/src/mainscreen/data/datasources/books_remote_data_source.dart';
import 'package:storyways/src/mainscreen/data/models/book_model.dart';
import 'package:storyways/src/mainscreen/data/repos/book_repo_impl.dart';

import 'book_repo_impl_test.mocks.dart';

@GenerateMocks([BooksRemoteDatasrc])
void main() {
  late MockBooksRemoteDatasrc remoteDatasrc;
  late BooksRepoImpl booksRepoImpl;
  setUp(() {
    remoteDatasrc = MockBooksRemoteDatasrc();
    booksRepoImpl = BooksRepoImpl(remoteDatasrc);
  });

  final tBookModelList = [BookModel.empty()];

  group('fetchAllBooks', () {
    test(
        'should return valid [List<Book>] when request to datasrc is successful',
        () async {
      when(remoteDatasrc.fetchAllBooks())
          .thenAnswer((_) async => tBookModelList);

      final result = await booksRepoImpl.fetchAllBooks();

      expect(result, Right<dynamic, List<BookModel>>(tBookModelList));
      verify(remoteDatasrc.fetchAllBooks()).called(1);
      verifyNoMoreInteractions(remoteDatasrc);
    });

    test(
        'should return a [ServerFailure] when request to datasrc is successful',
        () async {
      when(remoteDatasrc.fetchAllBooks()).thenThrow(
        const ServerException(
          message: "Failed to fetch books",
          statusCode: 400,
        ),
      );

      final result = await booksRepoImpl.fetchAllBooks();

      expect(
        result,
        const Left<Failure, dynamic>(
          ServerFailure(
            message: "Failed to fetch books",
            statusCode: 400,
          ),
        ),
      );
      verify(remoteDatasrc.fetchAllBooks()).called(1);
      verifyNoMoreInteractions(remoteDatasrc);
    });
  });

  group('searchBooks', () {
    test(
        'should return valid [List<Book>] when specific request to datasrc is successful',
        () async {
      when(remoteDatasrc.searchBooks(any))
          .thenAnswer((_) async => tBookModelList);

      final result = await booksRepoImpl.searchBooks("Kant");

      expect(result, Right<dynamic, List<BookModel>>(tBookModelList));
      verify(remoteDatasrc.searchBooks("Kant")).called(1);
      verifyNoMoreInteractions(remoteDatasrc);
    });

    test(
        'should return a [ServerFailure] when specific request to datasrc is successful',
        () async {
      when(remoteDatasrc.searchBooks(any)).thenThrow(
        const ServerException(
          message: "Failed to fetch books",
          statusCode: 400,
        ),
      );

      final result = await booksRepoImpl.searchBooks("Kant");

      expect(
        result,
        const Left<Failure, dynamic>(
          ServerFailure(
            message: "Failed to fetch books",
            statusCode: 400,
          ),
        ),
      );
      verify(remoteDatasrc.searchBooks("Kant")).called(1);
      verifyNoMoreInteractions(remoteDatasrc);
    });
  });
}
