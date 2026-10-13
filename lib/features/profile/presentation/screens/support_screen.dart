import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubits/account_cubits.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final Map<int, bool> _expandedState = {0: true, 1: false, 2: false};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupportCubit>().load();
    });
  }

  Future<void> _launch(String uriString) async {
    final uri = Uri.parse(uriString);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SupportCubit>().state;
    final info = state.info;

    final phone = info.phone?.isNotEmpty == true ? info.phone! : '19824';
    final whatsApp = info.whatsApp?.isNotEmpty == true
        ? info.whatsApp!
        : '+201001234567';
    final email = info.email?.isNotEmpty == true
        ? info.email!
        : 'support@hadeedgo.com';
    final hours = info.workingHours?.isNotEmpty == true
        ? info.workingHours!
        : 'السبت - الخميس: 9:00 ص - 6:00 م';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الدعم الفني',
          style: TextStyle(
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
      body: RefreshIndicator(
        onRefresh: () => context.read<SupportCubit>().load(),
        color: AppColors.primaryContainer,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Working hours & message banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.primaryContainer,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'مواعيد العمل الرسمية',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hours,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contact Channels
              _buildChannelCard(
                icon: Icons.phone_in_talk_rounded,
                iconColor: Colors.blue[700]!,
                title: 'الاتصال الهاتفي المباشر',
                subtitle: phone,
                actionLabel: 'اتصال الآن',
                onTap: () => _launch('tel:$phone'),
              ),
              const SizedBox(height: 12),
              _buildChannelCard(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: Colors.green[700]!,
                title: 'محادثة عبر واتساب',
                subtitle: whatsApp,
                actionLabel: 'بدء المحادثة',
                onTap: () =>
                    _launch('https://wa.me/${whatsApp.replaceAll('+', '')}'),
              ),
              const SizedBox(height: 12),
              _buildChannelCard(
                icon: Icons.alternate_email_rounded,
                iconColor: Colors.deepOrange[700]!,
                title: 'البريد الإلكتروني',
                subtitle: email,
                actionLabel: 'إرسال بريد',
                onTap: () => _launch('mailto:$email'),
              ),
              const SizedBox(height: 32),

              // FAQ Section
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الأسئلة الشائعة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFaqItem(
                0,
                'كيف يمكنني تتبع طلبي؟',
                'يمكنك تتبع طلبك بالانتقال إلى صفحة "طلباتي" ثم اختيار الطلب النشط والضغط على زر "تتبع الطلب" لمعرفة خط سير الشاحنة والموقع المباشر.',
              ),
              const SizedBox(height: 8),
              _buildFaqItem(
                1,
                'ما هي طرق الدفع المتاحة؟',
                'نوفر الدفع عبر البطاقات البنكية، والتحويل البنكي المعتمد، بالإضافة إلى خيارات الدفع الآجل للمقاولين والشركات المعتمدة.',
              ),
              const SizedBox(height: 8),
              _buildFaqItem(
                2,
                'هل الأسعار تشمل ضريبة القيمة المضافة والشحن؟',
                'يتم توضيح السعر الأساسي للطن مع حساب ضريبة القيمة المضافة (14%) ورسوم النقل بدقة في ملخص الطلب قبل إتمام الدفع.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChannelCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(int index, String question, String answer) {
    final isExpanded = _expandedState[index] ?? false;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (val) =>
              setState(() => _expandedState[index] = val),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: AppColors.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
