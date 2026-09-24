import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The app language shown in settings. English is offered as a future option;
/// only Indonesian is actually applied for now since all copy is in Bahasa
/// Indonesia.
enum AppLanguage { indonesia, english }

/// Holds the user's preferred theme mode as reactive state.
///
/// This is deliberately a real, toggleable piece of state so the switch in
/// settings moves and the icon reflects it. Dark is the first-class mode; the
/// app is built dark-first, so flipping to light does not repaint the app yet.
/// Settings surfaces an honest "coming soon" note next to the light option.
/// When a light theme is built, [BobApp] can read this to pick the ThemeData.
class ThemeModeController extends Notifier<bool> {
  /// State is "isDark". Starts dark, matching the teal-first design.
  @override
  bool build() => true;

  void setDark(bool value) => state = value;

  void toggle() => state = !state;
}

/// True when dark mode is selected. Dark is the default.
final NotifierProvider<ThemeModeController, bool> isDarkModeProvider =
    NotifierProvider<ThemeModeController, bool>(ThemeModeController.new);

/// Holds the selected language. Indonesian is the default and the only one
/// currently applied.
class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.indonesia;

  void set(AppLanguage language) => state = language;
}

/// The selected app language.
final NotifierProvider<LanguageController, AppLanguage> languageProvider =
    NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);
