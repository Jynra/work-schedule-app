import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'work_schedule_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  runApp(const WorkScheduleApp());
}