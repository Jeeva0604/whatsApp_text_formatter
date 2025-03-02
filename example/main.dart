import 'package:flutter/material.dart';
import 'package:whatsapp_text_formatter/whatsapp_text_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WhatsApp Text Formatter')),
        body: const Center(
          child: WhatsAppTextFormatter(
            text: "**Bold** *Italic* ~~Strikethrough~~ {#ff0000}Red Text",
          ),
        ),
      ),
    );
  }
}
