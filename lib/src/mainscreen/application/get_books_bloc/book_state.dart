part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

final class BookInitial extends BookState {
  const BookInitial();
}

final class BooksLoading extends BookState {
  const BooksLoading();
}

final class BooksLoaded extends BookState {
  const BooksLoaded(this.books);

  final List<Book> books;

  @override
  List<Object> get props => [books];
}

final class BookBlocLoadingErrorState extends BookState {
  const BookBlocLoadingErrorState(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
