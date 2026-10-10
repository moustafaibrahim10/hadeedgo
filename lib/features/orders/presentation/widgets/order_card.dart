import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onOpen;
  final VoidCallback? onTrack;
  const OrderCard({required this.order, this.onOpen, this.onTrack, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final delivered = order.statusType == OrderStatus.delivered;
    final tracking = order.statusType == OrderStatus.shipped;
    final color = tracking ? AppColors.primaryContainer : delivered ? const Color(0xFF10B981) : AppColors.tertiary;
    final status = order.statusLabel?.isNotEmpty == true ? order.statusLabel! : _status(order.statusType, l10n);
    final date = order.createdAt == null ? '—' : '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}';
    final shortId = order.id.length > 8 ? order.id.substring(0, 8) : order.id;
    final number = order.orderNumber?.isNotEmpty == true ? '#${order.orderNumber}' : '#$shortId';
    return Opacity(opacity: delivered ? 0.8 : 1, child: Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.78), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.surfaceVariant), boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8, offset: Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(number, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColors.onSurface, fontFamily: 'Tajawal')), SizedBox(height: 4.h), Text(date, style: TextStyle(fontSize: 15.sp, color: AppColors.secondary, fontFamily: 'Tajawal'))]), Container(padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), border: Border.all(color: color.withValues(alpha: 0.3)), borderRadius: BorderRadius.circular(20.r)), child: Text(status, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: color, fontFamily: 'Tajawal')))]),
      Padding(padding: EdgeInsets.symmetric(vertical: 12.h), child: Divider(height: 1, color: AppColors.surfaceVariant)),
      if (order.orderItems.isNotEmpty) ...order.orderItems.take(3).map((item) => Padding(padding: EdgeInsets.only(bottom: 5.h), child: Text('• ${item.displayTitle(Localizations.localeOf(context).languageCode == 'en')} × ${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 2)}', style: TextStyle(fontSize: 15.sp, color: AppColors.onSurface, fontFamily: 'Tajawal')))),
      Text('${order.itemCount == 0 ? order.orderItems.length : order.itemCount} ${l10n.tonUnit}', style: TextStyle(fontSize: 13.sp, color: AppColors.secondary, fontFamily: 'Tajawal')),
      SizedBox(height: 16.h),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l10n.total, style: TextStyle(fontSize: 11.sp, color: AppColors.secondary, fontFamily: 'Tajawal')), SizedBox(height: 3.h), Text('${order.totalAmount} ${order.currency ?? l10n.egp}', style: TextStyle(fontSize: delivered ? 20.sp : 24.sp, color: delivered ? AppColors.secondary : AppColors.primary, fontWeight: FontWeight.w600, fontFamily: 'Tajawal'))]), TextButton.icon(onPressed: onTrack ?? onOpen, icon: Icon(tracking ? Icons.local_shipping_outlined : Icons.arrow_forward_rounded, size: 18.sp), label: Text(tracking ? l10n.trackOrder : l10n.orderDetails, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, fontFamily: 'Tajawal')), style: TextButton.styleFrom(foregroundColor: tracking ? Colors.white : AppColors.secondary, backgroundColor: tracking ? AppColors.primaryContainer : AppColors.surfaceVariant, padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))))]),
    ])));
  }

  String _status(OrderStatus value, AppLocalizations l10n) => switch (value) { OrderStatus.delivered => l10n.orderDelivered, OrderStatus.shipped => l10n.orderInDelivery, _ => l10n.orderPreparing };
}
