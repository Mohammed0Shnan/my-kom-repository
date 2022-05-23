import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_localization/presistance/localization_preferences_helper.dart';

abstract class LocalizationEvent {}

class LocalizationArabicClickedEvent extends LocalizationEvent {}

class LocalizationEnglishClickedEvent extends LocalizationEvent {}

abstract class LocalizationState {}

class LocalizationArabicState extends LocalizationState {}

class LocalizationEnglishState extends LocalizationState {}

class LocalizationService extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationService()
      : super(
          Platform.localeName.substring(0, 2) == 'en'
              ? LocalizationEnglishState()
              : LocalizationArabicState(),
        ){

    on<LocalizationEvent>((LocalizationEvent event, Emitter<LocalizationState> emit) {
      if (event is LocalizationArabicClickedEvent) {
        emit( LocalizationArabicState());
      } else {
        emit( LocalizationEnglishState());
      }
    });
    getLanguage();

  }
  final LocalizationPreferencesHelper _preferencesHelper =
      LocalizationPreferencesHelper();

  setLanguage(String lang) async {
    await _preferencesHelper.setLanguage(lang);
    if (lang == 'ar')
      this.add(LocalizationArabicClickedEvent());
    else
      this.add(LocalizationEnglishClickedEvent());
  }

  getLanguage() async {
    String? lang = await _preferencesHelper.getLanguage();
    lang ??= 'en';
    if (lang == 'ar')
      this.add(LocalizationArabicClickedEvent());
    else
      this.add(LocalizationEnglishClickedEvent());
  }
}
