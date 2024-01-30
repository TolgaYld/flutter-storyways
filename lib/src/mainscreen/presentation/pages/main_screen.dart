import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storyways/core/extensions/context.dart';
import 'package:storyways/core/utils/core_utils.dart';
import 'package:storyways/core/utils/debouncer.dart';
import 'package:storyways/src/mainscreen/application/get_books_bloc/book_bloc.dart';
import 'package:storyways/src/mainscreen/application/search_bloc/search_book_bloc.dart';
import 'package:storyways/src/mainscreen/presentation/widgets/continue_widget.dart';
import 'package:storyways/src/mainscreen/presentation/widgets/new_widget.dart';
import '../../domain/entities/book.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final layerLink = LayerLink();
  List<Book> _searchedBooks = [];
  final _searchQueryController = TextEditingController();
  final focusNode = FocusNode();
  OverlayEntry? entry;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + context.heightRatio * 90,
        width: size.width,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Color(0x4C2B885B),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
    _searchQueryController.clear();
    _searchedBooks.clear();
  }

  Widget buildOverlay() => Material(
        child: BlocBuilder<SearchBookBloc, SearchBookState>(
          builder: (context, state) {
            if (state is SearchedBooksLoaded) {
              _searchedBooks = state.searchedBooks;
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: context.heightRatio * 450,
                  minHeight: context.heightRatio * 120,
                ),
                child: _searchedBooks.isEmpty &&
                        _searchQueryController.text.isNotEmpty
                    ? const Center(child: Text("Nichts zu finden. :)"))
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _searchedBooks.length,
                        itemBuilder: (context, index) =>
                            index == _searchedBooks.length - 1
                                ? NewWidget(
                                    showInSearchBar: true,
                                    book: _searchedBooks[index],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      NewWidget(
                                        showInSearchBar: true,
                                        book: _searchedBooks[index],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: context.heightRatio * 12,
                                          right: context.widthRatio * 16,
                                          left: context.widthRatio * 20,
                                          bottom: context.heightRatio * 12,
                                        ),
                                        child: const Divider(
                                          color: Color(0xFFE1EAE7),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
              );
            }
            if (state is SearchBooksInProgress) {
              return Container(
                color: Colors.white,
                height: context.heightRatio * 77,
                width: double.infinity,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amberAccent,
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      );

  @override
  void dispose() {
    _searchQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightRatio = context.heightRatio;
    final widthRatio = context.widthRatio;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<BookBloc, BookState>(
          listener: (context, state) {
            if (state is BookBlocLoadingErrorState) {
              CoreUtils.showSnackBar(context, state.message);
            }
          },
          buildWhen: (previous, current) => previous is BooksLoading,
          builder: (context, state) {
            if (state is BooksLoaded) {
              final books = state.books;
              final sortedBooks = state.books;
              sortedBooks
                  .sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 18 * widthRatio,
                            top: 36 * heightRatio,
                          ),
                          child: TextField(
                            onChanged: (value) {
                              final debouncer = Debouncer(milliseconds: 350);
                              debouncer.run(() {
                                context
                                    .read<SearchBookBloc>()
                                    .add(SearchBooksEvent(value));
                              });
                            },
                            controller: _searchQueryController,
                            focusNode: focusNode,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for something",
                              hintStyle: TextStyle(
                                color: Color(0xFF99ABA5),
                                fontSize: 16,
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 15 * widthRatio,
                          top: 36 * heightRatio,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/search_icon.svg',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: heightRatio * 9,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x192B885B),
                          blurRadius: 7,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 13 * widthRatio,
                      top: 18 * heightRatio,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF5B5EA6),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightRatio * 18,
                  ),
                  SizedBox(
                    height: heightRatio * 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: books.length,
                      itemBuilder: (context, index) =>
                          ContinueWidget(book: books[index]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 17 * widthRatio,
                      top: 15 * heightRatio,
                      bottom: heightRatio * 8,
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF5B5EA6),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: sortedBooks.length,
                      itemBuilder: (context, index) =>
                          index == sortedBooks.length - 1
                              ? NewWidget(
                                  showInSearchBar: false,
                                  book: sortedBooks[index],
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    NewWidget(
                                      showInSearchBar: false,
                                      book: sortedBooks[index],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: widthRatio * 16,
                                        left: widthRatio * 20,
                                      ),
                                      child: const Divider(
                                        color: Color(0xFFE1EAE7),
                                      ),
                                    ),
                                  ],
                                ),
                    ),
                  ),
                ],
              );
            }
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: context.theme.primaryColor,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: SizedBox(
          height: heightRatio * 64,
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/homebutton.svg'),
                    Padding(
                      padding: EdgeInsets.only(
                        left: widthRatio * 7,
                        top: heightRatio * 4,
                      ),
                      child: const Text(
                        'Home',
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Color(0xFF5B5EA6),
                          fontSize: 12,
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/Stack.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/Compass.svg'),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/forward.svg'),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
