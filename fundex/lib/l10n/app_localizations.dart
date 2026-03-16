import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your member portfolio and hotel booking privileges.'**
  String get loginSubtitle;

  /// No description provided for @loginAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get loginAccountLabel;

  /// No description provided for @loginModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose login method'**
  String get loginModeTitle;

  /// No description provided for @loginCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get loginCodeLabel;

  /// No description provided for @loginSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get loginSendCode;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginBrowseAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Browse without signing in (Guest mode)'**
  String get loginBrowseAsGuest;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get loginForgotPassword;

  /// No description provided for @loginFootnote.
  ///
  /// In en, this message translates to:
  /// **'Designed for global members with Japan-ready UX and privacy standards.'**
  String get loginFootnote;

  /// No description provided for @loginErrorSendCodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to send code. Please try again later.'**
  String get loginErrorSendCodeFailed;

  /// No description provided for @loginErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please verify your code.'**
  String get loginErrorInvalidCode;

  /// No description provided for @loginEmailAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address for email sign in.'**
  String get loginEmailAccountInvalid;

  /// No description provided for @loginMobileAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number for phone sign in.'**
  String get loginMobileAccountInvalid;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up secure access for investment, stays, and member privileges.'**
  String get registerSubtitle;

  /// No description provided for @registerQuickTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerQuickTitle;

  /// No description provided for @registerQuickSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register with just your email and password. You can complete required details later.'**
  String get registerQuickSubtitle;

  /// No description provided for @registerModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration method'**
  String get registerModeTitle;

  /// No description provided for @authModeEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authModeEmail;

  /// No description provided for @authModeMobile.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authModeMobile;

  /// No description provided for @splashBrandName.
  ///
  /// In en, this message translates to:
  /// **'StellaVia'**
  String get splashBrandName;

  /// No description provided for @splashBrandSlogan.
  ///
  /// In en, this message translates to:
  /// **'Investments become the road to tomorrow.'**
  String get splashBrandSlogan;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Real estate crowdfunding'**
  String get splashTagline;

  /// No description provided for @authEntryHeadline.
  ///
  /// In en, this message translates to:
  /// **'One sign-in for investment and hotel member services'**
  String get authEntryHeadline;

  /// No description provided for @authEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone or email to manage investments, bookings, and member privileges.'**
  String get authEntryDescription;

  /// No description provided for @authEntryPhoneLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with phone'**
  String get authEntryPhoneLogin;

  /// No description provided for @authEntryEmailLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get authEntryEmailLogin;

  /// No description provided for @authEntryNonMemberRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Not a member? Register now'**
  String get authEntryNonMemberRegisterNow;

  /// No description provided for @authBeforeMemberDirectLogin.
  ///
  /// In en, this message translates to:
  /// **'Already a member? Sign in'**
  String get authBeforeMemberDirectLogin;

  /// No description provided for @authBeforeNonMemberRegister.
  ///
  /// In en, this message translates to:
  /// **'Not a member? Register'**
  String get authBeforeNonMemberRegister;

  /// No description provided for @authRegisterEntryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Choose registration method'**
  String get authRegisterEntryHeadline;

  /// No description provided for @authRegisterEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your account with phone or email and manage all member services in one place.'**
  String get authRegisterEntryDescription;

  /// No description provided for @authEntryPhoneRegister.
  ///
  /// In en, this message translates to:
  /// **'Register with phone'**
  String get authEntryPhoneRegister;

  /// No description provided for @authEntryEmailRegister.
  ///
  /// In en, this message translates to:
  /// **'Register with email'**
  String get authEntryEmailRegister;

  /// No description provided for @authBackToLoginEntry.
  ///
  /// In en, this message translates to:
  /// **'Back to sign-in options'**
  String get authBackToLoginEntry;

  /// No description provided for @authBackToRegisterEntry.
  ///
  /// In en, this message translates to:
  /// **'Back to registration options'**
  String get authBackToRegisterEntry;

  /// No description provided for @authIntlCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone region code'**
  String get authIntlCodeLabel;

  /// No description provided for @authIntlCodePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Select phone region code'**
  String get authIntlCodePickerTitle;

  /// No description provided for @authMethodFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete secure verification with a one-time code.'**
  String get authMethodFormSubtitle;

  /// No description provided for @profileOnboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete profile details'**
  String get profileOnboardingTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile details'**
  String get profileEditTitle;

  /// No description provided for @profileOnboardingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile confirmation before trading & booking'**
  String get profileOnboardingCardTitle;

  /// No description provided for @profileOnboardingCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To meet transaction and booking verification requirements, please complete your profile details. You can skip for now and return later.'**
  String get profileOnboardingCardSubtitle;

  /// No description provided for @profileEditCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get profileEditCardTitle;

  /// No description provided for @profileEditCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your previous local input is retained and can be updated anytime.'**
  String get profileEditCardSubtitle;

  /// No description provided for @profileLastSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Previously saved local details have been loaded.'**
  String get profileLastSavedHint;

  /// No description provided for @profileSkipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get profileSkipButton;

  /// No description provided for @profileStepName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileStepName;

  /// No description provided for @profileStepNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter family name first, then given name (JP-style order).'**
  String get profileStepNameSubtitle;

  /// No description provided for @profileStepContact.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get profileStepContact;

  /// No description provided for @profileStepContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter address, phone, and email (auto-filled when available).'**
  String get profileStepContactSubtitle;

  /// No description provided for @profileStepDocument.
  ///
  /// In en, this message translates to:
  /// **'ID document photo'**
  String get profileStepDocument;

  /// No description provided for @profileStepDocumentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload an ID photo for future trading and booking verification.'**
  String get profileStepDocumentSubtitle;

  /// No description provided for @profileFamilyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get profileFamilyNameLabel;

  /// No description provided for @profileFamilyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter family name'**
  String get profileFamilyNameHint;

  /// No description provided for @profileGivenNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get profileGivenNameLabel;

  /// No description provided for @profileGivenNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter given name'**
  String get profileGivenNameHint;

  /// No description provided for @profileAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profileAddressLabel;

  /// No description provided for @profileAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full address (prefecture/city/street/building)'**
  String get profileAddressHint;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhoneLabel;

  /// No description provided for @profilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get profilePhoneHint;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get profileEmailHint;

  /// No description provided for @profileDocumentPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'ID document photo'**
  String get profileDocumentPhotoLabel;

  /// No description provided for @profileDocumentAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload document photo'**
  String get profileDocumentAddPhoto;

  /// No description provided for @profileDocumentChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change document photo'**
  String get profileDocumentChangePhoto;

  /// No description provided for @profileDocumentRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove document photo'**
  String get profileDocumentRemovePhoto;

  /// No description provided for @profileDocumentTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get profileDocumentTakePhoto;

  /// No description provided for @profileDocumentPickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get profileDocumentPickFromGallery;

  /// No description provided for @profileDocumentHint.
  ///
  /// In en, this message translates to:
  /// **'Please upload a clear, unobstructed document photo for later manual review.'**
  String get profileDocumentHint;

  /// No description provided for @profileDocumentAttachedBadge.
  ///
  /// In en, this message translates to:
  /// **'Attached'**
  String get profileDocumentAttachedBadge;

  /// No description provided for @profilePrevStep.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get profilePrevStep;

  /// No description provided for @profileNextStep.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get profileNextStep;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save details'**
  String get profileSaveButton;

  /// No description provided for @profileSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details saved'**
  String get profileSavedTitle;

  /// No description provided for @profileSavedAndContinueLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Your details have been saved locally. You can continue to sign in.'**
  String get profileSavedAndContinueLoginMessage;

  /// No description provided for @profileSavedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Profile details saved locally.'**
  String get profileSavedSnackbar;

  /// No description provided for @profileIntakeValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomplete profile details'**
  String get profileIntakeValidationTitle;

  /// No description provided for @profileFamilyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your family name.'**
  String get profileFamilyNameRequired;

  /// No description provided for @profileGivenNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your given name.'**
  String get profileGivenNameRequired;

  /// No description provided for @profileAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address.'**
  String get profileAddressRequired;

  /// No description provided for @profilePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get profilePhoneRequired;

  /// No description provided for @profileEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get profileEmailRequired;

  /// No description provided for @profileDocumentPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload an ID document photo.'**
  String get profileDocumentPhotoRequired;

  /// No description provided for @profileDocumentPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select document photo. Please try again.'**
  String get profileDocumentPickFailed;

  /// No description provided for @profileIncompleteBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details incomplete'**
  String get profileIncompleteBannerTitle;

  /// No description provided for @profileIncompleteBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trading and booking require a complete profile.'**
  String get profileIncompleteBannerSubtitle;

  /// No description provided for @profileIncompleteBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Please complete name, address, phone, email, and ID document photo before trading or booking.'**
  String get profileIncompleteBannerBody;

  /// No description provided for @profileGuardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details required'**
  String get profileGuardTitle;

  /// No description provided for @profileGuardMessage.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile details before trading or booking.'**
  String get profileGuardMessage;

  /// No description provided for @profileGuardMessageWithAction.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile details before \"{actionLabel}\".'**
  String profileGuardMessageWithAction(Object actionLabel);

  /// No description provided for @profileGuardCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileGuardCancel;

  /// No description provided for @profileGuardGoFill.
  ///
  /// In en, this message translates to:
  /// **'Complete now'**
  String get profileGuardGoFill;

  /// No description provided for @profileGuardPassMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile validation passed. You can continue with {actionLabel}.'**
  String profileGuardPassMessage(Object actionLabel);

  /// No description provided for @profileStatusCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile detail status'**
  String get profileStatusCardTitle;

  /// No description provided for @profileStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed. Trading and booking are available.'**
  String get profileStatusCompleted;

  /// No description provided for @profileStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete. Please complete your details before trading or booking.'**
  String get profileStatusIncomplete;

  /// No description provided for @profileStatusLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile status. Please try again.'**
  String get profileStatusLoadFailed;

  /// No description provided for @profileEditEntryButton.
  ///
  /// In en, this message translates to:
  /// **'Fill / Edit details'**
  String get profileEditEntryButton;

  /// No description provided for @profileProtectedBookingAction.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get profileProtectedBookingAction;

  /// No description provided for @profileProtectedTradeAction.
  ///
  /// In en, this message translates to:
  /// **'Trading'**
  String get profileProtectedTradeAction;

  /// No description provided for @authMobileLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone sign in'**
  String get authMobileLoginTitle;

  /// No description provided for @authEmailLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Email sign in'**
  String get authEmailLoginTitle;

  /// No description provided for @authMobileRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone registration'**
  String get authMobileRegisterTitle;

  /// No description provided for @authEmailRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Email registration'**
  String get authEmailRegisterTitle;

  /// No description provided for @registerAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get registerAccountLabel;

  /// No description provided for @registerEmailAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get registerEmailAccountLabel;

  /// No description provided for @registerMobileAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get registerMobileAccountLabel;

  /// No description provided for @registerCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get registerCodeLabel;

  /// No description provided for @registerSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get registerSendCode;

  /// No description provided for @registerSendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration code sent.'**
  String get registerSendCodeSuccess;

  /// No description provided for @registerContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get registerContactLabel;

  /// No description provided for @registerContactHelperEmail.
  ///
  /// In en, this message translates to:
  /// **'For email registration, enter your mobile number.'**
  String get registerContactHelperEmail;

  /// No description provided for @registerContactHelperMobile.
  ///
  /// In en, this message translates to:
  /// **'Optional: enter your email for account linking.'**
  String get registerContactHelperMobile;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code (optional)'**
  String get registerInviteCodeLabel;

  /// No description provided for @registerAcceptPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy.'**
  String get registerAcceptPolicy;

  /// No description provided for @registerPolicyButton.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get registerPolicyButton;

  /// No description provided for @registerPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and Privacy'**
  String get registerPolicyTitle;

  /// No description provided for @registerPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'This screen demonstrates reusable policy presentation in a shared bottom sheet. Connect your legal policy content service here.'**
  String get registerPolicyDescription;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerSubmit;

  /// No description provided for @registerBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get registerBackToLogin;

  /// No description provided for @registerPasswordMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordMismatchTitle;

  /// No description provided for @registerPasswordMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Please make sure both passwords are identical.'**
  String get registerPasswordMismatchMessage;

  /// No description provided for @registerUiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration UI ready'**
  String get registerUiReadyTitle;

  /// No description provided for @registerUiReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'UI is complete and ready for API integration.'**
  String get registerUiReadyMessage;

  /// No description provided for @registerEmailMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required for email registration.'**
  String get registerEmailMobileRequired;

  /// No description provided for @registerEmailAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address for email registration.'**
  String get registerEmailAccountInvalid;

  /// No description provided for @registerMobileAccountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number for phone registration.'**
  String get registerMobileAccountInvalid;

  /// No description provided for @registerSubmitFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registerSubmitFailed;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is created. Please sign in.'**
  String get registerSuccessMessage;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore account access with secure verification.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number or email'**
  String get forgotPasswordAccountLabel;

  /// No description provided for @forgotPasswordCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get forgotPasswordCodeLabel;

  /// No description provided for @forgotPasswordSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotPasswordSendCode;

  /// No description provided for @forgotPasswordSendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get forgotPasswordSendCodeSuccess;

  /// No description provided for @forgotPasswordNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get forgotPasswordNewPasswordLabel;

  /// No description provided for @forgotPasswordConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get forgotPasswordConfirmPasswordLabel;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordMismatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get forgotPasswordMismatchTitle;

  /// No description provided for @forgotPasswordMismatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Please verify your new password and confirmation.'**
  String get forgotPasswordMismatchMessage;

  /// No description provided for @forgotPasswordUiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset UI ready'**
  String get forgotPasswordUiReadyTitle;

  /// No description provided for @forgotPasswordUiReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'UI is complete and ready for API integration.'**
  String get forgotPasswordUiReadyMessage;

  /// No description provided for @forgotPasswordRecoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to recover access. Please verify your code.'**
  String get forgotPasswordRecoverFailed;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get commonBackToLogin;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @mainTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get mainTabHome;

  /// No description provided for @mainTabHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get mainTabHotel;

  /// No description provided for @mainTabDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get mainTabDiscussion;

  /// No description provided for @mainTabInvestment.
  ///
  /// In en, this message translates to:
  /// **'Funds'**
  String get mainTabInvestment;

  /// No description provided for @mainTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get mainTabProfile;

  /// No description provided for @mainTabKizunark.
  ///
  /// In en, this message translates to:
  /// **'KIZUNARK'**
  String get mainTabKizunark;

  /// No description provided for @mainTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainTabSettings;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Overview'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick view of portfolio, floating P/L, and available cash.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeHeroAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total assets'**
  String get homeHeroAssetsLabel;

  /// No description provided for @homeHeroPnlLabel.
  ///
  /// In en, this message translates to:
  /// **'Floating P/L'**
  String get homeHeroPnlLabel;

  /// No description provided for @homeHeroCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Available cash'**
  String get homeHeroCashLabel;

  /// No description provided for @homeWelcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name} 👋'**
  String homeWelcomeUser(Object name);

  /// No description provided for @homeHeroTotalAssetsAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total assets'**
  String get homeHeroTotalAssetsAmountLabel;

  /// No description provided for @homeHeroMonthlyDelta.
  ///
  /// In en, this message translates to:
  /// **'+¥127,500 (vs last month +3.4%)'**
  String get homeHeroMonthlyDelta;

  /// No description provided for @homeHeroActiveInvestmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Active investments'**
  String get homeHeroActiveInvestmentLabel;

  /// No description provided for @homeHeroTotalDividendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total dividends'**
  String get homeHeroTotalDividendsLabel;

  /// No description provided for @homeGuestBrowsingTitle.
  ///
  /// In en, this message translates to:
  /// **'Browsing without signing in'**
  String get homeGuestBrowsingTitle;

  /// No description provided for @homeGuestBrowsingBody.
  ///
  /// In en, this message translates to:
  /// **'An account is required to invest.'**
  String get homeGuestBrowsingBody;

  /// No description provided for @homeReminderProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to get started'**
  String get homeReminderProfileTitle;

  /// No description provided for @homeReminderProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Identity verification required. 3 steps remaining.'**
  String get homeReminderProfileBody;

  /// No description provided for @homeReminderProfileBadge.
  ///
  /// In en, this message translates to:
  /// **'Action needed'**
  String get homeReminderProfileBadge;

  /// No description provided for @homeReminderCoolingOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Cooling-off period in progress'**
  String get homeReminderCoolingOffTitle;

  /// No description provided for @homeReminderCoolingOffBody.
  ///
  /// In en, this message translates to:
  /// **'\"Shinsaibashi Commercial Building\" Contract document issued 3/2 → Cancellation deadline 3/10 (8 days)'**
  String get homeReminderCoolingOffBody;

  /// No description provided for @homeReminderCoolingOffBadge.
  ///
  /// In en, this message translates to:
  /// **'5 days left'**
  String get homeReminderCoolingOffBadge;

  /// No description provided for @homeReminderCoolingOffAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel contract'**
  String get homeReminderCoolingOffAction;

  /// No description provided for @homeFeaturedFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'🔥 Featured Funds'**
  String get homeFeaturedFundsTitle;

  /// No description provided for @homeViewAllAction.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAllAction;

  /// No description provided for @homeEstimatedYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. yield'**
  String get homeEstimatedYieldLabel;

  /// No description provided for @homeTagOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get homeTagOpen;

  /// No description provided for @homeTagLottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery'**
  String get homeTagLottery;

  /// No description provided for @homeTagUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeTagUpcoming;

  /// No description provided for @homeActiveFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Active Funds'**
  String get homeActiveFundsTitle;

  /// No description provided for @homeInvestedAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment amount'**
  String get homeInvestedAmountLabel;

  /// No description provided for @homeNextDividendLabel.
  ///
  /// In en, this message translates to:
  /// **'Next Distribution'**
  String get homeNextDividendLabel;

  /// No description provided for @homeShowMoreAction.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get homeShowMoreAction;

  /// No description provided for @homeShowLessAction.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get homeShowLessAction;

  /// No description provided for @homeMockFeaturedFundA.
  ///
  /// In en, this message translates to:
  /// **'Akasaka Premium Residence, Minato, Tokyo'**
  String get homeMockFeaturedFundA;

  /// No description provided for @homeMockFeaturedFundB.
  ///
  /// In en, this message translates to:
  /// **'Shinsaibashi Commercial Building, Chuo, Osaka'**
  String get homeMockFeaturedFundB;

  /// No description provided for @homeMockFeaturedFundC.
  ///
  /// In en, this message translates to:
  /// **'Machiya Renovation Hotel, Higashiyama, Kyoto'**
  String get homeMockFeaturedFundC;

  /// No description provided for @homeMockFeaturedMetaA.
  ///
  /// In en, this message translates to:
  /// **'12 months ・ ¥200M'**
  String get homeMockFeaturedMetaA;

  /// No description provided for @homeMockFeaturedMetaB.
  ///
  /// In en, this message translates to:
  /// **'18 months ・ ¥150M'**
  String get homeMockFeaturedMetaB;

  /// No description provided for @homeMockFeaturedMetaC.
  ///
  /// In en, this message translates to:
  /// **'24 months ・ ¥300M'**
  String get homeMockFeaturedMetaC;

  /// No description provided for @homeMockActiveFundA.
  ///
  /// In en, this message translates to:
  /// **'Shibuya Office Building #12'**
  String get homeMockActiveFundA;

  /// No description provided for @homeMockActiveFundB.
  ///
  /// In en, this message translates to:
  /// **'Nagoya Logistics Facility #09'**
  String get homeMockActiveFundB;

  /// No description provided for @homeMockActiveFundC.
  ///
  /// In en, this message translates to:
  /// **'Fukuoka Residence Fund #07'**
  String get homeMockActiveFundC;

  /// No description provided for @homeMockActiveFundD.
  ///
  /// In en, this message translates to:
  /// **'Sapporo Mixed-Use Fund #03'**
  String get homeMockActiveFundD;

  /// No description provided for @fundListTitle.
  ///
  /// In en, this message translates to:
  /// **'Fund List'**
  String get fundListTitle;

  /// No description provided for @fundListFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get fundListFilterAll;

  /// No description provided for @fundListFilterOperating.
  ///
  /// In en, this message translates to:
  /// **'Operating'**
  String get fundListFilterOperating;

  /// No description provided for @fundListFilterOperatingEnded.
  ///
  /// In en, this message translates to:
  /// **'Operation Ended'**
  String get fundListFilterOperatingEnded;

  /// No description provided for @fundListFilterOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get fundListFilterOpen;

  /// No description provided for @fundListFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get fundListFilterUpcoming;

  /// No description provided for @fundListFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get fundListFilterClosed;

  /// No description provided for @fundListFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get fundListFilterCompleted;

  /// No description provided for @fundListFilterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get fundListFilterFailed;

  /// No description provided for @fundListYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get fundListYieldLabel;

  /// No description provided for @fundListPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get fundListPeriodLabel;

  /// No description provided for @fundListMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get fundListMethodLabel;

  /// No description provided for @fundListMethodLottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery'**
  String get fundListMethodLottery;

  /// No description provided for @fundListMethodUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get fundListMethodUnknown;

  /// No description provided for @fundListAppliedAmount.
  ///
  /// In en, this message translates to:
  /// **'Applied {amount} ({progress})'**
  String fundListAppliedAmount(Object amount, Object progress);

  /// No description provided for @fundListOpenStartAt.
  ///
  /// In en, this message translates to:
  /// **'Subscription starts {start}'**
  String fundListOpenStartAt(Object start);

  /// No description provided for @fundListViewDetail.
  ///
  /// In en, this message translates to:
  /// **'Details→'**
  String get fundListViewDetail;

  /// No description provided for @fundListLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load funds. Please try again.'**
  String get fundListLoadError;

  /// No description provided for @fundListRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get fundListRetry;

  /// No description provided for @fundListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No funds found for this filter.'**
  String get fundListEmpty;

  /// No description provided for @fundListStatusOperating.
  ///
  /// In en, this message translates to:
  /// **'Operating'**
  String get fundListStatusOperating;

  /// No description provided for @fundListStatusOperatingEnded.
  ///
  /// In en, this message translates to:
  /// **'Operation Ended'**
  String get fundListStatusOperatingEnded;

  /// No description provided for @fundListStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get fundListStatusOpen;

  /// No description provided for @fundListStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get fundListStatusUpcoming;

  /// No description provided for @fundListStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get fundListStatusClosed;

  /// No description provided for @fundListStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get fundListStatusCompleted;

  /// No description provided for @fundListStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get fundListStatusFailed;

  /// No description provided for @fundListStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get fundListStatusUnknown;

  /// No description provided for @fundListVolume.
  ///
  /// In en, this message translates to:
  /// **'Vol. {number}'**
  String fundListVolume(Object number);

  /// No description provided for @hotelTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Hotel Booking Module (Framework)'**
  String get hotelTabHeadline;

  /// No description provided for @hotelTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search, list, detail, and booking flows will be integrated here next.'**
  String get hotelTabSubtitle;

  /// No description provided for @discussionTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Investment Discussion Board (Framework)'**
  String get discussionTabHeadline;

  /// No description provided for @discussionTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive message-board area for replies, likes, pinning, and moderation.'**
  String get discussionTabSubtitle;

  /// No description provided for @discussionTabReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get discussionTabReplyAction;

  /// No description provided for @kizunarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Investor community'**
  String get kizunarkSubtitle;

  /// No description provided for @kizunarkInvestorOnlyNotice.
  ///
  /// In en, this message translates to:
  /// **'🔒 Only verified investors can post & comment'**
  String get kizunarkInvestorOnlyNotice;

  /// No description provided for @kizunarkComposePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your investment thoughts...'**
  String get kizunarkComposePlaceholder;

  /// No description provided for @kizunarkPostAction.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get kizunarkPostAction;

  /// No description provided for @kizunarkReplyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get kizunarkReplyPlaceholder;

  /// No description provided for @kizunarkReplySendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get kizunarkReplySendAction;

  /// No description provided for @kizunarkJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get kizunarkJustNow;

  /// No description provided for @kizunarkFallbackDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Investor**'**
  String get kizunarkFallbackDisplayName;

  /// No description provided for @kizunarkFallbackHandle.
  ///
  /// In en, this message translates to:
  /// **'usr***@'**
  String get kizunarkFallbackHandle;

  /// No description provided for @kizunarkInvestorBadge.
  ///
  /// In en, this message translates to:
  /// **'Investor'**
  String get kizunarkInvestorBadge;

  /// No description provided for @kizunarkPostSuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Post submitted.'**
  String get kizunarkPostSuccessNotice;

  /// No description provided for @kizunarkReplySuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Comment sent.'**
  String get kizunarkReplySuccessNotice;

  /// No description provided for @kizunarkDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get kizunarkDeleteAction;

  /// No description provided for @kizunarkDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get kizunarkDeleteConfirmTitle;

  /// No description provided for @kizunarkDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get kizunarkDeleteConfirmBody;

  /// No description provided for @kizunarkDeleteCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get kizunarkDeleteCancelAction;

  /// No description provided for @kizunarkDeleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get kizunarkDeleteConfirmAction;

  /// No description provided for @kizunarkDeleteSuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted.'**
  String get kizunarkDeleteSuccessNotice;

  /// No description provided for @kizunarkDeleteFailedNotice.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete comment.'**
  String get kizunarkDeleteFailedNotice;

  /// No description provided for @kizunarkCopyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get kizunarkCopyAction;

  /// No description provided for @kizunarkCopySuccessNotice.
  ///
  /// In en, this message translates to:
  /// **'Message copied.'**
  String get kizunarkCopySuccessNotice;

  /// No description provided for @kizunarkMenuCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get kizunarkMenuCancelAction;

  /// No description provided for @kizunarkLoginRequiredToPost.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to post and comment.'**
  String get kizunarkLoginRequiredToPost;

  /// No description provided for @kizunarkEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Start the first discussion.'**
  String get kizunarkEmptyState;

  /// No description provided for @investmentTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Investment Module (Framework)'**
  String get investmentTabHeadline;

  /// No description provided for @investmentTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products, portfolio, subscriptions/redemptions, and statements will be added here.'**
  String get investmentTabSubtitle;

  /// No description provided for @investmentTabPortfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get investmentTabPortfolioLabel;

  /// No description provided for @investmentTabWatchlistLabel.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get investmentTabWatchlistLabel;

  /// No description provided for @profileTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Profile Center (Framework)'**
  String get profileTabHeadline;

  /// No description provided for @profileTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage account details, profile intake, preferences, and member status.'**
  String get profileTabSubtitle;

  /// No description provided for @settingsTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabHeadline;

  /// No description provided for @settingsTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account, security, legal documents, and preference settings will be integrated here.'**
  String get settingsTabSubtitle;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get menuSectionAccount;

  /// No description provided for @menuSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get menuSectionSecurity;

  /// No description provided for @menuSectionDocsTax.
  ///
  /// In en, this message translates to:
  /// **'Documents & Tax'**
  String get menuSectionDocsTax;

  /// No description provided for @menuSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get menuSectionPreferences;

  /// No description provided for @menuSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get menuSectionSupport;

  /// No description provided for @menuItemTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuItemTheme;

  /// No description provided for @menuItemEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit member profile'**
  String get menuItemEditProfile;

  /// No description provided for @menuItemBankSettings.
  ///
  /// In en, this message translates to:
  /// **'Bank account settings'**
  String get menuItemBankSettings;

  /// No description provided for @menuItemChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get menuItemChangePassword;

  /// No description provided for @menuItemTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get menuItemTwoFactor;

  /// No description provided for @menuItemAnnualReport.
  ///
  /// In en, this message translates to:
  /// **'Annual transaction report'**
  String get menuItemAnnualReport;

  /// No description provided for @menuItemContractList.
  ///
  /// In en, this message translates to:
  /// **'Contract document list'**
  String get menuItemContractList;

  /// No description provided for @menuItemMyNumber.
  ///
  /// In en, this message translates to:
  /// **'My Number management'**
  String get menuItemMyNumber;

  /// No description provided for @menuItemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuItemLanguage;

  /// No description provided for @menuThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get menuThemeSystem;

  /// No description provided for @menuThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get menuThemeLight;

  /// No description provided for @menuThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get menuThemeDark;

  /// No description provided for @menuItemFaqHelp.
  ///
  /// In en, this message translates to:
  /// **'FAQ / Help'**
  String get menuItemFaqHelp;

  /// No description provided for @menuItemChatSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat support'**
  String get menuItemChatSupport;

  /// No description provided for @menuVersionFootnote.
  ///
  /// In en, this message translates to:
  /// **'StellaVia v1.0.0 · Real Estate Specified Joint Enterprise License No. XXX'**
  String get menuVersionFootnote;

  /// No description provided for @menuDeleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get menuDeleteAccountAction;

  /// No description provided for @menuDeleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get menuDeleteAccountConfirmTitle;

  /// No description provided for @menuDeleteAccountConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. The actual account deletion flow will be connected later.'**
  String get menuDeleteAccountConfirmBody;

  /// No description provided for @menuDeleteAccountComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Account deletion flow will be connected in a later implementation.'**
  String get menuDeleteAccountComingSoon;

  /// No description provided for @menuFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} will be connected in a later implementation.'**
  String menuFeatureComingSoon(Object feature);

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsLotteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Lottery result'**
  String get notificationsLotteryTitle;

  /// No description provided for @notificationsLotterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'After API integration, lottery and deposit notifications will appear here.'**
  String get notificationsLotterySubtitle;

  /// No description provided for @notificationsSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System notices'**
  String get notificationsSystemTitle;

  /// No description provided for @notificationsSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance, statements, and legal updates.'**
  String get notificationsSystemSubtitle;

  /// No description provided for @notificationsTabImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get notificationsTabImportant;

  /// No description provided for @notificationsTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get notificationsTabGeneral;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsNewsPushLabel.
  ///
  /// In en, this message translates to:
  /// **'Receive news notifications'**
  String get notificationsNewsPushLabel;

  /// No description provided for @notificationsMarkAllReadDone.
  ///
  /// In en, this message translates to:
  /// **'Marked {count} items as read.'**
  String notificationsMarkAllReadDone(int count);

  /// No description provided for @notificationsAllReadAlreadyDone.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications.'**
  String get notificationsAllReadAlreadyDone;

  /// No description provided for @notificationsEmptyImportant.
  ///
  /// In en, this message translates to:
  /// **'No important notifications.'**
  String get notificationsEmptyImportant;

  /// No description provided for @notificationsEmptyGeneral.
  ///
  /// In en, this message translates to:
  /// **'No notifications.'**
  String get notificationsEmptyGeneral;

  /// No description provided for @notificationsEmptyGuest.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications.'**
  String get notificationsEmptyGuest;

  /// No description provided for @notificationsLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required.'**
  String get notificationsLoginRequired;

  /// No description provided for @notificationsDetailNoContent.
  ///
  /// In en, this message translates to:
  /// **'No details available.'**
  String get notificationsDetailNoContent;

  /// No description provided for @notificationsDetailClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get notificationsDetailClose;

  /// No description provided for @homeLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get homeLogout;

  /// No description provided for @uiErrorRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed. Please try again later.'**
  String get uiErrorRequestFailed;

  /// No description provided for @uiErrorNetworkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please try again later.'**
  String get uiErrorNetworkUnavailable;

  /// No description provided for @uiErrorAuthExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get uiErrorAuthExpired;

  /// No description provided for @uiErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this resource.'**
  String get uiErrorForbidden;

  /// No description provided for @uiErrorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service is temporarily unavailable. Please try again later.'**
  String get uiErrorServerUnavailable;

  /// No description provided for @languageFollowSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get languageFollowSystem;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChinese;

  /// No description provided for @languageTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get languageTraditionalChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// No description provided for @fundDetailEstimatedYieldAnnualLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated yield (annualized)'**
  String get fundDetailEstimatedYieldAnnualLabel;

  /// No description provided for @fundDetailYieldDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'※ Estimated, not guaranteed'**
  String get fundDetailYieldDisclaimer;

  /// No description provided for @fundDetailKeyFactsTitle.
  ///
  /// In en, this message translates to:
  /// **'📌 Key facts'**
  String get fundDetailKeyFactsTitle;

  /// No description provided for @fundDetailFundTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Fund size'**
  String get fundDetailFundTotalLabel;

  /// No description provided for @fundDetailMinimumInvestmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum investment'**
  String get fundDetailMinimumInvestmentLabel;

  /// No description provided for @fundDetailDividendLabel.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get fundDetailDividendLabel;

  /// No description provided for @fundDetailLotteryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Lottery date'**
  String get fundDetailLotteryDateLabel;

  /// No description provided for @fundDetailPreferredStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'🛡️ Senior/Junior Structure'**
  String get fundDetailPreferredStructureTitle;

  /// No description provided for @fundDetailSeniorInvestmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred'**
  String get fundDetailSeniorInvestmentLabel;

  /// No description provided for @fundDetailJuniorInvestmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Subordinated'**
  String get fundDetailJuniorInvestmentLabel;

  /// No description provided for @fundDetailPropertyInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'📍 Property details'**
  String get fundDetailPropertyInfoTitle;

  /// No description provided for @fundDetailLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get fundDetailLocationLabel;

  /// No description provided for @fundDetailPropertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Property type'**
  String get fundDetailPropertyTypeLabel;

  /// No description provided for @fundDetailStructureLabel.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get fundDetailStructureLabel;

  /// No description provided for @fundDetailBuiltYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Built'**
  String get fundDetailBuiltYearLabel;

  /// No description provided for @fundDetailCoolingOffLabel.
  ///
  /// In en, this message translates to:
  /// **'Cooling-off'**
  String get fundDetailCoolingOffLabel;

  /// No description provided for @fundDetailCoolingOffDefault.
  ///
  /// In en, this message translates to:
  /// **'8 days from the day after document delivery'**
  String get fundDetailCoolingOffDefault;

  /// No description provided for @fundDetailMapClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get fundDetailMapClose;

  /// No description provided for @fundDetailMapDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get fundDetailMapDestination;

  /// No description provided for @fundDetailMapCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get fundDetailMapCurrentLocation;

  /// No description provided for @fundDetailMapDirections.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get fundDetailMapDirections;

  /// No description provided for @fundDetailMapOpenMapApp.
  ///
  /// In en, this message translates to:
  /// **'Open maps app'**
  String get fundDetailMapOpenMapApp;

  /// No description provided for @fundDetailMapCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get fundDetailMapCancel;

  /// No description provided for @fundDetailMapPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is not granted.'**
  String get fundDetailMapPermissionDenied;

  /// No description provided for @fundDetailMapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to load map data.'**
  String get fundDetailMapUnavailable;

  /// No description provided for @fundDetailContractOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'📋 Contract Summary'**
  String get fundDetailContractOverviewTitle;

  /// No description provided for @fundDetailContractTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Contract type'**
  String get fundDetailContractTypeLabel;

  /// No description provided for @fundDetailContractTypeValue.
  ///
  /// In en, this message translates to:
  /// **'Silent partnership'**
  String get fundDetailContractTypeValue;

  /// No description provided for @fundDetailTargetPropertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Target real estate type'**
  String get fundDetailTargetPropertyTypeLabel;

  /// No description provided for @fundDetailAppraisalValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Appraisal value'**
  String get fundDetailAppraisalValueLabel;

  /// No description provided for @fundDetailAcquisitionPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned acquisition price'**
  String get fundDetailAcquisitionPriceLabel;

  /// No description provided for @fundDetailOfferPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Offering period'**
  String get fundDetailOfferPeriodLabel;

  /// No description provided for @fundDetailOperationStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned start date'**
  String get fundDetailOperationStartLabel;

  /// No description provided for @fundDetailOperationEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned end date'**
  String get fundDetailOperationEndLabel;

  /// No description provided for @fundDetailOperatorInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'🏢 Operator information'**
  String get fundDetailOperatorInfoTitle;

  /// No description provided for @fundDetailOperatorCompanyLabel.
  ///
  /// In en, this message translates to:
  /// **'Operator'**
  String get fundDetailOperatorCompanyLabel;

  /// No description provided for @fundDetailPermitNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get fundDetailPermitNumberLabel;

  /// No description provided for @fundDetailRepresentativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get fundDetailRepresentativeLabel;

  /// No description provided for @fundDetailCompanyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fundDetailCompanyAddressLabel;

  /// No description provided for @fundDetailOperatorCapitalLabel.
  ///
  /// In en, this message translates to:
  /// **'Capital'**
  String get fundDetailOperatorCapitalLabel;

  /// No description provided for @fundDetailOperatorEstablishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get fundDetailOperatorEstablishedLabel;

  /// No description provided for @fundDetailOperatorBusinessStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Business start filing'**
  String get fundDetailOperatorBusinessStartLabel;

  /// No description provided for @fundDetailDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'📄 Related documents'**
  String get fundDetailDocumentsTitle;

  /// No description provided for @fundDetailDocumentReady.
  ///
  /// In en, this message translates to:
  /// **'Tap to review'**
  String get fundDetailDocumentReady;

  /// No description provided for @fundDetailDocumentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Document URL not available'**
  String get fundDetailDocumentUnavailable;

  /// No description provided for @fundDetailPropertyPreviewBadge.
  ///
  /// In en, this message translates to:
  /// **'Property preview'**
  String get fundDetailPropertyPreviewBadge;

  /// No description provided for @fundDetailCommentsTitle.
  ///
  /// In en, this message translates to:
  /// **'💬 Investor voices (KIZUNARK)'**
  String get fundDetailCommentsTitle;

  /// No description provided for @fundDetailCommentsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Comments are intentionally left empty for now. UI integration will be added later.'**
  String get fundDetailCommentsPlaceholder;

  /// No description provided for @fundDetailCommentsPreviewAvatar.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get fundDetailCommentsPreviewAvatar;

  /// No description provided for @fundDetailCommentsPreviewUser.
  ///
  /// In en, this message translates to:
  /// **'Sato**'**
  String get fundDetailCommentsPreviewUser;

  /// No description provided for @fundDetailCommentsPreviewTime.
  ///
  /// In en, this message translates to:
  /// **'2h ago'**
  String get fundDetailCommentsPreviewTime;

  /// No description provided for @fundDetailCommentsPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'The Hakuba project looks solid with steady resort demand. The planned return range of 1.5%–14.6% is wide, but upside could be meaningful depending on the sale.'**
  String get fundDetailCommentsPreviewBody;

  /// No description provided for @fundDetailCommentsPreviewReplyCount.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get fundDetailCommentsPreviewReplyCount;

  /// No description provided for @fundDetailCommentsMoreAction.
  ///
  /// In en, this message translates to:
  /// **'💜 View more in KIZUNARK'**
  String get fundDetailCommentsMoreAction;

  /// No description provided for @fundDetailFinancialStatusAction.
  ///
  /// In en, this message translates to:
  /// **'📊 View operator financial status →'**
  String get fundDetailFinancialStatusAction;

  /// No description provided for @fundDetailFinancialStatusToast.
  ///
  /// In en, this message translates to:
  /// **'The financial status page will be connected in a later implementation.'**
  String get fundDetailFinancialStatusToast;

  /// No description provided for @fundDetailApplyNowAction.
  ///
  /// In en, this message translates to:
  /// **'Apply for lottery'**
  String get fundDetailApplyNowAction;

  /// No description provided for @fundDetailOpenSoonAction.
  ///
  /// In en, this message translates to:
  /// **'Waiting for opening'**
  String get fundDetailOpenSoonAction;

  /// No description provided for @fundDetailUnavailableAction.
  ///
  /// In en, this message translates to:
  /// **'Unavailable now'**
  String get fundDetailUnavailableAction;

  /// No description provided for @fundDetailApplyComingSoonToast.
  ///
  /// In en, this message translates to:
  /// **'The application flow will be connected in the next implementation.'**
  String get fundDetailApplyComingSoonToast;

  /// No description provided for @lotteryApplyFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Lottery Application'**
  String get lotteryApplyFlowTitle;

  /// No description provided for @lotteryApplyStep1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Enter investment amount'**
  String get lotteryApplyStep1Title;

  /// No description provided for @lotteryApplyStep1BalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'💰 Standby cash balance'**
  String get lotteryApplyStep1BalanceLabel;

  /// No description provided for @lotteryApplyStep1DepositAction.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get lotteryApplyStep1DepositAction;

  /// No description provided for @lotteryApplyStep1AmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment amount (1 unit = ¥100,000)'**
  String get lotteryApplyStep1AmountLabel;

  /// No description provided for @lotteryApplyStep1AmountLabelWithRules.
  ///
  /// In en, this message translates to:
  /// **'Investment amount (1 unit = {unitAmount} / max {maxAmount})'**
  String lotteryApplyStep1AmountLabelWithRules(
    Object unitAmount,
    Object maxAmount,
  );

  /// No description provided for @lotteryApplyStep1BalanceWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Insufficient standby cash'**
  String get lotteryApplyStep1BalanceWarningTitle;

  /// No description provided for @lotteryApplyStep1BalanceWarningBody.
  ///
  /// In en, this message translates to:
  /// **'Your balance is lower than the selected amount. Please deposit first, then continue the application.'**
  String get lotteryApplyStep1BalanceWarningBody;

  /// No description provided for @lotteryApplyStep1BalanceWarningAction.
  ///
  /// In en, this message translates to:
  /// **'💰 Go to deposit'**
  String get lotteryApplyStep1BalanceWarningAction;

  /// No description provided for @lotteryApplyStep1MaximumWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Exceeded maximum limit'**
  String get lotteryApplyStep1MaximumWarningTitle;

  /// No description provided for @lotteryApplyStep1MaximumWarningBody.
  ///
  /// In en, this message translates to:
  /// **'The selected amount exceeds the per-user limit for this project. Please reduce the number of units.'**
  String get lotteryApplyStep1MaximumWarningBody;

  /// No description provided for @lotteryApplyStep1EstimatedDistributionLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated distribution (before tax)'**
  String get lotteryApplyStep1EstimatedDistributionLabel;

  /// No description provided for @lotteryApplyStep1EstimatedDistributionSuffix.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get lotteryApplyStep1EstimatedDistributionSuffix;

  /// No description provided for @lotteryApplyStep1NextAction.
  ///
  /// In en, this message translates to:
  /// **'Next: Documents'**
  String get lotteryApplyStep1NextAction;

  /// No description provided for @lotteryApplyStep2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Review contract documents'**
  String get lotteryApplyStep2Title;

  /// No description provided for @lotteryApplyStep2Description.
  ///
  /// In en, this message translates to:
  /// **'These documents are required for your investment decision. Please review and check all items.'**
  String get lotteryApplyStep2Description;

  /// No description provided for @lotteryApplyDocumentPreContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-contract disclosure document'**
  String get lotteryApplyDocumentPreContractTitle;

  /// No description provided for @lotteryApplyDocumentPreContractSubtitle.
  ///
  /// In en, this message translates to:
  /// **'PDF 12 pages | Includes key terms and risk notes'**
  String get lotteryApplyDocumentPreContractSubtitle;

  /// No description provided for @lotteryApplyDocumentAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Silent partnership terms'**
  String get lotteryApplyDocumentAgreementTitle;

  /// No description provided for @lotteryApplyDocumentAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'PDF 8 pages | Contract terms and distribution details'**
  String get lotteryApplyDocumentAgreementSubtitle;

  /// No description provided for @lotteryApplyStep2InfoBody.
  ///
  /// In en, this message translates to:
  /// **'Consent for electronic document delivery was collected during account registration. You can revoke or update it anytime in settings.'**
  String get lotteryApplyStep2InfoBody;

  /// No description provided for @lotteryApplyStep2NextAction.
  ///
  /// In en, this message translates to:
  /// **'Continue after confirming all documents'**
  String get lotteryApplyStep2NextAction;

  /// No description provided for @lotteryApplyStep3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Confirm application details'**
  String get lotteryApplyStep3Title;

  /// No description provided for @lotteryApplyFundNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Fund'**
  String get lotteryApplyFundNameLabel;

  /// No description provided for @lotteryApplyInvestmentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment amount'**
  String get lotteryApplyInvestmentAmountLabel;

  /// No description provided for @lotteryApplyAnnualYieldPrefix.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get lotteryApplyAnnualYieldPrefix;

  /// No description provided for @lotteryApplyNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get lotteryApplyNoticeTitle;

  /// No description provided for @lotteryApplyNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This investment does not guarantee principal. If selected in the lottery, payment is required within the specified deadline.'**
  String get lotteryApplyNoticeBody;

  /// No description provided for @lotteryApplyAgreementLabel.
  ///
  /// In en, this message translates to:
  /// **'I have reviewed the above details and agree to proceed with the lottery application.'**
  String get lotteryApplyAgreementLabel;

  /// No description provided for @lotteryApplySubmitAction.
  ///
  /// In en, this message translates to:
  /// **'🎲 Submit lottery application'**
  String get lotteryApplySubmitAction;

  /// No description provided for @lotteryApplySubmitFailedFallback.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit lottery application. Please try again later.'**
  String get lotteryApplySubmitFailedFallback;

  /// No description provided for @lotteryApplyStep4Headline.
  ///
  /// In en, this message translates to:
  /// **'Lottery application submitted!'**
  String get lotteryApplyStep4Headline;

  /// No description provided for @lotteryApplyStep4Body.
  ///
  /// In en, this message translates to:
  /// **'Your lottery application for \"{projectName}\" has been completed. The result will be announced on the date below, and you\'ll receive a notification in the app.'**
  String lotteryApplyStep4Body(Object projectName);

  /// No description provided for @lotteryApplyResultAnnouncementDateLabel.
  ///
  /// In en, this message translates to:
  /// **'🗓️ Result announcement date'**
  String get lotteryApplyResultAnnouncementDateLabel;

  /// No description provided for @lotteryApplyApplicationNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Application number'**
  String get lotteryApplyApplicationNumberLabel;

  /// No description provided for @lotteryApplyStep4HintBody.
  ///
  /// In en, this message translates to:
  /// **'If selected, please complete payment within 8 days (including cooling-off period). If not selected, no action is needed. If minimum demand is not met, a review and lottery process still applies.'**
  String get lotteryApplyStep4HintBody;

  /// No description provided for @lotteryApplyBackHomeAction.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get lotteryApplyBackHomeAction;

  /// No description provided for @lotteryApplyDemoCheckResultAction.
  ///
  /// In en, this message translates to:
  /// **'(Demo) View lottery result →'**
  String get lotteryApplyDemoCheckResultAction;

  /// No description provided for @lotteryApplyStep5Headline.
  ///
  /// In en, this message translates to:
  /// **'Selection notice'**
  String get lotteryApplyStep5Headline;

  /// No description provided for @lotteryApplyStep5Body.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You were selected in the \"{projectName}\" lottery. Please transfer funds to the designated account by the deadline below.'**
  String lotteryApplyStep5Body(Object projectName);

  /// No description provided for @lotteryApplyDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'⏰ Payment deadline (includes 8-day cooling-off)'**
  String get lotteryApplyDeadlineLabel;

  /// No description provided for @lotteryApplyCoolingOffTitle.
  ///
  /// In en, this message translates to:
  /// **'About cooling-off'**
  String get lotteryApplyCoolingOffTitle;

  /// No description provided for @lotteryApplyCoolingOffBody.
  ///
  /// In en, this message translates to:
  /// **'You can cancel unconditionally within 8 days from the day after contract document delivery. Cancellation is also available during cooling-off even after payment.'**
  String get lotteryApplyCoolingOffBody;

  /// No description provided for @lotteryApplyDepositAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get lotteryApplyDepositAmountLabel;

  /// No description provided for @lotteryApplyBankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get lotteryApplyBankNameLabel;

  /// No description provided for @lotteryApplyBankBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get lotteryApplyBankBranchLabel;

  /// No description provided for @lotteryApplyBankAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get lotteryApplyBankAccountLabel;

  /// No description provided for @lotteryApplyBankHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder'**
  String get lotteryApplyBankHolderLabel;

  /// No description provided for @lotteryApplyMockBankName.
  ///
  /// In en, this message translates to:
  /// **'GMO Aozora Net Bank'**
  String get lotteryApplyMockBankName;

  /// No description provided for @lotteryApplyMockBankBranch.
  ///
  /// In en, this message translates to:
  /// **'Corporate First Branch (101)'**
  String get lotteryApplyMockBankBranch;

  /// No description provided for @lotteryApplyMockBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Ordinary 1234567'**
  String get lotteryApplyMockBankAccount;

  /// No description provided for @lotteryApplyMockBankHolder.
  ///
  /// In en, this message translates to:
  /// **'FUNDEX Co., Ltd.'**
  String get lotteryApplyMockBankHolder;

  /// No description provided for @lotteryApplyReportDepositAction.
  ///
  /// In en, this message translates to:
  /// **'Report payment completed'**
  String get lotteryApplyReportDepositAction;

  /// No description provided for @lotteryApplyLaterDepositAction.
  ///
  /// In en, this message translates to:
  /// **'Pay later'**
  String get lotteryApplyLaterDepositAction;

  /// No description provided for @lotteryApplyCopyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get lotteryApplyCopyAction;

  /// No description provided for @lotteryApplyCopyDoneToast.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get lotteryApplyCopyDoneToast;

  /// No description provided for @lotteryApplyStep6Headline.
  ///
  /// In en, this message translates to:
  /// **'Investment process completed'**
  String get lotteryApplyStep6Headline;

  /// No description provided for @lotteryApplyStep6Body.
  ///
  /// In en, this message translates to:
  /// **'We have confirmed your payment. Please wait for operation start. Distribution schedules will be sent via notifications.'**
  String get lotteryApplyStep6Body;

  /// No description provided for @lotteryApplyReceiptLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt No:'**
  String get lotteryApplyReceiptLabel;

  /// No description provided for @fundDetailUnknownValue.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get fundDetailUnknownValue;

  /// No description provided for @fundDetailOneUnitSuffix.
  ///
  /// In en, this message translates to:
  /// **'(1 unit)'**
  String get fundDetailOneUnitSuffix;

  /// No description provided for @fundDetailMonthlyDistribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get fundDetailMonthlyDistribution;

  /// No description provided for @fundDetailQuarterlyDistribution.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get fundDetailQuarterlyDistribution;

  /// No description provided for @fundDetailSemiAnnualDistribution.
  ///
  /// In en, this message translates to:
  /// **'Semi-annually'**
  String get fundDetailSemiAnnualDistribution;

  /// No description provided for @fundDetailAnnualDistribution.
  ///
  /// In en, this message translates to:
  /// **'Annually'**
  String get fundDetailAnnualDistribution;

  /// No description provided for @fundDetailPlannedDistributionRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned distribution rate (before tax)'**
  String get fundDetailPlannedDistributionRateLabel;

  /// No description provided for @fundDetailAchievementRateLabel.
  ///
  /// In en, this message translates to:
  /// **'📊 Funding achievement rate'**
  String get fundDetailAchievementRateLabel;

  /// No description provided for @fundDetailTabPropertyOverview.
  ///
  /// In en, this message translates to:
  /// **'📍 Property overview'**
  String get fundDetailTabPropertyOverview;

  /// No description provided for @fundDetailTabIncomeScheme.
  ///
  /// In en, this message translates to:
  /// **'📊 Income scheme'**
  String get fundDetailTabIncomeScheme;

  /// No description provided for @fundDetailPropertyCountHint.
  ///
  /// In en, this message translates to:
  /// **'This fund consists of {count} properties.'**
  String fundDetailPropertyCountHint(int count);

  /// No description provided for @fundDetailPropertyItemPrefix.
  ///
  /// In en, this message translates to:
  /// **'Property {index}'**
  String fundDetailPropertyItemPrefix(int index);

  /// No description provided for @fundDetailPropertyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Property name'**
  String get fundDetailPropertyNameLabel;

  /// No description provided for @fundDetailTransportationLabel.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get fundDetailTransportationLabel;

  /// No description provided for @fundDetailLandSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Land'**
  String get fundDetailLandSectionTitle;

  /// No description provided for @fundDetailLandCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Land category'**
  String get fundDetailLandCategoryLabel;

  /// No description provided for @fundDetailAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get fundDetailAreaLabel;

  /// No description provided for @fundDetailRightsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rights'**
  String get fundDetailRightsLabel;

  /// No description provided for @fundDetailBuildingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get fundDetailBuildingSectionTitle;

  /// No description provided for @fundDetailFloorAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor area'**
  String get fundDetailFloorAreaLabel;

  /// No description provided for @fundDetailBuiltYearMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Built year/month'**
  String get fundDetailBuiltYearMonthLabel;

  /// No description provided for @fundDetailRegulationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Regulation'**
  String get fundDetailRegulationSectionTitle;

  /// No description provided for @fundDetailLandUseZoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Land-use zone'**
  String get fundDetailLandUseZoneLabel;

  /// No description provided for @fundDetailBuildingCoverageRatioLabel.
  ///
  /// In en, this message translates to:
  /// **'Building coverage ratio'**
  String get fundDetailBuildingCoverageRatioLabel;

  /// No description provided for @fundDetailFloorAreaRatioLabel.
  ///
  /// In en, this message translates to:
  /// **'Floor area ratio'**
  String get fundDetailFloorAreaRatioLabel;

  /// No description provided for @fundDetailOperationContractSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation contract summary'**
  String get fundDetailOperationContractSectionTitle;

  /// No description provided for @fundDetailOperationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Operation type'**
  String get fundDetailOperationTypeLabel;

  /// No description provided for @fundDetailLandlordLabel.
  ///
  /// In en, this message translates to:
  /// **'Landlord / principal'**
  String get fundDetailLandlordLabel;

  /// No description provided for @fundDetailTenantLabel.
  ///
  /// In en, this message translates to:
  /// **'Tenant / contractor'**
  String get fundDetailTenantLabel;

  /// No description provided for @fundDetailContractPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Contract period'**
  String get fundDetailContractPeriodLabel;

  /// No description provided for @fundDetailMonthlyRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Annual operating income'**
  String get fundDetailMonthlyRentLabel;

  /// No description provided for @fundDetailContractAmendmentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Contract renewal method'**
  String get fundDetailContractAmendmentMethodLabel;

  /// No description provided for @fundDetailOtherImportantMattersLabel.
  ///
  /// In en, this message translates to:
  /// **'Other important matters'**
  String get fundDetailOtherImportantMattersLabel;

  /// No description provided for @fundDetailOperationTypeLeaseValue.
  ///
  /// In en, this message translates to:
  /// **'Lease contract'**
  String get fundDetailOperationTypeLeaseValue;

  /// No description provided for @fundDetailOperationTypeHotelValue.
  ///
  /// In en, this message translates to:
  /// **'Hotel / vacation rental operation'**
  String get fundDetailOperationTypeHotelValue;

  /// No description provided for @fundDetailSchemeMarketEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'※ Figures are market-based estimates.'**
  String get fundDetailSchemeMarketEstimateNote;

  /// No description provided for @fundDetailSchemeBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment breakdown'**
  String get fundDetailSchemeBreakdownTitle;

  /// No description provided for @fundDetailSchemeIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'📈 Income'**
  String get fundDetailSchemeIncomeTitle;

  /// No description provided for @fundDetailSchemeExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'📉 Expenses'**
  String get fundDetailSchemeExpenseTitle;

  /// No description provided for @fundDetailSchemePropertyPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Property price'**
  String get fundDetailSchemePropertyPriceLabel;

  /// No description provided for @fundDetailSchemeTotalInvestmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Total investment'**
  String get fundDetailSchemeTotalInvestmentLabel;

  /// No description provided for @fundDetailSchemeEstimatedAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated sale proceeds'**
  String get fundDetailSchemeEstimatedAmountLabel;

  /// No description provided for @fundDetailSchemeRentalIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Operating income'**
  String get fundDetailSchemeRentalIncomeLabel;

  /// No description provided for @fundDetailSchemeIncomeTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Income total ①'**
  String get fundDetailSchemeIncomeTotalLabel;

  /// No description provided for @fundDetailSchemeLandMiscLabel.
  ///
  /// In en, this message translates to:
  /// **'Land cost + miscellaneous'**
  String get fundDetailSchemeLandMiscLabel;

  /// No description provided for @fundDetailSchemeDesignCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Design + construction cost'**
  String get fundDetailSchemeDesignCostLabel;

  /// No description provided for @fundDetailSchemeBuildingCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Building cost'**
  String get fundDetailSchemeBuildingCostLabel;

  /// No description provided for @fundDetailSchemeMaintenanceFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance fee'**
  String get fundDetailSchemeMaintenanceFeeLabel;

  /// No description provided for @fundDetailSchemePublicUtilitiesTaxesLabel.
  ///
  /// In en, this message translates to:
  /// **'Public charges and taxes'**
  String get fundDetailSchemePublicUtilitiesTaxesLabel;

  /// No description provided for @fundDetailSchemeFireInsurancePremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Fire insurance premium'**
  String get fundDetailSchemeFireInsurancePremiumLabel;

  /// No description provided for @fundDetailSchemeBrokerageFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Brokerage fee'**
  String get fundDetailSchemeBrokerageFeeLabel;

  /// No description provided for @fundDetailSchemeAmFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'AM fee'**
  String get fundDetailSchemeAmFeeLabel;

  /// No description provided for @fundDetailSchemeAmFeeYear1Label.
  ///
  /// In en, this message translates to:
  /// **'AM fee (Year 1)'**
  String get fundDetailSchemeAmFeeYear1Label;

  /// No description provided for @fundDetailSchemeAmFeeYear2Label.
  ///
  /// In en, this message translates to:
  /// **'AM fee (Year 2)'**
  String get fundDetailSchemeAmFeeYear2Label;

  /// No description provided for @fundDetailSchemeAmCommissionLabel.
  ///
  /// In en, this message translates to:
  /// **'AM commission'**
  String get fundDetailSchemeAmCommissionLabel;

  /// No description provided for @fundDetailSchemePublicOfferingFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Public offering fees, etc.'**
  String get fundDetailSchemePublicOfferingFeeLabel;

  /// No description provided for @fundDetailSchemeMarketingCostsLabel.
  ///
  /// In en, this message translates to:
  /// **'Marketing costs'**
  String get fundDetailSchemeMarketingCostsLabel;

  /// No description provided for @fundDetailSchemeAccountantFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Accountant fee'**
  String get fundDetailSchemeAccountantFeeLabel;

  /// No description provided for @fundDetailSchemeConsignmentFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Consignment management fee'**
  String get fundDetailSchemeConsignmentFeeLabel;

  /// No description provided for @fundDetailSchemeNormalConsignmentFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Exclusive consignment fee'**
  String get fundDetailSchemeNormalConsignmentFeeLabel;

  /// No description provided for @fundDetailSchemeFundAdministratorFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fund administrator fee'**
  String get fundDetailSchemeFundAdministratorFeeLabel;

  /// No description provided for @fundDetailSchemeMiscExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous expenses'**
  String get fundDetailSchemeMiscExpensesLabel;

  /// No description provided for @fundDetailSchemeSellExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale expenses'**
  String get fundDetailSchemeSellExpensesLabel;

  /// No description provided for @fundDetailSchemeOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get fundDetailSchemeOtherLabel;

  /// No description provided for @fundDetailSchemeExpenseTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense total ②'**
  String get fundDetailSchemeExpenseTotalLabel;

  /// No description provided for @fundDetailSchemeDistributedCapitalFormula.
  ///
  /// In en, this message translates to:
  /// **'Income ① − Expense ②'**
  String get fundDetailSchemeDistributedCapitalFormula;

  /// No description provided for @fundDetailSchemeDistributedCapitalTitle.
  ///
  /// In en, this message translates to:
  /// **'Distributable capital'**
  String get fundDetailSchemeDistributedCapitalTitle;

  /// No description provided for @myPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Page'**
  String get myPageTitle;

  /// No description provided for @myPageTotalAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total assets'**
  String get myPageTotalAssetsLabel;

  /// No description provided for @myPageTotalAssetsCaption.
  ///
  /// In en, this message translates to:
  /// **'Operating + standby cash + distributions + lending'**
  String get myPageTotalAssetsCaption;

  /// No description provided for @myPageMetricOperating.
  ///
  /// In en, this message translates to:
  /// **'Operating'**
  String get myPageMetricOperating;

  /// No description provided for @myPageMetricStandby.
  ///
  /// In en, this message translates to:
  /// **'Standby cash'**
  String get myPageMetricStandby;

  /// No description provided for @myPageMetricAccumulatedDistribution.
  ///
  /// In en, this message translates to:
  /// **'Total distributions'**
  String get myPageMetricAccumulatedDistribution;

  /// No description provided for @myPageMetricLoanType.
  ///
  /// In en, this message translates to:
  /// **'Lending'**
  String get myPageMetricLoanType;

  /// No description provided for @myPageDepositAction.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get myPageDepositAction;

  /// No description provided for @myPageWithdrawAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get myPageWithdrawAction;

  /// No description provided for @myPagePendingApplicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'📩 Pending Applications'**
  String get myPagePendingApplicationsTitle;

  /// No description provided for @myPageCoolingOffTitle.
  ///
  /// In en, this message translates to:
  /// **'⏰ Cooling-off Period'**
  String get myPageCoolingOffTitle;

  /// No description provided for @myPageOperatingFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'📊 Active Funds'**
  String get myPageOperatingFundsTitle;

  /// No description provided for @myPageTransactionHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'📋 Transaction History'**
  String get myPageTransactionHistoryAction;

  /// No description provided for @myPageApplyAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Application amount'**
  String get myPageApplyAmountLabel;

  /// No description provided for @myPageResultAnnouncementLabel.
  ///
  /// In en, this message translates to:
  /// **'Result date'**
  String get myPageResultAnnouncementLabel;

  /// No description provided for @myPageResultAnnouncementTbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get myPageResultAnnouncementTbd;

  /// No description provided for @myPageApplySubmittedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Applied at'**
  String get myPageApplySubmittedAtLabel;

  /// No description provided for @myPageApplyReviewedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed at'**
  String get myPageApplyReviewedAtLabel;

  /// No description provided for @myPageApplyPaymentNoticeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment notice'**
  String get myPageApplyPaymentNoticeLabel;

  /// No description provided for @myPageApplyPaidAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid at'**
  String get myPageApplyPaidAtLabel;

  /// No description provided for @myPageApplyCancellationRequestedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation requested'**
  String get myPageApplyCancellationRequestedAtLabel;

  /// No description provided for @myPageApplyCancelledAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled at'**
  String get myPageApplyCancelledAtLabel;

  /// No description provided for @myPageInvestmentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment amount'**
  String get myPageInvestmentAmountLabel;

  /// No description provided for @myPageAccumulatedDistributionLabel.
  ///
  /// In en, this message translates to:
  /// **'Total distributions'**
  String get myPageAccumulatedDistributionLabel;

  /// No description provided for @myPageDocumentDeliveryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Document date'**
  String get myPageDocumentDeliveryDateLabel;

  /// No description provided for @myPageCancelDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation deadline'**
  String get myPageCancelDeadlineLabel;

  /// No description provided for @myPageCoolingOffFootnote.
  ///
  /// In en, this message translates to:
  /// **'* Cooling-off cancellation is available for 8 days from the day after receiving the contract document.'**
  String get myPageCoolingOffFootnote;

  /// No description provided for @myPageCancelRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get myPageCancelRequestAction;

  /// No description provided for @myPageCancelRequestComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cancellation flow will be connected in a later implementation.'**
  String get myPageCancelRequestComingSoon;

  /// No description provided for @myPageDepositComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Deposit page will be connected in a later implementation.'**
  String get myPageDepositComingSoon;

  /// No description provided for @myPageWithdrawComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Withdraw page will be connected in a later implementation.'**
  String get myPageWithdrawComingSoon;

  /// No description provided for @myPageHistoryComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Transaction history page will be connected in a later implementation.'**
  String get myPageHistoryComingSoon;

  /// No description provided for @walletDepositTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get walletDepositTitle;

  /// No description provided for @walletHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit History'**
  String get walletHistoryTitle;

  /// No description provided for @walletDedicatedAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dedicated Deposit Account'**
  String get walletDedicatedAccountTitle;

  /// No description provided for @walletDedicatedAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'This is your dedicated deposit account. Deposits are reflected automatically (minimum: ¥10,000). If unused for 3 months, the account may be changed.'**
  String get walletDedicatedAccountDescription;

  /// No description provided for @walletBankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get walletBankNameLabel;

  /// No description provided for @walletBranchNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get walletBranchNameLabel;

  /// No description provided for @walletAccountTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get walletAccountTypeLabel;

  /// No description provided for @walletAccountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account No.'**
  String get walletAccountNumberLabel;

  /// No description provided for @walletAccountHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Holder'**
  String get walletAccountHolderLabel;

  /// No description provided for @walletStandbyBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Standby Balance'**
  String get walletStandbyBalanceLabel;

  /// No description provided for @walletHistorySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest History'**
  String get walletHistorySectionTitle;

  /// No description provided for @walletHistoryMoreAction.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get walletHistoryMoreAction;

  /// No description provided for @walletHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get walletHistoryEmpty;

  /// No description provided for @walletHistoryUnknownType.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get walletHistoryUnknownType;

  /// No description provided for @walletBankAccountMissingDescription.
  ///
  /// In en, this message translates to:
  /// **'No dedicated deposit account has been issued yet. Please apply for one before making a deposit.'**
  String get walletBankAccountMissingDescription;

  /// No description provided for @walletBankAccountApplyAction.
  ///
  /// In en, this message translates to:
  /// **'Apply for Account'**
  String get walletBankAccountApplyAction;

  /// No description provided for @walletBankAccountApplySuccess.
  ///
  /// In en, this message translates to:
  /// **'Deposit account application submitted. Refreshing account info.'**
  String get walletBankAccountApplySuccess;

  /// No description provided for @walletBankAccountApplyFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to apply for a deposit account. Please try again later.'**
  String get walletBankAccountApplyFailure;

  /// No description provided for @walletBankAccountExpireNotice.
  ///
  /// In en, this message translates to:
  /// **'Please transfer by {date}.'**
  String walletBankAccountExpireNotice(Object date);

  /// No description provided for @walletHistoryPendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get walletHistoryPendingStatus;

  /// No description provided for @walletHistoryInflowLabel.
  ///
  /// In en, this message translates to:
  /// **'Inflow'**
  String get walletHistoryInflowLabel;

  /// No description provided for @walletHistoryOutflowLabel.
  ///
  /// In en, this message translates to:
  /// **'Outflow'**
  String get walletHistoryOutflowLabel;

  /// No description provided for @walletAutoReflectedSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Auto reflected)'**
  String get walletAutoReflectedSuffix;

  /// No description provided for @walletDataLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load deposit data.'**
  String get walletDataLoadError;

  /// No description provided for @myPagePendingEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No applications or lottery-waiting items.'**
  String get myPagePendingEmptyState;

  /// No description provided for @myPageCoolingOffEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No contracts in the cooling-off period.'**
  String get myPageCoolingOffEmptyState;

  /// No description provided for @myPageOperatingFundsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No operating funds yet.'**
  String get myPageOperatingFundsEmptyState;

  /// No description provided for @myPageSectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load this section. Please try again.'**
  String get myPageSectionLoadError;

  /// No description provided for @myPageApplyStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get myPageApplyStatusUnderReview;

  /// No description provided for @myPageApplyStatusReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get myPageApplyStatusReviewed;

  /// No description provided for @myPageApplyStatusAwaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get myPageApplyStatusAwaitingPayment;

  /// No description provided for @myPageApplyStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get myPageApplyStatusPaid;

  /// No description provided for @myPageApplyStatusCancellationReview.
  ///
  /// In en, this message translates to:
  /// **'Cancellation in review'**
  String get myPageApplyStatusCancellationReview;

  /// No description provided for @myPageApplyStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get myPageApplyStatusCancelled;

  /// No description provided for @myPageCoolingOffDeadlineRemaining.
  ///
  /// In en, this message translates to:
  /// **'Until {date} ({days} days left)'**
  String myPageCoolingOffDeadlineRemaining(Object date, int days);

  /// No description provided for @myPageCoolingOffDeadlineExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String myPageCoolingOffDeadlineExpired(Object date);

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSkipChevron.
  ///
  /// In en, this message translates to:
  /// **'Skip ›'**
  String get commonSkipChevron;

  /// No description provided for @commonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get commonOther;

  /// No description provided for @memberProfileFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get memberProfileFlowTitle;

  /// No description provided for @memberProfileStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Basic Info'**
  String get memberProfileStep1Title;

  /// No description provided for @memberProfileStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Enter your name and contact information.'**
  String get memberProfileStep1Description;

  /// No description provided for @memberProfileNameKanjiLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get memberProfileNameKanjiLabel;

  /// No description provided for @memberProfileNameKanjiHint.
  ///
  /// In en, this message translates to:
  /// **'Taro Tanaka'**
  String get memberProfileNameKanjiHint;

  /// No description provided for @memberProfileNameKanaLabel.
  ///
  /// In en, this message translates to:
  /// **'Phonetic name'**
  String get memberProfileNameKanaLabel;

  /// No description provided for @memberProfileNameKanaHint.
  ///
  /// In en, this message translates to:
  /// **'TANAKA TARO'**
  String get memberProfileNameKanaHint;

  /// No description provided for @memberProfileBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get memberProfileBirthdayLabel;

  /// No description provided for @memberProfileBirthdayHint.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get memberProfileBirthdayHint;

  /// No description provided for @memberProfileUnderageTitle.
  ///
  /// In en, this message translates to:
  /// **'This service is available only to users aged 18 or older.'**
  String get memberProfileUnderageTitle;

  /// No description provided for @memberProfileUnderageBody.
  ///
  /// In en, this message translates to:
  /// **'Under the Real Estate Specified Joint Enterprise Act, minors cannot apply for investments.'**
  String get memberProfileUnderageBody;

  /// No description provided for @memberProfilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get memberProfilePhoneLabel;

  /// No description provided for @memberProfilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'090-1234-5678'**
  String get memberProfilePhoneHint;

  /// No description provided for @memberProfileStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Address Info'**
  String get memberProfileStep2Title;

  /// No description provided for @memberProfileStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Required for identity verification.'**
  String get memberProfileStep2Description;

  /// No description provided for @memberProfilePostalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get memberProfilePostalCodeLabel;

  /// No description provided for @memberProfilePostalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'100-0001'**
  String get memberProfilePostalCodeHint;

  /// No description provided for @memberProfileAddressSearch.
  ///
  /// In en, this message translates to:
  /// **'Search address'**
  String get memberProfileAddressSearch;

  /// No description provided for @memberProfileAddressSearchPending.
  ///
  /// In en, this message translates to:
  /// **'Address lookup will be connected in a later implementation.'**
  String get memberProfileAddressSearchPending;

  /// No description provided for @memberProfileAddressSearchZipError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 7-digit postal code.'**
  String get memberProfileAddressSearchZipError;

  /// No description provided for @memberProfileAddressSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No address was found for this postal code.'**
  String get memberProfileAddressSearchEmpty;

  /// No description provided for @memberProfileAddressSearchSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an address'**
  String get memberProfileAddressSearchSelectTitle;

  /// No description provided for @memberProfilePrefectureLabel.
  ///
  /// In en, this message translates to:
  /// **'Prefecture'**
  String get memberProfilePrefectureLabel;

  /// No description provided for @memberProfileCityAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Street address'**
  String get memberProfileCityAddressLabel;

  /// No description provided for @memberProfileCityAddressHint.
  ///
  /// In en, this message translates to:
  /// **'1-1-1 Marunouchi, Chiyoda-ku'**
  String get memberProfileCityAddressHint;

  /// No description provided for @memberProfileStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Investor Suitability'**
  String get memberProfileStep3Title;

  /// No description provided for @memberProfileStep3Description.
  ///
  /// In en, this message translates to:
  /// **'We confirm your investment experience under Article 25 of the Real Estate Specified Joint Enterprise Act.'**
  String get memberProfileStep3Description;

  /// No description provided for @memberProfileOccupationLabel.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get memberProfileOccupationLabel;

  /// No description provided for @memberProfileAnnualIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Annual income'**
  String get memberProfileAnnualIncomeLabel;

  /// No description provided for @memberProfileFinancialAssetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Financial assets'**
  String get memberProfileFinancialAssetsLabel;

  /// No description provided for @memberProfileInvestmentExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment experience (multiple selection allowed)'**
  String get memberProfileInvestmentExperienceLabel;

  /// No description provided for @memberProfileInvestmentPurposeLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment purpose'**
  String get memberProfileInvestmentPurposeLabel;

  /// No description provided for @memberProfileFundSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Nature of investment funds'**
  String get memberProfileFundSourceLabel;

  /// No description provided for @memberProfileFundSourceWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Please be aware'**
  String get memberProfileFundSourceWarningTitle;

  /// No description provided for @memberProfileFundSourceWarningStandard.
  ///
  /// In en, this message translates to:
  /// **'This product does not guarantee principal, and you may lose your full investment. Please invest only within surplus funds.'**
  String get memberProfileFundSourceWarningStandard;

  /// No description provided for @memberProfileFundSourceWarningHighRisk.
  ///
  /// In en, this message translates to:
  /// **'This product does not guarantee principal, and you may lose your full investment. Investing with living funds or borrowed money is not recommended. Please invest within your surplus funds.'**
  String get memberProfileFundSourceWarningHighRisk;

  /// No description provided for @memberProfileRiskToleranceLabel.
  ///
  /// In en, this message translates to:
  /// **'Risk tolerance'**
  String get memberProfileRiskToleranceLabel;

  /// No description provided for @memberProfileStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Identity Verification (eKYC)'**
  String get memberProfileStep4Title;

  /// No description provided for @memberProfileStep4Description.
  ///
  /// In en, this message translates to:
  /// **'Please photograph your identity verification documents.'**
  String get memberProfileStep4Description;

  /// No description provided for @memberProfileDocumentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select document'**
  String get memberProfileDocumentTypeLabel;

  /// No description provided for @memberProfilePhotoDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo ID (Front & Back)'**
  String get memberProfilePhotoDocumentTitle;

  /// No description provided for @memberProfilePhotoDocumentDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to open the camera'**
  String get memberProfilePhotoDocumentDescription;

  /// No description provided for @memberProfileSelfieTitle.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie photo'**
  String get memberProfileSelfieTitle;

  /// No description provided for @memberProfileSelfieDescription.
  ///
  /// In en, this message translates to:
  /// **'Face the camera directly'**
  String get memberProfileSelfieDescription;

  /// No description provided for @memberProfileUploadDocumentPending.
  ///
  /// In en, this message translates to:
  /// **'Document capture will be connected in a later implementation.'**
  String get memberProfileUploadDocumentPending;

  /// No description provided for @memberProfileUploadSelfiePending.
  ///
  /// In en, this message translates to:
  /// **'Selfie capture will be connected in a later implementation.'**
  String get memberProfileUploadSelfiePending;

  /// No description provided for @memberProfileStep5RealPersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Real-Person Verification (Liveness)'**
  String get memberProfileStep5RealPersonTitle;

  /// No description provided for @memberProfileStep5RealPersonDescription.
  ///
  /// In en, this message translates to:
  /// **'After uploading your selfie, complete the live face verification.'**
  String get memberProfileStep5RealPersonDescription;

  /// No description provided for @memberProfileStep5RealPersonSelfieRequired.
  ///
  /// In en, this message translates to:
  /// **'Please upload a selfie photo first.'**
  String get memberProfileStep5RealPersonSelfieRequired;

  /// No description provided for @memberProfileStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Step 6: Bank Account'**
  String get memberProfileStep5Title;

  /// No description provided for @memberProfileStep5Description.
  ///
  /// In en, this message translates to:
  /// **'Register the bank account for distribution transfers.'**
  String get memberProfileStep5Description;

  /// No description provided for @memberProfileBankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Financial institution'**
  String get memberProfileBankNameLabel;

  /// No description provided for @memberProfileBankNameHint.
  ///
  /// In en, this message translates to:
  /// **'MUFG Bank'**
  String get memberProfileBankNameHint;

  /// No description provided for @memberProfileBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get memberProfileBranchLabel;

  /// No description provided for @memberProfileBranchHint.
  ///
  /// In en, this message translates to:
  /// **'Marunouchi Branch'**
  String get memberProfileBranchHint;

  /// No description provided for @memberProfileAccountTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get memberProfileAccountTypeLabel;

  /// No description provided for @memberProfileAccountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get memberProfileAccountNumberLabel;

  /// No description provided for @memberProfileAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'1234567'**
  String get memberProfileAccountNumberHint;

  /// No description provided for @memberProfileAccountHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder (katakana)'**
  String get memberProfileAccountHolderLabel;

  /// No description provided for @memberProfileAccountHolderHint.
  ///
  /// In en, this message translates to:
  /// **'TANAKA TARO'**
  String get memberProfileAccountHolderHint;

  /// No description provided for @memberProfileNextConsent.
  ///
  /// In en, this message translates to:
  /// **'Next: Consent Confirmation'**
  String get memberProfileNextConsent;

  /// No description provided for @memberProfileStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Step 7: Consent'**
  String get memberProfileStep6Title;

  /// No description provided for @memberProfileStep6Description.
  ///
  /// In en, this message translates to:
  /// **'Please review the following items and agree to all of them.'**
  String get memberProfileStep6Description;

  /// No description provided for @memberProfileElectronicDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Electronic delivery of documents'**
  String get memberProfileElectronicDeliveryTitle;

  /// No description provided for @memberProfileElectronicDeliveryBody.
  ///
  /// In en, this message translates to:
  /// **'We will deliver the following documents required under the Real Estate Specified Joint Enterprise Act electronically in the app as PDF files instead of on paper.'**
  String get memberProfileElectronicDeliveryBody;

  /// No description provided for @memberProfileElectronicDeliveryItem1.
  ///
  /// In en, this message translates to:
  /// **'Pre-contract disclosure document'**
  String get memberProfileElectronicDeliveryItem1;

  /// No description provided for @memberProfileElectronicDeliveryItem2.
  ///
  /// In en, this message translates to:
  /// **'Contract conclusion document'**
  String get memberProfileElectronicDeliveryItem2;

  /// No description provided for @memberProfileElectronicDeliveryItem3.
  ///
  /// In en, this message translates to:
  /// **'Property management report'**
  String get memberProfileElectronicDeliveryItem3;

  /// No description provided for @memberProfileElectronicDeliveryItem4.
  ///
  /// In en, this message translates to:
  /// **'Business and asset status documents'**
  String get memberProfileElectronicDeliveryItem4;

  /// No description provided for @memberProfileElectronicDeliveryFootnote.
  ///
  /// In en, this message translates to:
  /// **'※ You may withdraw your consent to electronic delivery at any time from Settings. After withdrawal, documents will be mailed in paper form.'**
  String get memberProfileElectronicDeliveryFootnote;

  /// No description provided for @memberProfileElectronicDeliveryConsent.
  ///
  /// In en, this message translates to:
  /// **'I agree to the electronic delivery method above.'**
  String get memberProfileElectronicDeliveryConsent;

  /// No description provided for @memberProfileAntiSocialTitle.
  ///
  /// In en, this message translates to:
  /// **'Declaration of not being an anti-social force'**
  String get memberProfileAntiSocialTitle;

  /// No description provided for @memberProfileAntiSocialBody.
  ///
  /// In en, this message translates to:
  /// **'I represent and warrant that I am not, now or in the future, part of any anti-social force such as organized crime groups, members, affiliates, or similar entities.'**
  String get memberProfileAntiSocialBody;

  /// No description provided for @memberProfileAntiSocialConsent.
  ///
  /// In en, this message translates to:
  /// **'I declare that I do not belong to any anti-social force.'**
  String get memberProfileAntiSocialConsent;

  /// No description provided for @memberProfilePrivacyConsent.
  ///
  /// In en, this message translates to:
  /// **'I agree to the handling of personal information and the privacy policy.'**
  String get memberProfilePrivacyConsent;

  /// No description provided for @memberProfileAgreeAndComplete.
  ///
  /// In en, this message translates to:
  /// **'Agree to all and complete registration'**
  String get memberProfileAgreeAndComplete;

  /// No description provided for @memberProfileCompletedToast.
  ///
  /// In en, this message translates to:
  /// **'Profile information registration is complete.'**
  String get memberProfileCompletedToast;

  /// No description provided for @memberProfilePhotoUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded successfully.'**
  String get memberProfilePhotoUploadSuccess;

  /// No description provided for @occupationEmployee.
  ///
  /// In en, this message translates to:
  /// **'Company employee'**
  String get occupationEmployee;

  /// No description provided for @occupationSelfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self-employed'**
  String get occupationSelfEmployed;

  /// No description provided for @occupationPublicServant.
  ///
  /// In en, this message translates to:
  /// **'Public servant'**
  String get occupationPublicServant;

  /// No description provided for @occupationHomemaker.
  ///
  /// In en, this message translates to:
  /// **'Homemaker'**
  String get occupationHomemaker;

  /// No description provided for @occupationStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get occupationStudent;

  /// No description provided for @occupationPensioner.
  ///
  /// In en, this message translates to:
  /// **'Pensioner'**
  String get occupationPensioner;

  /// No description provided for @incomeUnder3m.
  ///
  /// In en, this message translates to:
  /// **'Under JPY 3M'**
  String get incomeUnder3m;

  /// No description provided for @income3to5m.
  ///
  /// In en, this message translates to:
  /// **'JPY 3M to 5M'**
  String get income3to5m;

  /// No description provided for @income5to10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 5M to 10M'**
  String get income5to10m;

  /// No description provided for @incomeOver10m.
  ///
  /// In en, this message translates to:
  /// **'Over JPY 10M'**
  String get incomeOver10m;

  /// No description provided for @assetsUnder1m.
  ///
  /// In en, this message translates to:
  /// **'Under JPY 1M'**
  String get assetsUnder1m;

  /// No description provided for @assets1to5m.
  ///
  /// In en, this message translates to:
  /// **'JPY 1M to 5M'**
  String get assets1to5m;

  /// No description provided for @assets5to10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 5M to 10M'**
  String get assets5to10m;

  /// No description provided for @assetsOver10m.
  ///
  /// In en, this message translates to:
  /// **'Over JPY 10M'**
  String get assetsOver10m;

  /// No description provided for @purposeAssetGrowth.
  ///
  /// In en, this message translates to:
  /// **'Asset growth'**
  String get purposeAssetGrowth;

  /// No description provided for @purposeDividendIncome.
  ///
  /// In en, this message translates to:
  /// **'Regular income from distributions'**
  String get purposeDividendIncome;

  /// No description provided for @purposeIdleFunds.
  ///
  /// In en, this message translates to:
  /// **'Managing surplus cash'**
  String get purposeIdleFunds;

  /// No description provided for @purposeDiversification.
  ///
  /// In en, this message translates to:
  /// **'Portfolio diversification'**
  String get purposeDiversification;

  /// No description provided for @fundSourceSurplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus funds with no impact on daily life'**
  String get fundSourceSurplus;

  /// No description provided for @fundSourceLivingFunds.
  ///
  /// In en, this message translates to:
  /// **'Part of living expenses'**
  String get fundSourceLivingFunds;

  /// No description provided for @fundSourceBorrowed.
  ///
  /// In en, this message translates to:
  /// **'Borrowed money'**
  String get fundSourceBorrowed;

  /// No description provided for @riskToleranceAcceptLoss.
  ///
  /// In en, this message translates to:
  /// **'I understand and can tolerate principal loss.'**
  String get riskToleranceAcceptLoss;

  /// No description provided for @riskToleranceLowRisk.
  ///
  /// In en, this message translates to:
  /// **'I only want low-risk investments.'**
  String get riskToleranceLowRisk;

  /// No description provided for @riskToleranceHighRisk.
  ///
  /// In en, this message translates to:
  /// **'I can tolerate high-risk, high-return investments.'**
  String get riskToleranceHighRisk;

  /// No description provided for @documentTypeDriversLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s license'**
  String get documentTypeDriversLicense;

  /// No description provided for @documentTypeMyNumber.
  ///
  /// In en, this message translates to:
  /// **'My Number card'**
  String get documentTypeMyNumber;

  /// No description provided for @documentTypeResidenceCard.
  ///
  /// In en, this message translates to:
  /// **'Residence card'**
  String get documentTypeResidenceCard;

  /// No description provided for @documentTypePassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get documentTypePassport;

  /// No description provided for @documentTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other personal ID'**
  String get documentTypeOther;

  /// No description provided for @accountTypeOrdinary.
  ///
  /// In en, this message translates to:
  /// **'Ordinary'**
  String get accountTypeOrdinary;

  /// No description provided for @accountTypeChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get accountTypeChecking;

  /// No description provided for @prefectureTokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get prefectureTokyo;

  /// No description provided for @prefectureOsaka.
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get prefectureOsaka;

  /// No description provided for @prefectureKanagawa.
  ///
  /// In en, this message translates to:
  /// **'Kanagawa'**
  String get prefectureKanagawa;

  /// No description provided for @prefectureAichi.
  ///
  /// In en, this message translates to:
  /// **'Aichi'**
  String get prefectureAichi;

  /// No description provided for @prefectureFukuoka.
  ///
  /// In en, this message translates to:
  /// **'Fukuoka'**
  String get prefectureFukuoka;

  /// No description provided for @memberProfileExperienceStocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks / ETF'**
  String get memberProfileExperienceStocks;

  /// No description provided for @memberProfileExperienceMutualFunds.
  ///
  /// In en, this message translates to:
  /// **'Mutual funds'**
  String get memberProfileExperienceMutualFunds;

  /// No description provided for @memberProfileExperienceRealEstate.
  ///
  /// In en, this message translates to:
  /// **'Real estate investment'**
  String get memberProfileExperienceRealEstate;

  /// No description provided for @memberProfileExperienceRealEstateCrowdfunding.
  ///
  /// In en, this message translates to:
  /// **'Real estate crowdfunding / FTK'**
  String get memberProfileExperienceRealEstateCrowdfunding;

  /// No description provided for @memberProfileExperienceBonds.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get memberProfileExperienceBonds;

  /// No description provided for @memberProfileExperienceFxCrypto.
  ///
  /// In en, this message translates to:
  /// **'FX / Crypto assets'**
  String get memberProfileExperienceFxCrypto;

  /// No description provided for @memberProfileExperienceNone.
  ///
  /// In en, this message translates to:
  /// **'No investment experience'**
  String get memberProfileExperienceNone;

  /// No description provided for @identityAuthPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityAuthPageTitle;

  /// No description provided for @identityAuthPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Use facial verification to complete real-person authentication for security-sensitive actions.'**
  String get identityAuthPageDescription;

  /// No description provided for @identityAuthStartAction.
  ///
  /// In en, this message translates to:
  /// **'Start verification'**
  String get identityAuthStartAction;

  /// No description provided for @identityAuthAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Identity verification is already completed.'**
  String get identityAuthAlreadyVerified;

  /// No description provided for @identityAuthVerifySuccess.
  ///
  /// In en, this message translates to:
  /// **'Identity verification succeeded.'**
  String get identityAuthVerifySuccess;

  /// No description provided for @identityAuthVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Identity verification failed. Please try again.'**
  String get identityAuthVerifyFailed;

  /// No description provided for @identityAuthCollectFailed.
  ///
  /// In en, this message translates to:
  /// **'Face capture failed. Please try again.'**
  String get identityAuthCollectFailed;

  /// No description provided for @identityAuthLivenessNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Liveness collector is not configured.'**
  String get identityAuthLivenessNotConfigured;

  /// No description provided for @identityAuthBiometricNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not configured.'**
  String get identityAuthBiometricNotConfigured;

  /// No description provided for @identityAuthSensitiveBlocked.
  ///
  /// In en, this message translates to:
  /// **'Unable to continue this sensitive action.'**
  String get identityAuthSensitiveBlocked;

  /// No description provided for @identityAuthBaiduLicenseMissing.
  ///
  /// In en, this message translates to:
  /// **'Baidu face SDK license is missing.'**
  String get identityAuthBaiduLicenseMissing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
