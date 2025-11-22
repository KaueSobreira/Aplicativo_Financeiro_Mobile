import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/expense_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('pt_BR', null);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,    
      home: const ExpenseListPage(),
    );
  }
}