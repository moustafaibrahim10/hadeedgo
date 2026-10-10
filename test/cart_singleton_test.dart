import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hadeedgo/core/di/service_locator.dart';
import 'package:hadeedgo/features/cart/presentation/cubits/cart_cubit.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
    await configureDependencies();
  });

  test('cart cubit is reused across the app instead of recreating on each screen', () {
    final first = GetIt.instance<CartCubit>();
    final second = GetIt.instance<CartCubit>();

    expect(identical(first, second), isTrue);
  });
}
