import 'package:dartz/dartz.dart';
import 'package:storyways/core/errors/exception.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/core/utils/typedefs.dart';
import 'package:storyways/src/mainscreen/data/datasources/books_remote_data_source.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';
import 'package:storyways/src/mainscreen/domain/repos/books_repo.dart';

class BooksRepoImpl implements BooksRepo {
  const BooksRepoImpl(this._remoteBooksDataSource);

  final BooksRemoteDatasrc _remoteBooksDataSource;
  @override
  ResultFuture<List<Book>> fetchAllBooks() async {
    try {
      final result = await _remoteBooksDataSource.fetchAllBooks();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Book>> searchBooks(String query) async {
    try {
      final result = await _remoteBooksDataSource.searchBooks(query);

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
