import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtravel/models/calendar.dart';

import '../../cubits/calendar/calendar_cubit.dart';

class CalendarItemWidget extends StatelessWidget {
  const CalendarItemWidget(
      {super.key,
      required this.onCalendarClickHandler,
      required this.selectedDay,
      required this.thisMonthDays,
      required this.index,
      required this.onSelectDay});
  final Function onCalendarClickHandler;
  final CalendarItem thisMonthDays;
  final CalendarItem selectedDay;
  final int index;
  final Function onSelectDay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onCalendarClickHandler(),
      child: Container(
        width: 60,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          // color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                alignment: Alignment.center,
                height: 70,
                width: 60,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                decoration: BoxDecoration(
                    color: thisMonthDays == selectedDay
                        ? Colors.yellow.shade600
                        : Colors.black87.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: thisMonthDays.day.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: selectedDay == thisMonthDays
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            children: [
                          TextSpan(
                            text: thisMonthDays.month.suffix,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: selectedDay == thisMonthDays
                                  ? Colors.black
                                  : Colors.white,
                              fontFeatures: const [FontFeature.superscripts()],
                            ),
                          )
                        ])),
                    // const SizedBox(height: 5),
                    Text(
                      thisMonthDays.month.shortenedMonth,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: selectedDay == thisMonthDays
                            ? Colors.black
                            : Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                return state.whenOrNull(
                        success: (item) => Column(
                              children: [
                                if (selectedDay == item[index] &&
                                    (item[index].travelDays?.isEmpty ?? true))
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: InkWell(
                                      onTap: () => onSelectDay(),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.black87)),
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )) ??
                    const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
