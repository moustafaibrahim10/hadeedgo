import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/domain/entities/account_entities.dart';
import '../../../profile/presentation/cubits/account_cubits.dart';

class TaxInvoiceScreen extends StatefulWidget {
  final String? orderId;
  const TaxInvoiceScreen({this.orderId, super.key});

  @override
  State<TaxInvoiceScreen> createState() => _TaxInvoiceScreenState();
}

class _TaxInvoiceScreenState extends State<TaxInvoiceScreen> {
  String? _selectedOrderId;

  @override
  void initState() {
    super.initState();
    _selectedOrderId = widget.orderId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedOrderId != null) {
        context.read<InvoiceDetailsCubit>().load(_selectedOrderId!);
      } else {
        context.read<InvoicesCubit>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _selectedOrderId != null
              ? 'تفاصيل الفاتورة الضريبية'
              : 'الفواتير الضريبية',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () {
            if (_selectedOrderId != null && widget.orderId == null) {
              setState(() => _selectedOrderId = null);
            } else {
              context.pop();
            }
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: _selectedOrderId != null ? _buildDetailsView() : _buildListView(),
    );
  }

  Widget _buildListView() {
    return BlocBuilder<InvoicesCubit, InvoicesState>(
      builder: (context, state) {
        if (state.status == InvoicesStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryContainer),
          );
        }

        if (state.status == InvoicesStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'تعذر تحميل الفواتير',
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<InvoicesCubit>().load(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final items = state.page.items;
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'لا توجد فواتير ضريبية صادرة بعد',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تظهر الفواتير الضريبية تلقائياً بعد تأكيد وسداد طلبات الشراء',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<InvoicesCubit>().load(),
          color: AppColors.primaryContainer,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final invoice = items[index];
              return _InvoiceListItemCard(
                invoice: invoice,
                onTap: () {
                  setState(() => _selectedOrderId = invoice.orderId);
                  context.read<InvoiceDetailsCubit>().load(invoice.orderId);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailsView() {
    return BlocBuilder<InvoiceDetailsCubit, InvoiceDetailsState>(
      builder: (context, state) {
        if (state.status == InvoiceDetailsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryContainer),
          );
        }

        if (state.status == InvoiceDetailsStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'تعذر تحميل تفاصيل الفاتورة',
                  style: const TextStyle(fontFamily: 'Tajawal'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<InvoiceDetailsCubit>().load(
                    _selectedOrderId!,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final details = state.details;
        if (details == null) return const SizedBox.shrink();

        final invNumber =
            details.invoiceNumber ??
            'HG-INV-${details.orderId.substring(0, 6)}';
        final dateStr = details.issuedAt != null
            ? '${details.issuedAt!.day}/${details.issuedAt!.month}/${details.issuedAt!.year}'
            : '';
        final currency = details.currency ?? 'ج.م';

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'فاتورة ضريبية رسمية',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          invNumber,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryContainer,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'مدفوعة',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),

                // Buyer & Order Info
                _infoRow('المشتري:', details.buyerName ?? 'عميل HadeedGo'),
                if (details.buyerCompanyName?.isNotEmpty == true)
                  _infoRow('الشركة:', details.buyerCompanyName!),
                if (details.buyerTaxId?.isNotEmpty == true)
                  _infoRow('الرقم الضريبي:', details.buyerTaxId!),
                _infoRow('تاريخ الإصدار:', dateStr),
                if (details.orderNumber?.isNotEmpty == true)
                  _infoRow('رقم الطلب:', details.orderNumber!),
                const Divider(height: 28),

                // Invoice Lines
                const Text(
                  'تفاصيل البنود',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                ...details.lines.map(
                  (line) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                line.title ?? 'بند حديد',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Text(
                                'الكمية: ${line.quantity ?? 1} طن × ${line.unitPrice ?? 0} $currency',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.secondary,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${line.lineTotal ?? 0} $currency',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryContainer,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 28),

                // Totals
                _amountRow('المجموع الفرعي:', details.subTotal, currency),
                if (details.deliveryFee != null && details.deliveryFee! > 0)
                  _amountRow(
                    'رسوم الشحن والتوصيل:',
                    details.deliveryFee,
                    currency,
                  ),
                _amountRow(
                  'ضريبة القيمة المضافة (14%):',
                  details.taxAmount,
                  currency,
                ),
                const Divider(height: 16),
                _amountRow(
                  'الإجمالي الكلي:',
                  details.totalAmount,
                  currency,
                  isBold: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondary,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountRow(
    String label,
    num? amount,
    String currency, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            '${amount ?? 0} $currency',
            style: TextStyle(
              fontSize: isBold ? 17 : 13,
              fontWeight: FontWeight.bold,
              color: isBold ? AppColors.primaryContainer : AppColors.onSurface,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceListItemCard extends StatelessWidget {
  final TaxInvoiceItem invoice;
  final VoidCallback onTap;

  const _InvoiceListItemCard({required this.invoice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final invNumber =
        invoice.invoiceNumber ?? 'HG-INV-${invoice.orderId.substring(0, 6)}';
    final dateStr = invoice.issuedAt != null
        ? '${invoice.issuedAt!.day}/${invoice.issuedAt!.month}/${invoice.issuedAt!.year}'
        : '';
    final currency = invoice.currency ?? 'ج.م';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invNumber,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'تاريخ: $dateStr ${invoice.orderNumber != null ? "• طلب: ${invoice.orderNumber}" : ""}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${invoice.totalAmount ?? 0} $currency',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryContainer,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
