import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/domain/Modal/regularization.dart';
import 'package:zohomain/src/presentation/provider/regularProvider.dart';

class Regular extends ConsumerStatefulWidget {
  final void Function(int index) navigateToTab; // Accept the callback function

  const Regular({Key? key, required this.navigateToTab}) : super(key: key);
  // const Regular({Key? key}) : super(key: key);
  
  @override
  ConsumerState<Regular> createState() => _RegularState();
}

class _RegularState extends ConsumerState<Regular> {
  late DateTime selectedDate;
  TimeOfDay? checkInTime;
  TimeOfDay? checkOutTime;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now().toUtc().add(Duration(hours: 5, minutes: 30));
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDateOfMonth = DateTime(now.year, now.month, 1);
    final DateTime lastDate = DateTime(now.year, now.month, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDateOfMonth,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String choose) async {
    if (choose == 'in' && checkInTime != null) {
      _showError(context, 'Check-in already set for the day');
      return;
    }
    if (choose == 'out' && checkOutTime != null) {
      _showError(context, 'Check-out already set for the day');
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (choose == "in") {
          checkInTime = pickedTime;
        } else if (choose == 'out' && checkInTime != null) {
          checkOutTime = pickedTime;
        }
      });
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reset() {
    setState(() {
      selectedDate = DateTime.now();
      checkInTime = null;
      checkOutTime = null;
      selectedValue = null;
    });
  }

  Future<bool> _canSubmitRegularization() async {
    final List<RegularizationData> regularizations =
        ref.read(regularizationProvider);
    for (var regularization in regularizations) {
      if (regularization.date == selectedDate.toString()) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = [
      AppLocalizations.of(context)!.forgottocheckin,
      AppLocalizations.of(context)!.forgottocheckout,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.regularization,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 340,
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.employee,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Santra Richards (EM-3445)',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 340,
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.date,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: Icon(Icons.arrow_forward_ios_outlined,
                              color: Colors.lightBlueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 340,
                height: 300,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                _selectTime(context, "in");
                              },
                              child: Text(
                                '${AppLocalizations.of(context)!.checkin}\n${selectedDate.day}-${selectedDate.month}-${selectedDate.year} \n${checkInTime?.format(context) ?? '--:--'}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.green),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _selectTime(context, "out");
                              },
                              child: Text(
                                '${AppLocalizations.of(context)!.checkout}\n${selectedDate.day}-${selectedDate.month}-${selectedDate.year} \n${checkOutTime?.format(context) ?? '--:--'}',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.red),
                              ),
                            ),
                            Text(
                              '${checkInTime != null && checkOutTime != null ? (checkOutTime!.hour - checkInTime!.hour >= 0 ? checkOutTime!.hour - checkInTime!.hour : 0) : 0}\n ${AppLocalizations.of(context)!.hrs}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 216, 219, 227),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  AppLocalizations.of(context)!.forgottocheckin,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).hintColor),
                                ),
                                items: items
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 40,
                                  width: 120,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15),
                          ),
                          onPressed: _reset,
                          child: Center(
                            child: Text(AppLocalizations.of(context)!.reset),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 120),
            Center(
              child: Container(
                height: 50,
                width: 340,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        if (await _canSubmitRegularization()) {
                          if (checkInTime != null && checkOutTime != null) {
                            final regularizationData = RegularizationData(
                              employeeName: 'Santra Richards (EM-3445)',
                              date: selectedDate.toString(),
                              checkInTime: checkInTime!,
                              checkOutTime: checkOutTime!,
                              hours: checkOutTime!.hour - checkInTime!.hour,
                              dropdownValue: selectedValue!,
                              status: "Pending",
                            );
                            ref
                                .read(regularizationProvider.notifier)
                                .insertRegularization(regularizationData);
                                Navigator.pop(context);
                            widget.navigateToTab(0);
                          } else {
                            _showError(context,
                                'Please set both Check-in and Check-out times.');
                          }
                        } else {
                          _showError(context,
                              'A regularization request for this date already exists.');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.submit,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
