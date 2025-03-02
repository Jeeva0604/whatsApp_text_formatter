# WhatsApp Text Formatter

**WhatsApp Text Formatter** is a Flutter package that allows you to format text similar to WhatsApp's rich text formatting. It supports bold, italic, strikethrough, monospace, underline, and custom colors.

## Features
- **Bold:** `**Bold Text**` → **Bold Text**
- **Italic:** `*Italic Text*` → *Italic Text*
- **Strikethrough:** `~~Strikethrough~~` → ~~Strikethrough~~
- **Monospace:** `` `Monospace` `` → `Monospace`
- **Underline:** `__Underline__` → <u>Underline</u>
- **Custom Colors:** `{#ff0000}Red Text` → Red Text (Hex color supported)

## Getting Started
To use this package, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  whatsapp_text_formatter: latest_version
```

Then, run:
```sh
flutter pub get
```

## Usage
Import the package:
```dart
import 'package:whatsapp_text_formatter/whatsapp_text_formatter.dart';
```

### Example:
```dart
WhatsAppTextFormatter(
text: "**Bold** *Italic* ~~Strikethrough~~ `Monospace` {#ff0000}Red",
style: TextStyle(fontSize: 16),
textAlign: TextAlign.start,
)
```

## Example Output:
```
Bold Italic ~~Strikethrough~~ `Monospace` Red
```

## Additional Information
- Visit the [GitHub repository](https://github.com/Jeeva0604/whatsApp_text_formatter) for source code and contributions.
- File issues or feature requests in the [issue tracker](https://github.com/Jeeva0604/whatsApp_text_formatter/issues).
- Feel free to contribute and improve this package!

## License
This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

