import 'package:flutter/material.dart';

class SalesInvoice {
  final int salesId;
  final int invoiceNo;
  final DateTime invoiceDate;
  final String userName;
  final String customerName;
  final String narration;
  final String paymentMode;
  final int qty;
  final int items;
  final double grossAmount;
  final double vatAmount;

  const SalesInvoice({
    required this.salesId,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.userName,
    required this.customerName,
    this.narration = '',
    required this.paymentMode,
    required this.qty,
    required this.items,
    required this.grossAmount,
    required this.vatAmount,
  });

  double get netAmount => grossAmount + vatAmount;
}

class SalesInvoiceItem {
  final int slNo;
  String itemCode;
  String barcodeNo;
  String itemName;
  String uom;
  double qty;
  double rate;
  double grossAmount;
  double vatAmount;
  double netAmount;

  SalesInvoiceItem({
    required this.slNo,
    this.itemCode = '',
    this.barcodeNo = '',
    this.itemName = '',
    this.uom = '',
    this.qty = 0,
    this.rate = 0,
    this.grossAmount = 0,
    this.vatAmount = 0,
    this.netAmount = 0,
  });
}

class NewSalesModel {
  final int salesId;
  final DateTime invoiceDate;
  final TimeOfDay invoiceTime;
  final String customerName;
  final String customerMobile;
  final String taxType;
  final int invoiceNo;
  final int userId;
  final String userName;
  final String paymentMode;
  final String tillCode;
  final String branchName;
  final String transType;
  final String remark;
  final List<SalesInvoiceItem> items;

  const NewSalesModel({
    required this.salesId,
    required this.invoiceDate,
    required this.invoiceTime,
    this.customerName = '',
    this.customerMobile = '',
    required this.taxType,
    required this.invoiceNo,
    required this.userId,
    required this.userName,
    required this.paymentMode,
    required this.tillCode,
    required this.branchName,
    required this.transType,
    this.remark = '',
    required this.items,
  });

  double get totalQty => items.fold(0, (s, i) => s + i.qty);
  double get totalGross => items.fold(0, (s, i) => s + i.grossAmount);
  double get totalVat => items.fold(0, (s, i) => s + i.vatAmount);
  double get totalNet => items.fold(0, (s, i) => s + i.netAmount);
  int get totalItems => items.length;
}
