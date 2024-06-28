// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:zohomain/src/presentation/tabs/Approved.dart';
// import 'package:zohomain/src/presentation/tabs/Pending.dart';
// import 'package:zohomain/src/presentation/tabs/Rejected.dart';
// import 'package:zohomain/src/presentation/views/User/Add%20Regularisation.dart';

// class Approvals extends StatefulWidget {
//   const Approvals({super.key, required this.role});
//   final String role;

//   @override
//   State<Approvals> createState() => _ApprovalsState();
// }

// class _ApprovalsState extends State<Approvals> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: widget.role == "User"
//           ? AppBar(
//               automaticallyImplyLeading: false,
//               title: Text(
//                 AppLocalizations.of(context)!.approvals,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//               ),
//               actions: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Regular()),
//                     );
//                   },
//                 ),
//               ],
//             )
//           : null,
//       body: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             tabs: <Widget>[
//               Tab(text: AppLocalizations.of(context)!.pending),
//               Tab(text: AppLocalizations.of(context)!.approved),
//               Tab(text: AppLocalizations.of(context)!.rejected),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: <Widget>[
//                 Pending(selectedDropdownValue: '', role: widget.role),
//                 Approved(),
//                 Rejected(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }   


import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/presentation/tabs/Approved.dart';
import 'package:zohomain/src/presentation/tabs/Pending.dart';
import 'package:zohomain/src/presentation/tabs/Rejected.dart';
import 'package:zohomain/src/presentation/views/User/Add%20Regularisation.dart';

class Approvals extends StatefulWidget {
  final String role;

  const Approvals({Key? key, required this.role}) : super(key: key);

  @override
  State<Approvals> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approvals> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  // Method to navigate to a specific tab index
  void navigateToTab(int index) {
    _tabController.animateTo(index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.role == "User"
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                AppLocalizations.of(context)!.approvals,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Regular(navigateToTab: navigateToTab)),
                    );
                  },
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: AppLocalizations.of(context)!.pending),
              Tab(text: AppLocalizations.of(context)!.approved),
              Tab(text: AppLocalizations.of(context)!.rejected),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Pending(selectedDropdownValue: '', role: widget.role),
                Approved(),
                Rejected(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
