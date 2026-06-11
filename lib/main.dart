import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'views/login/login_view.dart';
import 'views/invoice_list/invoice_list_view.dart';
import 'views/new_sales/new_sales_view.dart';

void main() {
  runApp(const InvoboxApp());
}

class InvoboxApp extends StatelessWidget {
  const InvoboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVOBOX ERP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginView(),
        AppRoutes.invoiceList: (_) => const InvoiceListView(),
        AppRoutes.newSales: (_) => const NewSalesView(),
      },
    );
  }
}
