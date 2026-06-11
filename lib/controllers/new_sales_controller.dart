import 'package:flutter/material.dart';
import '../models/sales_invoice_model.dart';

class NewSalesController extends ChangeNotifier {
  final customerController = TextEditingController();
  final remarkController = TextEditingController();

  DateTime _invoiceDate = DateTime.now();
  TimeOfDay _invoiceTime = TimeOfDay.now();
  String _taxType = 'VAT';
  String _paymentMode = 'CASH';
  String _transType = 'CASH';
  bool _select80mmPrinter = false;
  bool _isSaving = false;

  final List<SalesInvoiceItem> _items = [SalesInvoiceItem(slNo: 1)];

  final int salesId = 1572;
  final int invoiceNo = 1572;
  final int userId = 1;
  final String userName = 'admin';
  final String tillCode = 'Till02';
  final String branchName = 'Al Khaleej Mubasher Trading';

  DateTime get invoiceDate => _invoiceDate;
  TimeOfDay get invoiceTime => _invoiceTime;
  String get taxType => _taxType;
  String get paymentMode => _paymentMode;
  String get transType => _transType;
  bool get select80mmPrinter => _select80mmPrinter;
  bool get isSaving => _isSaving;
  List<SalesInvoiceItem> get items => List.unmodifiable(_items);

  double get totalQty => _items.fold(0, (s, i) => s + i.qty);
  double get totalGross => _items.fold(0, (s, i) => s + i.grossAmount);
  double get totalVat => _items.fold(0, (s, i) => s + i.vatAmount);
  double get totalNet => _items.fold(0, (s, i) => s + i.netAmount);
  int get totalItems => _items.length;

  void setInvoiceDate(DateTime date) {
    _invoiceDate = date;
    notifyListeners();
  }

  void setInvoiceTime(TimeOfDay time) {
    _invoiceTime = time;
    notifyListeners();
  }

  void setTaxType(String value) {
    _taxType = value;
    notifyListeners();
  }

  void setPaymentMode(String value) {
    _paymentMode = value;
    notifyListeners();
  }

  void setTransType(String value) {
    _transType = value;
    notifyListeners();
  }

  void togglePrinterSelect() {
    _select80mmPrinter = !_select80mmPrinter;
    notifyListeners();
  }

  void addItem() {
    _items.add(SalesInvoiceItem(slNo: _items.length + 1));
    notifyListeners();
  }

  void removeItem(int index) {
    if (_items.length <= 1) return;
    _items.removeAt(index);
    // Re-number
    for (int i = 0; i < _items.length; i++) {
      _items[i] = SalesInvoiceItem(
        slNo: i + 1,
        itemCode: _items[i].itemCode,
        barcodeNo: _items[i].barcodeNo,
        itemName: _items[i].itemName,
        uom: _items[i].uom,
        qty: _items[i].qty,
        rate: _items[i].rate,
        grossAmount: _items[i].grossAmount,
        vatAmount: _items[i].vatAmount,
        netAmount: _items[i].netAmount,
      );
    }
    notifyListeners();
  }

  void updateItem(int index, SalesInvoiceItem updated) {
    _items[index] = updated;
    notifyListeners();
  }

  Future<bool> save() async {
    _isSaving = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _isSaving = false;
    notifyListeners();
    return true;
  }

  void cancel() {
    customerController.clear();
    remarkController.clear();
    _items.clear();
    _items.add(SalesInvoiceItem(slNo: 1));
    notifyListeners();
  }

  @override
  void dispose() {
    customerController.dispose();
    remarkController.dispose();
    super.dispose();
  }
}
