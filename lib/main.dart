import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storyways/core/services/injection.dart';
import 'package:storyways/core/theme/theme.dart';
import 'package:storyways/src/mainscreen/application/get_books_bloc/book_bloc.dart';
import 'package:storyways/src/mainscreen/application/search_bloc/search_book_bloc.dart';
import 'package:storyways/src/mainscreen/presentation/pages/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<BookBloc>()..add(const FetchAllBooksEvent()),
        ),
        BlocProvider(
          create: (context) => sl<SearchBookBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}
