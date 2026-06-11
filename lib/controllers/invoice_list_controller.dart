import 'package:flutter/material.dart';
import '../models/sales_invoice_model.dart';

class InvoiceListController extends ChangeNotifier {
  List<SalesInvoice> _allInvoices = [];
  List<SalesInvoice> _filtered = [];

  final salesIdController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final customerNameController = TextEditingController();

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;

  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;

  List<SalesInvoice> get invoices {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return [];
    return _filtered.sublist(start, end);
  }

  int get totalPages => (_filtered.length / _pageSize).ceil().clamp(1, 999);
  int get totalRecords => _filtered.length;

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Demo data
    _allInvoices = [
      SalesInvoice(
        salesId: 1572, invoiceNo: 1572,
        invoiceDate: DateTime(2026, 6, 9),
        userName: 'CASH CUSTOMER', customerName: 'CASH CUSTOMER',
        paymentMode: 'CASH', qty: 5, items: 3,
        grossAmount: 40.00, vatAmount: 6.01,
      ),
      SalesInvoice(
        salesId: 1571, invoiceNo: 1571,
        invoiceDate: DateTime(2026, 6, 9),
        userName: 'CASH CUSTOMER', customerName: 'CASH CUSTOMER',
        paymentMode: 'CASH', qty: 1, items: 2,
        grossAmount: 21.74, vatAmount: 3.27,
      ),
      SalesInvoice(
        salesId: 1570, invoiceNo: 1570,
        invoiceDate: DateTime(2026, 6, 9),
        userName: 'MUSTAFA MOUSA AL RAMADAN TRADING EST',
        customerName: 'MUSTAFA MOUSA AL RAMADAN TRADING EST',
        narration: 'sales invoice from pos',
        paymentMode: 'CASH', qty: 1, items: 1,
        grossAmount: 91.30, vatAmount: 13.70,
      ),
      SalesInvoice(
        salesId: 1569, invoiceNo: 1569,
        invoiceDate: DateTime(2026, 6, 8),
        userName: 'CASH CUSTOMER', customerName: 'CASH CUSTOMER',
        paymentMode: 'CASH', qty: 1, items: 1,
        grossAmount: 56.52, vatAmount: 8.48,
      ),
      SalesInvoice(
        salesId: 1568, invoiceNo: 1568,
        invoiceDate: DateTime(2026, 6, 8),
        userName: 'ADMIN USER', customerName: 'AHMED AL FARSI',
        paymentMode: 'CREDIT', qty: 3, items: 4,
        grossAmount: 210.00, vatAmount: 31.50,
      ),
      SalesInvoice(
        salesId: 1567, invoiceNo: 1567,
        invoiceDate: DateTime(2026, 6, 7),
        userName: 'CASH CUSTOMER', customerName: 'CASH CUSTOMER',
        paymentMode: 'CASH', qty: 2, items: 2,
        grossAmount: 78.60, vatAmount: 11.79,
      ),
    ];

    _filtered = List.from(_allInvoices);
    _isLoading = false;
    notifyListeners();
  }

  void setFromDate(DateTime date) {
    _fromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime date) {
    _toDate = date;
    notifyListeners();
  }

  void applyFilter() {
    _filtered = _allInvoices.where((inv) {
      final matchSalesId = salesIdController.text.isEmpty ||
          inv.salesId.toString().contains(salesIdController.text);
      final matchInvNo = invoiceNoController.text.isEmpty ||
          inv.invoiceNo.toString().contains(invoiceNoController.text);
      final matchCust = customerNameController.text.isEmpty ||
          inv.customerName.toLowerCase().contains(
              customerNameController.text.toLowerCase());
      final matchDate = !inv.invoiceDate.isBefore(_fromDate) &&
          !inv.invoiceDate.isAfter(_toDate);
      return matchSalesId && matchInvNo && matchCust && matchDate;
    }).toList();
    _currentPage = 1;
    notifyListeners();
  }

  void clearFilter() {
    salesIdController.clear();
    invoiceNoController.clear();
    customerNameController.clear();
    _fromDate = DateTime.now().subtract(const Duration(days: 30));
    _toDate = DateTime.now();
    _filtered = List.from(_allInvoices);
    _currentPage = 1;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    _currentPage = page;
    notifyListeners();
  }

  @override
  void dispose() {
    salesIdController.dispose();
    invoiceNoController.dispose();
    customerNameController.dispose();
    super.dispose();
  }
}
