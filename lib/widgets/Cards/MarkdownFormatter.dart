import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MarkdownFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    // Handle backspace deletion
    if (newValue.text.length < oldValue.text.length) {
      final oldText = oldValue.text;
      final cursor = oldValue.selection.start;

      if (cursor >= 6 &&
          oldText.substring(cursor - 6, cursor) == '- [ ] ') {
        final newText =
        oldText.replaceRange(cursor - 6, cursor, '');
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursor - 6),
        );
      }

      if (cursor >= 6 &&
          oldText.substring(cursor - 6, cursor) == '- [x] ') {
        final newText =
        oldText.replaceRange(cursor - 6, cursor, '');
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursor - 6),
        );
      }

      if (cursor >= 2 &&
          oldText.substring(cursor - 2, cursor) == '- ') {
        final newText =
        oldText.replaceRange(cursor - 2, cursor, '');
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursor - 2),
        );
      }

      return newValue;
    }

    // Only react to newline insertion
    if (!newValue.text.endsWith('\n')) {
      return newValue;
    }

    final cursor = newValue.selection.start;
    final text = newValue.text;

    // Find start of previous line
    final prevLineEnd = cursor - 1;
    final prevLineStart =
        text.lastIndexOf('\n', prevLineEnd - 1) + 1;

    final prevLine =
    text.substring(prevLineStart, prevLineEnd);

    String? insert;

    // Checklist
    if (prevLine.startsWith('- [ ] ')) {
      if (prevLine.trim() == '- [ ]') {
        insert = ''; // exit list
      } else {
        insert = '- [ ] ';
      }
    }
    // Checked checklist
    else if (prevLine.startsWith('- [x] ')) {
      if (prevLine.trim() == '- [x]') {
        insert = '';
      } else {
        insert = '- [ ] ';
      }
    }
    // Bullet list
    else if (prevLine.startsWith('- ')) {
      if (prevLine.trim() == '-') {
        insert = '';
      } else {
        insert = '- ';
      }
    }

    if (insert == null) return newValue;

    final newText =
    text.replaceRange(cursor, cursor, insert);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: cursor + insert.length,
      ),
    );
  }
}