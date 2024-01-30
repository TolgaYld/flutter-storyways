import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/src/mainscreen/domain/usecases/fetch_all_usecase.dart';
import 'package:storyways/src/mainscreen/application/get_books_bloc/book_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'book_bloc_test.mocks.dart';

@GenerateMocks([FetchAllUsecase])
void main() {
  late MockFetchAllUsecase fetchAllUsecase;
  late BookBloc bookBloc;

  const tServerFailure = ServerFailure(
    message: "Error",
    statusCode: 400,
  );

  setUp(() {
    fetchAllUsecase = MockFetchAllUsecase();
    bookBloc = BookBloc(
      fetchAllUsecase,
    );
  });
  tearDown(() => bookBloc.close());

  test('initial state should be [BookInitial]', () async {
    expect(bookBloc.state, const BookInitial());
  });

  group('fetchAllBooks', () {
    blocTest<BookBloc, BookState>(
      'should emit [BooksLoading, BooksLoaded] when successful',
      build: () {
        when(fetchAllUsecase()).thenAnswer((_) async => const Right([]));
        return bookBloc;
      },
      act: (bloc) => bloc.add(const FetchAllBooksEvent()),
      expect: () => const [
        BooksLoading(),
        BooksLoaded([]),
      ],
      verify: (_) {
        verify(fetchAllUsecase()).called(1);
        verifyNoMoreInteractions(fetchAllUsecase);
      },
    );

    blocTest<BookBloc, BookState>(
      'should emit [BooksLoading, BookBlocLoadingErrorState] when successful',
      build: () {
        when(fetchAllUsecase())
            .thenAnswer((_) async => const Left(tServerFailure));
        return bookBloc;
      },
      act: (bloc) => bloc.add(const FetchAllBooksEvent()),
      expect: () => [
        const BooksLoading(),
        BookBlocLoadingErrorState(tServerFailure.message),
      ],
      verify: (_) {
        verify(fetchAllUsecase()).called(1);
        verifyNoMoreInteractions(fetchAllUsecase);
      },
    );
  });
}
