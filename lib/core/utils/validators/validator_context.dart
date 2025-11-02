import 'package:fitness/core/utils/validators/validator_strategy.dart';

class ValidatorContext {
  final ValidatorStrategy strategy;

  ValidatorContext(this.strategy);

  String? validate(String value) {
    return strategy.validate(value) ? null : strategy.errorMessage;
  }
}
