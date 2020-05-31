import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_user_auth/flutter_user_auth.dart';

void main() {
  test('', () {
    UserAuth.initialize(
      AuthConfig(
        loginConfig: LoginConfig(
          endPoint: "Test Endpoint",
        ),
        registerConfig: RegisterConfig(
          endPoint: "Test Endpoint",
          userType: "customer",
        ),
      ),
    );
  });
}
