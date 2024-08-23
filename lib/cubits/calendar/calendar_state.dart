part of 'calendar_cubit.dart';

// import '../../models/calendar.dart';

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState.initial() = _Initial;
  const factory CalendarState.loading() = _Loading;
  const factory CalendarState.success({required List<CalendarItem> result}) =
      _Success;
}
