import 'package:gtravel/models/calendar.dart';
import 'package:intl/intl.dart';

class CalendarData {
  static final CalendarData _instance = CalendarData._internal();

  factory CalendarData() {
    return _instance;
  }

  CalendarData._internal(); // Private constructor
  List<String> getFormattedMonths() {
    final now = DateTime.now();
    final formatter = DateFormat('MMM');
    return List.generate(
      12,
      (month) => formatter.format(DateTime(now.year, month + 1)),
    );
  }

  List<CalendarItem> getFormattedDaysInMonth(int month, [int day = 0]) {
    final now = DateTime.now();
    final totalDays = DateTime(now.year, month + 1, day).day;
    // log("total days: $totalDays");
    final formatter = DateFormat('d');
    final fullMonthFormatter = DateFormat('MMMM');
    final monthFormatter = DateFormat('MMM');
    return List.generate(
      totalDays,
      (day) => CalendarItem(
          month: MonthData(
              monthName:
                  fullMonthFormatter.format(DateTime(now.year, month, day + 1)),
              monthIndex: month,
              shortenedMonth:
                  monthFormatter.format(DateTime(now.year, month, day + 1)),
              suffix: getDayWithOrdinal(int.parse(
                  formatter.format(DateTime(now.year, month, day + 1))))),
          day: int.parse(formatter.format(DateTime(now.year, month, day + 1)))),
    );
  }

  List<CalendarItem> getFormattedDaysInMonthFromToday(int month) {
    final now = DateTime.now();
    final totalDays = DateTime(now.year, month + 1, 0).day;
    final formatter = DateFormat('d');
    final monthFormatter = DateFormat('MMM');
    final fullMonthFormatter = DateFormat('MMMM');
    final currentDay = now.day;

    return List.generate(
      totalDays - currentDay + 1,
      (day) => CalendarItem(
          month: MonthData(
              monthName: fullMonthFormatter
                  .format(DateTime(now.year, month, currentDay + day)),
              monthIndex: month,
              shortenedMonth: monthFormatter
                  .format(DateTime(now.year, month, currentDay + day)),
              suffix: getDayWithOrdinal(int.parse(formatter
                  .format(DateTime(now.year, month, currentDay + day))))),
          day: int.parse(
              formatter.format(DateTime(now.year, month, currentDay + day)))),
    );
  }

  String getMonthName(int month) {
    final now = DateTime.now();
    final formatter = DateFormat('MMM');
    return formatter.format(DateTime(now.year, month));
  }

  String getDayWithOrdinal(int day) {
    final convertedString = day.toString();
    if (convertedString == "1") {
      return 'st';
    } else if (convertedString.length > 1 &&
        convertedString.split("").last == "1") {
      return 'st';
    } else if (convertedString == "2") {
      return 'nd';
    } else if (convertedString.length > 1 &&
        convertedString.split("").last == "2") {
      return 'nd';
    } else if (convertedString == "3") {
      return 'rd';
    } else if (convertedString.length > 1 &&
        convertedString.split("").last == "3") {
      return 'rd';
    } else {
      return 'th';
    }
  }
}
