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

  /// No description provided for @statsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get statsPageTitle;

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

  /// No description provided for @calibrationSettingsEntry.
  ///
  /// In en, this message translates to:
  /// **'Rehabilitation calibration'**
  String get calibrationSettingsEntry;

  /// No description provided for @calibrationRehabTitle.
  ///
  /// In en, this message translates to:
  /// **'Rehabilitation Calibration'**
  String get calibrationRehabTitle;

  /// No description provided for @calibrationTherapyGamepadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s calibrate your therapy gamepad'**
  String get calibrationTherapyGamepadSubtitle;

  /// No description provided for @calibrationBeforeWeBegin.
  ///
  /// In en, this message translates to:
  /// **'Before We Begin'**
  String get calibrationBeforeWeBegin;

  /// No description provided for @calibrationBeforeWeBeginBody.
  ///
  /// In en, this message translates to:
  /// **'This calibration will measure your current range of motion and strength'**
  String get calibrationBeforeWeBeginBody;

  /// No description provided for @calibrationDailyBaseline.
  ///
  /// In en, this message translates to:
  /// **'Daily Baseline'**
  String get calibrationDailyBaseline;

  /// No description provided for @calibrationDailyBaselineBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ll establish your daily maximum and minimum ranges'**
  String get calibrationDailyBaselineBody;

  /// No description provided for @calibrationFourQuickTests.
  ///
  /// In en, this message translates to:
  /// **'4 Quick Tests'**
  String get calibrationFourQuickTests;

  /// No description provided for @calibrationFourQuickTestsBody.
  ///
  /// In en, this message translates to:
  /// **'Grip strength, wrist flexion, extension, and rotation'**
  String get calibrationFourQuickTestsBody;

  /// No description provided for @calibrationAtYourPace.
  ///
  /// In en, this message translates to:
  /// **'At Your Pace'**
  String get calibrationAtYourPace;

  /// No description provided for @calibrationAtYourPaceBody.
  ///
  /// In en, this message translates to:
  /// **'Move only as far as comfortable. Stop if you feel pain'**
  String get calibrationAtYourPaceBody;

  /// No description provided for @calibrationImportantCallout.
  ///
  /// In en, this message translates to:
  /// **'Important: Only perform movements that are comfortable. This is not a stress test. Consult your therapist if unsure.'**
  String get calibrationImportantCallout;

  /// No description provided for @calibrationStartCalibration.
  ///
  /// In en, this message translates to:
  /// **'Start Calibration'**
  String get calibrationStartCalibration;

  /// No description provided for @calibrationConnectGamepad.
  ///
  /// In en, this message translates to:
  /// **'Connect Gamepad'**
  String get calibrationConnectGamepad;

  /// No description provided for @calibrationConnectGamepadHint.
  ///
  /// In en, this message translates to:
  /// **'Ensure your device is powered on and nearby'**
  String get calibrationConnectGamepadHint;

  /// No description provided for @calibrationSensorStatus.
  ///
  /// In en, this message translates to:
  /// **'Sensor Status'**
  String get calibrationSensorStatus;

  /// No description provided for @calibrationSensorStatusHint.
  ///
  /// In en, this message translates to:
  /// **'All sensors must be connected to proceed'**
  String get calibrationSensorStatusHint;

  /// No description provided for @calibrationSensorGrip.
  ///
  /// In en, this message translates to:
  /// **'Grip Sensor'**
  String get calibrationSensorGrip;

  /// No description provided for @calibrationSensorFlexion.
  ///
  /// In en, this message translates to:
  /// **'Flexion Sensor'**
  String get calibrationSensorFlexion;

  /// No description provided for @calibrationSensorExtension.
  ///
  /// In en, this message translates to:
  /// **'Extension Sensor'**
  String get calibrationSensorExtension;

  /// No description provided for @calibrationSensorRotation.
  ///
  /// In en, this message translates to:
  /// **'Rotation Sensor'**
  String get calibrationSensorRotation;

  /// No description provided for @calibrationConnectSensors.
  ///
  /// In en, this message translates to:
  /// **'Connect Sensors'**
  String get calibrationConnectSensors;

  /// No description provided for @calibrationExercisesHeading.
  ///
  /// In en, this message translates to:
  /// **'Calibration Exercises'**
  String get calibrationExercisesHeading;

  /// No description provided for @calibrationExercisesSubheading.
  ///
  /// In en, this message translates to:
  /// **'We\'ll guide you through 4 simple movements'**
  String get calibrationExercisesSubheading;

  /// No description provided for @calibrationWhatToExpect.
  ///
  /// In en, this message translates to:
  /// **'What to Expect'**
  String get calibrationWhatToExpect;

  /// No description provided for @calibrationWhatToExpectHint.
  ///
  /// In en, this message translates to:
  /// **'Each exercise takes 10-15 seconds'**
  String get calibrationWhatToExpectHint;

  /// No description provided for @calibrationListGripTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Grip Strength'**
  String get calibrationListGripTitle;

  /// No description provided for @calibrationListGripBody.
  ///
  /// In en, this message translates to:
  /// **'Squeeze as hard as comfortable, then release completely'**
  String get calibrationListGripBody;

  /// No description provided for @calibrationListFlexionTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Wrist Flexion'**
  String get calibrationListFlexionTitle;

  /// No description provided for @calibrationListFlexionBody.
  ///
  /// In en, this message translates to:
  /// **'Bend wrist forward, hold briefly, then return to neutral'**
  String get calibrationListFlexionBody;

  /// No description provided for @calibrationListExtensionTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Wrist Extension'**
  String get calibrationListExtensionTitle;

  /// No description provided for @calibrationListExtensionBody.
  ///
  /// In en, this message translates to:
  /// **'Bend wrist backward, hold briefly, then return to neutral'**
  String get calibrationListExtensionBody;

  /// No description provided for @calibrationListRotationTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Wrist Rotation'**
  String get calibrationListRotationTitle;

  /// No description provided for @calibrationListRotationBody.
  ///
  /// In en, this message translates to:
  /// **'Rotate wrist slowly through full range of motion'**
  String get calibrationListRotationBody;

  /// No description provided for @calibrationRememberHeading.
  ///
  /// In en, this message translates to:
  /// **'Remember:'**
  String get calibrationRememberHeading;

  /// No description provided for @calibrationRemember1.
  ///
  /// In en, this message translates to:
  /// **'Move only within your comfortable range'**
  String get calibrationRemember1;

  /// No description provided for @calibrationRemember2.
  ///
  /// In en, this message translates to:
  /// **'Stop immediately if you feel pain'**
  String get calibrationRemember2;

  /// No description provided for @calibrationRemember3.
  ///
  /// In en, this message translates to:
  /// **'Take breaks between exercises if needed'**
  String get calibrationRemember3;

  /// No description provided for @calibrationRemember4.
  ///
  /// In en, this message translates to:
  /// **'Follow the on-screen visual guidance'**
  String get calibrationRemember4;

  /// No description provided for @calibrationStartFirstExercise.
  ///
  /// In en, this message translates to:
  /// **'Start First Exercise'**
  String get calibrationStartFirstExercise;

  /// No description provided for @calibrationExerciseOf.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} of {total}'**
  String calibrationExerciseOf(int current, int total);

  /// No description provided for @calibrationExerciseGripTitle.
  ///
  /// In en, this message translates to:
  /// **'Grip Strength'**
  String get calibrationExerciseGripTitle;

  /// No description provided for @calibrationExerciseGripInstruction.
  ///
  /// In en, this message translates to:
  /// **'Squeeze the gamepad as hard as you can, then release completely'**
  String get calibrationExerciseGripInstruction;

  /// No description provided for @calibrationExerciseGripTip.
  ///
  /// In en, this message translates to:
  /// **'Squeeze and hold for 3 seconds, then release'**
  String get calibrationExerciseGripTip;

  /// No description provided for @calibrationExerciseFlexionTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrist Flexion'**
  String get calibrationExerciseFlexionTitle;

  /// No description provided for @calibrationExerciseFlexionInstruction.
  ///
  /// In en, this message translates to:
  /// **'Bend your wrist forward as far as comfortable, then return to neutral'**
  String get calibrationExerciseFlexionInstruction;

  /// No description provided for @calibrationExerciseFlexionTip.
  ///
  /// In en, this message translates to:
  /// **'Hold the end position for 3 seconds, then relax'**
  String get calibrationExerciseFlexionTip;

  /// No description provided for @calibrationExerciseExtensionTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrist Extension'**
  String get calibrationExerciseExtensionTitle;

  /// No description provided for @calibrationExerciseExtensionInstruction.
  ///
  /// In en, this message translates to:
  /// **'Bend your wrist backward as far as comfortable, then return to neutral'**
  String get calibrationExerciseExtensionInstruction;

  /// No description provided for @calibrationExerciseExtensionTip.
  ///
  /// In en, this message translates to:
  /// **'Hold the end position for 3 seconds, then relax'**
  String get calibrationExerciseExtensionTip;

  /// No description provided for @calibrationExerciseRotationTitle.
  ///
  /// In en, this message translates to:
  /// **'Wrist Rotation'**
  String get calibrationExerciseRotationTitle;

  /// No description provided for @calibrationExerciseRotationInstruction.
  ///
  /// In en, this message translates to:
  /// **'Rotate your wrist slowly through your full comfortable range'**
  String get calibrationExerciseRotationInstruction;

  /// No description provided for @calibrationExerciseRotationTip.
  ///
  /// In en, this message translates to:
  /// **'Complete 2 slow rotations, then rest'**
  String get calibrationExerciseRotationTip;

  /// No description provided for @calibrationBeginExercise.
  ///
  /// In en, this message translates to:
  /// **'Begin Exercise'**
  String get calibrationBeginExercise;

  /// No description provided for @calibrationCountdownPreparing.
  ///
  /// In en, this message translates to:
  /// **'Get ready…'**
  String get calibrationCountdownPreparing;

  /// No description provided for @calibrationExerciseComplete.
  ///
  /// In en, this message translates to:
  /// **'Exercise complete'**
  String get calibrationExerciseComplete;

  /// No description provided for @calibrationContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get calibrationContinue;

  /// No description provided for @calibrationCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibration Complete!'**
  String get calibrationCompleteTitle;

  /// No description provided for @calibrationCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your daily baseline has been established'**
  String get calibrationCompleteSubtitle;

  /// No description provided for @calibrationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibration Summary'**
  String get calibrationSummaryTitle;

  /// No description provided for @calibrationSessionCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Session completed on {date}'**
  String calibrationSessionCompletedOn(String date);

  /// No description provided for @calibrationSummaryExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get calibrationSummaryExercises;

  /// No description provided for @calibrationSummaryDataPoints.
  ///
  /// In en, this message translates to:
  /// **'Data Points'**
  String get calibrationSummaryDataPoints;

  /// No description provided for @calibrationExerciseResults.
  ///
  /// In en, this message translates to:
  /// **'Exercise Results'**
  String get calibrationExerciseResults;

  /// No description provided for @calibrationNextSteps.
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get calibrationNextSteps;

  /// No description provided for @calibrationNextStep1.
  ///
  /// In en, this message translates to:
  /// **'Your gamepad is now calibrated to your current abilities'**
  String get calibrationNextStep1;

  /// No description provided for @calibrationNextStep2.
  ///
  /// In en, this message translates to:
  /// **'These measurements will be used as your daily baseline'**
  String get calibrationNextStep2;

  /// No description provided for @calibrationNextStep3.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate daily for best results'**
  String get calibrationNextStep3;

  /// No description provided for @calibrationNextStep4.
  ///
  /// In en, this message translates to:
  /// **'Share this data with your therapist for progress tracking'**
  String get calibrationNextStep4;

  /// No description provided for @calibrationExportData.
  ///
  /// In en, this message translates to:
  /// **'Export Calibration Data'**
  String get calibrationExportData;

  /// No description provided for @calibrationReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get calibrationReturnHome;

  /// No description provided for @calibrationExportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Export will be available in a future update.'**
  String get calibrationExportComingSoon;

  /// No description provided for @calibrationConnectingSensors.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get calibrationConnectingSensors;
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
