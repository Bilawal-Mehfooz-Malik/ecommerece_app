// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_search_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsSearchResultsHash() =>
    r'b929c4f5f66753af54ee1137cf87b01111e0e809';

/// See also [productsSearchResults].
@ProviderFor(productsSearchResults)
final productsSearchResultsProvider =
    AutoDisposeFutureProvider<List<Product>>.internal(
  productsSearchResults,
  name: r'productsSearchResultsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsSearchResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductsSearchResultsRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$productsSearchQueryHash() =>
    r'727544f68e343ee697e01afad220d4d5e6a367f0';

/// See also [ProductsSearchQuery].
@ProviderFor(ProductsSearchQuery)
final productsSearchQueryProvider =
    AutoDisposeNotifierProvider<ProductsSearchQuery, String>.internal(
  ProductsSearchQuery.new,
  name: r'productsSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productsSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductsSearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
