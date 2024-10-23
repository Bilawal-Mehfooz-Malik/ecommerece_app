import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Cart());
  });

  late MockAuthRepository authRepository;
  late MockLocalCartRepository localCartRepository;
  late MockRemoteCartRepository remoteCartRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    localCartRepository = MockLocalCartRepository();
    remoteCartRepository = MockRemoteCartRepository();
  });

  CartService makeCartService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(cartServiceProvider);
  }

  group('setItem', () {
    test('null user, writes item to local cart', () async {
      // setup
      const expectedCart = Cart({'1': 1});
      final cartService = makeCartService();

      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );

      // run
      await cartService.setItem(Item(productId: '1', quantity: 1));

      // verify
      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, writes item to remote cart', () async {
      // setup
      const testUser = AppUser(uid: '123');
      const expectedCart = Cart({'1': 1});
      final cartService = makeCartService();

      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(const Cart()),
      );
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer((_) => Future.value());

      // run
      await cartService.setItem(Item(productId: '1', quantity: 1));

      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });

  group('addItems', () {
    test('null user, adds item to local cart', () async {
      // setup
      const initialCart = Cart({'ab': 3});
      const expectedCart = Cart({'ab': 4});
      final cartService = makeCartService();

      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(initialCart),
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );

      // run
      await cartService.addItem(Item(productId: 'ab', quantity: 1));

      // verify
      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, add items to remote cart', () async {
      // setup
      const testUser = AppUser(uid: '123');
      const initialCart = Cart({'ab': 3});
      const expectedCart = Cart({'ab': 4});
      final cartService = makeCartService();

      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(initialCart),
      );
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer((_) => Future.value());

      // run
      await cartService.addItem(Item(productId: 'ab', quantity: 1));

      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });

  group('removeItem', () {
    test('null user, removes item from local cart', () async {
      // setup
      const initialCart = Cart({'abc': 3, 'def': 1});
      const expectedCart = Cart({'def': 1});
      final cartService = makeCartService();
      when(() => authRepository.currentUser).thenReturn(null);
      when(localCartRepository.fetchCart).thenAnswer(
        (_) => Future.value(initialCart),
      );
      when(() => localCartRepository.setCart(expectedCart)).thenAnswer(
        (_) => Future.value(),
      );

      // run
      await cartService.removeItemById('abc');

      // verify
      verify(() => localCartRepository.setCart(expectedCart)).called(1);
      verifyNever(() => remoteCartRepository.setCart(any(), any()));
    });

    test('non-null user, remove item from remote cart', () async {
      // setup
      const testUser = AppUser(uid: '123');
      const initialCart = Cart({'abc': 3, 'def': 1});
      const expectedCart = Cart({'def': 1});
      final cartService = makeCartService();

      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteCartRepository.fetchCart(testUser.uid)).thenAnswer(
        (_) => Future.value(initialCart),
      );
      when(() => remoteCartRepository.setCart(testUser.uid, expectedCart))
          .thenAnswer((_) => Future.value());

      // run
      await cartService.removeItemById('abc');

      // verify
      verify(
        () => remoteCartRepository.setCart(testUser.uid, expectedCart),
      ).called(1);
      verifyNever(() => localCartRepository.setCart(any()));
    });
  });
}