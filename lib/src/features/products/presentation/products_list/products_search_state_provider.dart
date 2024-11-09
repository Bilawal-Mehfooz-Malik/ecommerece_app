import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

part 'products_search_state_provider.g.dart';

@riverpod
class ProductsSearchQuery extends _$ProductsSearchQuery {
  @override
  String build() {
    return '';
  }

  // Method to update the search query
  void setSearchQuery(String query) {
    state = query;
  }
}

// Future provider to fetch search results based on the query
@riverpod
Future<List<Product>> productsSearchResults(
    ProductsSearchResultsRef ref) async {
  final searchQuery = ref.watch(productsSearchQueryProvider);
  final productsList =
      await ref.watch(productsListSearchProvider(searchQuery).future);

  return productsList;
}
