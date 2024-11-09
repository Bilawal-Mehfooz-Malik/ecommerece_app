import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/src/features/products/presentation/products_list/products_search_state_provider.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/theme_extension.dart';

/// Search field used to filter products by name
class ProductsSearchTextField extends ConsumerStatefulWidget {
  const ProductsSearchTextField({super.key});

  @override
  ConsumerState<ProductsSearchTextField> createState() =>
      _ProductsSearchTextFieldState();
}

class _ProductsSearchTextFieldState
    extends ConsumerState<ProductsSearchTextField> {
  final _controller = TextEditingController();

  void _onSearch() {
    _controller.clear();
    ref.read(productsSearchQueryProvider.notifier).setSearchQuery('');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return TextField(
          controller: _controller,
          autofocus: false,
          style: context.textTheme.titleLarge,
          decoration: InputDecoration(
            hintText: 'Search products'.hardcoded,
            icon: const Icon(Icons.search),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    onPressed: _onSearch,
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (text) {
            ref.read(productsSearchQueryProvider.notifier).setSearchQuery(text);
          },
        );
      },
    );
  }
}
