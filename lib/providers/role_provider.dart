import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class RoleNotifier extends StateNotifier<UserRole> {
  RoleNotifier() : super(UserRole.driver);

  void setRole(UserRole role) {
    state = role;
  }

  void toggleRole() {
    if (state == UserRole.driver) {
      state = UserRole.owner;
    } else if (state == UserRole.owner) {
      state = UserRole.driver;
    }
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserRole>((ref) {
  return RoleNotifier();
});
