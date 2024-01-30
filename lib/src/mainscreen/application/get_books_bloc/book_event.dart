part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

final class FetchAllBooksEvent extends BookEvent {
  const FetchAllBooksEvent();
}
