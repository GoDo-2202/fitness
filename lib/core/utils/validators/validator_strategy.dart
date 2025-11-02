abstract class ValidatorStrategy {
  bool validate(String input);
  String? get errorMessage;
}
