Here’s a refined version with improved readability, consistency, and minor corrections:

---

# WhatsApp Text Formatter

**WhatsApp Text Formatter** is a Flutter package that enables WhatsApp-style rich text formatting. It supports bold, italic, strikethrough, monospace, inline code, bulleted lists, numbered lists, and blockquotes.

## Features
- **Bold:** `*Bold Text*` → **Bold Text**
- **Italic:** `_Italic Text_` → *Italic Text*
- **Strikethrough:** `~Strikethrough~` → ~~Strikethrough~~
- **Monospace:** `` ```Monospace``` `` → `Monospace`
- **Inline Code:** `` `Inline Code` `` → `Inline Code`
- **Bulleted List:**
    - `* Item 1` or `- Item 1` →
        - Item 1
        - Item 2
- **Numbered List:**
    - `1. Item 1` →
        1. Item 1
        2. Item 2
- **Blockquote:**
    - `> Quote Text` →
      > Quote Text

## Installation
Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  whatsapp_text_formatter: latest_version
```  

Then, fetch the dependencies:

```sh
flutter pub get
```  

## Usage
Import the package:

```dart
import 'package:whatsapp_text_formatter/whatsapp_text_formatter.dart';
```  

### Example
```dart
WhatsAppTextFormatter(
text: """
**Bold**  
_Italic_  
~~Strikethrough~~  
```Monospace```  
`Inline Code`  
* Bullet Point  
- Another Bullet  
1. Numbered List  
> Quoted Text  
""",
style: TextStyle(
fontSize: 16,
),
textAlign: TextAlign.start,
),
```  

## Example Output
```
*Bold* _Italic_ ~Strikethrough~ `Monospace` `Inline Code`
- Bullet Point
1. Numbered List
> Quoted Text
```  

## Additional Information
- Check out the [GitHub repository](https://github.com/Jeeva0604/whatsApp_text_formatter) for the source code and contributions.
- Report issues or request features in the [issue tracker](https://github.com/Jeeva0604/whatsApp_text_formatter/issues).
- Contributions are welcome! Feel free to improve and expand this package.

## License
This package is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This version improves clarity, structure, and consistency while ensuring Markdown renders correctly. Let me know if you need further adjustments! 🚀