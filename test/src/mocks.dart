import 'package:mocktail/mocktail.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockRemoteCartRepository extends Mock implements RemoteCartRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
