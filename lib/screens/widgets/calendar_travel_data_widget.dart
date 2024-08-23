import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/calendar/calendar_cubit.dart';
import '../../models/calendar.dart';

class CalendarTravelDataWidget extends StatefulWidget {
  const CalendarTravelDataWidget(
      {super.key, required this.selectedDay, required this.onSelectDay});
  final CalendarItem selectedDay;
  final Function onSelectDay;

  @override
  State<CalendarTravelDataWidget> createState() =>
      _CalendarTravelDataWidgetState();
}

class _CalendarTravelDataWidgetState extends State<CalendarTravelDataWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      // listener: (context, state) => state.whenOrNull(
      //     success: (item) => controller.initializeToday()),
      builder: (context, state) {
        return state.maybeWhen(
          success: (calendarItem) {
            List<CalendarItem> selectedItem = calendarItem
                .where((it) =>
                    it.day == widget.selectedDay.day &&
                    it.month.monthIndex == widget.selectedDay.month.monthIndex)
                .toList();
            if (selectedItem.isNotEmpty &&
                    selectedItem.first.travelDays == null ||
                (selectedItem.first.travelDays?.isEmpty ?? true)) {
              return const Expanded(
                child: const Center(
                  child: Text("Empty data"),
                ),
              );
            } else {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text:
                                "${selectedItem.first.travelDays?.first.startDay?.day ?? "hello"}.",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "${selectedItem.first.travelDays?.first.startDay?.month ?? "hello"}.",
                              ),
                              TextSpan(
                                text: selectedItem.first.travelDays?.first
                                        .startDay?.year ??
                                    "hello",
                              ),
                              const TextSpan(
                                text: " - ",
                              ),
                              TextSpan(
                                text:
                                    "${selectedItem.first.travelDays?.last.endDay?.day ?? "hello"}.",
                              ),
                              TextSpan(
                                text:
                                    "${selectedItem.first.travelDays?.last.endDay?.month ?? "hello"}.",
                              ),
                              TextSpan(
                                text: selectedItem
                                        .first.travelDays?.last.endDay?.year ??
                                    "hello",
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              "2 persons",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Icon(Icons.edit),
                            InkWell(
                              onTap: () => widget.onSelectDay(),
                              child: Container(
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
                                child: const Icon(Icons.edit, size: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 24),
                      itemBuilder: (context, index) {
                        final item = selectedItem.first.travelDays?[index];
                        return Column(
                          children: [
                            const Text(
                              "Place",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(item?.country?.name ?? ""),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 1, color: Colors.black26),
                      itemCount: selectedItem.first.travelDays!.length,
                    ),
                  ],
                ),
              );
            }
          },
          orElse: () {
            // log("it is else");
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
