import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storyways/src/mainscreen/domain/usecases/search_book_usecase.dart';

import '../../domain/entities/book.dart';

part 'search_book_event.dart';
part 'search_book_state.dart';

class SearchBookBloc extends Bloc<SearchBookEvent, SearchBookState> {
  SearchBookBloc(SearchBookUsecase searchBookUsecase)
      : _searchBookUsecase = searchBookUsecase,
        super(const SearchBookInitial()) {
    on<SearchBookEvent>((event, emit) {
      emit(const SearchBooksInProgress());
    });
    on<SearchBooksEvent>(_searchBooksHandler);
  }

  final SearchBookUsecase _searchBookUsecase;

  Future<void> _searchBooksHandler(
    SearchBooksEvent event,
    Emitter<SearchBookState> emit,
  ) async {
    if (event.query.isNotEmpty) {
      final result = await _searchBookUsecase(event.query);

      result.fold(
        (failure) => emit(
          SearchBookLoadingError(
            failure.message,
          ),
        ),
        (books) => emit(
          SearchedBooksLoaded(
            books,
          ),
        ),
      );
    } else {
      emit(
        const SearchedBooksLoaded([]),
      );
    }
  }
}
