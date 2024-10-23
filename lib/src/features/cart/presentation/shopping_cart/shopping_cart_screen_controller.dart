import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

part 'shopping_cart_screen_controller.g.dart';

@riverpod
class ShoppingCartScreenController extends _$ShoppingCartScreenController {
  @override
  FutureOr<void> build() {}

  Future<void> updateQuantity(ProductID productId, int quantity) async {
    state = const AsyncLoading();
    final updated = Item(productId: productId, quantity: quantity);
    final cartService = ref.read(cartServiceProvider);
    state = await AsyncValue.guard(() => cartService.setItem(updated));
  }

  Future<void> removeItemById(ProductID id) async {
    state = const AsyncLoading();
    final cartService = ref.read(cartServiceProvider);
    state = await AsyncValue.guard(() => cartService.removeItemById(id));
  }
}
