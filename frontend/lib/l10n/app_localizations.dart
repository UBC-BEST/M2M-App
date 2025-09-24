import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get title;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @nameAndUsername.
  ///
  /// In en, this message translates to:
  /// **'Name and Username'**
  String get nameAndUsername;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @enableFaceIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID?'**
  String get enableFaceIdTitle;

  /// No description provided for @enableFaceIdDescription.
  ///
  /// In en, this message translates to:
  /// **'Would you like to enable Face ID for easier logins in the future?'**
  String get enableFaceIdDescription;

  /// No description provided for @noButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noButtonLabel;

  /// No description provided for @yesButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesButtonLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @loginWithFaceId.
  ///
  /// In en, this message translates to:
  /// **'Log in with Face ID'**
  String get loginWithFaceId;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @recommendedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedSectionTitle;

  /// No description provided for @calibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get calibrationTitle;

  /// No description provided for @maintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceLabel;

  /// No description provided for @durationTwoToThreeMinutes.
  ///
  /// In en, this message translates to:
  /// **'2-3 min'**
  String get durationTwoToThreeMinutes;

  /// No description provided for @gripTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Grip Test'**
  String get gripTestTitle;

  /// No description provided for @exerciseLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exerciseLabel;

  /// No description provided for @rangeTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Range Test'**
  String get rangeTestTitle;

  /// No description provided for @durationThreeToTenMinutes.
  ///
  /// In en, this message translates to:
  /// **'3-10 min'**
  String get durationThreeToTenMinutes;

  /// No description provided for @dailyWarmupTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Warm-up'**
  String get dailyWarmupTitle;

  /// No description provided for @dailyWarmupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stretching • 3-10 min'**
  String get dailyWarmupSubtitle;

  /// No description provided for @weeklyChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Challenge'**
  String get weeklyChallengeTitle;

  /// No description provided for @weeklyChallengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stretching • 3-10 min'**
  String get weeklyChallengeSubtitle;

  /// No description provided for @startButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButtonLabel;

  /// No description provided for @gamePizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza Game'**
  String get gamePizza;

  /// No description provided for @gameGolf.
  ///
  /// In en, this message translates to:
  /// **'Golf Game'**
  String get gameGolf;

  /// No description provided for @gameCallOfDuty.
  ///
  /// In en, this message translates to:
  /// **'Call of Duty'**
  String get gameCallOfDuty;

  /// No description provided for @gameSpiderman.
  ///
  /// In en, this message translates to:
  /// **'Spiderman'**
  String get gameSpiderman;

  /// No description provided for @gameValorant.
  ///
  /// In en, this message translates to:
  /// **'Valorant'**
  String get gameValorant;

  /// No description provided for @statsPagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Stats coming soon'**
  String get statsPagePlaceholder;

  /// No description provided for @trainingSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Selection'**
  String get trainingSelectionTitle;

  /// No description provided for @trainingSelectionQuestion.
  ///
  /// In en, this message translates to:
  /// **'What would you like to train?'**
  String get trainingSelectionQuestion;

  /// No description provided for @trainingCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get trainingCardio;

  /// No description provided for @trainingStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get trainingStrength;

  /// No description provided for @trainingFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get trainingFlexibility;

  /// No description provided for @trainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get trainingBalance;

  /// No description provided for @trainingEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get trainingEndurance;

  /// No description provided for @trainingMovementAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Movement Accuracy'**
  String get trainingMovementAccuracy;

  /// No description provided for @nameSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Name Settings'**
  String get nameSettingsTitle;

  /// No description provided for @changeNameHeading.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get changeNameHeading;

  /// No description provided for @changeNameDescription.
  ///
  /// In en, this message translates to:
  /// **'You can change your name every 90 days and username every 30 days.'**
  String get changeNameDescription;

  /// No description provided for @emailSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Settings'**
  String get emailSettingsTitle;

  /// No description provided for @passwordSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Settings'**
  String get passwordSettingsTitle;

  /// No description provided for @placeholderComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get placeholderComingSoon;

  /// No description provided for @backButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonLabel;

  /// No description provided for @skipButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skipButtonLabel;

  /// No description provided for @nextButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButtonLabel;

  /// No description provided for @getStartedButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButtonLabel;

  /// No description provided for @onboardingExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete exercises'**
  String get onboardingExerciseTitle;

  /// No description provided for @onboardingExerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'Work through guided routines built with your therapist.'**
  String get onboardingExerciseDescription;

  /// No description provided for @onboardingGamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Play interactive games'**
  String get onboardingGamesTitle;

  /// No description provided for @onboardingGamesDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay engaged with motivating sessions tailored to your goals.'**
  String get onboardingGamesDescription;

  /// No description provided for @onboardingProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get onboardingProgressTitle;

  /// No description provided for @onboardingProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'See improvements over time and celebrate every milestone.'**
  String get onboardingProgressDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
