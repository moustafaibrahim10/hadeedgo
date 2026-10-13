import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/account_entities.dart';
import '../cubits/account_cubits.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressesCubit>().load();
    });
  }

  void _showAddressDialog({SavedAddress? addressToEdit}) {
    final isEditing = addressToEdit != null;
    final labelCtrl = TextEditingController(text: addressToEdit?.label ?? '');
    final govCtrl = TextEditingController(
      text: addressToEdit?.governorate ?? '',
    );
    final cityCtrl = TextEditingController(text: addressToEdit?.city ?? '');
    final streetCtrl = TextEditingController(text: addressToEdit?.street ?? '');
    final buildingCtrl = TextEditingController(
      text: addressToEdit?.building ?? '',
    );
    final floorCtrl = TextEditingController(text: addressToEdit?.floor ?? '');
    final aptCtrl = TextEditingController(text: addressToEdit?.apartment ?? '');
    final detailsCtrl = TextEditingController(
      text: addressToEdit?.additionalDetails ?? '',
    );
    bool isDefault = addressToEdit?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'تعديل العنوان' : 'إضافة عنوان جديد',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _inputField(
                  'تسمية العنوان (مثال: موقع المشروع، المخزن)',
                  labelCtrl,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _inputField('المحافظة', govCtrl)),
                    const SizedBox(width: 10),
                    Expanded(child: _inputField('المدينة', cityCtrl)),
                  ],
                ),
                const SizedBox(height: 12),
                _inputField('الشارع', streetCtrl),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _inputField('رقم المبنى', buildingCtrl)),
                    const SizedBox(width: 8),
                    Expanded(child: _inputField('الطابق', floorCtrl)),
                    const SizedBox(width: 8),
                    Expanded(child: _inputField('الشقة', aptCtrl)),
                  ],
                ),
                const SizedBox(height: 12),
                _inputField(
                  'تفاصيل إضافية / علامة مميزة',
                  detailsCtrl,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'تعيين كعنوان افتراضي',
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                  ),
                  value: isDefault,
                  activeThumbColor: AppColors.primaryContainer,
                  onChanged: (val) => setModalState(() => isDefault = val),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (cityCtrl.text.trim().isEmpty &&
                        streetCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(sheetContext).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى إدخال اسم المدينة أو الشارع'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(sheetContext);
                    if (isEditing) {
                      await this.context.read<AddressesCubit>().update(
                        addressId: addressToEdit.id,
                        label: labelCtrl.text.trim(),
                        governorate: govCtrl.text.trim(),
                        city: cityCtrl.text.trim(),
                        street: streetCtrl.text.trim(),
                        building: buildingCtrl.text.trim(),
                        floor: floorCtrl.text.trim(),
                        apartment: aptCtrl.text.trim(),
                        additionalDetails: detailsCtrl.text.trim(),
                        isDefault: isDefault,
                      );
                    } else {
                      await this.context.read<AddressesCubit>().create(
                        label: labelCtrl.text.trim(),
                        governorate: govCtrl.text.trim(),
                        city: cityCtrl.text.trim(),
                        street: streetCtrl.text.trim(),
                        building: buildingCtrl.text.trim(),
                        floor: floorCtrl.text.trim(),
                        apartment: aptCtrl.text.trim(),
                        additionalDetails: detailsCtrl.text.trim(),
                        isDefault: isDefault,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'حفظ التعديل' : 'إضافة العنوان',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryContainer),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressesCubit, AddressesState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.red[700],
            ),
          );
        } else if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage!,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.green[700],
            ),
          );
        }
      },
      builder: (context, state) {
        final addresses = state.addresses;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface.withValues(alpha: 0.8),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'العناوين المحفوظة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.onSurface,
                ),
                onPressed: () => context.pop(),
              ),
            ],
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(
                color: AppColors.outlineVariant.withValues(alpha: 0.3),
                height: 0.5,
              ),
            ),
          ),
          body: state.status == AddressesStatus.loading && addresses.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryContainer,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => context.read<AddressesCubit>().load(),
                  color: AppColors.primaryContainer,
                  child: addresses.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 64,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'لا توجد عناوين محفوظة بعد',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'أضف عناوينك لتسريع عملية التوصيل وتأكيد الطلبات',
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
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                          itemCount: addresses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final address = addresses[index];
                            return _AddressCard(
                              address: address,
                              onEdit: () =>
                                  _showAddressDialog(addressToEdit: address),
                              onDelete: () => context
                                  .read<AddressesCubit>()
                                  .delete(address.id),
                            );
                          },
                        ),
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddressDialog(),
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_location_alt_outlined),
            label: const Text(
              'إضافة عنوان',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddressCard extends StatelessWidget {
  final SavedAddress address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primaryContainer
              : AppColors.surfaceVariant,
          width: address.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: address.isDefault
                    ? AppColors.primaryContainer
                    : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  address.displayTitle(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'افتراضي',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryContainer,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.displayFullAddress(),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.secondary,
              fontFamily: 'Tajawal',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text(
                  'تعديل',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text(
                  'حذف',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red[700],
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
