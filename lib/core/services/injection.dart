import 'package:get_it/get_it.dart';
import 'package:storyways/src/mainscreen/application/search_bloc/search_book_bloc.dart';
import 'package:storyways/src/mainscreen/data/datasources/books_remote_data_source.dart';
import 'package:storyways/src/mainscreen/data/repos/book_repo_impl.dart';
import 'package:storyways/src/mainscreen/domain/repos/books_repo.dart';
import 'package:storyways/src/mainscreen/domain/usecases/fetch_all_usecase.dart';
import 'package:storyways/src/mainscreen/domain/usecases/search_book_usecase.dart';
import 'package:storyways/src/mainscreen/application/get_books_bloc/book_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(
      () => BookBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => SearchBookBloc(
        sl(),
      ),
    )
    ..registerLazySingleton(
      () => FetchAllUsecase(sl()),
    )
    ..registerLazySingleton(
      () => SearchBookUsecase(sl()),
    )
    ..registerLazySingleton<BooksRepo>(
      () => BooksRepoImpl(sl()),
    )
    ..registerLazySingleton<BooksRemoteDatasrc>(
      () => BooksRemoteDatasrcImpl(sl()),
    )
    ..registerLazySingleton(http.Client.new);
}
