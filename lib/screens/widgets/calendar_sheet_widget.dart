import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtravel/cubits/calendar/calendar_cubit.dart';
import 'package:gtravel/cubits/country/country_cubit.dart';
import 'package:gtravel/models/calendar.dart';
import 'package:gtravel/utils/app_utils.dart';
import 'package:gtravel/utils/extensions.dart';

class CalendarSheetWidget extends StatefulWidget {
  const CalendarSheetWidget(
      {super.key, required this.item, required this.isEdit});
  final CalendarItem item;
  final bool isEdit;

  @override
  State<CalendarSheetWidget> createState() => _CalendarSheetWidgetState();
}

class _CalendarSheetWidgetState extends State<CalendarSheetWidget> {
  List<CountryData> countries = [];

  List<String> daysOfWeek = [];

  @override
  void initState() {
    super.initState();
    countries = context.read<CountryCubit>().countriesList;
    context.read<CountryCubit>().selectCountryHandler();
    daysOfWeek = context.read<CalendarCubit>().days;
    if (widget.isEdit) {
      int currentDataIndex =
          widget.item.travelDays == null || widget.item.travelDays!.isEmpty
              ? 0
              : context.read<CountryCubit>().countriesList.indexWhere((item) =>
                  item.name == widget.item.travelDays?.last.country?.name);
      context.read<CountryCubit>().selectCountryHandler(
          country: context.read<CountryCubit>().countriesList[currentDataIndex +
              int.parse(
                  "${context.read<CountryCubit>().countriesList.length > currentDataIndex + 1 ? "1" : "0"}")]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterLogo(
                size: 80,
              ),
              Text(
                "Select dates of your trip",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(
                countries.length,
                (index) => BlocBuilder<CountryCubit, CountryState>(
                      builder: (context, state) {
                        return state.whenOrNull(
                                selectedSuccess: (item) => GestureDetector(
                                      onTap: () => context
                                          .read<CountryCubit>()
                                          .selectCountryHandler(
                                              country: countries[index]),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                            color: item == countries[index]
                                                ? AppUtils.colorChecker(
                                                    countries[index].color)
                                                : null,
                                            border: Border.all(
                                                color: AppUtils.colorChecker(
                                                    countries[index].color),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Text(countries[index].name),
                                      ),
                                    )) ??
                            const SizedBox.shrink();
                      },
                    )),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    daysOfWeek.length,
                    (index) => Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "${widget.item.month.monthName} ${DateTime.now().year}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 2,
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 2,
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                BlocBuilder<CountryCubit, CountryState>(
                  builder: (context, state) {
                    return state.whenOrNull(
                          selectedSuccess: (item) => CalendarView(
                            month: widget.item.month.monthIndex,
                            year: DateTime.now().year,
                            day: widget.item.day,
                            item: widget.item,
                            selectedCountry: item,
                            isEdit: widget.isEdit,
                            // onRangeAdded: (e) => selectCountryHandler(e),
                          ),
                        ) ??
                        const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context
                      .read<CalendarCubit>()
                      .addTravelRangesToCalender(item: widget.item);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Done",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 32),
                    Icon(
                      Icons.arrow_forward,
                      size: 32,
                    )
                  ],
                )),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}

class CalendarView extends StatefulWidget {
  final int month;
  final int year;
  final int day;
  final CalendarItem item;
  final CountryData selectedCountry;
  final bool isEdit;

  const CalendarView({
    super.key,
    required this.month,
    required this.year,
    required this.item,
    required this.day,
    required this.selectedCountry,
    required this.isEdit,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late int totalDays;
  late DateTime firstDay;
  late int startingWeekday;

  List<TravelRangeData>? travelData;

  initializeTravelData() {
    totalDays = DateTime(widget.year, widget.month + 1, 0).day;
    firstDay = DateTime(widget.year, widget.month, 1);
    startingWeekday = firstDay.weekday;
    // if (widget.isEdit) {
    for (var item in (widget.item.travelDays ?? [])) {
      context.read<CalendarCubit>().insertTravelRange(item);
    }
    travelData = widget.item.travelDays ?? [];

    if (widget.isEdit) {
      calenderCellColorHandler(
          int.parse(widget.item.travelDays?.last.endDay?.day ?? "1"));
    } else {
      calenderCellColorHandler(widget.day);
    }
  }

  TravelRangeData currentRangeData = TravelRangeData();

  calenderCellColorHandler(int day) {
    log("is edit day: $day");
    if (day >= widget.day) {
      if (currentRangeData.startDay?.day == null ||
          currentRangeData.startDay!.day!.isEmpty) {
        currentRangeData.startDay = DateData(
            day: day.toString(),
            month: widget.month.toString(),
            year: widget.year.toString());
        currentRangeData.country = widget.selectedCountry;
      } else if (currentRangeData.startDay?.day != null &&
          currentRangeData.startDay!.day!.isNotEmpty) {
        if (!travelData!.any((item) => isWithinRanges(day,
            item.startDay!.day!.intParser(), item.endDay!.day!.intParser()))) {
          currentRangeData.endDay = DateData(
              day: day.toString(),
              month: widget.month.toString(),
              year: widget.year.toString());
          currentRangeData.country = widget.selectedCountry;
          travelData?.add(currentRangeData);
          context.read<CalendarCubit>().insertTravelRange(currentRangeData);
          currentRangeData = TravelRangeData();

          context.read<CountryCubit>().autoSelectCountryHandler();
          calenderCellColorHandler(day);
        } else {
          currentRangeData = TravelRangeData();
        }
      }
      setState(() {});
    }
  }

  bool isWithinRanges(int number, int min, int max) {
    return number >= min && number <= max;
  }

  @override
  void initState() {
    super.initState();
    initializeTravelData();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalDays + startingWeekday,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          return const SizedBox.shrink();
        }
        final day = index - startingWeekday + 1;
        List<TravelRangeData> datas = currentRangeData.startDay?.day != null &&
                currentRangeData.startDay!.day!.isNotEmpty &&
                day.toString() == currentRangeData.startDay?.day
            ? [currentRangeData]
            : travelData!
                .where((item) => isWithinRanges(
                    day,
                    item.startDay!.day!.intParser(),
                    item.endDay!.day!.intParser()))
                .toList();
        return InkWell(
          onTap: () => calenderCellColorHandler(day),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: datas.isNotEmpty && datas.length == 1
                  ? AppUtils.colorChecker(datas.first.country!.color, true)
                  : null,
              gradient: datas.isNotEmpty && datas.length > 1
                  ? LinearGradient(
                      stops: const [0.5, 0.5],
                      transform: const GradientRotation(70),
                      colors: [
                        AppUtils.colorChecker(datas.first.country!.color, true),
                        AppUtils.colorChecker(datas.last.country!.color, true)!
                      ],
                    )
                  : null,
            ),
            child: Text(
              '$day',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
