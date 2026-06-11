import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../controllers/invoice_list_controller.dart';
import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../models/sales_invoice_model.dart';
import '../../widgets/shared_widgets.dart';

class InvoiceListView extends StatelessWidget {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceListController()..loadInvoices(),
      child: const _InvoiceListContent(),
    );
  }
}

class _InvoiceListContent extends StatelessWidget {
  const _InvoiceListContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppTitleBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _TopBar(),
                  const SizedBox(height: 12),
                  _FilterCard(),
                  const SizedBox(height: 12),
                  const Expanded(child: _InvoiceTable()),
                  const SizedBox(height: 12),
                  const _Pagination(),
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
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.cardBorder, width: 0.5),
            ),
            child: const Icon(Icons.arrow_back, size: 16, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Sales Invoice List',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
        const Spacer(),
        PrimaryButton(
          label: 'Add New Sales',
          icon: Icons.add,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.newSales),
        ),
      ],
    );
  }
}

class _FilterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<InvoiceListController>();

    return SectionCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: ctrl.salesIdController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Sales Id',
                    suffixIcon: Icon(Icons.unfold_more, size: 16, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: LabeledField(
                  label: 'Invoice From Date',
                  child: DatePickerField(
                    date: ctrl.fromDate,
                    onChanged: ctrl.setFromDate,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: LabeledField(
                  label: 'Invoice To Date',
                  child: DatePickerField(
                    date: ctrl.toDate,
                    onChanged: ctrl.setToDate,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PrimaryButton(
                label: 'Filter',
                icon: Icons.filter_list,
                onPressed: ctrl.applyFilter,
              ),
              const SizedBox(width: 8),
              SecondaryButton(
                label: 'Clear',
                onPressed: ctrl.clearFilter,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: ctrl.invoiceNoController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Invoice No',
                    suffixIcon: Icon(Icons.unfold_more, size: 16, color: AppColors.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: TextField(
                  controller: ctrl.customerNameController,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'Customer Name',
                    suffixIcon: Icon(Icons.unfold_more, size: 16, color: AppColors.textMuted),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvoiceTable extends StatelessWidget {
  const _InvoiceTable();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<InvoiceListController>();

    return SectionCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            _TableHeader(),
            if (ctrl.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (ctrl.invoices.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No invoices found',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: ctrl.invoices.length,
                  itemBuilder: (_, i) => _InvoiceRow(
                    invoice: ctrl.invoices[i],
                    isAlt: i.isOdd,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final List<_ColDef> cols = const [
    _ColDef('Sales Id', 70),
    _ColDef('Inv. No', 70),
    _ColDef('Inv. Date', 100),
    _ColDef('User Name', 0, flex: 2),
    _ColDef('Cust. Name', 0, flex: 2),
    _ColDef('Narration', 0, flex: 2),
    _ColDef('Pay. Mode', 80),
    _ColDef('Qty', 50),
    _ColDef('Items', 50),
    _ColDef('Gross Amt', 90),
    _ColDef('VAT Amt', 80),
    _ColDef('Action', 70),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tableHeader,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: cols.map((c) => _headerCell(c)).toList(),
      ),
    );
  }

  Widget _headerCell(_ColDef c) {
    final w = Text(
      c.label,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
    return c.flex > 0
        ? Expanded(flex: c.flex, child: w)
        : SizedBox(width: c.width, child: w);
  }
}

class _ColDef {
  final String label;
  final double width;
  final int flex;
  const _ColDef(this.label, this.width, {this.flex = 0});
}

class _InvoiceRow extends StatelessWidget {
  final SalesInvoice invoice;
  final bool isAlt;

  const _InvoiceRow({required this.invoice, required this.isAlt});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy-MM-dd');
    return Container(
      color: isAlt ? AppColors.tableRowAlt : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        children: [
          _cell(invoice.salesId.toString(), width: 70),
          _cell(invoice.invoiceNo.toString(), width: 70),
          _cell(fmt.format(invoice.invoiceDate), width: 100, muted: true),
          _flexCell(invoice.userName, flex: 2),
          _flexCell(invoice.customerName, flex: 2),
          _flexCell(invoice.narration, flex: 2, muted: true),
          SizedBox(width: 80, child: PaymentBadge(mode: invoice.paymentMode)),
          _cell(invoice.qty.toString(), width: 50),
          _cell(invoice.items.toString(), width: 50),
          _cell(invoice.grossAmount.toStringAsFixed(2), width: 90, bold: true),
          _cell(
            invoice.vatAmount.toStringAsFixed(2),
            width: 80,
            color: AppColors.success,
            bold: true,
          ),
          SizedBox(
            width: 70,
            child: Row(
              children: [
                _iconBtn(Icons.edit_outlined, AppColors.infoLight, AppColors.info, () {}),
                const SizedBox(width: 4),
                _iconBtn(Icons.print_outlined, AppColors.infoLight, AppColors.info, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text, {required double width, bool muted = false, bool bold = false, Color? color}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color ?? (muted ? AppColors.textMuted : AppColors.textPrimary),
          fontWeight: bold ? FontWeight.w500 : FontWeight.normal,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _flexCell(String text, {required int flex, bool muted = false}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: muted ? AppColors.textMuted : AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, Color bg, Color fg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 14, color: fg),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination();

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<InvoiceListController>();
    final total = ctrl.totalPages;
    final current = ctrl.currentPage;

    List<int?> pages = [];
    if (total <= 5) {
      pages = List.generate(total, (i) => i + 1);
    } else {
      pages = [1, 2, 3, null, total];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageBtn(icon: Icons.first_page, onTap: () => ctrl.goToPage(1)),
        _PageBtn(icon: Icons.chevron_left, onTap: () => ctrl.goToPage(current - 1)),
        ...pages.map(
          (p) => p == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text('…', style: TextStyle(color: AppColors.textMuted)),
                )
              : _PageBtn(
                  label: p.toString(),
                  isActive: p == current,
                  onTap: () => ctrl.goToPage(p),
                ),
        ),
        _PageBtn(icon: Icons.chevron_right, onTap: () => ctrl.goToPage(current + 1)),
        _PageBtn(icon: Icons.last_page, onTap: () => ctrl.goToPage(total)),
        const SizedBox(width: 16),
        Text(
          '${ctrl.totalRecords} records',
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  const _PageBtn({this.label, this.icon, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.cardBorder,
              width: 0.5,
            ),
          ),
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                    ),
                  )
                : Icon(icon, size: 14, color: isActive ? Colors.white : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
