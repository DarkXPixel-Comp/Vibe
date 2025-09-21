import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifer extends _$ThemeNotifer {
  @override
  bool build() => false;

  void toggle() => state = !state;
}