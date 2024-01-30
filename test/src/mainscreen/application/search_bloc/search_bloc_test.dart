import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:storyways/core/errors/failures.dart';
import 'package:storyways/src/mainscreen/domain/usecases/search_book_usecase.dart';
import 'package:storyways/src/mainscreen/application/search_bloc/search_book_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchBookUsecase])
void main() {
  late MockSearchBookUsecase searchBookUsecase;
  late SearchBookBloc searchBloc;

  const tServerFailure = ServerFailure(
    message: "Error",
    statusCode: 400,
  );

  setUp(() {
    searchBookUsecase = MockSearchBookUsecase();
    searchBloc = SearchBookBloc(
      searchBookUsecase,
    );
  });
  tearDown(() => searchBloc.close());

  test('initial state should be [SearchBookInitial]', () async {
    expect(searchBloc.state, const SearchBookInitial());
  });

  group('searchBooks', () {
    blocTest<SearchBookBloc, SearchBookState>(
      'should emit [SearchBooksInProgress, BooksLoaded] when successful',
      build: () {
        when(searchBookUsecase(any)).thenAnswer((_) async => const Right([]));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchBooksEvent("blabla")),
      expect: () => const [
        SearchBooksInProgress(),
        SearchedBooksLoaded([]),
      ],
      verify: (_) {
        verify(searchBookUsecase("blabla")).called(1);
        verifyNoMoreInteractions(searchBookUsecase);
      },
    );

    blocTest<SearchBookBloc, SearchBookState>(
      'should emit [SearchBooksInProgress, SearchBookLoadingError] when successful',
      build: () {
        when(searchBookUsecase(any))
            .thenAnswer((_) async => const Left(tServerFailure));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchBooksEvent("blabla")),
      expect: () => [
        const SearchBooksInProgress(),
        SearchBookLoadingError(tServerFailure.message),
      ],
      verify: (_) {
        verify(searchBookUsecase("blabla")).called(1);
        verifyNoMoreInteractions(searchBookUsecase);
      },
    );
  });
}
