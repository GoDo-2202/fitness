import 'package:fitness/core/utils/validators/validator_strategy.dart';

class PasswordValidator implements ValidatorStrategy {
  @override
  String? get errorMessage => 'Password không hợp lệ';

  @override
  bool validate(String input) {
    return input.length >= 6;
  }
}
