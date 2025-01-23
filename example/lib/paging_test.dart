import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InteractivePageView(),
    );
  }
}
class InteractivePageView extends StatefulWidget {
  @override
  _InteractivePageViewState createState() => _InteractivePageViewState();
}

class _InteractivePageViewState extends State<InteractivePageView> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _pages = ['Page 1', 'Page 2', 'Page 3', 'Page 4'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  void _handlePageChange(int delta) {
    int newPage = _currentPage + delta;
    if (newPage >= 0 && newPage < _pages.length) {
      _pageController.animateToPage(
          newPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut
      );
    }
  }
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Handle keyboard arrow key navigation
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _handlePageChange(1);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _handlePageChange(-1);
          }
        }
      },
      child: GestureDetector(
        // Handle touch and mouse scroll interactions
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _handlePageChange(-1); // Swipe right to go previous
          } else if (details.primaryVelocity! < 0) {
            _handlePageChange(1); // Swipe left to go next
          }
        },
        child: Listener(
          onPointerSignal: (pointerSignal) {
            // Handle mouse wheel scrolling
            if (pointerSignal is PointerScrollEvent) {
              if (pointerSignal.scrollDelta.dy > 0) {
                _handlePageChange(1);
              } else if (pointerSignal.scrollDelta.dy < 0) {
                _handlePageChange(-1);
              }
            }
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                    _pages[index],
                    style: TextStyle(fontSize: 24)
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}