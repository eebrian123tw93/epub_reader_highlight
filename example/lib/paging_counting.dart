import 'package:flutter/material.dart';

class EbookReader extends StatefulWidget {
  final String content;

  EbookReader({required this.content});

  @override
  _EbookReaderState createState() => _EbookReaderState();
}

class _EbookReaderState extends State<EbookReader> {
  late List<String> pages;
  double fontSize = 16.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在這裡安全地計算頁數
    _calculatePages();
  }

  void _calculatePages() {
    final screenSize = MediaQuery.of(context).size;

    // 設置每頁可用的寬高
    final pageWidth = screenSize.width - 16.0 * 2; // 考慮頁邊距
    final pageHeight = screenSize.height - 100.0; // 考慮標題和底部空間

    if (pageWidth <= 0 || pageHeight <= 0) {
      // 如果頁面尺寸無效，直接返回空列表
      pages = [];
      return;
    }

    // 初始化 TextPainter
    final textStyle = TextStyle(fontSize: fontSize);
    final textSpan = TextSpan(text: widget.content, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: pageWidth);

    List<String> resultPages = [];
    int start = 0; // 起始字符位置

    while (start < widget.content.length) {
      // 計算在當前頁面內可以容納的文字範圍
      final end =
          textPainter.getPositionForOffset(Offset(0, pageHeight)).offset;

      if (end <= start) break; // 防止無限循環

      resultPages.add(widget.content.substring(start, end));
      start = end; // 更新下一頁起始位置
    }

    pages = resultPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('電子書閱讀器'),
      ),
      body: Column(
        children: [
          // 動態字體調整
          Slider(
            value: fontSize,
            min: 12.0,
            max: 32.0,
            divisions: 20,
            label: fontSize.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                fontSize = value;
                _calculatePages(); // 字體大小改變時重新計算頁數
              });
            },
          ),
          Expanded(
            child: PageView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    pages[index],
                    style: TextStyle(fontSize: fontSize),
                    textAlign: TextAlign.justify,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: EbookReader(
          content: '這是一段非常長的測試文字，模擬電子書的內容，用於測試翻頁效果與頁數計算。請根據字體大小調整顯示內容。' * 50),
    ));
