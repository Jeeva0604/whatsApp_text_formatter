import 'package:flutter/material.dart';

/// A widget that formats text like WhatsApp-style formatting.
class WhatsAppTextFormatter extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  /// Creates a WhatsAppTextFormatter widget.
  ///
  /// This widget supports:
  /// - **Bold** (`**text**` or `__text__`)
  /// - *Italic* (`*text*`)
  /// - ~~Strikethrough~~ (`~~text~~`)
  /// - `Monospace` (`` `text` ``)
  /// - Underline (`__text__`)
  /// - Custom Colors (`{#RRGGBB}text`)
  const WhatsAppTextFormatter({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
  });

  static final config = _Config();

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: _applyDefaultStyle(style ?? DefaultTextStyle.of(context).style),
        children: _parseMarkdown(text),
      ),
    );
  }

  /// Applies default style settings
  TextStyle _applyDefaultStyle(TextStyle style) {
    return style.copyWith(
      fontWeight: null, // Removes fontWeight restrictions
      color: style.color ?? Colors.black,
      fontSize: style.fontSize ?? 16,
    );
  }

  /// Parses WhatsApp-style formatting syntax
  List<TextSpan> _parseMarkdown(String text) {
    final RegExp exp = RegExp(
        r"(\*\*(.*?)\*\*|\*(.*?)\*|~~(.*?)~~|`(.*?)`|__(.*?)__|\\n|\{#([a-fA-F0-9]{6})\}(.*?))",
        multiLine: true);

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (var match in exp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      String? italicBold = match.group(2);
      String? bold = match.group(3);
      String? strikethrough = match.group(4);
      String? monospace = match.group(5);
      String? underline = match.group(6);
      bool isNewLine = match.group(0) == '\\n';
      String? colorCode = match.group(7);
      String? colorText = match.group(8);

      if (italicBold != null) {
        spans.add(TextSpan(
          text: italicBold,
          style: _applyDefaultStyle(config.italicBoldStyle ??
              const TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        ));
      } else if (bold != null) {
        spans.add(TextSpan(
          text: bold,
          style: _applyDefaultStyle(
              config.boldStyle ?? const TextStyle(fontWeight: FontWeight.bold)),
        ));
      } else if (strikethrough != null) {
        spans.add(TextSpan(
          text: strikethrough,
          style: _applyDefaultStyle(config.strikethroughStyle ??
              const TextStyle(decoration: TextDecoration.lineThrough)),
        ));
      } else if (monospace != null) {
        spans.add(TextSpan(
          text: monospace,
          style: _applyDefaultStyle(config.monospaceStyle ??
              const TextStyle(fontFamily: 'monospace')),
        ));
      } else if (underline != null) {
        spans.add(TextSpan(
          text: underline,
          style: _applyDefaultStyle(config.underlineStyle ??
              const TextStyle(decoration: TextDecoration.underline)),
        ));
      } else if (colorCode != null && colorText != null) {
        spans.add(TextSpan(
            text: colorText,
            style: _applyDefaultStyle(
                TextStyle(color: Color(int.parse("0xff$colorCode"))))));
      } else if (isNewLine) {
        spans.add(const TextSpan(text: '\n'));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return spans;
  }
}

class _Config {
  TextStyle? boldStyle;
  TextStyle? italicBoldStyle;
  TextStyle? strikethroughStyle;
  TextStyle? monospaceStyle;
  TextStyle? underlineStyle;

  void setBoldStyle(TextStyle style) {
    boldStyle = style;
  }

  void setItalicBoldStyle(TextStyle style) {
    italicBoldStyle = style;
  }

  void setStrikethroughStyle(TextStyle style) {
    strikethroughStyle = style;
  }

  void setMonospaceStyle(TextStyle style) {
    monospaceStyle = style;
  }

  void setUnderlineStyle(TextStyle style) {
    underlineStyle = style;
  }
}
