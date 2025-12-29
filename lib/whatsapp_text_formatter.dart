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
  /// - *Bold* (`*text*`)
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
    final defaultStyle = (style ?? DefaultTextStyle.of(context).style);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: defaultStyle,
        children: _parseWhatsAppFormat(text, defaultStyle),
      ),
    );
  }

  List<TextSpan> _parseWhatsAppFormat(String text, TextStyle defaultStyle) {
    final spans = <TextSpan>[];
    final lines = text.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      final bulletMatch = RegExp(r'^\s*([\*\-]) (.+)$').firstMatch(line);
      final numMatch = RegExp(r'^\s*(\d+)\. (.+)$').firstMatch(line);
      final quoteMatch = RegExp(r'^\s*>\s?(.*)$').firstMatch(line);

      final baseStyle = defaultStyle;
      var innerText = line;

      if (bulletMatch != null) {
        innerText = bulletMatch.group(2)!;
        spans.add(TextSpan(
            text: '${i > 0 ? '\n' : ''}• ',
            style:
                baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold))));
        spans.addAll(_parseInlineStyles(innerText,
            baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold))));
      } else if (numMatch != null) {
        innerText = numMatch.group(2)!;
        String numberStr = numMatch.group(1)!;
        spans.add(TextSpan(
            text: '${i > 0 ? '\n' : ''}$numberStr. ',
            style:
                baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold))));
        spans.addAll(_parseInlineStyles(innerText,
            baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold))));
      } else if (quoteMatch != null) {
        innerText = quoteMatch.group(1)!;
        spans.add(TextSpan(
          text: '${i > 0 ? '\n' : ''}> ',
          style: baseStyle.merge(const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          )),
        ));
        spans.addAll(_parseInlineStyles(
            innerText,
            baseStyle.merge(const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ))));
      } else {
        if (i != 0) {
          spans.add(const TextSpan(text: '\n'));
        }
        spans.addAll(_parseInlineStyles(innerText, baseStyle));
      }
    }

    return spans;
  }

  List<TextSpan> _parseInlineStyles(String text, TextStyle baseStyle) {
    final codeBlockExp = RegExp(r'```(.*?)```', dotAll: true);
    final firstCodeBlockMatch = codeBlockExp.firstMatch(text);

    if (firstCodeBlockMatch != null) {
      final spans = <TextSpan>[];

      if (firstCodeBlockMatch.start > 0) {
        spans.addAll(_parseInlineStyles(
          text.substring(0, firstCodeBlockMatch.start),
          baseStyle,
        ));
      }

      spans.add(TextSpan(
        text: firstCodeBlockMatch.group(1),
        style: baseStyle.merge(const TextStyle(fontFamily: 'monospace')),
      ));

      if (firstCodeBlockMatch.end < text.length) {
        spans.addAll(_parseInlineStyles(
          text.substring(firstCodeBlockMatch.end),
          baseStyle,
        ));
      }

      return spans;
    }

    final inlineCodeExp = RegExp(r'`([^`\n]+?)`');
    final matches = inlineCodeExp.allMatches(text).toList();

    if (matches.isNotEmpty) {
      List<TextSpan> spans = [];
      int lastMatchEnd = 0;
      for (final match in matches) {
        if (match.start > lastMatchEnd) {
          spans.addAll(_parseBoldItalicStrike(
              text.substring(lastMatchEnd, match.start), baseStyle));
        }
        spans.add(TextSpan(
          text: match.group(1),
          style: baseStyle.merge(const TextStyle(
            fontFamily: 'monospace',
            backgroundColor: Colors.grey,
          )),
        ));
        lastMatchEnd = match.end;
      }
      if (lastMatchEnd < text.length) {
        spans.addAll(
            _parseBoldItalicStrike(text.substring(lastMatchEnd), baseStyle));
      }
      return spans;
    }

    return _parseBoldItalicStrike(text, baseStyle);
  }

  List<TextSpan> _parseBoldItalicStrike(String text, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final pattern = RegExp(
      r'(~~(?<strike>.+?)~~)|(\*(?! )(?!\*)(?<bold>(?:[^\*]|(\*[^\*]))+?)\*)|(_(?<italic>[^_]+?)_)',
    );

    int lastMatchEnd = 0;
    final matches = pattern.allMatches(text).toList();

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: baseStyle,
        ));
      }
      final strike = match.namedGroup('strike');
      final bold = match.namedGroup('bold');
      final italic = match.namedGroup('italic');

      if (strike != null) {
        spans.add(
          TextSpan(
            children: _parseBoldItalicStrike(
                strike,
                baseStyle.merge(
                    const TextStyle(decoration: TextDecoration.lineThrough))),
            style: baseStyle
                .merge(const TextStyle(decoration: TextDecoration.lineThrough)),
          ),
        );
      } else if (bold != null) {
        spans.add(
          TextSpan(
            children: _parseBoldItalicStrike(bold,
                baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold))),
            style:
                baseStyle.merge(const TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      } else if (italic != null) {
        spans.add(
          TextSpan(
            children: _parseBoldItalicStrike(italic,
                baseStyle.merge(const TextStyle(fontStyle: FontStyle.italic))),
            style:
                baseStyle.merge(const TextStyle(fontStyle: FontStyle.italic)),
          ),
        );
      }
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: baseStyle,
      ));
    }
    return spans;
  }
}
