@Timeout(Duration(seconds: 5))
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeProductsRepository productRepository;
  FakeProductsRepository makeProductRepository() =>
      FakeProductsRepository(addDelay: false);

  setUpAll(() {
    productRepository = makeProductRepository();
  });

  group('FakeProductRepository', () {
    test('getProductsList returns Global list', () {
      expect(productRepository.getProductsList(), kTestProducts);
    });

    test('getProduct(1) returns first item', () {
      expect(productRepository.getProduct('1'), kTestProducts[0]);
    });

    test('getProduct(100) returns null', () {
      expect(productRepository.getProduct('100'), null);
    });

    test('fetchProductList returns global list', () async {
      expect(await productRepository.fetchProductsList(), kTestProducts);
    });

    test('watchProductsList emits gloabl list', () {
      expect(productRepository.watchProductsList(), emits(kTestProducts));
    });

    test('watchProduct(1) returns first item', () {
      expect(productRepository.watchProduct('1'), emits(kTestProducts[0]));
    });

    test('watchProduct(10) returns null', () {
      expect(productRepository.watchProduct('100'), emits(null));
    });
  });
}
