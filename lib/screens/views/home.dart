import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtravel/cubits/calendar/calendar_cubit.dart';

import '../../models/calendar.dart';
import '../../utils/stateless_view.dart';
import '../controllers/home.dart';
import '../widgets/calendar_sheet_widget.dart';

class HomeView extends StatelessView<HomeScreen, HomeController> {
  const HomeView(super.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 85,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ValueListenableBuilder(
                      valueListenable: controller.selectedDay,
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () => controller.calendarClickHandler(
                              controller.thisMonthDays[index]),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 6),
                                    decoration: BoxDecoration(
                                        color: controller
                                                    .thisMonthDays[index] ==
                                                value
                                            ? Colors.yellow.shade600
                                            : Colors.black87.withOpacity(0.8),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: controller
                                                    .thisMonthDays[index].day
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: value ==
                                                          controller
                                                                  .thisMonthDays[
                                                              index]
                                                      ? Colors.black
                                                      : Colors.white,
                                                ),
                                                children: [
                                              TextSpan(
                                                text: controller
                                                    .thisMonthDays[index]
                                                    .month
                                                    .suffix,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: value ==
                                                          controller
                                                                  .thisMonthDays[
                                                              index]
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontFeatures: const [
                                                    FontFeature.superscripts()
                                                  ],
                                                ),
                                              )
                                            ])),
                                        // const SizedBox(height: 5),
                                        Text(
                                          controller.thisMonthDays[index].month
                                              .shortenedMonth,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: value ==
                                                    controller
                                                        .thisMonthDays[index]
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
                                                    if (value == item[index] &&
                                                        (item[index]
                                                                .travelDays
                                                                ?.isEmpty ??
                                                            true))
                                                      Align(
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: InkWell(
                                                          onTap: () => onSelectDay(
                                                              context,
                                                              item: controller
                                                                      .thisMonthDays[
                                                                  index]),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .black87)),
                                                            child: const Icon(
                                                              Icons
                                                                  .arrow_back_ios,
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
                      });
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: controller.thisMonthDays.length,
              ),
            ),
            BlocBuilder<CalendarCubit, CalendarState>(
              // listener: (context, state) => state.whenOrNull(
              //     success: (item) => controller.initializeToday()),
              builder: (context, state) {
                return state.maybeWhen(
                  success: (calendarItem) {
                    List<CalendarItem> selectedItem = calendarItem
                        .where((it) =>
                            it.day == controller.selectedDay.value?.day &&
                            it.month.monthIndex ==
                                controller.selectedDay.value?.month.monthIndex)
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
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
                                        text: selectedItem.first.travelDays
                                                ?.first.startDay?.year ??
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
                                        text: selectedItem.first.travelDays
                                                ?.last.endDay?.year ??
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
                                      onTap: () {
                                        onSelectDay(
                                          context,
                                          item: controller.selectedDay.value!,
                                          isEdit: true,
                                        );
                                      },
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
                                        child: Icon(
                                          Icons.edit,
                                          size: 14,
                                        ),
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
                                final item =
                                    selectedItem.first.travelDays?[index];
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
                                  const Divider(
                                      thickness: 1, color: Colors.black26),
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
            ),
          ],
        ),
      ),
    );
  }

  onSelectDay(BuildContext context,
      {required CalendarItem item, bool isEdit = false}) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return CalendarSheetWidget(item: item, isEdit: isEdit);
        });
  }
}
