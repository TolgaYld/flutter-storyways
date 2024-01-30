import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storyways/src/mainscreen/domain/entities/book.dart';
import 'package:storyways/src/mainscreen/domain/usecases/fetch_all_usecase.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc(
    FetchAllUsecase fetchAllUsecase,
  )   : _fetchAllUsecase = fetchAllUsecase,
        super(const BookInitial()) {
    on<FetchAllBooksEvent>(_fetchAllBooksHandler);
  }

  final FetchAllUsecase _fetchAllUsecase;

  Future<void> _fetchAllBooksHandler(
    FetchAllBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BooksLoading());
    final result = await _fetchAllUsecase();

    result.fold(
      (failure) => emit(
        BookBlocLoadingErrorState(
          failure.message,
        ),
      ),
      (books) => emit(
        BooksLoaded(
          books,
        ),
      ),
    );
  }
}
