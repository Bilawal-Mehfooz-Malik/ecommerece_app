@Timeout(Duration(seconds: 5))
import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '12345678';
  final uid = testEmail.split('').reversed.join();
  final appUser = AppUser(uid: uid, email: testEmail);

  late FakeAuthRepository authRepository;

  FakeAuthRepository makeAuthRepository() =>
      FakeAuthRepository(addDelay: false);

  setUpAll(() {
    authRepository = makeAuthRepository();
  });

  group('FakeAuthRepository', () {
    test('currentUser is null', () {
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('currentUser is not null after signIn', () async {
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, appUser);
      expect(authRepository.authStateChanges(), emits(appUser));
    });

    test('currentUser is not null after creating account', () async {
      await authRepository.createUserWithEmailAndPassword(
          testEmail, testPassword);
      expect(authRepository.currentUser, appUser);
      expect(authRepository.authStateChanges(), emits(appUser));
    });

    test('currentUser is null after signOut', () async {
      await authRepository.signInWithEmailAndPassword(testEmail, testPassword);
      expect(authRepository.currentUser, appUser);
      expect(authRepository.authStateChanges(), emits(appUser));
      await authRepository.signOut();
      expect(authRepository.currentUser, null);
      expect(authRepository.authStateChanges(), emits(null));
    });

    test('sig in after dispose throws exception', () {
      authRepository.dispose();
      expect(
        () =>
            authRepository.signInWithEmailAndPassword(testEmail, testPassword),
        throwsStateError,
      );
    });
  });

  tearDownAll(() {
    authRepository.dispose();
  });
}
