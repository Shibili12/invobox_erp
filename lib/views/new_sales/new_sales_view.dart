import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controllers/new_sales_controller.dart';
import '../../core/app_theme.dart';
import '../../models/sales_invoice_model.dart';
import '../../widgets/shared_widgets.dart';

class NewSalesView extends StatelessWidget {
  const NewSalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewSalesController(),
      child: const _NewSalesContent(),
    );
  }
}

class _NewSalesContent extends StatelessWidget {
  const _NewSalesContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppTitleBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _TopBar(),
                  const SizedBox(height: 12),
                  const _HeaderFields(),
                  const SizedBox(height: 8),
                  const _SecondRowFields(),
                  const SizedBox(height: 8),
                  const _ThirdRowFields(),
                  const SizedBox(height: 10),
                  const Expanded(child: _ItemsTable()),
                  const SizedBox(height: 10),
                  const _TotalsBar(),
                  const SizedBox(height: 10),
                  const _FooterBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.receipt_long_outlined, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        const Text(
          'New Sales',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const Spacer(),
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.cardBorder, width: 0.5),
            ),
            child: const Icon(Icons.arrow_back, size: 15, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('A', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}

class _HeaderFields extends StatelessWidget {
  const _HeaderFields();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();
    final fmt = DateFormat('yyyy-MM-dd');

    return Row(
      children: [
        Expanded(
          child: LabeledField(
            label: 'Sales Id',
            child: ReadOnlyField(value: ctrl.salesId.toString()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'Invoice Date',
            child: DatePickerField(date: ctrl.invoiceDate, onChanged: ctrl.setInvoiceDate),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'Invoice Time',
            child: _TimeField(time: ctrl.invoiceTime, onChanged: ctrl.setInvoiceTime),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: LabeledField(
            label: 'Cust. Name / Mobile No',
            child: TextField(
              controller: ctrl.customerController,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Search customer...',
                suffixIcon: Icon(Icons.add, size: 16, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'To Aspect AC Details',
            child: const ReadOnlyField(value: '3  Sales'),
          ),
        ),
      ],
    );
  }
}

class _SecondRowFields extends StatelessWidget {
  const _SecondRowFields();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();

    return Row(
      children: [
        Expanded(
          child: LabeledField(
            label: 'Tax Type',
            child: AppDropdown(
              value: ctrl.taxType,
              items: const ['VAT', 'NON-VAT', 'EXEMPT'],
              onChanged: (v) => ctrl.setTaxType(v!),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LabeledField(
            label: 'Invoice No',
            child: ReadOnlyField(value: ctrl.invoiceNo.toString()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'User ID & Name',
            child: ReadOnlyField(value: '${ctrl.userId}  ${ctrl.userName}'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'Payment ID & Mode',
            child: AppDropdown(
              value: ctrl.paymentMode,
              items: const ['CASH', 'CREDIT', 'CARD', 'CHEQUE'],
              onChanged: (v) => ctrl.setPaymentMode(v!),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'By Aspect AC Details',
            child: ReadOnlyField(value: '1  CASH'),
          ),
        ),
      ],
    );
  }
}

class _ThirdRowFields extends StatelessWidget {
  const _ThirdRowFields();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();

    return Row(
      children: [
        Expanded(
          child: LabeledField(
            label: 'Till Code',
            child: ReadOnlyField(value: ctrl.tillCode),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'To Branch ID & Name',
            child: ReadOnlyField(value: '1  ${ctrl.branchName}'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'Trans Type',
            child: AppDropdown(
              value: ctrl.transType,
              items: const ['CASH', 'CREDIT', 'RETURN'],
              onChanged: (v) => ctrl.setTransType(v!),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: LabeledField(
            label: 'Remark desc',
            child: TextField(
              controller: ctrl.remarkController,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Enter remark desc',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: LabeledField(
            label: 'Current Customer Bal',
            child: const ReadOnlyField(value: ''),
          ),
        ),
      ],
    );
  }
}

class _ItemsTable extends StatelessWidget {
  const _ItemsTable();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();

    return SectionCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            _ItemsHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: ctrl.items.length,
                itemBuilder: (_, i) => _ItemRow(
                  item: ctrl.items[i],
                  isAlt: i.isOdd,
                  onRemove: () => ctrl.removeItem(i),
                  onUpdate: (updated) => ctrl.updateItem(i, updated),
                ),
              ),
            ),
            // Add row button
            InkWell(
              onTap: ctrl.addItem,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.infoLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.add, size: 14, color: AppColors.info),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Add item row',
                      style: TextStyle(fontSize: 11, color: AppColors.info),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsHeader extends StatelessWidget {
  final List<_ColDef> cols = const [
    _ColDef('SL', 36),
    _ColDef('Item Code', 90),
    _ColDef('Barcode No', 100),
    _ColDef('Item Name', 0, flex: 3),
    _ColDef('UOM', 70),
    _ColDef('Qty', 55),
    _ColDef('Rate', 65),
    _ColDef('Gross Amount', 100),
    _ColDef('VAT Amount', 90),
    _ColDef('Net Amount', 90),
    _ColDef('', 36),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      child: Row(
        children: cols.map((c) {
          final t = Text(
            c.label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white),
          );
          return c.flex > 0
              ? Expanded(flex: c.flex, child: t)
              : SizedBox(width: c.width, child: t);
        }).toList(),
      ),
    );
  }
}

class _ColDef {
  final String label;
  final double width;
  final int flex;
  const _ColDef(this.label, this.width, {this.flex = 0});
}

class _ItemRow extends StatelessWidget {
  final SalesInvoiceItem item;
  final bool isAlt;
  final VoidCallback onRemove;
  final ValueChanged<SalesInvoiceItem> onUpdate;

  const _ItemRow({
    required this.item,
    required this.isAlt,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isAlt ? AppColors.tableRowAlt : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(item.slNo.toString(),
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ),
          SizedBox(
            width: 90,
            child: _SmallInput(
              value: item.itemCode,
              hint: '',
              onChanged: (v) => onUpdate(SalesInvoiceItem(
                slNo: item.slNo, itemCode: v, barcodeNo: item.barcodeNo,
                itemName: item.itemName, uom: item.uom, qty: item.qty, rate: item.rate,
                grossAmount: item.grossAmount, vatAmount: item.vatAmount, netAmount: item.netAmount,
              )),
            ),
          ),
          SizedBox(
            width: 100,
            child: _SmallInput(
              value: item.barcodeNo,
              hint: '',
              onChanged: (v) => onUpdate(SalesInvoiceItem(
                slNo: item.slNo, itemCode: item.itemCode, barcodeNo: v,
                itemName: item.itemName, uom: item.uom, qty: item.qty, rate: item.rate,
                grossAmount: item.grossAmount, vatAmount: item.vatAmount, netAmount: item.netAmount,
              )),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _SmallInput(
                value: item.itemName,
                hint: 'Item name',
                onChanged: (v) => onUpdate(SalesInvoiceItem(
                  slNo: item.slNo, itemCode: item.itemCode, barcodeNo: item.barcodeNo,
                  itemName: v, uom: item.uom, qty: item.qty, rate: item.rate,
                  grossAmount: item.grossAmount, vatAmount: item.vatAmount, netAmount: item.netAmount,
                )),
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: _SmallInput(
              value: item.uom,
              hint: 'UOM',
              onChanged: (v) => onUpdate(SalesInvoiceItem(
                slNo: item.slNo, itemCode: item.itemCode, barcodeNo: item.barcodeNo,
                itemName: item.itemName, uom: v, qty: item.qty, rate: item.rate,
                grossAmount: item.grossAmount, vatAmount: item.vatAmount, netAmount: item.netAmount,
              )),
            ),
          ),
          SizedBox(
            width: 55,
            child: _SmallInput(
              value: item.qty == 0 ? '' : item.qty.toString(),
              hint: '0',
              isNumber: true,
              onChanged: (v) {
                final qty = double.tryParse(v) ?? 0;
                final gross = qty * item.rate;
                final vat = gross * 0.15;
                onUpdate(SalesInvoiceItem(
                  slNo: item.slNo, itemCode: item.itemCode, barcodeNo: item.barcodeNo,
                  itemName: item.itemName, uom: item.uom, qty: qty, rate: item.rate,
                  grossAmount: gross, vatAmount: vat, netAmount: gross + vat,
                ));
              },
            ),
          ),
          SizedBox(
            width: 65,
            child: _SmallInput(
              value: item.rate == 0 ? '' : item.rate.toString(),
              hint: '0.00',
              isNumber: true,
              onChanged: (v) {
                final rate = double.tryParse(v) ?? 0;
                final gross = item.qty * rate;
                final vat = gross * 0.15;
                onUpdate(SalesInvoiceItem(
                  slNo: item.slNo, itemCode: item.itemCode, barcodeNo: item.barcodeNo,
                  itemName: item.itemName, uom: item.uom, qty: item.qty, rate: rate,
                  grossAmount: gross, vatAmount: vat, netAmount: gross + vat,
                ));
              },
            ),
          ),
          _readCell(item.grossAmount.toStringAsFixed(2), 100, bold: true),
          _readCell(item.vatAmount.toStringAsFixed(2), 90, color: AppColors.success),
          _readCell(item.netAmount.toStringAsFixed(2), 90, bold: true),
          SizedBox(
            width: 36,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.delete_outline, size: 13, color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readCell(String text, double width, {bool bold = false, Color? color}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color ?? AppColors.textPrimary,
          fontWeight: bold ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SmallInput extends StatelessWidget {
  final String value;
  final String hint;
  final bool isNumber;
  final ValueChanged<String> onChanged;

  const _SmallInput({
    required this.value,
    required this.hint,
    this.isNumber = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      margin: const EdgeInsets.only(right: 4),
      child: TextFormField(
        initialValue: value,
        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))]
            : null,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.cardBorder, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.cardBorder, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _TotalsBar extends StatelessWidget {
  const _TotalsBar();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();

    return Row(
      children: [
        _TotalBox(label: 'QTY', value: ctrl.totalQty.toStringAsFixed(0)),
        const SizedBox(width: 8),
        _TotalBox(label: 'ITEMS', value: ctrl.totalItems.toString()),
        const SizedBox(width: 8),
        _TotalBox(label: 'GROSS TOTAL', value: '${ctrl.totalGross.toStringAsFixed(2)} SAR'),
        const SizedBox(width: 8),
        _TotalBox(label: 'VAT TOTAL', value: '${ctrl.totalVat.toStringAsFixed(2)} SAR'),
        const SizedBox(width: 8),
        _TotalBox(label: 'DISCOUNT TOTAL', value: '0.00'),
        const SizedBox(width: 8),
        _TotalBox(
          label: 'NET TOTAL',
          value: '${ctrl.totalNet.toStringAsFixed(2)} SAR',
          highlight: true,
        ),
      ],
    );
  }
}

class _TotalBox extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _TotalBox({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: highlight ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NewSalesController>();

    return Row(
      children: [
        InkWell(
          onTap: ctrl.togglePrinterSelect,
          child: Row(
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: ctrl.select80mmPrinter,
                  onChanged: (_) => ctrl.togglePrinterSelect(),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Select 80 mm Printer',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Save  F12',
          icon: Icons.save_outlined,
          isLoading: ctrl.isSaving,
          onPressed: () async {
            final ok = await ctrl.save();
            if (ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invoice saved successfully'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(width: 8),
        PrimaryButton(
          label: 'Import',
          icon: Icons.upload_outlined,
          backgroundColor: AppColors.success,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        SecondaryButton(
          label: 'Cancel',
          onPressed: ctrl.cancel,
        ),
        const SizedBox(width: 8),
        PrimaryButton(
          label: 'Close',
          backgroundColor: AppColors.dangerLight,
          foregroundColor: AppColors.danger,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  final TimeOfDay time;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimeField({required this.time, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onChanged(picked);
      },
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$h:$m $period',
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.access_time_outlined, size: 15, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
