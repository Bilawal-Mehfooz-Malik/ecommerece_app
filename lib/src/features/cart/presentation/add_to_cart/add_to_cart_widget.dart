import 'dart:math';

import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

/// A widget that shows an [ItemQuantitySelector] along with a [PrimaryButton]
/// to add the selected quantity of the item to the cart.
class AddToCartWidget extends ConsumerWidget {
  const AddToCartWidget({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableQuantity = product.availableQuantity;
    final state = ref.watch(addToCartControllerProvider);
    final quantity = ref.watch(itemQuantityControllerProvider);
    debugPrint(quantity.toString());

    ref.listen<AsyncValue>(
      addToCartControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity:'.hardcoded),
            ItemQuantitySelector(
              quantity: quantity,
              maxQuantity: min(availableQuantity, 10),
              onChanged: state.isLoading
                  ? null
                  : (value) => ref
                      .read(itemQuantityControllerProvider.notifier)
                      .updateQuantity(value),
            ),
          ],
        ),
        gapH8,
        const Divider(),
        gapH8,
        PrimaryButton(
          isLoading: state.isLoading,
          // only enable this button if there is enough stock
          onPressed: availableQuantity > 0
              ? () => ref
                  .read(addToCartControllerProvider.notifier)
                  .addItem(product.id)
              : null,
          text: availableQuantity > 0
              ? 'Add to Cart'.hardcoded
              : 'Out of Stock'.hardcoded,
        ),
        if (product.availableQuantity > 0 && availableQuantity == 0) ...[
          gapH8,
          Text(
            'Already added to cart'.hardcoded,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ]
      ],
    );
  }
}
