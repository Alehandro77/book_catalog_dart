import 'dart:io';

String readNonEmptyString(String label) {
  while (true) {
    stdout.write(label);
    final input = stdin.readLineSync()?.trim() ?? '';
    if (input.isNotEmpty) {
      return input;
    }
    stdout.writeln('Ошибка: поле не может быть пустым.');
  }
}

int? readOptionalPositiveInt(String label) {
  stdout.write(label);
  final input = stdin.readLineSync()?.trim() ?? '';
  if (input.isEmpty) {
    return null;
  }
  final number = int.tryParse(input);
  if (number != null && number > 0) {
    return number;
  }
  stdout.writeln('Ошибка: введите положительное число или оставьте пустым.');
  return readOptionalPositiveInt(label);
}

String readOptionalString(String label) {
  stdout.write(label);
  final input = stdin.readLineSync()?.trim() ?? '';
  return input;
}