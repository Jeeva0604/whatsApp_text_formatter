import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_text_formatter/whatsapp_text_formatter.dart';

void main() {
  const testKey = Key('formatted_text');

  Widget buildWidget(String text) {
    return MaterialApp(
      home: Scaffold(
        body: WhatsAppTextFormatter(
          key: testKey,
          text: text,
        ),
      ),
    );
  }

  testWidgets('WhatsAppTextFormatter renders bold text', (WidgetTester tester) async {
    const input = '*Bold*';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;

    bool foundBold = false;
    void searchBold(TextSpan span) {
      if (span.style?.fontWeight == FontWeight.bold && span.toPlainText() == 'Bold') {
        foundBold = true;
      }
      if (span.children != null) {
        for (final child in span.children!) {
          if (child is TextSpan) searchBold(child);
        }
      }
    }
    searchBold(span);

    expect(foundBold, isTrue);
  });

  testWidgets('WhatsAppTextFormatter renders italic text', (WidgetTester tester) async {
    const input = '_Italic_';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;

    bool foundItalic = false;
    void searchItalic(TextSpan span) {
      if (span.style?.fontStyle == FontStyle.italic && span.toPlainText() == 'Italic') {
        foundItalic = true;
      }
      if (span.children != null) {
        for (final child in span.children!) {
          if (child is TextSpan) searchItalic(child);
        }
      }
    }
    searchItalic(span);

    expect(foundItalic, isTrue);
  });

  testWidgets('WhatsAppTextFormatter renders strikethrough', (WidgetTester tester) async {
    const input = '~~Strike~~';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;

    bool foundStrike = false;
    void searchStrike(TextSpan span) {
      final style = span.style;
      if (style != null &&
          style.decoration != null &&
          style.decoration!.contains(TextDecoration.lineThrough) &&
          span.toPlainText() == 'Strike') {
        foundStrike = true;
      }
      if (span.children != null) {
        for (final child in span.children!) {
          if (child is TextSpan) searchStrike(child);
        }
      }
    }
    searchStrike(span);

    expect(foundStrike, isTrue);
  });

  testWidgets('WhatsAppTextFormatter renders monospace code block', (WidgetTester tester) async {
    const input = '```Monospace```';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    bool foundMonospace = false;
    void searchMonospace(TextSpan span) {
      if ((span.style?.fontFamily == 'monospace') && span.toPlainText() == 'Monospace') {
        foundMonospace = true;
      }
      if (span.children != null) {
        for (final child in span.children!) {
          if (child is TextSpan) searchMonospace(child);
        }
      }
    }
    searchMonospace(span);

    expect(foundMonospace, isTrue);
  });

  testWidgets('WhatsAppTextFormatter renders inline code', (WidgetTester tester) async {
    const input = '`Inline Code`';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    bool foundInlineCode = false;
    void searchInlineCode(TextSpan span) {
      final style = span.style;
      if (style != null &&
          style.fontFamily == 'monospace' &&
          style.backgroundColor == Colors.grey &&
          span.toPlainText() == 'Inline Code') {
        foundInlineCode = true;
      }
      if (span.children != null) {
        for (final child in span.children!) {
          if (child is TextSpan) searchInlineCode(child);
        }
      }
    }
    searchInlineCode(span);

    expect(foundInlineCode, isTrue);
  });

  testWidgets('WhatsAppTextFormatter renders bullet list', (WidgetTester tester) async {
    const input = '* Bullet Point\n- Second Point';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    final plain = span.toPlainText();
    expect(plain, contains('• Bullet Point'));
    expect(plain, contains('• Second Point'));
  });

  testWidgets('WhatsAppTextFormatter renders numbered list', (WidgetTester tester) async {
    const input = '1. First Item\n2. Second Item';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    final plain = span.toPlainText();
    expect(plain, contains('1. First Item'));
    expect(plain, contains('2. Second Item'));
  });

  testWidgets('WhatsAppTextFormatter renders quote', (WidgetTester tester) async {
    const input = '> Quoted Text';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    final plain = span.toPlainText();
    expect(plain, contains('> Quoted Text'));
  });

  testWidgets('WhatsAppTextFormatter renders mixed formatting', (WidgetTester tester) async {
    const input = '*Bold* _Italic_ ~~Strike~~ `inline` ```block```';
    await tester.pumpWidget(buildWidget(input));
    final richText = tester.widget<RichText>(find.descendant(of: find.byKey(testKey), matching: find.byType(RichText)));
    final span = richText.text as TextSpan;
    final plain = span.toPlainText();
    expect(plain, contains('Bold'));
    expect(plain, contains('Italic'));
    expect(plain, contains('Strike'));
    expect(plain, contains('inline'));
    expect(plain, contains('block'));
  });
}
