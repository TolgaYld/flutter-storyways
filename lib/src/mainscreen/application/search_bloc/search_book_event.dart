part of 'search_book_bloc.dart';

abstract class SearchBookEvent extends Equatable {
  const SearchBookEvent();

  @override
  List<Object> get props => [];
}

final class SearchBooksEvent extends SearchBookEvent {
  const SearchBooksEvent(this.query);
  final String query;

  @override
  List<String> get props => [query];
}
