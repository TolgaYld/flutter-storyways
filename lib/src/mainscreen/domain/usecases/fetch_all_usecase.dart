import 'package:storyways/src/mainscreen/domain/repos/books_repo.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/book.dart';

class FetchAllUsecase implements UsecaseWithoutParams<List<Book>> {
  const FetchAllUsecase(this._bookRepo);

  final BooksRepo _bookRepo;
  @override
  ResultFuture<List<Book>> call() async => _bookRepo.fetchAllBooks();
}
