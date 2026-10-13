import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/catalog_entities.dart';
import '../../../cart/domain/entities/cart_entities.dart';
import '../../../cart/presentation/cubits/cart_cubit.dart';
import '../cubits/checkout_cubit.dart';

/// Connected checkout screen. Reuses the Stitch design language (option cards,
/// glass cards, Tajawal, [AppColors]) but wires every input to the real
/// [CheckoutCubit] and ultimately to `POST /api/v1/orders`.
///
/// The selected [FulfillmentMethod] controls which branch is rendered:
///  - Delivery → address label / details / optional preferred date.
///  - Pickup   → real catalog supplier selection.
///
/// Delivery and Pickup fields are never shown together.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (p, c) =>
          p.errorMessage != c.errorMessage || p.createdOrder != c.createdOrder,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppFeedback.showError(context, state.errorMessage!);
        } else if (state.createdOrder != null) {
          _onOrderCreated(context);
        }
      },
      child: const _CheckoutView(),
    );
  }

  /// After a successful order the backend already created it from the user's
  /// cart. Refresh the shared cart/summary so the badge reflects the new
  /// (backend-authoritative) state, then open the real success screen.
  void _onOrderCreated(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    cartCubit.load();
    context.pushReplacement(
      '/checkout-confirmation',
      extra: context.read<CheckoutCubit>().state.createdOrder,
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إتمام الطلب',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: 220,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'هتستلم الحديد إزاي؟',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _FulfillmentOption(
                          method: FulfillmentMethod.delivery,
                          title: 'توصيل لموقعك',
                          subtitle: 'نوصلك الحديد لموقعك مباشرة',
                          icon: Icons.local_shipping_outlined,
                          isSelected: state.isDelivery,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _FulfillmentOption(
                          method: FulfillmentMethod.pickup,
                          title: 'استلام من المصنع',
                          subtitle: 'تستلم الحديد من بوابة المصنع',
                          icon: Icons.factory_outlined,
                          isSelected: state.isPickup,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state.isDelivery
                        ? const _DeliveryBranch(key: ValueKey('delivery'))
                        : const _PickupBranch(key: ValueKey('pickup')),
                  ),
                ],
              ),
            ),
            Positioned(left: 0, right: 0, bottom: 0, child: const _SubmitBar()),
          ],
        ),
      ),
    );
  }
}

/// Selectable fulfillment card — mirrors the existing Stitch option card style.
class _FulfillmentOption extends StatelessWidget {
  final FulfillmentMethod method;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;

  const _FulfillmentOption({
    required this.method,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<CheckoutCubit>().selectMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceContainerLowest
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryContainer,
                    size: 24,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryContainer,
                    size: 24,
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Delivery branch: address label, address details and an optional preferred
/// delivery date. Only rendered for [FulfillmentMethod.delivery].
class _DeliveryBranch extends StatelessWidget {
  const _DeliveryBranch({super.key});

  static const _labelOptions = ['البيت', 'موقع البناء', 'الشركة'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    final cubit = context.read<CheckoutCubit>();
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('عنوان التوصيل'),
          const SizedBox(height: 12),
          const _FieldLabel('تصنيف العنوان *'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in _labelOptions)
                _LabelChip(
                  label: option,
                  selected: state.addressLabel == option,
                  onTap: () => cubit.setAddressLabel(
                    state.addressLabel == option ? '' : option,
                  ),
                ),
            ],
          ),
          if (state.addressLabelError != null) ...[
            const SizedBox(height: 6),
            Text(
              state.addressLabelError!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
          const SizedBox(height: 16),
          const _FieldLabel('العنوان بالتفصيل *'),
          const SizedBox(height: 8),
          TextField(
            maxLines: 3,
            onChanged: cubit.setAddressDetails,
            style: const TextStyle(fontFamily: 'Tajawal'),
            decoration: _inputDecoration(
              'اكتب العنوان والعلامات المميزة للموقع',
            ),
          ),
          if (state.addressDetailsError != null) ...[
            const SizedBox(height: 6),
            Text(
              state.addressDetailsError!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
          const SizedBox(height: 16),
          const _FieldLabel('تاريخ التوصيل المفضل (اختياري)'),
          const SizedBox(height: 8),
          _DatePickerField(
            date: state.preferredDeliveryDate,
            onPicked: cubit.setPreferredDeliveryDate,
            onCleared: cubit.clearPreferredDeliveryDate,
          ),
        ],
      ),
    );
  }
}

/// Pickup branch: real supplier selection from `GET /api/v1/catalog/suppliers`.
/// Only rendered for [FulfillmentMethod.pickup].
class _PickupBranch extends StatelessWidget {
  const _PickupBranch({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    final cubit = context.read<CheckoutCubit>();

    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('اختر المصنع'),
          const SizedBox(height: 12),
          switch (state.suppliersStatus) {
            SuppliersLoadStatus.initial ||
            SuppliersLoadStatus.loading => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            SuppliersLoadStatus.failure => _SuppliersRetry(
              message: state.errorMessage,
              onRetry: cubit.loadSuppliers,
            ),
            SuppliersLoadStatus.success when state.suppliers.isEmpty =>
              const _EmptyState('لا توجد مصانع متاحة حالياً'),
            SuppliersLoadStatus.success => Column(
              children: [
                for (final supplier in state.suppliers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SupplierTile(
                      supplier: supplier,
                      selected: state.selectedSupplier?.id == supplier.id,
                      onTap: () => cubit.selectSupplier(supplier),
                    ),
                  ),
              ],
            ),
          },
          if (state.supplierError != null) ...[
            const SizedBox(height: 6),
            Text(
              state.supplierError!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bottom submit bar. Shows the live cart totals (from the shared [CartCubit])
/// and the submit button. Disabled while submitting to prevent duplicates.
class _SubmitBar extends StatelessWidget {
  const _SubmitBar();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutCubit>().state;
    final cart = context.select<CartCubit, Cart>((c) => c.state.cart);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي التقديري',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    '${_format(cart.grandTotal)} ${cart.currency ?? 'ج.م'}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () => context.read<CheckoutCubit>().submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primaryContainer
                      .withValues(alpha: 0.5),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'تأكيد وإنشاء الطلب',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Real catalog supplier row. `supplier.id` is the real UUID used as
/// `pickupSupplierId` — never the display name.
class _SupplierTile extends StatelessWidget {
  final Supplier supplier;
  final bool selected;
  final VoidCallback onTap;

  const _SupplierTile({
    required this.supplier,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.surfaceContainerLowest
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: selected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.factory_outlined,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier.displayName(false),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (supplier.isVerified) ...[
                    const SizedBox(height: 2),
                    const Row(
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: AppColors.primaryContainer,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'موثّق',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryContainer,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Optional preferred-delivery-date field. Shows a readable Arabic date and lets
/// the user clear it (sends `null` to the API when unset).
class _DatePickerField extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime?> onPicked;
  final VoidCallback onCleared;

  const _DatePickerField({
    required this.date,
    required this.onPicked,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null ? 'اختر تاريخاً (اختياري)' : _formatDate(date!),
                style: TextStyle(
                  fontSize: 15,
                  color: date == null
                      ? AppColors.secondary
                      : AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            if (date != null)
              GestureDetector(
                onTap: onCleared,
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) =>
    '${date.year}-${_two(date.month)}-${_two(date.day)}';

String _two(int value) => value.toString().padLeft(2, '0');

// ─── Shared small widgets (reuse existing glass-card design language) ──────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Tajawal',
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceVariant,
      fontFamily: 'Tajawal',
    ),
  );
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LabelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primaryContainer.withValues(alpha: 0.1)
            : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected
              ? AppColors.primaryContainer
              : AppColors.outlineVariant.withValues(alpha: 0.5),
          width: selected ? 1.5 : 0.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? AppColors.primaryContainer : AppColors.onSurface,
          fontFamily: 'Tajawal',
        ),
      ),
    ),
  );
}

class _SuppliersRetry extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _SuppliersRetry({required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        message ?? 'تعذر تحميل المصانع',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.secondary,
          fontFamily: 'Tajawal',
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text(
          'إعادة المحاولة',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
      ),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.secondary,
          fontFamily: 'Tajawal',
        ),
      ),
    ),
  );
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(
    fontSize: 14,
    color: AppColors.secondary,
    fontFamily: 'Tajawal',
  ),
  filled: true,
  fillColor: AppColors.surfaceContainerLowest,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
  ),
);

String _format(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
