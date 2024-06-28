import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:zohomain/src/presentation/barGraph/barGraph.dart';
import 'package:zohomain/src/presentation/provider/hoursProvider.dart';
import 'package:zohomain/src/presentation/provider/reportProvider.dart';

class Report extends ConsumerStatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  ConsumerState<Report> createState() => _ReportState();
}

class _ReportState extends ConsumerState<Report> {
  late String formattedStartDate;
  late String formattedEndDate;

  @override
  void initState() {
    super.initState();
    ref.read(hrsProvider.notifier).setHours();
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    ref
        .read(checkInOutProvider.notifier)
        .fetchCheckInOutList(startOfWeek, endOfWeek);
  }

  void _updateCheckInOutList(DateTime startDate, DateTime endDate) {
    ref
        .read(checkInOutProvider.notifier)
        .fetchCheckInOutList(startDate, endDate);
  }

  @override
  Widget build(BuildContext context) {
    final checkInOutList = ref.watch(checkInOutProvider);
    final hrsProviderNotifier = ref.watch(hrsProvider.notifier);
    final hrs = ref.watch(hrsProvider).hrs;
    final startDate = ref.watch(hrsProvider).startDate;
    final endDate = startDate.add(Duration(days: 6));

    formattedStartDate = DateFormat('dd/MM/yyyy').format(startDate);
    formattedEndDate = DateFormat('dd/MM/yyyy').format(endDate);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.report,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 340,
            height: 320,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.summaryReport,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: () {
                            setState(() {
                              hrsProviderNotifier.setPreviousWeek();
                              _updateCheckInOutList(
                                  ref.read(hrsProvider).startDate,
                                  ref
                                      .read(hrsProvider)
                                      .startDate
                                      .add(Duration(days: 6)));
                            });
                          },
                        ),
                        Text(
                          formattedStartDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Spacer(),
                        Text(
                          formattedEndDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_rounded),
                          onPressed: () {
                            setState(() {
                              hrsProviderNotifier.setCurrentWeek();
                              _updateCheckInOutList(
                                  ref.read(hrsProvider).startDate,
                                  ref
                                      .read(hrsProvider)
                                      .startDate
                                      .add(Duration(days: 6)));
                            });
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        height: 190,
                        child: BarGraph(
                          weeklySummary: hrs,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: checkInOutList.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.record),
                  )
                : ListView.builder(
                    itemCount: checkInOutList.length,
                    itemBuilder: (context, index) {
                      final checkInOut = checkInOutList[index];
                      String checkin = checkInOut['checkin'] ?? '--:--:--';
                      Color checkinColor = (checkin == '--:--:--')
                          ? const Color.fromARGB(255, 206, 203, 203)
                          : Color.fromARGB(255, 6, 5, 5);
                      String checkout = checkInOut['checkout'] ?? '--:--:--';
                      Color checkoutColor = (checkout == '--:--:--')
                          ? const Color.fromARGB(255, 206, 203, 203)
                          : Color.fromARGB(255, 6, 5, 5);
                      String hours = checkInOut['hours'] ?? 'Absent';
                      Color hoursColor =
                          (hours == 'Absent' || hours == 'Weekend')
                              ? Colors.red
                              : const Color.fromARGB(255, 15, 8, 3);

                      return Center(
                        child: SizedBox(
                          width: 340,
                          height: 130,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('EEEE, dd MMMM').format(
                                            DateTime.parse(checkInOut['date'])),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        hours,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: hoursColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg',
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                      SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .checkin,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 177, 178, 178),
                                            ),
                                          ),
                                          Text(
                                            checkin,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: checkinColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 50),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(context)!
                                                .checkout,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromARGB(
                                                  255, 177, 178, 178),
                                            ),
                                          ),
                                          Text(
                                            checkout,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: checkoutColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}