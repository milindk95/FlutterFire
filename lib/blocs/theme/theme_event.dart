part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class ChangeTheme extends ThemeEvent {
  final bool isDark;

  ChangeTheme({this.isDark = false});

  @override
  List<Object> get props => [isDark];
}

class GetTheme extends ThemeEvent {
  @override
  List<Object> get props => [];
}
