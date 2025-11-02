import 'package:fitness/core/utils/validators/validator_strategy.dart';

class PhoneValidator implements ValidatorStrategy {
  @override
  String? get errorMessage => 'Số điện thoại không hợp lệ';

  @override
  bool validate(String input) {
    final regex = RegExp(r'^(0[0-9]{9})$');
    return regex.hasMatch(input);
  }
}
