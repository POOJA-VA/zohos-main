import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zohomain/src/presentation/provider/changeNotifer.dart';
import 'package:zohomain/src/presentation/views/User/Regularization.dart';
import 'package:zohomain/src/presentation/views/User/UserList.dart';
import 'package:zohomain/src/presentation/views/User/login.dart';
import 'package:zohomain/src/presentation/widgets/AdminDropdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Admin extends StatelessWidget {
  final CheckInProvider checkInProvider = CheckInProvider();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, dd MMM').format(now);

    return ChangeNotifierProvider.value(
      value: checkInProvider,
      child: Consumer<CheckInProvider>(
        builder: (context, checkInProvider, _) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                AppLocalizations.of(context)!.welcomeAdmin,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/id/1396644902/photo/businesswoman-posing-and-smiling-during-a-meeting-in-an-office.jpg?s=612x612&w=0&k=20&c=7wzUE1CRFOccGnps-XZWOJIyDvqA3xGbL2c49PU5_m8=',
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 400,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                  'https://media.istockphoto.com/id/1396644902/photo/businesswoman-posing-and-smiling-during-a-meeting-in-an-office.jpg?s=612x612&w=0&k=20&c=7wzUE1CRFOccGnps-XZWOJIyDvqA3xGbL2c49PU5_m8=',
                                ),
                              ),
                              Text('Jessie',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text('Admin',
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
                                        'Date',
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
                                        'Admin Id',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '0001',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 150,
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
                                        style: TextStyle(color: Colors.white),
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
                  icon: Icon(Icons.person), // Search icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserList()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.info), // Search icon
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminLanguage()),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Approvals(
                role: "Admin",
              ),
            ),
          );
        },
      ),
    );
  }
}