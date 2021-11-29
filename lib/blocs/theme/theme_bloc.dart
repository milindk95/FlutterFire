import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeDark());

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ChangeTheme) {
      await Preference.setAppTheme(event.isDark);
      yield event.isDark ? ThemeDark() : ThemeLight();
    } else if (event is GetTheme) {
      final themeData = await Preference.getTheme();
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      yield themeData != null
          ? (themeData ? ThemeDark() : ThemeLight())
          : brightness == Brightness.dark
              ? ThemeDark()
              : ThemeLight();
    }
  }
}
