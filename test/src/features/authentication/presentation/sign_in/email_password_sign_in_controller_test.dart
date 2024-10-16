@Timeout(Duration(seconds: 5))
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345678';
  late AsyncData<void> data;
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
    data = const AsyncData<void>(null);
    authRepository = MockAuthRepository();
    listener = Listener<AsyncValue<void>>();
    registerFallbackValue(const AsyncLoading<void>());
  });

  group('submit', () {
    test('''Given FormType is SigIn
    When signIn Succeeds
    Then return true
    And State is AsyncData''', () async {
      // setup
      final container = makeContainer(authRepository);
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller =
          container.read(emailPasswordSignInControllerProvider.notifier);
      container.listen(
        emailPasswordSignInControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final result = await controller.submit(
        email: testEmail,
        password: testPassword,
        formType: EmailPasswordSignInFormType.signIn,
      );

      // verify
      expect(result, true);
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
    });

    test('''Given FormType is SigIn
    When signIn Fails
    Then return false
    And State is AsyncError''', () async {
      // setup
      final container = makeContainer(authRepository);
      final exception = Exception('Connection Failed!');
      when(() => authRepository.signInWithEmailAndPassword(
          testEmail, testPassword)).thenThrow(exception);
      final controller =
          container.read(emailPasswordSignInControllerProvider.notifier);
      container.listen(
        emailPasswordSignInControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final result = await controller.submit(
        email: testEmail,
        password: testPassword,
        formType: EmailPasswordSignInFormType.signIn,
      );

      // verify
      expect(result, false);
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
    });

    test('''Given FormType is Register
    When register Succeeds
    Then return true
    And State is AsyncData''', () async {
      // setup
      final container = makeContainer(authRepository);
      when(() => authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      final controller =
          container.read(emailPasswordSignInControllerProvider.notifier);
      container.listen(
        emailPasswordSignInControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final result = await controller.submit(
        email: testEmail,
        password: testPassword,
        formType: EmailPasswordSignInFormType.register,
      );

      // verify
      expect(result, true);
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
    });

    test('''Given FormType is Register
    When Register Fails
    Then return false
    And State is AsyncError''', () async {
      // setup
      final container = makeContainer(authRepository);
      final exception = Exception('Connection Failed!');
      when(() => authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword)).thenThrow(exception);
      final controller =
          container.read(emailPasswordSignInControllerProvider.notifier);
      container.listen(
        emailPasswordSignInControllerProvider,
        listener,
        fireImmediately: true,
      );

      // run
      final result = await controller.submit(
        email: testEmail,
        password: testPassword,
        formType: EmailPasswordSignInFormType.register,
      );

      // verify
      expect(result, false);
      verifyInOrder([
        () => listener(null, data),
        () => listener(data, any(that: isA<AsyncLoading>())),
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
    });
  });
}