import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order.dart';
import '../cubits/orders_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String id;
  final bool trackingOnly;
  const OrderDetailsScreen({required this.id, this.trackingOnly = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(trackingOnly ? 'تتبع الطلب' : 'تفاصيل الطلب', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)), leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios_new_rounded))),
      body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading || state.status == OrdersStatus.initial) return const Center(child: CircularProgressIndicator());
          if (state.status == OrdersStatus.failure) return Center(child: Text(state.errorMessage ?? 'تعذر تحميل الطلب'));
          final order = state.order;
          final tracking = state.tracking;
          if (order == null || tracking == null) return const SizedBox.shrink();
          return ListView(padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h), children: [
            _Header(order: order, tracking: tracking),
            if (!trackingOnly) ...[
              SizedBox(height: 16.h),
              _Section(title: 'عناصر الطلب', child: Column(children: order.orderItems.map((item) => ListTile(contentPadding: EdgeInsets.zero, title: Text(item.displayTitle(false), style: const TextStyle(fontFamily: 'Tajawal')), subtitle: Text('${item.quantity} ${item.unit ?? ''}', style: const TextStyle(fontFamily: 'Tajawal')), trailing: Text('${item.lineTotal} ${item.currency ?? ''}', style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold)))).toList())),
              SizedBox(height: 16.h),
              _Section(title: 'ملخص التكلفة', child: Column(children: [_Row('المجموع الفرعي', order.subTotal, order.currency), _Row('رسوم التوصيل', order.deliveryFee, order.currency), _Row('الضريبة', order.taxAmount, order.currency), _Row('الإجمالي', order.totalAmount, order.currency, bold: true)])),
            ],
            SizedBox(height: 16.h),
            _Section(title: 'حالة الطلب', child: Column(children: tracking.timeline.map((event) => _TimelineEvent(event: event)).toList())),
          ]);
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Order order;
  final OrderTracking tracking;
  const _Header({required this.order, required this.tracking});
  @override
  Widget build(BuildContext context) => _Section(title: order.orderNumber == null ? 'الطلب' : '#${order.orderNumber}', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(order.statusLabel ?? order.status, style: TextStyle(color: AppColors.primaryContainer, fontSize: 20.sp, fontWeight: FontWeight.bold, fontFamily: 'Tajawal')), if (tracking.etaMinutes != null) Text('الوصول المتوقع خلال ${tracking.etaMinutes} دقيقة', style: const TextStyle(fontFamily: 'Tajawal')), if (tracking.deliveryDestinationLabel != null) Text(tracking.deliveryDestinationLabel!, style: const TextStyle(fontFamily: 'Tajawal')), if (tracking.driverName != null) Text('السائق: ${tracking.driverName}', style: const TextStyle(fontFamily: 'Tajawal'))]));
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Container(padding: EdgeInsets.all(16.w), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.78), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.surfaceVariant)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: AppColors.primary, fontFamily: 'Tajawal')), SizedBox(height: 12.h), child]));
}

class _Row extends StatelessWidget {
  final String title;
  final num value;
  final String? currency;
  final bool bold;
  const _Row(this.title, this.value, this.currency, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.only(bottom: 8.h), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontFamily: 'Tajawal')), Text('$value ${currency ?? ''}', style: TextStyle(fontFamily: 'Tajawal', fontWeight: bold ? FontWeight.bold : FontWeight.normal))]));
}

class _TimelineEvent extends StatelessWidget {
  final OrderStatusEvent event;
  const _TimelineEvent({required this.event});
  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: Icon(event.isCurrent ? Icons.radio_button_checked : Icons.check_circle_outline, color: event.isCurrent ? AppColors.primaryContainer : AppColors.secondary), title: Text(event.title ?? event.status, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.w600)), subtitle: Text(event.description ?? (event.occurredAt?.toLocal().toString() ?? ''), style: const TextStyle(fontFamily: 'Tajawal')));
}
