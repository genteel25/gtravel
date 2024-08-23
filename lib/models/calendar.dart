class CalendarItem {
  final int day;
  final MonthData month;
  List<TravelRangeData>? travelDays;

  CalendarItem({required this.month, required this.day, this.travelDays});
}

class MonthData {
  final String monthName;
  final int monthIndex;
  final String shortenedMonth;
  final String suffix;
  MonthData(
      {required this.monthName,
      required this.monthIndex,
      required this.shortenedMonth,
      required this.suffix});
}

class TravelRangeData {
  CountryData? country;
  DateData? startDay;
  DateData? endDay;

  TravelRangeData({this.country, this.endDay, this.startDay});
}

class DateData {
  String? day;
  String? month;
  String? year;
  DateData({this.day, this.month, this.year});
}

enum ColorEnum { orange, blue, pink, purple, unknown }

class CountryData {
  final String name;
  final ColorEnum color;

  CountryData({required this.color, required this.name});
}
