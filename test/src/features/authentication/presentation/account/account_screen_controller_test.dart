import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  group('AccountScreenController', () {
    ProviderContainer makeContainer(MockAuthRepository authRepository) {
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
      );
      addTearDown(container.dispose);
      return container;
    }

    setUpAll(() {
      registerFallbackValue(const AsyncLoading<void>());
    });
    test('initial state is AsyncData(null)', () {
      final authRepository = MockAuthRepository();
      final container = makeContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      verify(() => listener(null, const AsyncData<void>(null)));
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signOut);
    });

    test('signOut success', () async {
      final authRepository = MockAuthRepository();
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final container = makeContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      const data = AsyncData<void>(null);
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();

      // verify
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });

    test('signOut Failure', () async {
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed!');
      when(authRepository.signOut).thenThrow(exception);
      final container = makeContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      const data = AsyncData<void>(null);
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();

      // verify
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });
  });
}
