import '../entities/book.dart';
import '../../../../core/utils/typedefs.dart';

abstract class BooksRepo {
  const BooksRepo();
  ResultFuture<List<Book>> fetchAllBooks();
  ResultFuture<List<Book>> searchBooks(String query);
}
