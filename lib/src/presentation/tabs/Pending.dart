import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:zohomain/src/presentation/provider/regularProvider.dart';

class Pending extends ConsumerWidget {
  final String selectedDropdownValue;
  final String role;
  
  const Pending(
      {Key? key, required this.selectedDropdownValue, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(statusProvider).setPendingList();
    final pendingList = ref.watch(statusProvider).pendingList;

    if (pendingList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
              'https://lottie.host/bd0e5132-2c38-407a-ba72-f1892558f9c5/yop6ZBBJIu.json',
              fit: BoxFit.cover,
            ),
            Text(
              AppLocalizations.of(context)!.norecords,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.norecordsnow,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: pendingList.length,
        itemBuilder: (context, index) {
          final regularizationData = pendingList[index];
          final dateFormat = DateFormat('yyyy-MM-dd');
          final formattedDate =
              dateFormat.format(DateTime.parse(regularizationData.date));

          return Center(
            child: SizedBox(
              width: 340,
              height: role == "Admin"
                  ? 220
                  : 170,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${regularizationData.employeeName}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.date}: $formattedDate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.checkin}: ${regularizationData.checkInTime.hour.toString().padLeft(2, '0')}:${regularizationData.checkInTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.checkout}: ${regularizationData.checkOutTime.hour.toString().padLeft(2, '0')}:${regularizationData.checkOutTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.hours}: ${regularizationData.hours}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.reason}: ${regularizationData.dropdownValue}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      role == "Admin"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(regularizationProvider.notifier)
                                        .updateRegularization(
                                            regularizationData.id, "Approved");
                                    ref.read(statusProvider).setPendingList();
                                    ref.read(statusProvider).setApprovedList();
                                    ref.read(statusProvider).setRejectedList();
                                    showNotification("Status Updated",
                                        "Your regularization has been Approved");
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                  ),
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(regularizationProvider.notifier)
                                        .updateRegularization(
                                            regularizationData.id, "Rejected");
                                    ref.read(statusProvider).setPendingList();
                                    ref.read(statusProvider).setApprovedList();
                                    ref.read(statusProvider).setRejectedList();
                                    showNotification("Status Updated",
                                        "Your regularization has been Rejected");
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10),
                                  ),
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}