import 'package:fitness/core/utils/validators/validator_strategy.dart';

class EmailValidator implements ValidatorStrategy {
  @override
  String? get errorMessage => 'Email không hợp lệ';

  @override
  bool validate(String input) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(input);
  }
}
