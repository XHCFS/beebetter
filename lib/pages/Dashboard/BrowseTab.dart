import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:beebetter/pages/Dashboard/DashboardLogic.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:beebetter/widgets/Cards/PreviousEntry.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = context.watch<DashboardLogic>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // Calendar Title
          // ---------------------------------------------------
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

          Card(
            color: colorScheme.onPrimary,
            shadowColor: colorScheme.inversePrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------
                  // Prompt List
                  // ---------------------------------------------------
                  if (logic.prompts.isEmpty)
                    Text(
                      "No entries for this day.",
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.primary.withAlpha(160)),
                    )
                  else
                    Column(
                      children: logic.prompts.map((prompt) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PreviousEntry(
                            prompt: prompt.prompt,
                            category: prompt.category,
                            isText: prompt.isText ?? false,
                          ),
                        );
                      }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}