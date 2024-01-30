import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyways/src/mainscreen/domain/usecases/search_book_usecase.dart';
import 'fetch_all_usecase_test.mocks.dart';

void main() {
  late MockBooksRepo repo;
  late SearchBookUsecase usecase;

  setUp(() {
    repo = MockBooksRepo();
    usecase = SearchBookUsecase(repo);
  });

  final tBookList = [Book.empty()];
  const tFailure =
      ServerFailure(message: "An Error occured. :(", statusCode: 404);

  group('searchBooks', () {
    test("should return [List<Book>] from [BooksRepo]", () async {
      //Arrange
      when(repo.searchBooks(any)).thenAnswer((_) async => Right(tBookList));

      //Act
      final result = await usecase("irgendwas");

      // Assert
      expect(result, Right<dynamic, List<Book>>(tBookList));
      verify(repo.searchBooks("irgendwas")).called(1);

      verifyNoMoreInteractions(repo);
    });

    test("should return [ServerFailure] from [BooksRepo] when fetching failed",
        () async {
      //Arrange
      when(repo.searchBooks(any)).thenAnswer((_) async => const Left(tFailure));

      //Act
      final result = await usecase("aaa");

      // Assert
      expect(result, const Left<Failure, dynamic>(tFailure));
      verify(repo.searchBooks("aaa")).called(1);

      verifyNoMoreInteractions(repo);
    });
  });
}
