import 'package:storyways/src/mainscreen/domain/repos/books_repo.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/book.dart';

class SearchBookUsecase implements UsecaseWithParams<List<Book>, String> {
  const SearchBookUsecase(this._bookRepo);

  final BooksRepo _bookRepo;
  @override
  ResultFuture<List<Book>> call(String params) async =>
      _bookRepo.searchBooks(params);
}
