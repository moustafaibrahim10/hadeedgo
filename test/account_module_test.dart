import 'package:flutter_test/flutter_test.dart';
import 'package:hadeedgo/features/profile/domain/entities/account_entities.dart';
import 'package:hadeedgo/features/profile/presentation/cubits/account_cubits.dart';

/// Validates the Account / Profile module data layer (DTO/Entity parsing),
/// nullability tolerance, and the Equatable-backed Cubit states against the
/// backend contract shape `{ success, message, data, errors }`.
void main() {
  group('UserProfile parsing', () {
    test('maps a full profile payload from the API data node', () {
      final profile = UserProfile.fromJson({
        'id': 'user-1',
        'fullName': 'أحمد محمد',
        'phone': '+201001234567',
        'email': 'ahmed@example.com',
        'companyName': 'Hadeed Co',
        'avatarUrl': 'https://example.com/a.png',
        'isPhoneVerified': true,
        'isEmailVerified': false,
      });

      expect(profile.id, 'user-1');
      expect(profile.fullName, 'أحمد محمد');
      expect(profile.phone, '+201001234567');
      expect(profile.email, 'ahmed@example.com');
      expect(profile.companyName, 'Hadeed Co');
      expect(profile.avatarUrl, 'https://example.com/a.png');
      expect(profile.isPhoneVerified, isTrue);
      expect(profile.isEmailVerified, isFalse);
    });

    test('tolerates missing/null fields (nullability safety)', () {
      final profile = UserProfile.fromJson({'id': 'user-1', 'fullName': null});

      expect(profile.id, 'user-1');
      expect(profile.fullName, isNull);
      expect(profile.email, isNull);
      expect(profile.companyName, isNull);
      expect(profile.avatarUrl, isNull);
      expect(profile.isPhoneVerified, isFalse);
      expect(profile.isEmailVerified, isFalse);
    });
  });

  group('AccountSummary parsing', () {
    test('wraps a nested profile and counts', () {
      final summary = AccountSummary.fromJson({
        'profile': {
          'id': 'user-1',
          'fullName': 'أحمد',
        },
        'savedAddressCount': 3,
        'taxInvoiceCount': 5,
      });

      expect(summary.profile.fullName, 'أحمد');
      expect(summary.savedAddressCount, 3);
      expect(summary.taxInvoiceCount, 5);
    });

    test('falls back to an empty profile when data is absent', () {
      final summary = AccountSummary.fromJson(const {});

      expect(summary.profile.id, '');
      expect(summary.savedAddressCount, 0);
      expect(summary.taxInvoiceCount, 0);
    });
  });

  group('SavedAddress parsing & display', () {
    test('parses a full address and renders display helpers', () {
      final address = SavedAddress.fromJson({
        'id': 'addr-1',
        'label': 'موقع المشروع',
        'governorate': 'القاهرة',
        'city': 'مدينة نصر',
        'street': 'شارع 10',
        'building': '5',
        'floor': '3',
        'apartment': '12',
        'additionalDetails': 'بجوار المول',
        'isDefault': true,
      });

      expect(address.id, 'addr-1');
      expect(address.label, 'موقع المشروع');
      expect(address.isDefault, isTrue);
      expect(address.displayTitle(), 'موقع المشروع');
      expect(address.displayFullAddress(), contains('شارع 10'));
      expect(address.displayFullAddress(), contains('القاهرة'));
    });

    test('builds an address line when formattedAddress is missing', () {
      final address = SavedAddress.fromJson({
        'id': 'addr-2',
        'city': 'الجيزة',
      });

      expect(address.displayTitle(), 'الجيزة');
      expect(address.displayFullAddress(), contains('الجيزة'));
    });
  });

  group('Tax invoices parsing', () {
    test('parses a paginated invoices list', () {
      final page = TaxInvoicesPage.fromJson({
        'totalCount': 25,
        'page': 1,
        'pageSize': 10,
        'items': [
          {
            'orderId': 'order-1',
            'invoiceNumber': 'INV-1',
            'orderNumber': 'ORD-1',
            'issuedAt': '2026-01-15T10:00:00Z',
            'taxAmount': 210,
            'totalAmount': 1710,
            'currency': 'SAR',
          },
        ],
      });

      expect(page.totalCount, 25);
      expect(page.page, 1);
      expect(page.pageSize, 10);
      expect(page.items, hasLength(1));
      expect(page.items.first.orderId, 'order-1');
      expect(page.items.first.issuedAt, isA<DateTime>());
      expect(page.hasMore, isTrue);
    });

    test('parses invoice details with line items and monetary fields', () {
      final details = TaxInvoiceDetails.fromJson({
        'orderId': 'order-1',
        'invoiceNumber': 'INV-1',
        'orderNumber': 'ORD-1',
        'issuedAt': '2026-01-15T10:00:00Z',
        'currency': 'SAR',
        'buyerName': 'أحمد',
        'buyerTaxId': '3000',
        'subTotal': 1500,
        'deliveryFee': 100,
        'taxAmount': 210,
        'totalAmount': 1810,
        'lines': [
          {
            'title': 'Steel Coil',
            'quantity': 2,
            'unitPrice': 750,
            'lineTotal': 1500,
            'currency': 'SAR',
          },
        ],
      });

      expect(details.orderId, 'order-1');
      expect(details.totalAmount, 1810);
      expect(details.taxAmount, 210);
      expect(details.lines, hasLength(1));
      expect(details.lines.first.title, 'Steel Coil');
      expect(details.lines.first.lineTotal, 1500);
    });
  });

  group('SupportInfo parsing', () {
    test('parses support contact channels', () {
      final info = SupportInfo.fromJson({
        'phone': '19824',
        'whatsApp': '+201001234567',
        'email': 'support@hadeedgo.com',
        'workingHours': 'السبت - الخميس',
      });

      expect(info.phone, '19824');
      expect(info.whatsApp, '+201001234567');
      expect(info.email, 'support@hadeedgo.com');
      expect(info.workingHours, 'السبت - الخميس');
    });

    test('handles an empty support payload without throwing', () {
      final info = SupportInfo.fromJson(const {});
      expect(info.phone, isNull);
      expect(info.email, isNull);
    });
  });

  group('Cubit states are Equatable', () {
    test('equal default states of every cubit are equal', () {
      expect(const AccountSummaryState(), const AccountSummaryState());
      expect(const ProfileState(), const ProfileState());
      expect(const AddressesState(), const AddressesState());
      expect(const InvoicesState(), const InvoicesState());
      expect(const InvoiceDetailsState(), const InvoiceDetailsState());
      expect(const SupportState(), const SupportState());
    });

    test('every state exposes non-empty props', () {
      expect(const AccountSummaryState().props, isNotEmpty);
      expect(const ProfileState().props, isNotEmpty);
      expect(const AddressesState().props, isNotEmpty);
      expect(const InvoicesState().props, isNotEmpty);
      expect(const InvoiceDetailsState().props, isNotEmpty);
      expect(const SupportState().props, isNotEmpty);
    });

    test('states with different values are not equal', () {
      const a = AccountSummaryState(status: AccountSummaryStatus.loading);
      const b = AccountSummaryState(
        status: AccountSummaryStatus.failure,
        errorMessage: 'x',
      );
      expect(a, isNot(b));
    });
  });
}

