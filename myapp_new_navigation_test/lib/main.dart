import 'package:flutter/material.dart';
import 'package:myapp_new_navigation_test/unknown_screen.dart';

import './models/book.dart';
import './books_list_screen.dart';
import './book_detail_screen.dart';

main() {
  runApp(BooksApp());
}

class BooksApp extends StatefulWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  _BooksAppState createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  /*
   In _BooksAppState, keep two pieces of state: 
    a list of books and the selected book 
   */
  late Book _selectedBook;
  bool show404 = false;
  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler')
  ];

  void _handleBookTapped(Book book) {
    print('livro da lista de livros clicado');
    setState(() {
      _selectedBook = book;
    });
  }

  @override
  void initState() {
    print('Setei o livro selecionado para vazio');
    _selectedBook = Book('', '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      /*
      The Navigator has a new pages argument in its constructor. 
        If the list of Page objects changes, Navigator updates 
        the stack of routes to match
      */
      home: Navigator(
        pages: [
          MaterialPage(
            key: ValueKey('BooksListPage'),
            child: BooksListScreen(
              books: books,
              onTapped: _handleBookTapped,
            ),
          ),
          //lembrar de deixar sem chaves {}
          if (show404)
            MaterialPage(
              key: ValueKey('UnknownPage'),
              child: UnknownScreen(),
            )
          /*Note that the key for the page is defined by the value 
                of the book object. This tells the Navigator that 
                this MaterialPage object is different from another 
                when the Book object is different. 
              Without a unique key, the framework can’t determine 
                when to show a transition animation between different Pages. */
          else if (_selectedBook.title.isNotEmpty)
            MaterialPage(
              key: ValueKey(_selectedBook),
              child: BookDetailScreen(book: _selectedBook),
            ),
        ],
        /*
        Finally, it’s an error to provide a pages argument without 
          also providing an onPopPage callback. This function is called 
          whenever Navigator.pop() is called. It should be used to update 
          the state (that determines the list of pages), and it must 
          call didPop on the route to determine if the pop succeeded:
         */
        onPopPage: (route, result) {
          print('Clicaram em voltar');
          print('Resultado do didPop: ${_selectedBook.title}');

          //It’s important to check whether didPop fails before updating the app state.
          if (!route.didPop(result)) {
            print('Falhou');
            return true;
          }
          setState(() {
            _selectedBook = Book('', '');
          });
          print('Atualizei o livro para vazio, veja: ${_selectedBook.title}');
          return true;
        },
      ),
    );
  }
}
