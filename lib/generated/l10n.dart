// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Enter or edit information about your Institution:`
  String get enterInstitution {
    return Intl.message(
      'Enter or edit information about your Institution:',
      name: 'enterInstitution',
      desc: '',
      args: [],
    );
  }

  /// `Enter or edit Resources:`
  String get enterResources {
    return Intl.message(
      'Enter or edit Resources:',
      name: 'enterResources',
      desc: '',
      args: [],
    );
  }

  /// `WHAT do you want to do?`
  String get selectExperiment {
    return Intl.message(
      'WHAT do you want to do?',
      name: 'selectExperiment',
      desc: '',
      args: [],
    );
  }

  /// `Enter or edit Compounds or Substances:`
  String get enterCompounds {
    return Intl.message(
      'Enter or edit Compounds or Substances:',
      name: 'enterCompounds',
      desc: '',
      args: [],
    );
  }

  /// `Enter or edit Instrument or Tools:`
  String get enterTools {
    return Intl.message(
      'Enter or edit Instrument or Tools:',
      name: 'enterTools',
      desc: '',
      args: [],
    );
  }

  /// `Enter or edit References (publications or samples):`
  String get enterReferences {
    return Intl.message(
      'Enter or edit References (publications or samples):',
      name: 'enterReferences',
      desc: '',
      args: [],
    );
  }

  /// `Enter or edit information about your Personnel:`
  String get enterPersonnel {
    return Intl.message(
      'Enter or edit information about your Personnel:',
      name: 'enterPersonnel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
