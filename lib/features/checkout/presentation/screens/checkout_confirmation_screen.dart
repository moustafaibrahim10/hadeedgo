import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/domain/entities/order.dart';

/// Real order-success screen. Renders the [Order] returned by
/// `POST /api/v1/orders` — no fabricated values.
///
/// Safe behavior for nullable fields:
///  - `orderNumber == null`  → show a generic label, never invent a number.
///  - `currency == null`     → render amounts without a currency suffix.
///  - `statusLabel == null`  → fall back to the raw status string.
class CheckoutConfirmationScreen extends StatelessWidget {
  final Order? order;
  const CheckoutConfirmationScreen({this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final order = this.order;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'تم إنشاء الطلب',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: order == null
          ? const Center(
              child: Text(
                'تعذر تحميل بيانات الطلب',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            )
          : _SuccessBody(order: order),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  final Order order;
  const _SuccessBody({required this.order});

  @override
  Widget build(BuildContext context) {
    final currency = order.currency;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  const Text(
                    'تم استلام طلبك بنجاح!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    order.orderNumber == null
                        ? 'سيتم تحديثك بحالة الطلب'
                        : 'رقم الطلب: #${order.orderNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.secondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _Section(
                    title: 'ملخص الطلب',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          'طريقة الاستلام',
                          _methodLabel(order.deliveryMethod),
                        ),
                        if (order.deliveryMethod == 'Delivery') ...[
                          if ((order.deliveryAddressLabel ?? '').isNotEmpty)
                            _InfoRow(
                              'تصنيف العنوان',
                              order.deliveryAddressLabel!,
                            ),
                          if ((order.deliveryAddressDetails ?? '').isNotEmpty)
                            _InfoRow('العنوان', order.deliveryAddressDetails!),
                          if (order.preferredDeliveryDate != null)
                            _InfoRow(
                              'تاريخ التوصيل المفضل',
                              _formatDate(order.preferredDeliveryDate!),
                            ),
                        ],
                        if (order.createdAt != null)
                          _InfoRow(
                            'تاريخ الطلب',
                            _formatDate(order.createdAt!),
                          ),
                        if (order.etaMinutes != null)
                          _InfoRow(
                            'الوصول المتوقع',
                            'خلال ${order.etaMinutes} دقيقة',
                          ),
                        if ((order.deliveryDestinationLabel ?? '').isNotEmpty)
                          _InfoRow(
                            'جهة التسليم',
                            order.deliveryDestinationLabel!,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),
                  if (order.orderItems.isNotEmpty)
                    _Section(
                      title: 'عناصر الطلب',
                      child: Column(
                        children: order.orderItems
                            .map(
                              (item) =>
                                  _OrderItemRow(item: item, currency: currency),
                            )
                            .toList(),
                      ),
                    ),
                  if (order.orderItems.isNotEmpty) SizedBox(height: 16.h),
                  _Section(
                    title: 'ملخص التكلفة',
                    child: Column(
                      children: [
                        _AmountRow('المجموع الفرعي', order.subTotal, currency),
                        _AmountRow('رسوم التوصيل', order.deliveryFee, currency),
                        _AmountRow('الضريبة', order.taxAmount, currency),
                        Divider(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        _AmountRow(
                          'الإجمالي',
                          order.totalAmount,
                          currency,
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  if (_currentEvent() != null) ...[
                    SizedBox(height: 16.h),
                    _Section(
                      title: 'حالة الطلب',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primaryContainer,
                            size: 18,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              _currentEvent()!.title ?? _statusLabel(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              border: Border(
                top: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/orders/${order.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تتبع الطلب',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                    minimumSize: const Size(double.infinity, 52),
                    side: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'العودة للرئيسية',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  OrderStatusEvent? _currentEvent() {
    for (final event in order.statusEvents) {
      if (event.isCurrent) return event;
    }
    return order.statusEvents.isNotEmpty ? order.statusEvents.last : null;
  }

  String _statusLabel() =>
      (order.statusLabel != null && order.statusLabel!.trim().isNotEmpty)
      ? order.statusLabel!
      : (order.status.trim().isNotEmpty ? order.status : 'قيد المراجعة');

  String _methodLabel(String method) =>
      method == 'Pickup' ? 'استلام من المصنع' : 'توصيل لموقعك';
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.surfaceVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130.w,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.secondary,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    ),
  );
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;
  final String? currency;
  const _OrderItemRow({required this.item, required this.currency});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.displayTitle(false),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                'الكمية: ${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        Text(
          currency == null
              ? _format(item.lineTotal)
              : '${_format(item.lineTotal)} $currency',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    ),
  );
}

class _AmountRow extends StatelessWidget {
  final String label;
  final num value;
  final String? currency;
  final bool bold;
  const _AmountRow(this.label, this.value, this.currency, {this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: bold ? AppColors.onSurface : AppColors.secondary,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          currency == null ? _format(value) : '${_format(value)} $currency',
          style: TextStyle(
            fontSize: 15,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    ),
  );
}

String _format(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 2);

String _formatDate(DateTime date) =>
    '${date.year}-${_two(date.month)}-${_two(date.day)}';

String _two(int value) => value.toString().padLeft(2, '0');
