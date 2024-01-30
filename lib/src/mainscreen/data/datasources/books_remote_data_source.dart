import 'package:storyways/core/errors/exception.dart';
import 'package:storyways/core/utils/constants.dart';
import 'package:storyways/src/mainscreen/data/models/book_model.dart';
import 'package:http/http.dart' as http;

abstract class BooksRemoteDatasrc {
  Future<List<BookModel>> fetchAllBooks();
  Future<List<BookModel>> searchBooks(String query);
}

class BooksRemoteDatasrcImpl implements BooksRemoteDatasrc {
  const BooksRemoteDatasrcImpl(this._client);
  final http.Client _client;

  @override
  Future<List<BookModel>> fetchAllBooks() async {
    try {
      final result = await _client.get(Uri.parse(kUrl));
      if (result.statusCode >= 300) {
        throw ServerException(
          message: "An error occured",
          statusCode: result.statusCode,
        );
      }
      return BookModel.bookModelFromJson(result.body);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final result = await _client.get(Uri.parse(kUrl + query));
      if (result.statusCode >= 300) {
        throw ServerException(
          message: "An error occured",
          statusCode: result.statusCode,
        );
      }
      return BookModel.bookModelFromJson(result.body);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
