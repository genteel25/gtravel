import 'package:flutter/material.dart';

import '../../models/calendar.dart';
import '../../utils/stateless_view.dart';
import '../controllers/home.dart';
import '../widgets/calendar_item_widget.dart';
import '../widgets/calendar_sheet_widget.dart';
import '../widgets/calendar_travel_data_widget.dart';

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
                        return CalendarItemWidget(
                          onCalendarClickHandler: () =>
                              controller.calendarClickHandler(
                                  controller.thisMonthDays[index]),
                          thisMonthDays: controller.thisMonthDays[index],
                          selectedDay: value!,
                          index: index,
                          onSelectDay: () => onSelectDay(context,
                              item: controller.thisMonthDays[index]),
                        );
                      });
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: controller.thisMonthDays.length,
              ),
            ),
            CalendarTravelDataWidget(
              selectedDay: controller.selectedDay.value!,
              onSelectDay: () => onSelectDay(
                context,
                item: controller.selectedDay.value!,
                isEdit: true,
              ),
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
