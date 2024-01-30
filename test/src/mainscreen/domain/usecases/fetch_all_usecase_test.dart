import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';
import 'package:storyways/src/mainscreen/domain/usecases/fetch_all_usecase.dart';
import 'package:storyways/src/mainscreen/domain/repos/books_repo.dart';
import 'fetch_all_usecase_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

@GenerateMocks([BooksRepo])
void main() {
  late BooksRepo repo;
  late FetchAllUsecase usecase;

  setUp(() {
    repo = MockBooksRepo();
    usecase = FetchAllUsecase(repo);
  });

  final tBookList = [Book.empty()];
  const tFailure =
      ServerFailure(message: "An Error occured. :(", statusCode: 404);

  group('FetchAllBooks', () {
    test("should return [List<Book>] from [BooksRepo]", () async {
      //Arrange
      when(repo.fetchAllBooks()).thenAnswer((_) async => Right(tBookList));

      //Act
      final result = await usecase();

      // Assert
      expect(result, Right<dynamic, List<Book>>(tBookList));
      verify(repo.fetchAllBooks()).called(1);

      verifyNoMoreInteractions(repo);
    });

    test("should return [ServerFailure] from [BooksRepo] when fetching failed",
        () async {
      //Arrange
      when(repo.fetchAllBooks()).thenAnswer((_) async => const Left(tFailure));

      //Act
      final result = await usecase();

      // Assert
      expect(result, const Left<Failure, dynamic>(tFailure));
      verify(repo.fetchAllBooks()).called(1);

      verifyNoMoreInteractions(repo);
    });
  });
}
