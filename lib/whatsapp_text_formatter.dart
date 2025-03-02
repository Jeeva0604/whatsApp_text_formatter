import 'package:flutter/material.dart';

/// A widget that formats text like WhatsApp-style formatting.
class WhatsAppTextFormatter extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  /// Creates a WhatsAppTextFormatter widget.
  ///
  /// This widget supports:
  /// - *Italic* (`_text_`)
  /// - **Bold** (`**text**`)
  /// - ~~Strikethrough~~ (`~~text~~`)
  /// - `Monospace` (`` `text` ``)
  /// - Bulleted List (`* text` or `- text`)
  /// - Numbered List (`1. text`)
  /// - Quote (`> text`)
  /// - Inline Code (` `text` `)
  const WhatsAppTextFormatter({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle =
        (style ?? DefaultTextStyle.of(context).style).copyWith(
      color: style?.color ??
          Colors.black, // Default to black if no color is provided
    );

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: defaultStyle,
        children: _parseWhatsAppFormat(text, defaultStyle),
      ),
    );
  }

  List<TextSpan> _parseWhatsAppFormat(String text, TextStyle defaultStyle) {
    final RegExp exp = RegExp(
      r"(\*\*(.*?)\*\*|_(.*?)_|~~(.*?)~~|```(.*?)```|`(.*?)`|^(\*|\-) (.*?)$|^(\d+)\. (.*?)$|^> (.*?)$)",
      multiLine: true,
    );

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (var match in exp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: defaultStyle));
      }

      String? bold = match.group(2);
      String? italic = match.group(3);
      String? strikethrough = match.group(4);
      String? monospaceBlock = match.group(5);
      String? inlineCode = match.group(6);
      String? bulletSymbol = match.group(7);
      String? bulletText = match.group(8);
      String? numberedIndex = match.group(9);
      String? numberedText = match.group(10);
      String? quoteText = match.group(11);

      if (bold != null) {
        spans.add(TextSpan(
          text: bold,
          style:
              defaultStyle.merge(const TextStyle(fontWeight: FontWeight.bold)),
        ));
      } else if (italic != null) {
        spans.add(TextSpan(
          text: italic,
          style:
              defaultStyle.merge(const TextStyle(fontStyle: FontStyle.italic)),
        ));
      } else if (strikethrough != null) {
        spans.add(TextSpan(
          text: strikethrough,
          style: defaultStyle
              .merge(const TextStyle(decoration: TextDecoration.lineThrough)),
        ));
      } else if (monospaceBlock != null) {
        spans.add(TextSpan(
          text: monospaceBlock,
          style: defaultStyle.merge(const TextStyle(fontFamily: 'monospace')),
        ));
      } else if (inlineCode != null) {
        spans.add(TextSpan(
          text: inlineCode,
          style: defaultStyle.merge(const TextStyle(
            fontFamily: 'monospace',
            backgroundColor: Colors.grey,
          )),
        ));
      } else if (bulletSymbol != null && bulletText != null) {
        spans.add(TextSpan(
          text: '\n• $bulletText',
          style:
              defaultStyle.merge(const TextStyle(fontWeight: FontWeight.bold)),
        ));
      } else if (numberedIndex != null && numberedText != null) {
        spans.add(TextSpan(
          text: '\n$numberedIndex. $numberedText',
          style:
              defaultStyle.merge(const TextStyle(fontWeight: FontWeight.bold)),
        ));
      } else if (quoteText != null) {
        spans.add(TextSpan(
          text: '\n> $quoteText',
          style: defaultStyle.merge(const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          )),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
          TextSpan(text: text.substring(lastMatchEnd), style: defaultStyle));
    }

    return spans;
  }
}
