import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:zohomain/src/data/datasource/local/sqflite.dart';
import 'package:zohomain/src/presentation/provider/langProvider.dart';
import 'package:zohomain/src/presentation/views/User/login.dart';

void main() async {
  ProjectDataSource db = ProjectDataSource();
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Configure notification settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

// Initialize the plugin with the configured settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  db.initDB();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(languageProvider),
      home: LoginScreen(),
    );
  }
}