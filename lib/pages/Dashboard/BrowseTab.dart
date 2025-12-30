import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beebetter/widgets/Cards/PreviousEntries/PreviousEntry.dart';

class BrowseTab extends StatefulWidget {
  @override
  BrowseTabStatefulState createState() => BrowseTabStatefulState();
}
class BrowseTabStatefulState extends State<BrowseTab> {
  String? expandedIndex;
  String searchQuery = "";

  Future<bool> confirmDelete(BuildContext context, String title) async {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: colorScheme.surfaceContainerLow.withAlpha(128),
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: colorScheme.onPrimary,
        title: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              "Delete Entry?",
              style: textTheme.titleMedium,
            ),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: "You’re about to delete "),
              TextSpan(
                text: "“$title”",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const TextSpan(
                text: ". This action cannot be undone.",
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    return result ?? false;
  }
  

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<DashboardLogic>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSearching = searchQuery.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // Search Bar
          // ---------------------------------------------------
          TextField(
            decoration: InputDecoration(
              hintText: "Search entries...",
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary.withAlpha(128),
              ),
              prefixIcon: Icon(Icons.search, color: colorScheme.primary,),
              filled: true,
              fillColor: colorScheme.onPrimary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
            ),
            onChanged: (value) async {
              setState(() {
                searchQuery = value.trim().toLowerCase();
              });
              // Trigger search in logic
              await logic.searchEntries(searchQuery);
            },
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------
          // Calendar Title
          // ---------------------------------------------------
          if (!isSearching) ...[
            Row(
              children: [
                Icon(
                  Symbols.calendar_month_rounded,
                  size: 32,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                Text(
                  "Calendar",
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ---------------------------------------------------
            // Calendar
            // ---------------------------------------------------
            Card(
              color: colorScheme.onPrimary,
              shadowColor: colorScheme.inversePrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: logic.focusedDay,

                  selectedDayPredicate: (day) =>
                      isSameDay(logic.selectedDay, day),

                  eventLoader: (day) {
                    return logic.getEntriesForDay(day);
                  },

                  onDaySelected: (selectedDay, focusedDay) {
                    logic.selectDay(selectedDay, focusedDay);
                  },

                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: textTheme.titleMedium!
                        .copyWith(color: colorScheme.primary),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: colorScheme.primary,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: colorScheme.primary,
                    ),
                  ),

                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(40),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: colorScheme.inversePrimary,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle:
                    TextStyle(color: colorScheme.primary),
                    weekendTextStyle:
                    TextStyle(color: colorScheme.primary.withAlpha(160)),
                    selectedTextStyle: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),

                    todayTextStyle: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle:
                    TextStyle(color: colorScheme.primary),
                    weekendStyle:
                    TextStyle(color: colorScheme.primary.withAlpha(160)),
                  ),

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      if (events.isEmpty) return const SizedBox.shrink();

                      return Positioned(
                        bottom: 6,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------
            // Selected Day
            // ---------------------------------------------------
            Row(
              children: [
                Icon(
                  Symbols.calendar_today_rounded,
                  size: 32,
                  color: colorScheme.primary.withAlpha(240),
                ),
                const SizedBox(width: 8),
                if (logic.selectedDay != null)
                  Text(
                    "Previous Entries: ${DateFormat('dd-MM-yyyy').format(logic.selectedDay!)}",
                    style: textTheme.titleMedium
                        ?.copyWith(color: colorScheme.primary),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------
            // List of Entries
            // ---------------------------------------------------
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // List of Entries
                // ---------------------------------------------------
                if (logic.entries.isEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      color: colorScheme.onPrimary,
                      shadowColor: colorScheme.inversePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "No entries for this day.",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: logic.entries.map((entry) {
                      final index = entry.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: PreviousEntry(
                          prompt: entry.title,
                          category: entry.category,
                          isText: entry.isText ?? false,
                          userInput: entry.userInput,
                          emotions: entry.emotions,
                          isExpanded: expandedIndex == index,
                          onTap: () {
                            setState(() {
                              if (expandedIndex == index) {
                                expandedIndex = null;
                              } else {
                                expandedIndex = index;
                              }
                            });
                          },
                          onDelete: () async {
                            final confirmed = await confirmDelete(context, entry.title);

                            if (confirmed) {
                              logic.deleteEntry(entry.id);
                            }
                          },
                        ),
                      );
                    }).toList(),
                ),
              ],
            ),
          ]
          else ...[
            // ---------------------------------------------------
            // List of Entries
            // ---------------------------------------------------
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------
                // List of Entries
                // ---------------------------------------------------
                if (logic.filteredEntries.isEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      color: colorScheme.onPrimary,
                      shadowColor: colorScheme.inversePrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "No entries found.",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                        ),
                      ),
                    ),
                  )
                else
                    Column(
                      children: logic.filteredEntries.map((entry) {
                        final index = entry.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: PreviousEntry(
                            prompt: entry.title,
                            category: entry.category,
                            isText: entry.isText ?? false,
                            userInput: entry.userInput,
                            emotions: entry.emotions,
                            isExpanded: expandedIndex == index,
                            onTap: () {
                              setState(() {
                                if (expandedIndex == index) {
                                  expandedIndex = null;
                                } else {
                                  expandedIndex = index;
                                }
                              });
                            },
                            onDelete: () async {
                              final confirmed = await confirmDelete(context, entry.title);

                              if (confirmed) {
                                logic.deleteEntry(entry.id);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}