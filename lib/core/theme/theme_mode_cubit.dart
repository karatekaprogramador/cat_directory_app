import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit() : super(ThemeMode.system);

  void setDarkMode(bool enabled) {
    emit(enabled ? ThemeMode.dark : ThemeMode.light);
  }
}
