import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/presentation/provider/changeNotifer.dart';
import 'package:zohomain/src/presentation/views/User/login.dart';
import 'package:zohomain/src/presentation/widgets/UserDropdown.dart';

class Home extends StatelessWidget { 
  final CheckInProvider checkInProvider = CheckInProvider();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM').format(now);
    return ChangeNotifierProvider.value(
      value: checkInProvider,
      child: Consumer<CheckInProvider>(
        builder: (context, checkInProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.home,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg',
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 340,
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg',
                                ),
                              ),
                              Text('Santra Richard',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text(
                                  AppLocalizations.of(context)!.productdesigner,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey)),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!.date,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        formattedDate, // Display formatted date
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!
                                            .employeeid,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '3445',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly, // Adjust alignment as needed
                                children: [
                                  SizedBox(
                                    height: 40, // Set desired height
                                    width: 150, // Set desired width
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 75, 195, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.logout,
                                        style: TextStyle(
                                            color: Colors
                                                .white), // Set text color to white
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40, // Set desired height
                                    width: 150, // Set desired width
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 75, 195, 255)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.close,
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 75, 195,
                                                255)), // Set text color to white
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.info), // Search icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Language()),
                    );
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: SizedBox(
                      width: 340,
                      height: 600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/home.json',
                            width: 300,
                            height: 200,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 75, 195, 255),
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${checkInProvider.hours}'.padLeft(2, '0'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Text(':', style: TextStyle(fontSize: 30)),
                              SizedBox(width: 05),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 75, 195, 255),
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${checkInProvider.minutes}'
                                        .padLeft(2, '0'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Text(':', style: TextStyle(fontSize: 30)),
                              SizedBox(width: 05),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 75, 195, 255),
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${checkInProvider.seconds}'
                                        .padLeft(2, '0'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            formattedDate,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Text(
                            AppLocalizations.of(context)!.generally,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              checkInProvider.toggleCheckIn();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 10),
                              // Dynamically set the background color based on isCheckedIn value
                              backgroundColor: checkInProvider.isCheckedIn
                                  ? Colors.red
                                  : Color.fromARGB(255, 92, 212, 88),
                            ),
                            child: Text(
                              checkInProvider.isCheckedIn
                                  ? '${AppLocalizations.of(context)!.checkout}'
                                  : '${AppLocalizations.of(context)!.checkin}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
        },
      ),
    );
  }
}