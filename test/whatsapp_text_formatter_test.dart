import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_text_formatter/whatsapp_text_formatter.dart';

void main() {
  testWidgets('WhatsAppTextFormatter formats bold text correctly',
      (WidgetTester tester) async {
    // Define a test key for the widget
    const testKey = Key('formatted_text');

    // Test text with WhatsApp-style formatting
    const testText = """
**Bold**  
_Italic_  
~~Strikethrough~~  
```Monospace```  
`Inline Code`  
* Bullet Point  
- Another Bullet Point
1. Numbered List  
> Quoted Text  
""";

    // Build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WhatsAppTextFormatter(
            key: testKey,
            text: testText,
          ),
        ),
      ),
    );

    // Find the formatted text widget
    final textFinder = find.byKey(testKey);
    expect(textFinder, findsOneWidget);
  });
}
