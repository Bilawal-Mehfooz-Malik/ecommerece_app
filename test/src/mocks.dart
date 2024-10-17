import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
