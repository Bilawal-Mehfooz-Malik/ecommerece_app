@Timeout(Duration(seconds: 5))
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';

import '../../../../mocks.dart';

void main() {
  const data = AsyncData<void>(null);
  final exception = Exception('Connection Failed!');

  late MockAuthRepository authRepository;
  late Listener<AsyncValue<void>> listener;

  ProviderContainer makeContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    authRepository = MockAuthRepository();
    listener = Listener<AsyncValue<void>>();
    registerFallbackValue(const AsyncLoading<void>());
  });

  group('AccountScreenController', () {
    test('initial state is AsyncData(null)', () {
      // setup
      final container = makeContainer(authRepository);
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );

      // verify
      verify(() => listener(null, const AsyncData<void>(null)));
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signOut);
    });

    test('signOut success', () async {
      // setup
      final container = makeContainer(authRepository);
      when(authRepository.signOut).thenAnswer((_) => Future.value());
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
      // setup
      final container = makeContainer(authRepository);
      when(authRepository.signOut).thenThrow(exception);
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

  tearDownAll(() {
    authRepository.dispose();
  });
}
