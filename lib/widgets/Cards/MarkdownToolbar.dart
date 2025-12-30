import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MarkdownToolbar extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownToolbar({
    super.key,
    required this.controller,
  });

  // -----------------------------------
  // Helper Functions
  // -----------------------------------

  int safeCursor() {
    final sel = controller.selection.start;
    return sel < 0 ? 0 : sel;
  }

  int lineStart() {
    final cursor = safeCursor();
    if (controller.text.isEmpty) return 0;

    return controller.text.lastIndexOf('\n', cursor - 1) + 1;
  }

  String currentLine() {
    final text = controller.text;
    final cursor = safeCursor();
    final start = lineStart();
    final end = text.indexOf('\n', cursor);
    return text.substring(start, end == -1 ? text.length : end);
  }


  // -----------------------------------
  // Bold (**)
  // -----------------------------------

  void toggleBold() {
    final sel = controller.selection;
    final text = controller.text;

    // Cursor only (no selection)
    if (sel.isCollapsed) {
      final cursor = sel.start;

      // Check if cursor is between "**|**"
      if (cursor >= 2 &&
          cursor + 2 <= text.length &&
          text.substring(cursor - 2, cursor) == '**' &&
          text.substring(cursor, cursor + 2) == '**') {
        // Remove empty bold
        controller.text = text.replaceRange(cursor - 2, cursor + 2, '');
        controller.selection =
            TextSelection.collapsed(offset: cursor - 2);
        return;
      }

      // Insert "** **" and place cursor inside
      controller.text = text.replaceRange(cursor, cursor, '****');
      controller.selection =
          TextSelection.collapsed(offset: cursor + 2);
      return;
    }

    // Selection exists
    final selected = text.substring(sel.start, sel.end);

    // Already wrapped -> unwrap
    if (selected.startsWith('**') && selected.endsWith('**')) {
      final inner = selected.substring(2, selected.length - 2);

      // If empty remove entirely
      if (inner.isEmpty) {
        controller.text =
            text.replaceRange(sel.start, sel.end, '');
        controller.selection = TextSelection.collapsed(offset: sel.start);
      } else {
        // Normal unwrap
        controller.text =
            text.replaceRange(sel.start, sel.end, inner);
        controller.selection =
            TextSelection.collapsed(offset: sel.start + inner.length);
      }
    } else {
      // Wrap selection
      final wrapped = '**$selected**';
      controller.text =
          text.replaceRange(sel.start, sel.end, wrapped);
      controller.selection =
          TextSelection.collapsed(offset: sel.start + wrapped.length);
    }
  }

  // -----------------------------------
  // Italic (_)
  // -----------------------------------

  void toggleItalic() {
    final sel = controller.selection;
    final text = controller.text;

    // Cursor only (no selection)
    if (sel.isCollapsed) {
      final cursor = sel.start;

      // Check if cursor is between "_|_"
      if (cursor >= 1 &&
          cursor + 1 <= text.length &&
          text.substring(cursor - 1, cursor) == '_' &&
          text.substring(cursor, cursor + 1) == '_') {
        // Remove empty bold
        controller.text = text.replaceRange(cursor - 1, cursor + 1, '');
        controller.selection =
            TextSelection.collapsed(offset: cursor - 1);
        return;
      }

      // Insert "__" and place cursor inside
      controller.text = text.replaceRange(cursor, cursor, '__');
      controller.selection =
          TextSelection.collapsed(offset: cursor + 1);
      return;
    }

    // Selection exists
    final selected = text.substring(sel.start, sel.end);

    // Already wrapped -> unwrap
    if (selected.startsWith('_') && selected.endsWith('_')) {
      final inner = selected.substring(1, selected.length - 1);

      // If empty remove entirely
      if (inner.isEmpty) {
        controller.text =
            text.replaceRange(sel.start, sel.end, '');
        controller.selection = TextSelection.collapsed(offset: sel.start);
      } else {
        // Normal unwrap
        controller.text =
            text.replaceRange(sel.start, sel.end, inner);
        controller.selection =
            TextSelection.collapsed(offset: sel.start + inner.length);
      }
    } else {
      // Wrap selection
      final wrapped = '_${selected}_';
      controller.text =
          text.replaceRange(sel.start, sel.end, wrapped);
      controller.selection =
          TextSelection.collapsed(offset: sel.start + wrapped.length);
    }
  }


  // -----------------------------------
  // Header (#)
  // -----------------------------------

  void toggleHeader() {
    final text = controller.text;
    final sel = controller.selection;
    final start = lineStart();
    final lineEnd = text.indexOf('\n', start);
    final end = lineEnd == -1 ? text.length : lineEnd;
    final line = text.substring(start, end);

    // Detect current level
    int level = 0;
    if (line.startsWith('### ')) level = 3;
    else if (line.startsWith('## ')) level = 2;
    else if (line.startsWith('# ')) level = 1;

    // Compute next level (0 -> 1 -> 2 -> 3 -> 0)
    final nextLevel = (level + 1) % 4;

    // Remove existing header
    int removeLength = level > 0 ? level + 1 : 0; // "# ", "## ", "### "
    String newText = text;
    int cursorOffset = sel.start;

    if (removeLength > 0) {
      newText = newText.replaceRange(start, start + removeLength, '');
      if (cursorOffset >= start + removeLength) {
        cursorOffset -= removeLength;
      } else if (cursorOffset > start) {
        cursorOffset = start;
      }
    }

    // Add new prefix if needed
    if (nextLevel > 0) {
      final prefix = '${'#' * nextLevel} ';
      newText = newText.replaceRange(start, start, prefix);
      cursorOffset += prefix.length;
    }

    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: cursorOffset.clamp(0, newText.length),
    );
  }

  // -----------------------------------
  // List (-)
  // -----------------------------------
  void toggleList() {
    final text = controller.text;
    final sel = controller.selection;
    final cursor = sel.start < 0 ? 0 : sel.start;

    final start = lineStart();
    final lineEnd = text.indexOf('\n', start);
    final end = lineEnd == -1 ? text.length : lineEnd;
    final line = text.substring(start, end);

    int cursorOffset = cursor;

    // Detect header level
    int headerLength = 0;
    if (line.startsWith('### ')) {
      headerLength = 4;
    } else if (line.startsWith('## ')) {
      headerLength = 3;
    } else if (line.startsWith('# ')) {
      headerLength = 2;
    }

    // CASE 1: replace Header with List
    if (headerLength > 0) {
      // Remove header
      controller.text =
          text.replaceRange(start, start + headerLength, '- ');

      // Adjust cursor
      if (cursorOffset >= start + headerLength) {
        cursorOffset = cursorOffset - headerLength + 2;
      } else if (cursorOffset > start) {
        cursorOffset = start + 2;
      }
    }
    // CASE 2: Already a List so remove it
    else if (line.startsWith('- ')) {
      controller.text = text.replaceRange(start, start + 2, '');

      if (cursorOffset >= start + 2) {
        cursorOffset -= 2;
      } else if (cursorOffset > start) {
        cursorOffset = start;
      }
    }
    // CASE 3: Add List
    else {
      controller.text = text.replaceRange(start, start, '- ');
      cursorOffset += 2;
    }

    controller.selection = TextSelection.collapsed(
      offset: cursorOffset.clamp(0, controller.text.length),
    );
  }

  // -----------------------------------
  // Checklist (- [ ])
  // -----------------------------------
  void toggleChecklist() {
    final text = controller.text;
    final sel = controller.selection;
    final cursor = sel.start < 0 ? 0 : sel.start;

    final start = lineStart();
    final lineEnd = text.indexOf('\n', start);
    final end = lineEnd == -1 ? text.length : lineEnd;
    final line = text.substring(start, end);

    int cursorOffset = cursor;

    // Detect header
    int headerLength = 0;
    if (line.startsWith('### ')) {
      headerLength = 4;
    } else if (line.startsWith('## ')) {
      headerLength = 3;
    } else if (line.startsWith('# ')) {
      headerLength = 2;
    }

    // CASE 1: Header -> Checklist
    if (headerLength > 0) {
      controller.text = text.replaceRange(
        start,
        start + headerLength,
        '- [ ] ',
      );

      if (cursorOffset >= start + headerLength) {
        cursorOffset = cursorOffset - headerLength + 6;
      } else {
        cursorOffset = start + 6;
      }
    }
    // CASE 2: Unchecked -> Checked
    else if (line.startsWith('- [ ] ')) {
      controller.text =
          text.replaceRange(start, start + 6, '- [x] ');
      // cursor stays
    }
    // CASE 3: Checked -> Remove checklist
    else if (line.startsWith('- [x] ')) {
      controller.text =
          text.replaceRange(start, start + 6, '');
      if (cursorOffset >= start + 6) {
        cursorOffset -= 6;
      } else if (cursorOffset > start) {
        cursorOffset = start;
      }
    }
    // CASE 4: Plain list -> Checklist
    else if (line.startsWith('- ')) {
      controller.text =
          text.replaceRange(start, start + 2, '- [ ] ');
      cursorOffset += 4;
    }
    // CASE 5: Plain text -> Checklist
    else {
      controller.text =
          text.replaceRange(start, start, '- [ ] ');
      cursorOffset += 6;
    }

    controller.selection = TextSelection.collapsed(
      offset: cursorOffset.clamp(0, controller.text.length),
    );
  }


  // -----------------------------------
  // UI
  // -----------------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Header',
              icon: Icon(
                Symbols.format_h1_rounded,
                weight: 600,
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: toggleHeader,
            ),
            IconButton(
              tooltip: 'Bold',
              icon: Icon(
                Symbols.format_bold_rounded,
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: toggleBold,
            ),
            IconButton(
              tooltip: 'Italic',
              icon: Icon(
                Symbols.format_italic_rounded,
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: toggleItalic,
            ),
            IconButton(
              tooltip: 'List',
              icon: Icon(
                Symbols.format_list_bulleted_rounded,
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: toggleList,
            ),
            IconButton(
              tooltip: 'Checklist',
              icon: Icon(
                Symbols.checklist_rounded,
                color: colorScheme.primary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
              onPressed: toggleChecklist,
            ),
          ],
        ),
      ),
    );
  }
}
