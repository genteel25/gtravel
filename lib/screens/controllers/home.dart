import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtravel/cubits/calendar/calendar_cubit.dart';
import 'package:gtravel/models/calendar.dart';

import '../views/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeController createState() => HomeController();
}

class HomeController extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => HomeView(this);

  @override
  void initState() {
    initializeToday();
    super.initState();
    // context.read<CalendarCubit>().fetchCalender();
    context
        .read<CalendarCubit>()
        .addTravelRangesToCalender(item: thisMonthDays.first);
  }

  List<CalendarItem> thisMonthDays = [];
  // CalendarItem? selectedDay;
  ValueNotifier<CalendarItem?> selectedDay = ValueNotifier(null);

  initializeToday() {
    thisMonthDays = context.read<CalendarCubit>().calendarItems;
    selectedDay.value = context.read<CalendarCubit>().calendarItems.first;
    setState(() {});
  }

  calendarClickHandler(CalendarItem day) {
    selectedDay.value = day;
    setState(() {});
  }

  @override
  void dispose() {
    selectedDay.dispose();
    super.dispose();
  }
}
