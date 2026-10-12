import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ar', 'AE'));
  }

  bool get _isEnglish => locale.languageCode == 'en';

  String _text(String arabic, String english) => _isEnglish ? english : arabic;

  String get appName => 'HadeedGo';
  String get splashTagline =>
      _text('تطبيق تجارة الصلب الموثوق', 'Trusted steel trading');

  String get onboardingWelcomeTitle =>
      _text('مرحباً بك في HadeedGo', 'Welcome to HadeedGo');
  String get onboardingWelcomeSubtitle => _text(
    'سوق الحديد الرقمي الأول في المنطقة. ابحث، قارن، واطلب بكل سهولة.',
    'The region\'s first digital steel marketplace. Search, compare, and order with ease.',
  );
  String get onboardingCompareTitle =>
      _text('قارن الأسعار والشركات', 'Compare prices and companies');
  String get onboardingCompareSubtitle => _text(
    'استعرض عروض الأسعار من أكبر المصانع والموردين في مكان واحد واختر ما يناسب ميزانيتك.',
    'Review quotes from leading factories and suppliers in one place and choose what fits your budget.',
  );
  String get onboardingTrackingTitle =>
      _text('تتبع شحناتك لحظة بلحظة', 'Track your shipments in real time');
  String get onboardingTrackingSubtitle => _text(
    'نظام لوجستي متكامل يضمن وصول طلباتك بأمان مع تتبع مباشر من المصنع حتى موقعك.',
    'An integrated logistics system that keeps your orders safe with live tracking from the factory to your location.',
  );
  String get skip => _text('تخطي', 'Skip');
  String get next => _text('التالي', 'Next');
  String get getStarted => _text('ابدأ الآن', 'Get started');

  String get loginTitle => _text('تسجيل الدخول', 'Login');
  String get loginSubtitle => _text(
    'مرحباً بك في منصة HadeedGo الموثوقة',
    'Welcome to the trusted HadeedGo platform',
  );
  String get phoneNumber => _text('رقم الهاتف', 'Phone number');
  String get phoneHint => '01X XXXX XXXX';
  String get password => _text('كلمة المرور', 'Password');
  String get passwordHint => '••••••••';
  String get forgotPassword => _text('نسيت كلمة المرور؟', 'Forgot password?');
  String get login => _text('دخول', 'Login');
  String get loginSuccess =>
      _text('تم تسجيل الدخول بنجاح', 'Logged in successfully');
  String get noAccount => _text('ليس لديك حساب؟ ', 'Don\'t have an account? ');
  String get createAccount => _text('إنشاء حساب جديد', 'Create a new account');
  String get requiredPhone =>
      _text('يرجى إدخال رقم الهاتف', 'Please enter your phone number');
  String get requiredLoginPassword =>
      _text('يرجى إدخال كلمة المرور', 'Please enter your password');

  String get registerTitle => _text('إنشاء حساب جديد', 'Create a new account');
  String get registerSubtitle => _text(
    'انضم إلى منصة HadeedGo للحديد والصلب',
    'Join HadeedGo steel marketplace',
  );
  String get fullName => _text('الاسم الكامل', 'Full name');
  String get fullNameHint => _text('أدخل اسمك الكامل', 'Enter your full name');
  String get companyNameOptional =>
      _text('اسم الشركة - اختياري', 'Company name - optional');
  String get companyNameHint => _text('اسم شركتك', 'Your company name');
  String get email => _text('البريد الإلكتروني', 'Email address');
  String get emailHint => 'example@domain.com';
  String get requiredEmail =>
      _text('يرجى إدخال البريد الإلكتروني', 'Please enter your email address');
  String get registerPassword => _text('كلمة السر', 'Password');
  String get requiredFullName =>
      _text('يرجى إدخال الاسم الكامل', 'Please enter your full name');
  String get invalidEmail =>
      _text('بريد إلكتروني غير صالح', 'Please enter a valid email address');
  String get shortPassword => _text(
    'يجب أن تكون كلمة السر 6 أحرف على الأقل',
    'Password must be at least 6 characters',
  );
  String get showPassword => _text('إظهار كلمة السر', 'Show password');
  String get hidePassword => _text('إخفاء كلمة السر', 'Hide password');
  String get register => _text('إنشاء الحساب', 'Create account');
  String get hasAccount =>
      _text('لديك حساب بالفعل؟ ', 'Already have an account? ');
  String get loginNow => _text('سجل دخولك الآن', 'Log in now');
  String get genericError => _text('حدث خطأ', 'Something went wrong');
  String get registerSuccess =>
      _text('تم إنشاء الحساب بنجاح', 'Account created successfully');
  String get registerFailure => _text(
    'تعذر إنشاء الحساب، حاول مرة أخرى',
    'Could not create the account. Try again',
  );
  String get otpTitle => _text('رمز التحقق', 'Verification code');
  String get otpSubtitle => _text(
    'أدخل الرمز المرسل إلى رقم هاتفك',
    'Enter the code sent to your phone',
  );
  String get otpCode => _text('رمز التحقق', 'Verification code');
  String get otpHint => '123456';
  String get requiredOtp =>
      _text('يرجى إدخال رمز التحقق', 'Enter the verification code');
  String get continueRegistration =>
      _text('متابعة التسجيل', 'Continue registration');
  String get acceptTerms =>
      _text('أوافق على الشروط والأحكام', 'I accept the terms and conditions');
  String get sendOtp => _text('إرسال رمز التحقق', 'Send verification code');
  String get otpSent => _text('تم إرسال رمز التحقق', 'Verification code sent');

  String get homeTitle => 'HadeedGo';
  String get notifications => _text('الإشعارات', 'Notifications');
  String get profile => _text('الملف الشخصي', 'Profile');
  String get shipmentStatus => _text(
    'شُحنتك في الطريق: ١٥ دقيقة',
    'Your shipment is on the way: 15 min',
  );
  String get featuredOffers => _text('عروض مميزة', 'Featured offers');
  String get verifiedSupplier => _text('مورد موثّق', 'Verified supplier');
  String get productSpecification => _text(
    'مواسير 50×50 مم — سمك 1.5 مم — طول 6 متر',
    'Pipes 50x50 mm - 1.5 mm thickness - 6 m length',
  );
  String get price => _text('السعر', 'Price');
  String get priceValue => _text('46,300 جنيه / طن', 'EGP 46,300 / ton');
  String get update => _text('تحديث', 'Update');
  String get lastUpdatedToday =>
      _text('آخر تحديث: اليوم', 'Last updated: today');
  String get quantity => _text('٥ طن', '5 tons');
  String get addToCart => _text('إضافة للسلة', 'Add to cart');
  String get categories => _text('التصنيفات', 'Categories');
  String get pipes => _text('مواسير', 'Pipes');
  String get angles => _text('زوايا', 'Angles');
  String get beams => _text('كمر', 'Beams');
  String get sheets => _text('صاج', 'Sheets');
  String get partnerMills => _text('المصانع الشريكة', 'Partner mills');
  String get ezzSteel => _text('حديد عز', 'Ezz Steel');
  String get egyptianSteel => _text('حديد المصريين', 'Egyptian Steel');
  String get elAshrySteel => _text('حديد العشري', 'El-Ashry Steel');
  String get elGarhy => _text('الجارحي', 'El Garhy');
  String get marketNews => _text('أخبار السوق', 'Market news');
  String get billetPriceNews => _text(
    'ارتفاع طفيف في أسعار البليت عالمياً',
    'Slight rise in global billet prices',
  );
  String get billetPriceDescription => _text(
    'سجلت أسعار البليت زيادة بنسبة ١٪ في الأسواق العالمية اليوم...',
    'Global billet prices rose by 1% today...',
  );
  String get ezzProductionNews => _text(
    'طاقات إنتاجية جديدة لحديد عز',
    'New production capacity for Ezz Steel',
  );
  String get ezzProductionDescription => _text(
    'إعلان عن افتتاح خط إنتاج جديد لتلبية الطلب المحلي المتزايد...',
    'A new production line opened to meet growing local demand...',
  );
  String get home => _text('الرئيسية', 'Home');
  String get search => _text('البحث', 'Search');
  String get orders => _text('طلباتي', 'Orders');
  String get cart => _text('السلة', 'Cart');
  String get myOrdersTitle => _text('طلباتي', 'My orders');
  String get orderInDelivery => _text('قيد التوصيل', 'In delivery');
  String get orderPreparing => _text('قيد التجهيز', 'Preparing');
  String get orderDelivered => _text('تم التسليم', 'Delivered');
  String get trackOrder => _text('تتبع الطلب', 'Track order');
  String get orderDetails => _text('التفاصيل', 'Details');
  String get reorder => _text('إعادة الطلب', 'Reorder');
  String get total => _text('الإجمالي', 'Total');
  String get orderNumberOne => '#HG-99821';
  String get orderNumberTwo => '#HG-99750';
  String get orderNumberThree => '#HG-99610';
  String get orderDateOne => _text('24 أكتوبر 2023', '24 October 2023');
  String get orderDateTwo => _text('22 أكتوبر 2023', '22 October 2023');
  String get orderDateThree => _text('15 أكتوبر 2023', '15 October 2023');
  String get orderItemRebar12 =>
      _text('5 طن حديد تسليح 12 مم', '5 tons 12 mm rebar');
  String get orderItemRebar16 =>
      _text('2 طن حديد تسليح 16 مم', '2 tons 16 mm rebar');
  String get orderItemCoils =>
      _text('10 طن لفائف مدرفلة على الساخن', '10 tons hot-rolled coils');
  String get orderItemRebar14 =>
      _text('3 طن حديد تسليح 14 مم', '3 tons 14 mm rebar');
  String get orderTotalOne => _text('282,100 ج.م', 'EGP 282,100');
  String get orderTotalTwo => _text('450,000 ج.م', 'EGP 450,000');
  String get orderTotalThree => _text('110,000 ج.م', 'EGP 110,000');
  String get cartTitle => _text('عربة التسوق', 'Shopping cart');
  String get tonUnit => _text('طن', 'tons');
  String get emptyCart => _text('السلة فارغة', 'Your cart is empty');
  String get clearCart => _text('إفراغ السلة', 'Clear cart');
  String get cartLoadError => _text('تعذر تحميل السلة', 'Unable to load cart');
  String get removeItem => _text('حذف المنتج', 'Remove item');
  String get decreaseQuantity => _text('تقليل الكمية', 'Decrease quantity');
  String get increaseQuantity => _text('زيادة الكمية', 'Increase quantity');
  String get rebarAz12 => _text('حديد تسليح عز 12 مم', 'Ezz Steel 12 mm rebar');
  String get rebarBeshay16 =>
      _text('حديد تسليح بشاي 16 مم', 'Beshay Steel 16 mm rebar');
  String get grade60Length12 =>
      _text('رتبة 60 • طول 12 متر', 'Grade 60 • 12 meter length');
  String get cartWeight => _text('إجمالي الوزن', 'Total weight');
  String get subtotal => _text('المجموع الفرعي', 'Subtotal');
  String get deliveryFee =>
      _text('رسوم التوصيل (تقديرية)', 'Estimated delivery fee');
  String get vat => _text('ضريبة القيمة المضافة (14%)', 'VAT (14%)');
  String get grandTotal => _text('الإجمالي الكلي', 'Grand total');
  String get checkout => _text('إتمام الطلب والدفع', 'Checkout and pay');

  String get searchProductsTitle =>
      _text('منتجات حديد عز', 'Ezz Steel products');
  String get back => _text('رجوع', 'Back');
  String get factoryRating => '4.9';
  String get certifiedFactory => _text('مصنع معتمد', 'Certified factory');
  String get sadat => _text('السادات', 'Sadat City');
  String get all => _text('الكل', 'All');
  String get rebarLengths => _text('أطوال (حديد تسليح)', 'Rebar lengths');
  String get coils => _text('لفائف', 'Coils');
  String get scrap => _text('خردة', 'Scrap');
  String get flatProducts => _text('مسطحات', 'Flat products');
  String get rebar12 => _text('حديد تسليح 12 مم', '12 mm rebar');
  String get rebar16 => _text('حديد تسليح 16 مم', '16 mm rebar');
  String get coil8 => _text('لفائف صلب 8 مم', '8 mm steel coil');
  String get rebarDescription => _text(
    'صلب عالي المقاومة (Grade 60) - أطوال 12 متر',
    'High-strength steel (Grade 60) - 12 m lengths',
  );
  String get coilDescription => _text(
    'صلب طري (Mild Steel) للاستخدامات الصناعية',
    'Mild steel for industrial applications',
  );
  String get pricePerTon => _text('السعر للطن', 'Price per ton');
  String get viewDetails => _text('التفاصيل', 'View details');
  String get egp => _text('جنيه', 'EGP');
  String get addProductToCart =>
      _text('إضافة المنتج للسلة', 'Add product to cart');
  String get technicalSpecifications =>
      _text('المواصفات الفنية', 'Technical specifications');
  String get directFromFactory =>
      _text('حديد من المصنع مباشرة', 'Direct from factory');
  String get estimatedTotal => _text('الإجمالي التقديري', 'Estimated total');
  String get cartItemAdded => _text('تمت الإضافة إلى السلة', 'Added to cart');
  String get selectSupplierOffer =>
      _text('اختر عرض المورد', 'Choose a supplier offer');
  String get rebar12Price => '46,300';
  String get rebar16Price => '46,300';
  String get coil8Price => '45,800';
  String get productConfiguration => _text('تكوين المنتج', 'Configure product');
  String get steelIBeam => _text('كمر حديد (I-Beam)', 'Steel I-Beam');
  String get sizeFixed => _text('المقاس (ثابت)', 'Size (fixed)');
  String get ipe100 => 'IPE 100';
  String get thickness => _text('السماكة (مم)', 'Thickness (mm)');
  String get length => _text('الطول (متر)', 'Length (meter)');
  String get quantityTons => _text('الكمية (طن)', 'Quantity (tons)');
  String totalForQuantity(String quantity) =>
      _text('الإجمالي ($quantity طن)', 'Total ($quantity tons)');
  String get productPricePerTon => _text('السعر للطن', 'Price per ton');
  String get productTotalPrice => _text('480,000 ج.م', 'EGP 480,000');
  String get productUnitPrice => _text('48,000 ج.م', 'EGP 48,000');
  String get addConfiguredProduct => _text('إضافة للسلة', 'Add to cart');
  String get catalogProducts => _text('المنتجات', 'Products');
  String get catalogSuppliers => _text('الموردون', 'Suppliers');
  String get catalogCategories => _text('التصنيفات', 'Categories');
  String get noCatalogResults => _text('لا توجد نتائج', 'No results found');
  String get retry => _text('إعادة المحاولة', 'Retry');
  String get supplierOffers => _text('عروض الموردين', 'Supplier offers');
  String productsCount(int count) => _text('$count منتج', '$count products');
  String lastUpdated(String value) =>
      _text('آخر تحديث: $value', 'Updated: $value');
  String get detailsUnavailable =>
      _text('التفاصيل غير متاحة', 'Details unavailable');
  String get sixMeters => _text('6 م', '6 m');
  String get twelveMeters => _text('12 م', '12 m');
  String get thickness41 => '4.1';
  String get thickness57 => '5.7';
  String get thickness69 => '6.9';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
