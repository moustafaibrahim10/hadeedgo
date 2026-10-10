import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final Map<int, bool> _expandedState = {0: true, 1: false, 2: false};

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
          'الدعم الفني',
          style: TextStyle(
            fontSize: 24,
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.secondary,
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Hero Section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/photos/png/onboarding3.png', // Temporary placeholder
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'كيف يمكننا مساعدتك؟',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'فريق الدعم الفني في HadeedGo متواجد على مدار الساعة لحل أي مشكلة تواجهك في منصتنا.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.secondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Support Channels
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المحادثة الفورية',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'تحدث مع أحد ممثلينا الآن (أسرع استجابة)',
                          style: TextStyle(fontSize: 15, fontFamily: 'Tajawal'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ), // RTL back equivalent
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.call,
                    title: 'اتصل بنا',
                    subtitle: '920000000',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.mail_outline,
                    title: 'البريد الإلكتروني',
                    subtitle: 'support@hadeedgo.com',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // FAQ Section
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'الأسئلة الشائعة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              index: 0,
              title: 'تتبع الطلب',
              content:
                  'يمكنك تتبع طلبك من خلال الذهاب إلى قسم "الطلبات" في شريط التنقل السفلي، ثم اختيار الطلب الذي تود تتبعه لمعرفة حالته وموقعه الحالي على الخريطة.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              index: 1,
              title: 'مشاكل الدفع',
              content:
                  'إذا واجهت أي مشكلة أثناء الدفع، يرجى التأكد من صلاحية البطاقة الائتمانية أو رصيد الحساب. في حال استمرار المشكلة، يرجى التواصل مع فريق الدعم عبر المحادثة الفورية.',
            ),
            const SizedBox(height: 12),
            _buildFAQItem(
              index: 2,
              title: 'تغير الأسعار',
              content:
                  'أسعار الحديد والصلب تتحدث بشكل يومي بناءً على السوق العالمي والمحلي. السعر النهائي للطلب هو السعر المعروض لحظة تأكيد الشراء.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required int index,
    required String title,
    required String content,
  }) {
    final isExpanded = _expandedState[index] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedState[index] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
