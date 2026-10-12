import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../cubits/orders_cubit.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: AppColors.surface, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light, systemNavigationBarColor: AppColors.background, systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(preferredSize: Size.fromHeight(64.h + MediaQuery.paddingOf(context).top), child: const HomeAppBar()),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading || state.status == OrdersStatus.initial) return const Center(child: CircularProgressIndicator());
            if (state.status == OrdersStatus.failure) return _Retry(message: state.errorMessage, onRetry: context.read<OrdersCubit>().load);
            return SafeArea(child: Column(children: [
              Padding(padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 12.h), child: Align(alignment: AlignmentDirectional.centerStart, child: Text(l10n.myOrdersTitle, style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold, color: AppColors.onSurface, fontFamily: 'Tajawal')))),
              _OrderFilters(selected: state.filter),
              Expanded(child: state.page.items.isEmpty ? Center(child: Text(l10n.noCatalogResults, style: Theme.of(context).textTheme.titleMedium)) : ListView.builder(padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 110.h), itemCount: state.page.items.length, itemBuilder: (context, index) { final order = state.page.items[index]; return Padding(padding: EdgeInsets.only(bottom: 16.h), child: OrderCard(order: order, onOpen: () => context.push('/orders/${order.id}'), onTrack: order.canTrack ? () => context.push('/orders/${order.id}/tracking') : null)); }))
            ]));
          },
        ),
      ),
    );
  }
}

class _OrderFilters extends StatelessWidget {
  final String selected;
  const _OrderFilters({required this.selected});
  @override
  Widget build(BuildContext context) {
    const filters = {'All': 'الكل', 'InProgress': 'قيد التنفيذ', 'Completed': 'مكتملة'};
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: filters.entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                end: entry.key == 'Completed' ? 0 : 8.w,
              ),
              child: ChoiceChip(
                label: Text(
                  entry.value,
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 12.sp),
                ),
                selected: entry.key == selected,
                onSelected: (_) =>
                    context.read<OrdersCubit>().load(filter: entry.key),
                selectedColor: AppColors.primaryFixed,
                side: BorderSide(
                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _Retry({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(message ?? 'تعذر تحميل الطلبات'), SizedBox(height: 12.h), ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry))]));
}
