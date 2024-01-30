part of 'search_book_bloc.dart';

abstract class SearchBookState extends Equatable {
  const SearchBookState();

  @override
  List<Object> get props => [];
}

final class SearchBookInitial extends SearchBookState {
  const SearchBookInitial();
}

final class SearchBooksInProgress extends SearchBookState {
  const SearchBooksInProgress();
}

final class SearchedBooksLoaded extends SearchBookState {
  const SearchedBooksLoaded(this.searchedBooks);

  final List<Book> searchedBooks;

  @override
  List<Object> get props => [searchedBooks];
}

final class SearchBookLoadingError extends SearchBookState {
  const SearchBookLoadingError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
