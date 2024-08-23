import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gtravel/utils/calendar.dart';

import '../../models/calendar.dart';

part 'calendar_cubit.freezed.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(const CalendarState.initial());

  final List<CalendarItem> _items = [
    ...(CalendarData().getFormattedDaysInMonthFromToday(DateTime.now().month)),
    ...CalendarData().getFormattedDaysInMonth(DateTime.now().month + 1),
  ];

  List<CalendarItem> get calendarItems => _items;

  final List<TravelRangeData> rangeData = [];

  final List<String> _daysOfWeek = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  ];
  List<String> get days => _daysOfWeek;

  CalendarItem? selectedItem;

  void fetchCalender() {
    emit(CalendarState.success(result: calendarItems));
  }

  insertTravelRange(TravelRangeData data) {
    rangeData.add(data);
  }

  addTravelRangesToCalender({required CalendarItem item }) {
    // if(is)
    emit(const CalendarState.loading());
    int calendarIndex = _items.indexWhere((calendarItem) =>
        calendarItem.day == item.day &&
        calendarItem.month.monthIndex == item.month.monthIndex);
    _items[calendarIndex].travelDays = rangeData.toSet().toList();
    emit(CalendarState.success(result: calendarItems));
    rangeData.clear();
  }
}
