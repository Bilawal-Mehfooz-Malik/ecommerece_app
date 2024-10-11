import 'dart:async';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).signOut());

    return state.hasError == false;
  }
}

final accountScreenControllerProvider =
    AsyncNotifierProvider<AccountScreenController, void>(
        AccountScreenController.new);
