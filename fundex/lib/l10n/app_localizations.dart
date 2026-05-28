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

  /// No description provided for @loginSendCodeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get loginSendCodeSuccess;

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

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @pushDialogDefaultBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'This app is unavailable'**
  String get pushDialogDefaultBlockTitle;

  /// No description provided for @pushDialogDefaultBlockBody.
  ///
  /// In en, this message translates to:
  /// **'Please use the specified app instead.'**
  String get pushDialogDefaultBlockBody;

  /// No description provided for @pushDialogDefaultUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'A new version is available'**
  String get pushDialogDefaultUpdateTitle;

  /// No description provided for @pushDialogDefaultUpdateBody.
  ///
  /// In en, this message translates to:
  /// **'Please update to the latest version.'**
  String get pushDialogDefaultUpdateBody;

  /// No description provided for @pushDialogDefaultCampaignTitle.
  ///
  /// In en, this message translates to:
  /// **'Campaign Notice'**
  String get pushDialogDefaultCampaignTitle;

  /// No description provided for @pushDialogOpenStore.
  ///
  /// In en, this message translates to:
  /// **'Open Store'**
  String get pushDialogOpenStore;

  /// No description provided for @pushDialogUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get pushDialogUpdateNow;

  /// No description provided for @pushDialogUpdateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get pushDialogUpdateLater;

  /// No description provided for @pushDialogClose.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get pushDialogClose;

  /// No description provided for @pushDialogOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the link.'**
  String get pushDialogOpenFailed;

  /// No description provided for @discussionAvatarPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get discussionAvatarPageTitle;

  /// No description provided for @discussionAvatarPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a default avatar or upload an image from your photo library.'**
  String get discussionAvatarPreviewHint;

  /// No description provided for @discussionAvatarDefaultSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Default avatars'**
  String get discussionAvatarDefaultSectionTitle;

  /// No description provided for @discussionAvatarSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save avatar'**
  String get discussionAvatarSaveAction;

  /// No description provided for @discussionAvatarSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated.'**
  String get discussionAvatarSaveSuccess;

  /// No description provided for @discussionAvatarPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to choose an image. Please try again.'**
  String get discussionAvatarPickFailed;

  /// No description provided for @profileImageSizeTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The image is too large. Please choose an image under 10MB.'**
  String get profileImageSizeTooLarge;

  /// No description provided for @discussionAvatarPhotoLibraryPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow photo library access to select an avatar image.'**
  String get discussionAvatarPhotoLibraryPermissionRequired;

  /// No description provided for @discussionAvatarCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust avatar'**
  String get discussionAvatarCropTitle;

  /// No description provided for @discussionAvatarCropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the image and pinch to zoom so the avatar fits inside the circle.'**
  String get discussionAvatarCropHint;

  /// No description provided for @discussionAvatarCropApplyAction.
  ///
  /// In en, this message translates to:
  /// **'Use this image'**
  String get discussionAvatarCropApplyAction;

  /// No description provided for @commonOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get commonOpenSettings;

  /// No description provided for @pdfViewerPageTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdfViewerPageTitle;

  /// No description provided for @pdfViewerOpenExternalTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open externally'**
  String get pdfViewerOpenExternalTooltip;

  /// No description provided for @pdfViewerOpenExternalLabel.
  ///
  /// In en, this message translates to:
  /// **'Open externally'**
  String get pdfViewerOpenExternalLabel;

  /// No description provided for @pdfViewerShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get pdfViewerShareTooltip;

  /// No description provided for @pdfViewerShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get pdfViewerShareLabel;

  /// No description provided for @pdfViewerLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading PDF...'**
  String get pdfViewerLoadingLabel;

  /// No description provided for @pdfViewerLoadFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PDF.'**
  String get pdfViewerLoadFailedLabel;

  /// No description provided for @pdfViewerInvalidUrlNotice.
  ///
  /// In en, this message translates to:
  /// **'Invalid PDF URL.'**
  String get pdfViewerInvalidUrlNotice;

  /// No description provided for @pdfViewerOpenExternalFailedNotice.
  ///
  /// In en, this message translates to:
  /// **'Unable to open PDF.'**
  String get pdfViewerOpenExternalFailedNotice;

  /// No description provided for @pdfViewerShareFailedNotice.
  ///
  /// In en, this message translates to:
  /// **'Unable to share PDF.'**
  String get pdfViewerShareFailedNotice;

  /// No description provided for @imageViewerLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get imageViewerLoadingLabel;

  /// No description provided for @imageViewerLoadFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed to load image.'**
  String get imageViewerLoadFailedLabel;

  /// No description provided for @imageViewerRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get imageViewerRetryLabel;

  /// No description provided for @imageViewerInvalidSourceNotice.
  ///
  /// In en, this message translates to:
  /// **'Invalid image source.'**
  String get imageViewerInvalidSourceNotice;

  /// No description provided for @webViewerLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading page...'**
  String get webViewerLoadingLabel;

  /// No description provided for @webViewerLoadFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed to load page.'**
  String get webViewerLoadFailedLabel;

  /// No description provided for @webViewerInvalidUrlNotice.
  ///
  /// In en, this message translates to:
  /// **'Invalid page URL.'**
  String get webViewerInvalidUrlNotice;

  /// No description provided for @imageViewerCloseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get imageViewerCloseTooltip;

  /// No description provided for @favoriteAddedToast.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteAddedToast;

  /// No description provided for @favoriteRemovedToast.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoriteRemovedToast;

  /// No description provided for @networkOfflineBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get networkOfflineBannerTitle;

  /// No description provided for @networkOfflineBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ll refresh the latest data automatically when the connection returns.'**
  String get networkOfflineBannerMessage;

  /// No description provided for @networkAccessDeniedBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to access the network'**
  String get networkAccessDeniedBannerTitle;

  /// No description provided for @networkAccessDeniedBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection, or allow StellaVia network access in iPhone Settings.'**
  String get networkAccessDeniedBannerMessage;

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

  /// No description provided for @memberProfileAutoSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get memberProfileAutoSavedToast;

  /// No description provided for @memberProfileTemporarySaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get memberProfileTemporarySaveAction;

  /// No description provided for @memberProfilePhotoPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get memberProfilePhotoPreviewAction;

  /// No description provided for @memberProfileDraftImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved profile draft found'**
  String get memberProfileDraftImportTitle;

  /// No description provided for @memberProfileDraftImportMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to import the saved draft from your last session?'**
  String get memberProfileDraftImportMessage;

  /// No description provided for @memberProfileDraftImportAction.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get memberProfileDraftImportAction;

  /// No description provided for @memberProfileDraftImportSkipAction.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get memberProfileDraftImportSkipAction;

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

  /// No description provided for @profileDocumentCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to take a document photo.'**
  String get profileDocumentCameraPermissionRequired;

  /// No description provided for @profileDocumentPhotoLibraryPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow photo library access to select a document photo.'**
  String get profileDocumentPhotoLibraryPermissionRequired;

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
  /// **'I agree to the Terms of Service'**
  String get registerAcceptPolicy;

  /// No description provided for @registerElectronicDeliveryDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Consent to Electronic Delivery of Documents'**
  String get registerElectronicDeliveryDocumentTitle;

  /// No description provided for @registerAntiSocialDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Statement and Pledge Regarding Non-Affiliation with Anti-Social Forces'**
  String get registerAntiSocialDocumentTitle;

  /// No description provided for @registerPersonalInformationDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Regarding the Handling of Personal Information'**
  String get registerPersonalInformationDocumentTitle;

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
  /// **'Welcome back, {name}'**
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

  /// No description provided for @homeTopBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Build future assets\nwith trusted real estate.'**
  String get homeTopBannerTitle;

  /// No description provided for @homeTopBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Invest smartly in carefully selected real estate in Japan from JPY 10,000.'**
  String get homeTopBannerBody;

  /// No description provided for @homeTopBannerRegisterAction.
  ///
  /// In en, this message translates to:
  /// **'Free Sign Up'**
  String get homeTopBannerRegisterAction;

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

  /// No description provided for @homeGuestRegisterBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Free sign-up for new members'**
  String get homeGuestRegisterBonusTitle;

  /// No description provided for @homeGuestRegisterBonusBar.
  ///
  /// In en, this message translates to:
  /// **'Get ¥3,000 in investment credit.'**
  String get homeGuestRegisterBonusBar;

  /// No description provided for @homeAttractionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Why StellaVia'**
  String get homeAttractionSectionTitle;

  /// No description provided for @homeAttractionAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'Focused on hotels, inns,'**
  String get homeAttractionAreaTitle;

  /// No description provided for @homeAttractionAreaBody.
  ///
  /// In en, this message translates to:
  /// **' and resorts.'**
  String get homeAttractionAreaBody;

  /// No description provided for @homeAttractionStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay at the property'**
  String get homeAttractionStructureTitle;

  /// No description provided for @homeAttractionStructureBody.
  ///
  /// In en, this message translates to:
  /// **' you invested in.'**
  String get homeAttractionStructureBody;

  /// No description provided for @homeAttractionFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your assets with'**
  String get homeAttractionFundsTitle;

  /// No description provided for @homeAttractionFundsBody.
  ///
  /// In en, this message translates to:
  /// **' a two-layer shield.'**
  String get homeAttractionFundsBody;

  /// No description provided for @homeAttractionAreaDetailBody.
  ///
  /// In en, this message translates to:
  /// **'An investment designed to turn travel demand directly into returns.'**
  String get homeAttractionAreaDetailBody;

  /// No description provided for @homeAttractionStructureDetailBody.
  ///
  /// In en, this message translates to:
  /// **'The travel experience itself can become part of the return.'**
  String get homeAttractionStructureDetailBody;

  /// No description provided for @homeAttractionShieldDetailBody.
  ///
  /// In en, this message translates to:
  /// **'A structure where the company takes risk first.'**
  String get homeAttractionShieldDetailBody;

  /// No description provided for @homeAttractionShieldFirstLabel.
  ///
  /// In en, this message translates to:
  /// **'Shield 1'**
  String get homeAttractionShieldFirstLabel;

  /// No description provided for @homeAttractionShieldFirstBody.
  ///
  /// In en, this message translates to:
  /// **'Subordinated investment by Stella Asset Co., Ltd.'**
  String get homeAttractionShieldFirstBody;

  /// No description provided for @homeAttractionShieldSecondLabel.
  ///
  /// In en, this message translates to:
  /// **'Shield 2'**
  String get homeAttractionShieldSecondLabel;

  /// No description provided for @homeAttractionShieldSecondBody.
  ///
  /// In en, this message translates to:
  /// **'Investment by the operating company (TJ BROTHERS GROUP)'**
  String get homeAttractionShieldSecondBody;

  /// No description provided for @homeAttractionShieldFootnote.
  ///
  /// In en, this message translates to:
  /// **'The amount of subordinated investment varies for each project (starting from 10%). Please see the project overview for details.'**
  String get homeAttractionShieldFootnote;

  /// No description provided for @homeInvestmentFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'How to Invest'**
  String get homeInvestmentFlowTitle;

  /// No description provided for @homeInvestmentFlowStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get homeInvestmentFlowStep1Title;

  /// No description provided for @homeInvestmentFlowStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Register instantly with your email'**
  String get homeInvestmentFlowStep1Body;

  /// No description provided for @homeInvestmentFlowStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Verify Identity'**
  String get homeInvestmentFlowStep2Title;

  /// No description provided for @homeInvestmentFlowStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Complete secure identity verification'**
  String get homeInvestmentFlowStep2Body;

  /// No description provided for @homeInvestmentFlowStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Start Investing'**
  String get homeInvestmentFlowStep3Title;

  /// No description provided for @homeInvestmentFlowStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Invest in curated fund opportunities'**
  String get homeInvestmentFlowStep3Body;

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

  /// No description provided for @homeReminderVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get homeReminderVerifyAction;

  /// No description provided for @homeReminderEmailVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get homeReminderEmailVerificationTitle;

  /// No description provided for @homeReminderEmailVerificationBody.
  ///
  /// In en, this message translates to:
  /// **'This account has no email address yet. Please enter and verify your email address.'**
  String get homeReminderEmailVerificationBody;

  /// No description provided for @homeReminderPhoneVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone verification'**
  String get homeReminderPhoneVerificationTitle;

  /// No description provided for @homeReminderPhoneVerificationBody.
  ///
  /// In en, this message translates to:
  /// **'Phone verification is not complete for this account. Please verify your phone number.'**
  String get homeReminderPhoneVerificationBody;

  /// No description provided for @homeReminderRealPersonVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get homeReminderRealPersonVerificationTitle;

  /// No description provided for @homeReminderRealPersonVerificationBody.
  ///
  /// In en, this message translates to:
  /// **'Real-person verification is not complete for this account. Please complete identity verification.'**
  String get homeReminderRealPersonVerificationBody;

  /// No description provided for @homeCelebrationBadge.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BONUS'**
  String get homeCelebrationBadge;

  /// No description provided for @homeCelebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'First Sign-Up Reward'**
  String get homeCelebrationTitle;

  /// No description provided for @homeCelebrationAmount.
  ///
  /// In en, this message translates to:
  /// **'¥2,500'**
  String get homeCelebrationAmount;

  /// No description provided for @homeCelebrationBody.
  ///
  /// In en, this message translates to:
  /// **'Thanks for completing your first registration. We have added a 2,500 yen investment bonus to your account.'**
  String get homeCelebrationBody;

  /// No description provided for @homeCelebrationPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get homeCelebrationPrimaryAction;

  /// No description provided for @memberProfileEditRequiresFaceVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Face verification required'**
  String get memberProfileEditRequiresFaceVerificationTitle;

  /// No description provided for @memberProfileEditRequiresFaceVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete face verification before editing submitted identity information.'**
  String get memberProfileEditRequiresFaceVerificationMessage;

  /// No description provided for @walletWithdrawRequiresFaceVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Face verification required'**
  String get walletWithdrawRequiresFaceVerificationTitle;

  /// No description provided for @walletWithdrawRequiresFaceVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete face verification before continuing with the withdrawal.'**
  String get walletWithdrawRequiresFaceVerificationMessage;

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
  /// **'Latest Funds'**
  String get homeFeaturedFundsTitle;

  /// No description provided for @homeViewAllAction.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAllAction;

  /// No description provided for @homeOfficialSiteAction.
  ///
  /// In en, this message translates to:
  /// **'StellaVia Office Site'**
  String get homeOfficialSiteAction;

  /// No description provided for @homeOfficialSiteOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to open the official site.'**
  String get homeOfficialSiteOpenFailed;

  /// No description provided for @homeEstimatedYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Est. yield'**
  String get homeEstimatedYieldLabel;

  /// No description provided for @homeFreeMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Flea Market'**
  String get homeFreeMarketTitle;

  /// No description provided for @homeFreeMarketStatusListed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get homeFreeMarketStatusListed;

  /// No description provided for @homeFreeMarketSoldUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Matched Units'**
  String get homeFreeMarketSoldUnitsLabel;

  /// No description provided for @homeFreeMarketUnitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get homeFreeMarketUnitPriceLabel;

  /// No description provided for @homeFreeMarketEmptyState.
  ///
  /// In en, this message translates to:
  /// **'There are no public flea market listings right now.'**
  String get homeFreeMarketEmptyState;

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
  /// **'Active Funds'**
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

  /// No description provided for @fundListFilterFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get fundListFilterFavorites;

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

  /// No description provided for @fundListMinimumInvestmentValue.
  ///
  /// In en, this message translates to:
  /// **'From JPY {amount}'**
  String fundListMinimumInvestmentValue(Object amount);

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

  /// No description provided for @fundListGainTypeIncomeGain.
  ///
  /// In en, this message translates to:
  /// **'Income Gain'**
  String get fundListGainTypeIncomeGain;

  /// No description provided for @fundListGainTypeCapitalGain.
  ///
  /// In en, this message translates to:
  /// **'Capital Gain'**
  String get fundListGainTypeCapitalGain;

  /// No description provided for @fundListGainTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed (Income + Capital)'**
  String get fundListGainTypeMixed;

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

  /// No description provided for @hotelBrandMark.
  ///
  /// In en, this message translates to:
  /// **'STELLAVIA STAY'**
  String get hotelBrandMark;

  /// No description provided for @hotelTabHeadline.
  ///
  /// In en, this message translates to:
  /// **'Kyoto Machiya & Selected Stays'**
  String get hotelTabHeadline;

  /// No description provided for @hotelTabSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From urban assets to bookable, real stay experiences.'**
  String get hotelTabSubtitle;

  /// No description provided for @hotelDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get hotelDestinationLabel;

  /// No description provided for @hotelDefaultDestination.
  ///
  /// In en, this message translates to:
  /// **'All areas'**
  String get hotelDefaultDestination;

  /// No description provided for @hotelAreaOsaka.
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get hotelAreaOsaka;

  /// No description provided for @hotelAreaKyoto.
  ///
  /// In en, this message translates to:
  /// **'Kyoto'**
  String get hotelAreaKyoto;

  /// No description provided for @hotelAreaTokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get hotelAreaTokyo;

  /// No description provided for @hotelPropertyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Stay type'**
  String get hotelPropertyTypeLabel;

  /// No description provided for @hotelCheckInDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Stay dates'**
  String get hotelCheckInDateLabel;

  /// No description provided for @hotelGuestFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get hotelGuestFieldLabel;

  /// No description provided for @hotelSearchKeywordHint.
  ///
  /// In en, this message translates to:
  /// **'Hotel name, area, or station'**
  String get hotelSearchKeywordHint;

  /// No description provided for @hotelSearchAction.
  ///
  /// In en, this message translates to:
  /// **'Check availability'**
  String get hotelSearchAction;

  /// No description provided for @hotelSearchNights.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 night} other{{count} nights}}'**
  String hotelSearchNights(int count);

  /// No description provided for @hotelSearchSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'{destination}, {dateRange}, {nights}'**
  String hotelSearchSummaryLine(
    Object destination,
    Object dateRange,
    Object nights,
  );

  /// No description provided for @hotelSearchConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search conditions'**
  String get hotelSearchConditionsTitle;

  /// No description provided for @hotelSearchConditionsHint.
  ///
  /// In en, this message translates to:
  /// **'Opens from summary'**
  String get hotelSearchConditionsHint;

  /// No description provided for @hotelQuickActionUserInfo.
  ///
  /// In en, this message translates to:
  /// **'User info'**
  String get hotelQuickActionUserInfo;

  /// No description provided for @hotelQuickActionOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get hotelQuickActionOrders;

  /// No description provided for @hotelQuickActionCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get hotelQuickActionCoupons;

  /// No description provided for @hotelQuickActionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get hotelQuickActionContact;

  /// No description provided for @hotelMemberProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'User info'**
  String get hotelMemberProfileTitle;

  /// No description provided for @hotelMemberProfileNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get hotelMemberProfileNickname;

  /// No description provided for @hotelMemberProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get hotelMemberProfileEmail;

  /// No description provided for @hotelMemberProfilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get hotelMemberProfilePhone;

  /// No description provided for @hotelMemberProfileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get hotelMemberProfileGender;

  /// No description provided for @hotelMemberProfileBirthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get hotelMemberProfileBirthday;

  /// No description provided for @hotelMemberProfileMemberLevel.
  ///
  /// In en, this message translates to:
  /// **'Member level'**
  String get hotelMemberProfileMemberLevel;

  /// No description provided for @hotelMemberProfileAboutLevel.
  ///
  /// In en, this message translates to:
  /// **'About membership'**
  String get hotelMemberProfileAboutLevel;

  /// No description provided for @hotelMemberProfileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hotelMemberProfileEdit;

  /// No description provided for @hotelMemberProfileUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get hotelMemberProfileUnset;

  /// No description provided for @hotelMemberProfileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get hotelMemberProfileGenderMale;

  /// No description provided for @hotelMemberProfileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get hotelMemberProfileGenderFemale;

  /// No description provided for @hotelMemberProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get hotelMemberProfileSave;

  /// No description provided for @hotelMemberProfilePhoneCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get hotelMemberProfilePhoneCountryCode;

  /// No description provided for @hotelMemberProfilePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get hotelMemberProfilePhoneNumber;

  /// No description provided for @hotelMemberProfileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'User information has been updated.'**
  String get hotelMemberProfileSaveSuccess;

  /// No description provided for @hotelMemberProfileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update user information. Please try again.'**
  String get hotelMemberProfileSaveFailed;

  /// No description provided for @hotelMemberProfileLevelWithDiscount.
  ///
  /// In en, this message translates to:
  /// **'{level} · {discount}% OFF'**
  String hotelMemberProfileLevelWithDiscount(Object level, int discount);

  /// No description provided for @hotelFilterAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All stays'**
  String get hotelFilterAllTypes;

  /// No description provided for @hotelSortRecommended.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get hotelSortRecommended;

  /// No description provided for @hotelSortPriceLow.
  ///
  /// In en, this message translates to:
  /// **'Price sort'**
  String get hotelSortPriceLow;

  /// No description provided for @hotelSortPriceHigh.
  ///
  /// In en, this message translates to:
  /// **'Price sort'**
  String get hotelSortPriceHigh;

  /// No description provided for @hotelSortPriceAscending.
  ///
  /// In en, this message translates to:
  /// **'Price low to high'**
  String get hotelSortPriceAscending;

  /// No description provided for @hotelSortPriceDescending.
  ///
  /// In en, this message translates to:
  /// **'Price high to low'**
  String get hotelSortPriceDescending;

  /// No description provided for @hotelToolbarSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get hotelToolbarSort;

  /// No description provided for @hotelToolbarFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get hotelToolbarFilter;

  /// No description provided for @hotelToolbarMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get hotelToolbarMap;

  /// No description provided for @hotelMapListButton.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get hotelMapListButton;

  /// No description provided for @hotelMapNearbyButton.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get hotelMapNearbyButton;

  /// No description provided for @hotelGuestAdults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get hotelGuestAdults;

  /// No description provided for @hotelGuestChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get hotelGuestChildren;

  /// No description provided for @hotelGuestRooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get hotelGuestRooms;

  /// No description provided for @hotelGuestSummary.
  ///
  /// In en, this message translates to:
  /// **'{guests} adults · {rooms} rooms'**
  String hotelGuestSummary(int guests, int rooms);

  /// No description provided for @hotelGuestDetailedSummary.
  ///
  /// In en, this message translates to:
  /// **'{adults} adults · {children} children · {rooms} rooms'**
  String hotelGuestDetailedSummary(int adults, int children, int rooms);

  /// No description provided for @hotelDetailStayDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in · Check-out'**
  String get hotelDetailStayDateLabel;

  /// No description provided for @hotelDetailGuestRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests · Rooms'**
  String get hotelDetailGuestRoomLabel;

  /// No description provided for @hotelDetailAvailableRooms.
  ///
  /// In en, this message translates to:
  /// **'Available rooms'**
  String get hotelDetailAvailableRooms;

  /// No description provided for @hotelDetailRemainingRoomsShort.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms left'**
  String hotelDetailRemainingRoomsShort(int count);

  /// No description provided for @hotelDetailRoomCapacity.
  ///
  /// In en, this message translates to:
  /// **'Sleeps {count}'**
  String hotelDetailRoomCapacity(int count);

  /// No description provided for @hotelDetailRoomBaseOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Base {count} guests'**
  String hotelDetailRoomBaseOccupancy(int count);

  /// No description provided for @hotelDetailRoomArea.
  ///
  /// In en, this message translates to:
  /// **'{size}㎡'**
  String hotelDetailRoomArea(Object size);

  /// No description provided for @hotelDetailBedrooms.
  ///
  /// In en, this message translates to:
  /// **'{count} bedrooms'**
  String hotelDetailBedrooms(int count);

  /// No description provided for @hotelDetailBathrooms.
  ///
  /// In en, this message translates to:
  /// **'{count} bathrooms'**
  String hotelDetailBathrooms(int count);

  /// No description provided for @hotelDetailBedSummary.
  ///
  /// In en, this message translates to:
  /// **'{name}: {quantity} beds {width}'**
  String hotelDetailBedSummary(Object name, int quantity, Object width);

  /// No description provided for @hotelRoomBedUnitDefault.
  ///
  /// In en, this message translates to:
  /// **'bed(s)'**
  String get hotelRoomBedUnitDefault;

  /// No description provided for @hotelRoomBedUnitFuton.
  ///
  /// In en, this message translates to:
  /// **'futon(s)'**
  String get hotelRoomBedUnitFuton;

  /// No description provided for @hotelRoomBedSummary.
  ///
  /// In en, this message translates to:
  /// **'{name}: {quantity} {unit}'**
  String hotelRoomBedSummary(Object name, int quantity, Object unit);

  /// No description provided for @hotelRoomBedSummaryWithWidth.
  ///
  /// In en, this message translates to:
  /// **'{summary} ({width})'**
  String hotelRoomBedSummaryWithWidth(Object summary, Object width);

  /// No description provided for @hotelRoomBedWidth.
  ///
  /// In en, this message translates to:
  /// **'width {width}cm'**
  String hotelRoomBedWidth(Object width);

  /// No description provided for @hotelRoomFacilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Room facilities'**
  String get hotelRoomFacilitiesTitle;

  /// No description provided for @hotelRoomDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Room details'**
  String get hotelRoomDescriptionTitle;

  /// No description provided for @hotelRoomFacilityGuestRoom.
  ///
  /// In en, this message translates to:
  /// **'Guest room'**
  String get hotelRoomFacilityGuestRoom;

  /// No description provided for @hotelRoomFacilityBathroomAmenities.
  ///
  /// In en, this message translates to:
  /// **'Bathroom amenities'**
  String get hotelRoomFacilityBathroomAmenities;

  /// No description provided for @hotelRoomFacilitySupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get hotelRoomFacilitySupplies;

  /// No description provided for @hotelRoomFacilityLending.
  ///
  /// In en, this message translates to:
  /// **'Lending items'**
  String get hotelRoomFacilityLending;

  /// No description provided for @hotelDetailPayableAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount due'**
  String get hotelDetailPayableAmount;

  /// No description provided for @hotelDetailTaxNote.
  ///
  /// In en, this message translates to:
  /// **'{nights} days · {rooms} rooms · Taxes included'**
  String hotelDetailTaxNote(int nights, int rooms);

  /// No description provided for @hotelDetailBookNow.
  ///
  /// In en, this message translates to:
  /// **'Book now'**
  String get hotelDetailBookNow;

  /// No description provided for @hotelDetailSelectRoomFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a room first'**
  String get hotelDetailSelectRoomFirst;

  /// No description provided for @hotelAssignOccupancyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the room quantity. Please try again.'**
  String get hotelAssignOccupancyFailed;

  /// No description provided for @hotelAssignOccupancyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get hotelAssignOccupancyDialogTitle;

  /// No description provided for @hotelAssignOccupancyDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get hotelAssignOccupancyDialogConfirm;

  /// No description provided for @hotelDetailBookingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking flow will be added later'**
  String get hotelDetailBookingComingSoon;

  /// No description provided for @hotelCurrencyCode.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get hotelCurrencyCode;

  /// No description provided for @hotelBookingConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation'**
  String get hotelBookingConfirmTitle;

  /// No description provided for @hotelBookingCheckInDate.
  ///
  /// In en, this message translates to:
  /// **'Check-in date'**
  String get hotelBookingCheckInDate;

  /// No description provided for @hotelBookingCheckOutDate.
  ///
  /// In en, this message translates to:
  /// **'Check-out date'**
  String get hotelBookingCheckOutDate;

  /// No description provided for @hotelBookingOfficialBooking.
  ///
  /// In en, this message translates to:
  /// **'Aparthotel · Room booking'**
  String get hotelBookingOfficialBooking;

  /// No description provided for @hotelBookingSelectedRooms.
  ///
  /// In en, this message translates to:
  /// **'Selected rooms:'**
  String get hotelBookingSelectedRooms;

  /// No description provided for @hotelBookingEditContent.
  ///
  /// In en, this message translates to:
  /// **'Change booking details'**
  String get hotelBookingEditContent;

  /// No description provided for @hotelBookingCouponOff.
  ///
  /// In en, this message translates to:
  /// **'Coupon available'**
  String get hotelBookingCouponOff;

  /// No description provided for @hotelBookingCoupons.
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get hotelBookingCoupons;

  /// No description provided for @hotelBookingCouponsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} available'**
  String hotelBookingCouponsAvailable(int count);

  /// No description provided for @hotelBookingNoCoupons.
  ///
  /// In en, this message translates to:
  /// **'None available'**
  String get hotelBookingNoCoupons;

  /// No description provided for @hotelBookingPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get hotelBookingPaymentTitle;

  /// No description provided for @hotelBookingCreditCardPay.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get hotelBookingCreditCardPay;

  /// No description provided for @hotelBookingRegisteredCards.
  ///
  /// In en, this message translates to:
  /// **'{count} saved cards'**
  String hotelBookingRegisteredCards(int count);

  /// No description provided for @hotelBookingAddCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Add credit card'**
  String get hotelBookingAddCreditCard;

  /// No description provided for @hotelBookingAlipay.
  ///
  /// In en, this message translates to:
  /// **'Alipay'**
  String get hotelBookingAlipay;

  /// No description provided for @hotelBookingWechatPay.
  ///
  /// In en, this message translates to:
  /// **'WechatPay'**
  String get hotelBookingWechatPay;

  /// No description provided for @hotelBookingBookerInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest booking information'**
  String get hotelBookingBookerInfoTitle;

  /// No description provided for @hotelBookingRoomGuestInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Room guest information'**
  String get hotelBookingRoomGuestInfoTitle;

  /// No description provided for @hotelBookingGuestName.
  ///
  /// In en, this message translates to:
  /// **'Guest name'**
  String get hotelBookingGuestName;

  /// No description provided for @hotelBookingLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get hotelBookingLastName;

  /// No description provided for @hotelBookingFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get hotelBookingFirstName;

  /// No description provided for @hotelBookingCountryRegion.
  ///
  /// In en, this message translates to:
  /// **'Country/region'**
  String get hotelBookingCountryRegion;

  /// No description provided for @hotelBookingEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get hotelBookingEmail;

  /// No description provided for @hotelBookingPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get hotelBookingPhoneNumber;

  /// No description provided for @hotelBookingAdults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get hotelBookingAdults;

  /// No description provided for @hotelBookingChildren.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get hotelBookingChildren;

  /// No description provided for @hotelBookingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get hotelBookingInvoice;

  /// No description provided for @hotelBookingUseGuestName.
  ///
  /// In en, this message translates to:
  /// **'Use the booking guest name by default'**
  String get hotelBookingUseGuestName;

  /// No description provided for @hotelBookingInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice title'**
  String get hotelBookingInvoiceTitle;

  /// No description provided for @hotelBookingMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking note'**
  String get hotelBookingMessageTitle;

  /// No description provided for @hotelBookingMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Special requests cannot be guaranteed, but we will do our best.'**
  String get hotelBookingMessageHint;

  /// No description provided for @hotelBookingConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm booking'**
  String get hotelBookingConfirmAction;

  /// No description provided for @hotelBookingRequiredFieldsMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter the required booker information.'**
  String get hotelBookingRequiredFieldsMissing;

  /// No description provided for @hotelBookingCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the pre-order. Please try again later.'**
  String get hotelBookingCreateFailed;

  /// No description provided for @hotelPaymentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment flow will be added later'**
  String get hotelPaymentComingSoon;

  /// No description provided for @hotelPaymentPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get hotelPaymentPageTitle;

  /// No description provided for @hotelPaymentOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get hotelPaymentOrderIdLabel;

  /// No description provided for @hotelPaymentSelectCreditCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Select credit card'**
  String get hotelPaymentSelectCreditCardTitle;

  /// No description provided for @hotelPaymentSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit card verification'**
  String get hotelPaymentSecureTitle;

  /// No description provided for @hotelPaymentNoCreditCard.
  ///
  /// In en, this message translates to:
  /// **'Please add a credit card first.'**
  String get hotelPaymentNoCreditCard;

  /// No description provided for @hotelPaymentCreditCardFailed.
  ///
  /// In en, this message translates to:
  /// **'Credit card payment failed. Please try again later.'**
  String get hotelPaymentCreditCardFailed;

  /// No description provided for @hotelPaymentCreditCardSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment completed. Please check your order.'**
  String get hotelPaymentCreditCardSuccess;

  /// No description provided for @hotelPaymentAddCreditCardAndPay.
  ///
  /// In en, this message translates to:
  /// **'Add credit card and pay'**
  String get hotelPaymentAddCreditCardAndPay;

  /// No description provided for @hotelPaymentExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment is not complete'**
  String get hotelPaymentExitTitle;

  /// No description provided for @hotelPaymentExitMessage.
  ///
  /// In en, this message translates to:
  /// **'Closing this page may interrupt the current payment process. Do you want to exit?'**
  String get hotelPaymentExitMessage;

  /// No description provided for @hotelPaymentExitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get hotelPaymentExitConfirm;

  /// No description provided for @hotelBookingResultAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking result'**
  String get hotelBookingResultAppBarTitle;

  /// No description provided for @hotelBookingResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your booking is not complete yet'**
  String get hotelBookingResultTitle;

  /// No description provided for @hotelBookingResultOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Reservation number'**
  String get hotelBookingResultOrderNumber;

  /// No description provided for @hotelBookingResultPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get hotelBookingResultPaymentMethod;

  /// No description provided for @hotelBookingResultPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get hotelBookingResultPaymentAmount;

  /// No description provided for @hotelBookingResultNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Please pay within 15 minutes'**
  String get hotelBookingResultNoticeTitle;

  /// No description provided for @hotelBookingResultNotice.
  ///
  /// In en, this message translates to:
  /// **'This page leads from Tanimachikun Travel to the payment information entry page. Press the button below to continue to payment. If payment is not completed within 15 minutes, the order will be cancelled.'**
  String get hotelBookingResultNotice;

  /// No description provided for @hotelBookingResultBackToOrders.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get hotelBookingResultBackToOrders;

  /// No description provided for @hotelBookingResultPay.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get hotelBookingResultPay;

  /// No description provided for @hotelOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get hotelOrdersTitle;

  /// No description provided for @hotelOrdersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get hotelOrdersFilterAll;

  /// No description provided for @hotelOrdersFilterAwaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get hotelOrdersFilterAwaitingPayment;

  /// No description provided for @hotelOrdersFilterBooked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get hotelOrdersFilterBooked;

  /// No description provided for @hotelOrdersFilterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get hotelOrdersFilterCancelled;

  /// No description provided for @hotelOrdersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get hotelOrdersEmpty;

  /// No description provided for @hotelOrdersLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get hotelOrdersLoadMore;

  /// No description provided for @hotelOrdersOrderNoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get hotelOrdersOrderNoPrefix;

  /// No description provided for @hotelOrdersAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Order amount'**
  String get hotelOrdersAmountLabel;

  /// No description provided for @hotelOrdersCheckInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get hotelOrdersCheckInLabel;

  /// No description provided for @hotelOrdersCheckOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get hotelOrdersCheckOutLabel;

  /// No description provided for @hotelOrdersRebookAction.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get hotelOrdersRebookAction;

  /// No description provided for @hotelOrdersCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get hotelOrdersCancelAction;

  /// No description provided for @hotelOrdersDetailAction.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get hotelOrdersDetailAction;

  /// No description provided for @hotelOrdersRebookComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Book-again flow will be added later'**
  String get hotelOrdersRebookComingSoon;

  /// No description provided for @hotelOrdersCancelComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cancellation will be connected later'**
  String get hotelOrdersCancelComingSoon;

  /// No description provided for @hotelOrdersDetailComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Order details will be added later'**
  String get hotelOrdersDetailComingSoon;

  /// No description provided for @hotelOrderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order detail'**
  String get hotelOrderDetailTitle;

  /// No description provided for @hotelOrderDetailBookingTypeRoom.
  ///
  /// In en, this message translates to:
  /// **'Room booking'**
  String get hotelOrderDetailBookingTypeRoom;

  /// No description provided for @hotelOrderDetailGuestCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get hotelOrderDetailGuestCountLabel;

  /// No description provided for @hotelOrderDetailTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get hotelOrderDetailTotalAmount;

  /// No description provided for @hotelOrderDetailCheckInGuide.
  ///
  /// In en, this message translates to:
  /// **'Check-in guide'**
  String get hotelOrderDetailCheckInGuide;

  /// No description provided for @hotelOrderDetailNoGuide.
  ///
  /// In en, this message translates to:
  /// **'No check-in guide yet'**
  String get hotelOrderDetailNoGuide;

  /// No description provided for @hotelOrderDetailGatePassword.
  ///
  /// In en, this message translates to:
  /// **'Gate password'**
  String get hotelOrderDetailGatePassword;

  /// No description provided for @hotelOrderDetailCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get hotelOrderDetailCopy;

  /// No description provided for @hotelOrderDetailCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get hotelOrderDetailCopied;

  /// No description provided for @hotelOrderDetailBookerInfo.
  ///
  /// In en, this message translates to:
  /// **'Booker information'**
  String get hotelOrderDetailBookerInfo;

  /// No description provided for @hotelOrderDetailGuestInfo.
  ///
  /// In en, this message translates to:
  /// **'Guest information'**
  String get hotelOrderDetailGuestInfo;

  /// No description provided for @hotelOrderDetailGuestBadge.
  ///
  /// In en, this message translates to:
  /// **'{count} guests'**
  String hotelOrderDetailGuestBadge(Object count);

  /// No description provided for @hotelOrderDetailCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Guest name'**
  String get hotelOrderDetailCustomerName;

  /// No description provided for @hotelOrderDetailNationality.
  ///
  /// In en, this message translates to:
  /// **'Country/region'**
  String get hotelOrderDetailNationality;

  /// No description provided for @hotelOrderDetailEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get hotelOrderDetailEmail;

  /// No description provided for @hotelOrderDetailPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get hotelOrderDetailPhone;

  /// No description provided for @hotelOrderDetailCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get hotelOrderDetailCreatedAt;

  /// No description provided for @hotelOrderDetailAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get hotelOrderDetailAdult;

  /// No description provided for @hotelOrderDetailRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room no.'**
  String get hotelOrderDetailRoomNumber;

  /// No description provided for @hotelOrderDetailLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get hotelOrderDetailLocation;

  /// No description provided for @hotelOrderDetailCancelPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get hotelOrderDetailCancelPolicy;

  /// No description provided for @hotelOrderDetailPayNow.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get hotelOrderDetailPayNow;

  /// No description provided for @hotelOrderDetailRefundRequest.
  ///
  /// In en, this message translates to:
  /// **'Request refund'**
  String get hotelOrderDetailRefundRequest;

  /// No description provided for @hotelOrderDetailNotCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Not checked in'**
  String get hotelOrderDetailNotCheckedIn;

  /// No description provided for @hotelOrderDetailCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get hotelOrderDetailCheckedIn;

  /// No description provided for @hotelOrderDetailMoreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More actions will be added later'**
  String get hotelOrderDetailMoreComingSoon;

  /// No description provided for @hotelOrderDetailPaymentComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Payment flow will be added later'**
  String get hotelOrderDetailPaymentComingSoon;

  /// No description provided for @hotelOrderDetailRefundComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Refund flow will be added later'**
  String get hotelOrderDetailRefundComingSoon;

  /// No description provided for @hotelOrderDetailPaymentInfo.
  ///
  /// In en, this message translates to:
  /// **'Order payment information'**
  String get hotelOrderDetailPaymentInfo;

  /// No description provided for @hotelOrderDetailOrderTime.
  ///
  /// In en, this message translates to:
  /// **'Order time'**
  String get hotelOrderDetailOrderTime;

  /// No description provided for @hotelOrderDetailOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get hotelOrderDetailOrderStatus;

  /// No description provided for @hotelOrderDetailCouponDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount amount'**
  String get hotelOrderDetailCouponDiscount;

  /// No description provided for @hotelOrderDetailCouponUnused.
  ///
  /// In en, this message translates to:
  /// **'No coupon used'**
  String get hotelOrderDetailCouponUnused;

  /// No description provided for @hotelOrderDetailPaidAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment amount'**
  String get hotelOrderDetailPaidAmount;

  /// No description provided for @hotelOrderDetailPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get hotelOrderDetailPaymentStatus;

  /// No description provided for @hotelOrderDetailReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get hotelOrderDetailReceiptTitle;

  /// No description provided for @hotelOrderDetailBookingComment.
  ///
  /// In en, this message translates to:
  /// **'Booking message'**
  String get hotelOrderDetailBookingComment;

  /// No description provided for @hotelOrderDetailRoomGuestCount.
  ///
  /// In en, this message translates to:
  /// **'Room guests'**
  String get hotelOrderDetailRoomGuestCount;

  /// No description provided for @hotelPaymentStatusNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Payment pending'**
  String get hotelPaymentStatusNotPaid;

  /// No description provided for @hotelPaymentStatusInvalidPaid.
  ///
  /// In en, this message translates to:
  /// **'Invalid payment'**
  String get hotelPaymentStatusInvalidPaid;

  /// No description provided for @hotelPaymentStatusPartialPay.
  ///
  /// In en, this message translates to:
  /// **'Partial payment'**
  String get hotelPaymentStatusPartialPay;

  /// No description provided for @hotelPaymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Payment completed'**
  String get hotelPaymentStatusPaid;

  /// No description provided for @hotelPaymentStatusOverpaid.
  ///
  /// In en, this message translates to:
  /// **'Overpaid'**
  String get hotelPaymentStatusOverpaid;

  /// No description provided for @hotelPaymentStatusNotRefunded.
  ///
  /// In en, this message translates to:
  /// **'Not refunded'**
  String get hotelPaymentStatusNotRefunded;

  /// No description provided for @hotelPaymentStatusRefunding.
  ///
  /// In en, this message translates to:
  /// **'Refund in progress'**
  String get hotelPaymentStatusRefunding;

  /// No description provided for @hotelPaymentStatusPartialRefunded.
  ///
  /// In en, this message translates to:
  /// **'Partial refund in progress'**
  String get hotelPaymentStatusPartialRefunded;

  /// No description provided for @hotelPaymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refund completed'**
  String get hotelPaymentStatusRefunded;

  /// No description provided for @hotelDetailNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No available rooms'**
  String get hotelDetailNoRooms;

  /// No description provided for @hotelDetailFacilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get hotelDetailFacilities;

  /// No description provided for @hotelDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Property details'**
  String get hotelDetailDescription;

  /// No description provided for @hotelDetailSurrounding.
  ///
  /// In en, this message translates to:
  /// **'Surroundings'**
  String get hotelDetailSurrounding;

  /// No description provided for @hotelDetailTravel.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get hotelDetailTravel;

  /// No description provided for @hotelDetailCheckInGuide.
  ///
  /// In en, this message translates to:
  /// **'Check-in guide'**
  String get hotelDetailCheckInGuide;

  /// No description provided for @hotelDetailPolicy.
  ///
  /// In en, this message translates to:
  /// **'House rules'**
  String get hotelDetailPolicy;

  /// No description provided for @hotelDetailRefundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get hotelDetailRefundPolicy;

  /// No description provided for @hotelDetailCheckInTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in/out time'**
  String get hotelDetailCheckInTime;

  /// No description provided for @hotelDetailCheckInAfter.
  ///
  /// In en, this message translates to:
  /// **'Check in after {time}'**
  String hotelDetailCheckInAfter(Object time);

  /// No description provided for @hotelDetailCheckOutBefore.
  ///
  /// In en, this message translates to:
  /// **'Check out before {time}'**
  String hotelDetailCheckOutBefore(Object time);

  /// No description provided for @hotelDetailContact.
  ///
  /// In en, this message translates to:
  /// **'Contact phone'**
  String get hotelDetailContact;

  /// No description provided for @hotelDetailShowMoreAction.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get hotelDetailShowMoreAction;

  /// No description provided for @hotelDetailAddress.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get hotelDetailAddress;

  /// No description provided for @hotelMapAppPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get hotelMapAppPickerTitle;

  /// No description provided for @hotelMapAppNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'This app is not installed.'**
  String get hotelMapAppNotInstalled;

  /// No description provided for @hotelDetailPerStay.
  ///
  /// In en, this message translates to:
  /// **' / {nights} nights'**
  String hotelDetailPerStay(int nights);

  /// No description provided for @hotelDetailDiscount.
  ///
  /// In en, this message translates to:
  /// **'{discount}% OFF'**
  String hotelDetailDiscount(Object discount);

  /// No description provided for @hotelDiscountBadgeValue.
  ///
  /// In en, this message translates to:
  /// **'{discount}%OFF'**
  String hotelDiscountBadgeValue(Object discount);

  /// No description provided for @hotelResultsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stays'**
  String hotelResultsCount(int count);

  /// No description provided for @hotelUnnamedProperty.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotelUnnamedProperty;

  /// No description provided for @hotelUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get hotelUnavailable;

  /// No description provided for @hotelPriceAsk.
  ///
  /// In en, this message translates to:
  /// **'Price on request'**
  String get hotelPriceAsk;

  /// No description provided for @hotelPricePerNight.
  ///
  /// In en, this message translates to:
  /// **' from / night'**
  String get hotelPricePerNight;

  /// No description provided for @hotelCardMeta.
  ///
  /// In en, this message translates to:
  /// **'{location} · Up to {count} guests'**
  String hotelCardMeta(Object location, int count);

  /// No description provided for @hotelRemainingRooms.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms left'**
  String hotelRemainingRooms(int count);

  /// No description provided for @hotelRemainingRoomsFew.
  ///
  /// In en, this message translates to:
  /// **'Only {count} rooms left'**
  String hotelRemainingRoomsFew(int count);

  /// No description provided for @hotelRemainingRoomsMany.
  ///
  /// In en, this message translates to:
  /// **'4+ rooms left'**
  String get hotelRemainingRoomsMany;

  /// No description provided for @hotelNoRooms.
  ///
  /// In en, this message translates to:
  /// **'No vacancy'**
  String get hotelNoRooms;

  /// No description provided for @hotelRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to refresh. Showing the previous results.'**
  String get hotelRefreshFailed;

  /// No description provided for @hotelLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load hotels.'**
  String get hotelLoadFailed;

  /// No description provided for @hotelEmptyResults.
  ///
  /// In en, this message translates to:
  /// **'No hotels match the current search.'**
  String get hotelEmptyResults;

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
  /// **'Only verified investors can post & comment'**
  String get kizunarkInvestorOnlyNotice;

  /// No description provided for @kizunarkComposePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Share your investment thoughts...'**
  String get kizunarkComposePlaceholder;

  /// No description provided for @kizunarkAssociateFundAction.
  ///
  /// In en, this message translates to:
  /// **'Link Fund'**
  String get kizunarkAssociateFundAction;

  /// No description provided for @kizunarkAssociateFundSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Fund to Link'**
  String get kizunarkAssociateFundSheetTitle;

  /// No description provided for @kizunarkAssociateFundEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active funds are available to link.'**
  String get kizunarkAssociateFundEmpty;

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

  /// No description provided for @kizunarkTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String kizunarkTimeMinutesAgo(int count);

  /// No description provided for @kizunarkTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String kizunarkTimeHoursAgo(int count);

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

  /// No description provided for @kizunarkSendFailedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get kizunarkSendFailedDialogTitle;

  /// No description provided for @kizunarkSendFailedDraftSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sending failed. It has been saved to drafts.'**
  String get kizunarkSendFailedDraftSavedMessage;

  /// No description provided for @kizunarkSendFailedRetryAction.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get kizunarkSendFailedRetryAction;

  /// No description provided for @kizunarkSendingQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'Sending {count} posts...'**
  String kizunarkSendingQueueTitle(int count);

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

  /// No description provided for @kizunarkGuestLoginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in or create an account to comment.'**
  String get kizunarkGuestLoginPrompt;

  /// No description provided for @kizunarkEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No posts yet. Start the first discussion.'**
  String get kizunarkEmptyState;

  /// No description provided for @kizunarkEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Share an investment topic'**
  String get kizunarkEntryTitle;

  /// No description provided for @kizunarkEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Attach related funds and photos'**
  String get kizunarkEntrySubtitle;

  /// No description provided for @kizunarkComposeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create post'**
  String get kizunarkComposeSheetTitle;

  /// No description provided for @kizunarkComposeCloseAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get kizunarkComposeCloseAction;

  /// No description provided for @kizunarkComposeAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Your investment topic'**
  String get kizunarkComposeAuthorLabel;

  /// No description provided for @kizunarkComposeDraftAction.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get kizunarkComposeDraftAction;

  /// No description provided for @kizunarkComposeDeleteDraftAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get kizunarkComposeDeleteDraftAction;

  /// No description provided for @kizunarkComposeSaveDraftAction.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get kizunarkComposeSaveDraftAction;

  /// No description provided for @kizunarkDraftListTitle.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get kizunarkDraftListTitle;

  /// No description provided for @kizunarkDraftEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet.'**
  String get kizunarkDraftEmptyState;

  /// No description provided for @kizunarkDraftLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load drafts.'**
  String get kizunarkDraftLoadError;

  /// No description provided for @kizunarkDraftDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get kizunarkDraftDeleteAction;

  /// No description provided for @kizunarkDraftDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete draft?'**
  String get kizunarkDraftDeleteConfirmTitle;

  /// No description provided for @kizunarkDraftDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This draft cannot be restored after deletion.'**
  String get kizunarkDraftDeleteConfirmBody;

  /// No description provided for @kizunarkDraftImageOnlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Image draft'**
  String get kizunarkDraftImageOnlyLabel;

  /// No description provided for @kizunarkDraftPostTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get kizunarkDraftPostTypeLabel;

  /// No description provided for @kizunarkDraftReplyTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get kizunarkDraftReplyTypeLabel;

  /// No description provided for @kizunarkDraftThreadUnavailableNotice.
  ///
  /// In en, this message translates to:
  /// **'The original message cannot be opened right now. Please refresh and try again.'**
  String get kizunarkDraftThreadUnavailableNotice;

  /// No description provided for @kizunarkComposeAudienceEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get kizunarkComposeAudienceEveryone;

  /// No description provided for @kizunarkComposeReplyPermissionEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone can reply'**
  String get kizunarkComposeReplyPermissionEveryone;

  /// No description provided for @kizunarkAddImageAction.
  ///
  /// In en, this message translates to:
  /// **'Add image'**
  String get kizunarkAddImageAction;

  /// No description provided for @kizunarkImageCounter.
  ///
  /// In en, this message translates to:
  /// **'{count} / 4'**
  String kizunarkImageCounter(int count);

  /// No description provided for @kizunarkReplySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create reply'**
  String get kizunarkReplySheetTitle;

  /// No description provided for @kizunarkReplyAuthorLabel.
  ///
  /// In en, this message translates to:
  /// **'Replying to {name}'**
  String kizunarkReplyAuthorLabel(String name);

  /// No description provided for @kizunarkReplyTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get kizunarkReplyTargetLabel;

  /// No description provided for @kizunarkRepliesTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} replies'**
  String kizunarkRepliesTitle(int count);

  /// No description provided for @kizunarkRepliesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get kizunarkRepliesSectionTitle;

  /// No description provided for @kizunarkWriteReplyAction.
  ///
  /// In en, this message translates to:
  /// **'Write a reply'**
  String get kizunarkWriteReplyAction;

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
  /// **'Member profile'**
  String get menuItemEditProfile;

  /// No description provided for @memberProfileOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Profile'**
  String get memberProfileOverviewTitle;

  /// No description provided for @memberProfileOverviewStatusEmailUnbound.
  ///
  /// In en, this message translates to:
  /// **'Email not linked'**
  String get memberProfileOverviewStatusEmailUnbound;

  /// No description provided for @memberProfileOverviewStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get memberProfileOverviewStatusIncomplete;

  /// No description provided for @memberProfileOverviewStatusUnverified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get memberProfileOverviewStatusUnverified;

  /// No description provided for @memberProfileOverviewStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get memberProfileOverviewStatusPending;

  /// No description provided for @memberProfileOverviewStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get memberProfileOverviewStatusFailed;

  /// No description provided for @memberProfileOverviewStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get memberProfileOverviewStatusVerified;

  /// No description provided for @memberProfileOverviewUnverifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete identity verification now (about 3 min)'**
  String get memberProfileOverviewUnverifiedTitle;

  /// No description provided for @memberProfileOverviewUnverifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'After identity verification, you can start investing with ¥3,000 in investment credit.'**
  String get memberProfileOverviewUnverifiedMessage;

  /// No description provided for @memberProfileOverviewFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get memberProfileOverviewFailedTitle;

  /// No description provided for @memberProfileOverviewFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Restart the member profile intake flow to verify again.'**
  String get memberProfileOverviewFailedMessage;

  /// No description provided for @memberProfileOverviewStartIntakeAction.
  ///
  /// In en, this message translates to:
  /// **'Go to profile intake'**
  String get memberProfileOverviewStartIntakeAction;

  /// No description provided for @commonEditText.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEditText;

  /// No description provided for @commonReplaceText.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonReplaceText;

  /// No description provided for @menuItemBankSettings.
  ///
  /// In en, this message translates to:
  /// **'Bank account settings'**
  String get menuItemBankSettings;

  /// No description provided for @menuItemCreditCardSettings.
  ///
  /// In en, this message translates to:
  /// **'Credit cards'**
  String get menuItemCreditCardSettings;

  /// No description provided for @creditCardListTitle.
  ///
  /// In en, this message translates to:
  /// **'Credit cards'**
  String get creditCardListTitle;

  /// No description provided for @creditCardSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add credit card'**
  String get creditCardSettingsTitle;

  /// No description provided for @creditCardAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add credit card'**
  String get creditCardAddAction;

  /// No description provided for @creditCardRegisteredSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Registered cards'**
  String get creditCardRegisteredSectionTitle;

  /// No description provided for @creditCardAddSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Card information'**
  String get creditCardAddSectionTitle;

  /// No description provided for @creditCardNoRegistered.
  ///
  /// In en, this message translates to:
  /// **'No registered credit cards.'**
  String get creditCardNoRegistered;

  /// No description provided for @creditCardMaskedCardFallback.
  ///
  /// In en, this message translates to:
  /// **'Card information'**
  String get creditCardMaskedCardFallback;

  /// No description provided for @creditCardDefaultChip.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get creditCardDefaultChip;

  /// No description provided for @creditCardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get creditCardNumberLabel;

  /// No description provided for @creditCardHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Card holder'**
  String get creditCardHolderLabel;

  /// No description provided for @creditCardExpiryLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get creditCardExpiryLabel;

  /// No description provided for @creditCardMonthHint.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get creditCardMonthHint;

  /// No description provided for @creditCardYearHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get creditCardYearHint;

  /// No description provided for @creditCardCvvLabel.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get creditCardCvvLabel;

  /// No description provided for @creditCardBankContactHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address or phone number registered with your bank.'**
  String get creditCardBankContactHint;

  /// No description provided for @creditCardBankEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank registered email'**
  String get creditCardBankEmailLabel;

  /// No description provided for @creditCardIntlCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get creditCardIntlCodeLabel;

  /// No description provided for @creditCardMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank registered mobile phone'**
  String get creditCardMobileLabel;

  /// No description provided for @creditCardDefaultPaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Use as the default payment card for future orders.'**
  String get creditCardDefaultPaymentLabel;

  /// No description provided for @creditCardBackAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get creditCardBackAction;

  /// No description provided for @creditCardSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save card information'**
  String get creditCardSaveAction;

  /// No description provided for @creditCardSaved.
  ///
  /// In en, this message translates to:
  /// **'Card information saved.'**
  String get creditCardSaved;

  /// No description provided for @creditCardValidationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter card information and a contact method.'**
  String get creditCardValidationRequired;

  /// No description provided for @creditCardTokenKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Card verification key is not configured.'**
  String get creditCardTokenKeyMissing;

  /// No description provided for @creditCardTokenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify card information.'**
  String get creditCardTokenFailed;

  /// No description provided for @creditCardPreviewCardHolder.
  ///
  /// In en, this message translates to:
  /// **'Card Holder'**
  String get creditCardPreviewCardHolder;

  /// No description provided for @creditCardPreviewFullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get creditCardPreviewFullName;

  /// No description provided for @creditCardPreviewExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get creditCardPreviewExpires;

  /// No description provided for @creditCardPreviewUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get creditCardPreviewUnknown;

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

  /// No description provided for @settingsTwoFactorDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage phone verification and real-person verification status for sensitive actions.'**
  String get settingsTwoFactorDescription;

  /// No description provided for @settingsEmailVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get settingsEmailVerificationTitle;

  /// No description provided for @settingsPhoneVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone verification'**
  String get settingsPhoneVerificationTitle;

  /// No description provided for @settingsFaceVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Face verification'**
  String get settingsFaceVerificationTitle;

  /// No description provided for @settingsVerificationStatusVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get settingsVerificationStatusVerified;

  /// No description provided for @settingsVerificationStatusUnverified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get settingsVerificationStatusUnverified;

  /// No description provided for @settingsVerificationEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified email'**
  String get settingsVerificationEmailLabel;

  /// No description provided for @settingsVerificationPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified number'**
  String get settingsVerificationPhoneLabel;

  /// No description provided for @settingsVerificationLastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last verified'**
  String get settingsVerificationLastUpdatedLabel;

  /// No description provided for @settingsEmailVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a verification code to your current email address and update the email verification status.'**
  String get settingsEmailVerificationDescription;

  /// No description provided for @settingsCurrentEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Current email address'**
  String get settingsCurrentEmailLabel;

  /// No description provided for @settingsEmailUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No email address registered.'**
  String get settingsEmailUnavailable;

  /// No description provided for @settingsEmailVerificationInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address to use for verification and send a verification code.'**
  String get settingsEmailVerificationInputDescription;

  /// No description provided for @settingsEmailAutoFillHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code from the email to complete verification.'**
  String get settingsEmailAutoFillHint;

  /// No description provided for @settingsEmailVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify email address'**
  String get settingsEmailVerifyAction;

  /// No description provided for @settingsEmailCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code first.'**
  String get settingsEmailCodeRequired;

  /// No description provided for @settingsEmailCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get settingsEmailCodeSent;

  /// No description provided for @settingsEmailVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email verification completed.'**
  String get settingsEmailVerificationSuccess;

  /// No description provided for @settingsEmailVerifiedReadonlyDescription.
  ///
  /// In en, this message translates to:
  /// **'A verified email address cannot be changed from this screen.'**
  String get settingsEmailVerifiedReadonlyDescription;

  /// No description provided for @settingsPhoneVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a one-time code to your registered phone number and update verification status on this device.'**
  String get settingsPhoneVerificationDescription;

  /// No description provided for @settingsCurrentPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Current phone number'**
  String get settingsCurrentPhoneLabel;

  /// No description provided for @settingsPhoneUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number registered.'**
  String get settingsPhoneUnavailable;

  /// No description provided for @settingsPhoneVerificationPhoneMissing.
  ///
  /// In en, this message translates to:
  /// **'Register a phone number in your member profile first.'**
  String get settingsPhoneVerificationPhoneMissing;

  /// No description provided for @settingsPhoneVerificationInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number to use for verification and send a one-time code.'**
  String get settingsPhoneVerificationInputDescription;

  /// No description provided for @settingsPhoneAutoFillHint.
  ///
  /// In en, this message translates to:
  /// **'On supported devices, the SMS verification code can appear as an autofill suggestion.'**
  String get settingsPhoneAutoFillHint;

  /// No description provided for @settingsPhoneVerifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify phone number'**
  String get settingsPhoneVerifyAction;

  /// No description provided for @settingsPhoneCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code first.'**
  String get settingsPhoneCodeRequired;

  /// No description provided for @settingsPhoneCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get settingsPhoneCodeSent;

  /// No description provided for @settingsPhoneVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone verification completed.'**
  String get settingsPhoneVerificationSuccess;

  /// No description provided for @settingsFaceVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable face verification on this device as a security measure. After setup, it will be used to confirm your identity for sensitive actions.'**
  String get settingsFaceVerificationDescription;

  /// No description provided for @settingsFaceVerificationUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a selfie'**
  String get settingsFaceVerificationUploadTitle;

  /// No description provided for @settingsFaceVerificationUploadDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a selfie for identity verification and face verification will start automatically. You can also retry it manually.'**
  String get settingsFaceVerificationUploadDescription;

  /// No description provided for @settingsFaceVerificationSelfieTitle.
  ///
  /// In en, this message translates to:
  /// **'Selfie for identity verification'**
  String get settingsFaceVerificationSelfieTitle;

  /// No description provided for @settingsFaceVerificationSelfieDescription.
  ///
  /// In en, this message translates to:
  /// **'Face the camera directly and make sure your full face is clearly visible.'**
  String get settingsFaceVerificationSelfieDescription;

  /// No description provided for @settingsFaceVerificationReverifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify again'**
  String get settingsFaceVerificationReverifyAction;

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

  /// No description provided for @menuItemContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get menuItemContactUs;

  /// No description provided for @menuItemOperatingCompany.
  ///
  /// In en, this message translates to:
  /// **'About the operator'**
  String get menuItemOperatingCompany;

  /// No description provided for @settingsContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get settingsContactTitle;

  /// No description provided for @settingsContactDescription.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or feedback, please feel free to contact us using the form below.'**
  String get settingsContactDescription;

  /// No description provided for @settingsContactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get settingsContactNameLabel;

  /// No description provided for @settingsContactKanaLabel.
  ///
  /// In en, this message translates to:
  /// **'Phonetic name'**
  String get settingsContactKanaLabel;

  /// No description provided for @settingsContactKanaFamilySegment.
  ///
  /// In en, this message translates to:
  /// **'SEI'**
  String get settingsContactKanaFamilySegment;

  /// No description provided for @settingsContactKanaGivenSegment.
  ///
  /// In en, this message translates to:
  /// **'MEI'**
  String get settingsContactKanaGivenSegment;

  /// No description provided for @settingsContactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get settingsContactEmailLabel;

  /// No description provided for @settingsContactEmailHint.
  ///
  /// In en, this message translates to:
  /// **'example@mail.com'**
  String get settingsContactEmailHint;

  /// No description provided for @settingsContactCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Inquiry category'**
  String get settingsContactCategoryLabel;

  /// No description provided for @settingsContactCategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get settingsContactCategoryPlaceholder;

  /// No description provided for @settingsContactCategoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'About investment'**
  String get settingsContactCategoryInvestment;

  /// No description provided for @settingsContactCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'About account or login'**
  String get settingsContactCategoryAccount;

  /// No description provided for @settingsContactCategoryWallet.
  ///
  /// In en, this message translates to:
  /// **'About distributions or deposits and withdrawals'**
  String get settingsContactCategoryWallet;

  /// No description provided for @settingsContactCategoryEkyc.
  ///
  /// In en, this message translates to:
  /// **'About identity verification (eKYC)'**
  String get settingsContactCategoryEkyc;

  /// No description provided for @settingsContactCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settingsContactCategoryOther;

  /// No description provided for @settingsContactMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get settingsContactMessageLabel;

  /// No description provided for @settingsContactMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your inquiry'**
  String get settingsContactMessageHint;

  /// No description provided for @settingsContactConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get settingsContactConfirmAction;

  /// No description provided for @settingsContactConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm inquiry details'**
  String get settingsContactConfirmTitle;

  /// No description provided for @settingsContactSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get settingsContactSubmitAction;

  /// No description provided for @settingsContactSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your inquiry has been received.'**
  String get settingsContactSubmitSuccess;

  /// No description provided for @settingsContactSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Your inquiry has been\nreceived'**
  String get settingsContactSuccessTitle;

  /// No description provided for @settingsContactSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us.\nWe have sent a confirmation email. Please check your inbox.\nAfter reviewing your inquiry, we will generally reply within three business days.'**
  String get settingsContactSuccessBody;

  /// No description provided for @settingsContactSuccessBackAction.
  ///
  /// In en, this message translates to:
  /// **'Back to top page'**
  String get settingsContactSuccessBackAction;

  /// No description provided for @settingsContactPhoneSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone inquiries'**
  String get settingsContactPhoneSectionTitle;

  /// No description provided for @settingsContactPhoneHours.
  ///
  /// In en, this message translates to:
  /// **'Business hours: Weekdays 10:00–18:00 (excluding weekends and holidays)'**
  String get settingsContactPhoneHours;

  /// No description provided for @settingsContactCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone app.'**
  String get settingsContactCallFailed;

  /// No description provided for @settingsCompanyMailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the mail app.'**
  String get settingsCompanyMailFailed;

  /// No description provided for @settingsContactValidationName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your family name and given name.'**
  String get settingsContactValidationName;

  /// No description provided for @settingsContactValidationKana.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phonetic name.'**
  String get settingsContactValidationKana;

  /// No description provided for @settingsContactValidationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get settingsContactValidationEmail;

  /// No description provided for @settingsContactValidationCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select an inquiry category.'**
  String get settingsContactValidationCategory;

  /// No description provided for @settingsContactValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message.'**
  String get settingsContactValidationMessage;

  /// No description provided for @settingsOperatingCompanyTitle.
  ///
  /// In en, this message translates to:
  /// **'Operating company'**
  String get settingsOperatingCompanyTitle;

  /// No description provided for @settingsContractListDescription.
  ///
  /// In en, this message translates to:
  /// **'Review contract documents and reports for your invested projects.'**
  String get settingsContractListDescription;

  /// No description provided for @settingsContractListEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No contract documents available.'**
  String get settingsContractListEmptyState;

  /// No description provided for @settingsContractListPdfCount.
  ///
  /// In en, this message translates to:
  /// **'{count} PDFs'**
  String settingsContractListPdfCount(Object count);

  /// No description provided for @settingsContractListDocumentTypeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} document types'**
  String settingsContractListDocumentTypeCount(Object count);

  /// No description provided for @settingsContractListLatestUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get settingsContractListLatestUpdatedLabel;

  /// No description provided for @settingsContractListPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'PDF pending'**
  String get settingsContractListPendingLabel;

  /// No description provided for @settingsContractDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract documents'**
  String get settingsContractDetailTitle;

  /// No description provided for @settingsContractDetailRelatedFilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Related PDFs'**
  String get settingsContractDetailRelatedFilesTitle;

  /// No description provided for @settingsContractDetailMissingProject.
  ///
  /// In en, this message translates to:
  /// **'Contract document details could not be found.'**
  String get settingsContractDetailMissingProject;

  /// No description provided for @settingsContractDetailNoPdfAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are no PDFs available yet.'**
  String get settingsContractDetailNoPdfAvailable;

  /// No description provided for @settingsCompanyTradeNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Trade name'**
  String get settingsCompanyTradeNameLabel;

  /// No description provided for @settingsCompanyLicenseNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'License number'**
  String get settingsCompanyLicenseNumberLabel;

  /// No description provided for @settingsCompanyLicenseTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'License type'**
  String get settingsCompanyLicenseTypeLabel;

  /// No description provided for @settingsCompanyRepresentativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get settingsCompanyRepresentativeLabel;

  /// No description provided for @settingsCompanyHeadOfficeLabel.
  ///
  /// In en, this message translates to:
  /// **'Head office'**
  String get settingsCompanyHeadOfficeLabel;

  /// No description provided for @settingsCompanyTelLabel.
  ///
  /// In en, this message translates to:
  /// **'TEL'**
  String get settingsCompanyTelLabel;

  /// No description provided for @settingsCompanyEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get settingsCompanyEmailLabel;

  /// No description provided for @settingsCompanyEstablishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Established'**
  String get settingsCompanyEstablishedLabel;

  /// No description provided for @settingsCompanyBusinessLabel.
  ///
  /// In en, this message translates to:
  /// **'Main business'**
  String get settingsCompanyBusinessLabel;

  /// No description provided for @settingsCompanyManagerLabel.
  ///
  /// In en, this message translates to:
  /// **'Business manager'**
  String get settingsCompanyManagerLabel;

  /// No description provided for @settingsCompanyRelatedLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Related links'**
  String get settingsCompanyRelatedLinksTitle;

  /// No description provided for @settingsCompanyLinkTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsCompanyLinkTerms;

  /// No description provided for @settingsCompanyLinkPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsCompanyLinkPrivacy;

  /// No description provided for @settingsCompanyLinkSolicitation.
  ///
  /// In en, this message translates to:
  /// **'Solicitation policy'**
  String get settingsCompanyLinkSolicitation;

  /// No description provided for @settingsCompanyLinkAntiSocial.
  ///
  /// In en, this message translates to:
  /// **'Anti-social forces policy'**
  String get settingsCompanyLinkAntiSocial;

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

  /// No description provided for @settingsDeleteAccountSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccountSupportTitle;

  /// No description provided for @settingsDeleteAccountSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not available in the app yet. Please contact customer support by phone.'**
  String get settingsDeleteAccountSupportMessage;

  /// No description provided for @settingsDeleteAccountCallAction.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get settingsDeleteAccountCallAction;

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

  /// No description provided for @settingsLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get settingsLogoutConfirmTitle;

  /// No description provided for @settingsLogoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue using this account.'**
  String get settingsLogoutConfirmBody;

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

  /// No description provided for @uiErrorNetworkAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Unable to access the network. Check your connection or system settings.'**
  String get uiErrorNetworkAccessDenied;

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
  /// **'Key facts'**
  String get fundDetailKeyFactsTitle;

  /// No description provided for @fundDetailScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Offering & Operation Schedule'**
  String get fundDetailScheduleTitle;

  /// No description provided for @fundDetailTargetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get fundDetailTargetAmountLabel;

  /// No description provided for @fundDetailInvestmentUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment unit'**
  String get fundDetailInvestmentUnitLabel;

  /// No description provided for @fundDetailMaximumInvestmentPerPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum per investor'**
  String get fundDetailMaximumInvestmentPerPersonLabel;

  /// No description provided for @fundDetailFundTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Fund size'**
  String get fundDetailFundTotalLabel;

  /// No description provided for @fundDetailOfferCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Offering category'**
  String get fundDetailOfferCategoryLabel;

  /// No description provided for @fundDetailRemainingDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days remaining'**
  String get fundDetailRemainingDaysLabel;

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

  /// No description provided for @fundDetailDistributionDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Distribution Date'**
  String get fundDetailDistributionDateLabel;

  /// No description provided for @fundDetailLotteryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Lottery date'**
  String get fundDetailLotteryDateLabel;

  /// No description provided for @fundDetailOfferingTargetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Offering targets'**
  String get fundDetailOfferingTargetsLabel;

  /// No description provided for @fundDetailPreferredStructureTitle.
  ///
  /// In en, this message translates to:
  /// **'Senior/Junior Structure'**
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
  /// **'Property details'**
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
  /// **'Contract Summary'**
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
  /// **'Operator information'**
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
  /// **'Related documents'**
  String get fundDetailDocumentsTitle;

  /// No description provided for @fundDetailDocumentReady.
  ///
  /// In en, this message translates to:
  /// **'Tap to review'**
  String get fundDetailDocumentReady;

  /// No description provided for @fundDetailDocumentMultipleReady.
  ///
  /// In en, this message translates to:
  /// **'{count} PDF files'**
  String fundDetailDocumentMultipleReady(int count);

  /// No description provided for @fundDetailDocumentSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select document'**
  String get fundDetailDocumentSelectTitle;

  /// No description provided for @fundDetailDocumentPickerItem.
  ///
  /// In en, this message translates to:
  /// **'Document {index}'**
  String fundDetailDocumentPickerItem(int index);

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
  /// **'Investor voices (KIZUNARK)'**
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
  /// **'View more in KIZUNARK'**
  String get fundDetailCommentsMoreAction;

  /// No description provided for @fundDetailFinancialStatusAction.
  ///
  /// In en, this message translates to:
  /// **'View operator financial status →'**
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
  /// **'1. Enter units'**
  String get lotteryApplyStep1Title;

  /// No description provided for @lotteryApplyStep1BalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Standby cash balance'**
  String get lotteryApplyStep1BalanceLabel;

  /// No description provided for @lotteryApplyStep1DepositAction.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get lotteryApplyStep1DepositAction;

  /// No description provided for @lotteryApplyStep1AmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Units to apply (1 unit = ¥100,000)'**
  String get lotteryApplyStep1AmountLabel;

  /// No description provided for @lotteryApplyStep1AmountLabelWithRules.
  ///
  /// In en, this message translates to:
  /// **'Units to apply (1 unit = {unitAmount} / max {maxAmount})'**
  String lotteryApplyStep1AmountLabelWithRules(
    Object unitAmount,
    Object maxAmount,
  );

  /// No description provided for @lotteryApplyStep1UnitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per unit'**
  String get lotteryApplyStep1UnitPriceLabel;

  /// No description provided for @lotteryApplyStep1UnitCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get lotteryApplyStep1UnitCountLabel;

  /// No description provided for @lotteryApplyStep1UnitSuffix.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get lotteryApplyStep1UnitSuffix;

  /// No description provided for @lotteryApplyStep1TotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Order total'**
  String get lotteryApplyStep1TotalAmountLabel;

  /// No description provided for @lotteryApplyStep1MaximumUnitsNotice.
  ///
  /// In en, this message translates to:
  /// **'You can apply for up to {maxUnits} units.'**
  String lotteryApplyStep1MaximumUnitsNotice(Object maxUnits);

  /// No description provided for @lotteryApplyStep1MinimumUnitsNotice.
  ///
  /// In en, this message translates to:
  /// **'The minimum order is {minUnits} unit.'**
  String lotteryApplyStep1MinimumUnitsNotice(Object minUnits);

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
  /// **'Go to deposit'**
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

  /// No description provided for @lotteryApplyStep2OpenDocumentFirstNotice.
  ///
  /// In en, this message translates to:
  /// **'Please open and review the document first.'**
  String get lotteryApplyStep2OpenDocumentFirstNotice;

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
  /// **'Submit lottery application'**
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
  /// **'Your lottery application for \"{projectName}\" has been completed. and you\'ll receive a notification in the app.'**
  String lotteryApplyStep4Body(Object projectName);

  /// No description provided for @lotteryApplyResultAnnouncementDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Result announcement date'**
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
  /// **'View lottery result →'**
  String get lotteryApplyDemoCheckResultAction;

  /// No description provided for @lotteryApplyStep5Headline.
  ///
  /// In en, this message translates to:
  /// **'Selection notice'**
  String get lotteryApplyStep5Headline;

  /// No description provided for @lotteryApplyStep5Body.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You were selected in the \"{projectName}\" lottery. Please transfer funds to the designated account.'**
  String lotteryApplyStep5Body(Object projectName);

  /// No description provided for @lotteryApplyDeadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment deadline (includes 8-day cooling-off)'**
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

  /// No description provided for @lotteryApplyReportDepositSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment completion report sent.'**
  String get lotteryApplyReportDepositSuccess;

  /// No description provided for @lotteryApplyReportDepositFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the payment completion report. Please try again later.'**
  String get lotteryApplyReportDepositFailure;

  /// No description provided for @lotteryApplyStandbyBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Standby cash balance'**
  String get lotteryApplyStandbyBalanceLabel;

  /// No description provided for @lotteryApplyStandbyPurchaseAction.
  ///
  /// In en, this message translates to:
  /// **'Purchase with standby cash'**
  String get lotteryApplyStandbyPurchaseAction;

  /// No description provided for @lotteryApplyStandbyPurchaseConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase with standby cash?'**
  String get lotteryApplyStandbyPurchaseConfirmTitle;

  /// No description provided for @lotteryApplyStandbyPurchaseConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Project: {projectName}\nTransaction amount: {amount}'**
  String lotteryApplyStandbyPurchaseConfirmBody(
    Object projectName,
    Object amount,
  );

  /// No description provided for @lotteryApplyStandbyPurchaseConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get lotteryApplyStandbyPurchaseConfirmAction;

  /// No description provided for @lotteryApplyStandbyPurchaseMissingProcess.
  ///
  /// In en, this message translates to:
  /// **'Unable to confirm the purchase information. Please refresh and try again.'**
  String get lotteryApplyStandbyPurchaseMissingProcess;

  /// No description provided for @lotteryApplyStandbyShortageLabel.
  ///
  /// In en, this message translates to:
  /// **'Shortage'**
  String get lotteryApplyStandbyShortageLabel;

  /// No description provided for @lotteryApplyStandbyPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchased with standby cash.'**
  String get lotteryApplyStandbyPurchaseSuccess;

  /// No description provided for @lotteryApplyStandbyPurchaseFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to purchase with standby cash.'**
  String get lotteryApplyStandbyPurchaseFailure;

  /// No description provided for @lotteryApplyDepositReportConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'We have received your payment completion notice.'**
  String get lotteryApplyDepositReportConfirmedTitle;

  /// No description provided for @lotteryApplyDepositReportConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your response.\nWe will review the details and proceed as quickly as possible.'**
  String get lotteryApplyDepositReportConfirmedBody;

  /// No description provided for @lotteryApplyDepositReportBackAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get lotteryApplyDepositReportBackAction;

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

  /// No description provided for @lotteryApplyCopyAccountInfoAction.
  ///
  /// In en, this message translates to:
  /// **'Copy account info'**
  String get lotteryApplyCopyAccountInfoAction;

  /// No description provided for @lotteryApplyCopyDoneToast.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get lotteryApplyCopyDoneToast;

  /// No description provided for @walletDepositTransferNameCopyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy payer name'**
  String get walletDepositTransferNameCopyAction;

  /// No description provided for @lotteryApplyStep6Headline.
  ///
  /// In en, this message translates to:
  /// **'Investment process completed'**
  String get lotteryApplyStep6Headline;

  /// No description provided for @lotteryApplyStep6Body.
  ///
  /// In en, this message translates to:
  /// **'We have confirmed your payment. \nDistribution schedules will be sent via notifications.'**
  String get lotteryApplyStep6Body;

  /// No description provided for @lotteryApplyReceiptLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt No:'**
  String get lotteryApplyReceiptLabel;

  /// No description provided for @fundApplyVerificationRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification required'**
  String get fundApplyVerificationRequiredTitle;

  /// No description provided for @fundApplyVerificationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Fund applications are available only to verified members. Please complete verification first.'**
  String get fundApplyVerificationRequiredMessage;

  /// No description provided for @fundDetailUnknownValue.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get fundDetailUnknownValue;

  /// No description provided for @fundDetailProductSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Summary'**
  String get fundDetailProductSummaryTitle;

  /// No description provided for @fundDetailFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get fundDetailFeaturesTitle;

  /// No description provided for @fundDetailReferenceVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Reference video'**
  String get fundDetailReferenceVideoTitle;

  /// No description provided for @fundDetailReferenceVideoLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the video.'**
  String get fundDetailReferenceVideoLoadError;

  /// No description provided for @fundDetailReferenceVideoOpenInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Play in browser'**
  String get fundDetailReferenceVideoOpenInBrowser;

  /// No description provided for @fundDetailReferenceVideoExternalHint.
  ///
  /// In en, this message translates to:
  /// **'This video opens on an external page.'**
  String get fundDetailReferenceVideoExternalHint;

  /// No description provided for @fundDetailReferenceVideoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the video page.'**
  String get fundDetailReferenceVideoOpenFailed;

  /// No description provided for @fundDetailReferenceVideoPlayAction.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get fundDetailReferenceVideoPlayAction;

  /// No description provided for @fundDetailInvestmentUnitValue.
  ///
  /// In en, this message translates to:
  /// **'{amount}円 / 1 unit'**
  String fundDetailInvestmentUnitValue(Object amount);

  /// No description provided for @fundDetailMaximumInvestmentPerPersonValue.
  ///
  /// In en, this message translates to:
  /// **'{amount}円 / {units} units'**
  String fundDetailMaximumInvestmentPerPersonValue(Object amount, Object units);

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
  /// **'Funding achievement rate'**
  String get fundDetailAchievementRateLabel;

  /// No description provided for @fundDetailGainTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Type of Return'**
  String get fundDetailGainTypeTitle;

  /// No description provided for @fundDetailSubordinatedRatioLabel.
  ///
  /// In en, this message translates to:
  /// **'Subordinated investment ratio'**
  String get fundDetailSubordinatedRatioLabel;

  /// No description provided for @fundDetailDistributionInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution details'**
  String get fundDetailDistributionInfoTitle;

  /// No description provided for @fundDetailDistributionCalculationPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Distribution calculation period'**
  String get fundDetailDistributionCalculationPeriodLabel;

  /// No description provided for @fundDetailDistributionCalculationPeriodSeason.
  ///
  /// In en, this message translates to:
  /// **'Calculated for each natural quarter. A natural quarter means each period from January 1 to March 31, April 1 to June 30, July 1 to September 30, and October 1 to December 31 of every year.'**
  String get fundDetailDistributionCalculationPeriodSeason;

  /// No description provided for @fundDetailDistributionCalculationPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'Calculated for each natural year. A natural year means the period from January 1 to December 31 of every year.'**
  String get fundDetailDistributionCalculationPeriodYear;

  /// No description provided for @fundDetailDistributionScheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned distribution'**
  String get fundDetailDistributionScheduleLabel;

  /// No description provided for @fundDetailDistributionScheduleDefault.
  ///
  /// In en, this message translates to:
  /// **'By the last business day of the corresponding month, two months after each calculation period'**
  String get fundDetailDistributionScheduleDefault;

  /// No description provided for @fundDetailGainTypeDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'About the Type of Return'**
  String get fundDetailGainTypeDescriptionTitle;

  /// No description provided for @fundDetailGainTypeIncomeGainTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Income Gain'**
  String get fundDetailGainTypeIncomeGainTitle;

  /// No description provided for @fundDetailGainTypeIncomeGainBody.
  ///
  /// In en, this message translates to:
  /// **'Meaning: Regular income generated from held assets\n\nFeatures: Stable cash flow received monthly or quarterly\n\nExamples: Rental income from real estate, revenue from minpaku and hotel operations'**
  String get fundDetailGainTypeIncomeGainBody;

  /// No description provided for @fundDetailGainTypeCapitalGainTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Capital Gain'**
  String get fundDetailGainTypeCapitalGainTitle;

  /// No description provided for @fundDetailGainTypeCapitalGainBody.
  ///
  /// In en, this message translates to:
  /// **'Meaning: Profit earned by selling an asset after its price increases\n\nFeatures: One-time profit realized when the asset is sold\n\nExamples: Profit from real estate sales'**
  String get fundDetailGainTypeCapitalGainBody;

  /// No description provided for @fundDetailGainTypeMixedTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Mixed (Income + Capital)'**
  String get fundDetailGainTypeMixedTitle;

  /// No description provided for @fundDetailGainTypeMixedBody.
  ///
  /// In en, this message translates to:
  /// **'Meaning: A strategy that targets both income gain and capital gain\n\nFeatures: Can expect both stable income such as dividends or interest and upside from price appreciation\n\nExamples: Rental income + profit from property sales'**
  String get fundDetailGainTypeMixedBody;

  /// No description provided for @fundDetailTabPropertyOverview.
  ///
  /// In en, this message translates to:
  /// **'Property overview'**
  String get fundDetailTabPropertyOverview;

  /// No description provided for @fundDetailTabIncomeScheme.
  ///
  /// In en, this message translates to:
  /// **'Income scheme'**
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
  /// **'Income'**
  String get fundDetailSchemeIncomeTitle;

  /// No description provided for @fundDetailSchemeExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
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

  /// No description provided for @fundDetailSchemeCurrencyUnit.
  ///
  /// In en, this message translates to:
  /// **' JPY'**
  String get fundDetailSchemeCurrencyUnit;

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

  /// No description provided for @myPageWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get myPageWelcomeBack;

  /// No description provided for @myPageTotalAssetsCaption.
  ///
  /// In en, this message translates to:
  /// **'Operating + standby cash'**
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

  /// No description provided for @myPageAssetTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Trend'**
  String get myPageAssetTrendTitle;

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
  /// **'Pending Applications'**
  String get myPagePendingApplicationsTitle;

  /// No description provided for @myPageCoolingOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Cooling-off Period'**
  String get myPageCoolingOffTitle;

  /// No description provided for @myPageOrderInquirySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell Order Inquiry'**
  String get myPageOrderInquirySectionTitle;

  /// No description provided for @myPageOrderInquiryListTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Inquiry'**
  String get myPageOrderInquiryListTitle;

  /// No description provided for @myPageOperatingFundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Funds'**
  String get myPageOperatingFundsTitle;

  /// No description provided for @myPageInvestmentStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment Status'**
  String get myPageInvestmentStatusTitle;

  /// No description provided for @myPageLicenseNotice.
  ///
  /// In en, this message translates to:
  /// **'Osaka Prefectural Governor Permit No. 22 (Official Permit) \n Type I, Type II, and Electronic Transaction Services'**
  String get myPageLicenseNotice;

  /// No description provided for @myPageActiveFundHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'MY FUND'**
  String get myPageActiveFundHeroEyebrow;

  /// No description provided for @myPageTransactionHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get myPageTransactionHistoryAction;

  /// No description provided for @myPageApplyAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Application amount'**
  String get myPageApplyAmountLabel;

  /// No description provided for @myPageApplyUnitsAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Application units / amount'**
  String get myPageApplyUnitsAmountLabel;

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

  /// No description provided for @myPageOrderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Order time'**
  String get myPageOrderTimeLabel;

  /// No description provided for @myPageOrderInvestorTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Investor type'**
  String get myPageOrderInvestorTypeLabel;

  /// No description provided for @myPageOrderUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Ordered / Filled units'**
  String get myPageOrderUnitsLabel;

  /// No description provided for @myPageOrderUnitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Order unit price'**
  String get myPageOrderUnitPriceLabel;

  /// No description provided for @myPageOrderInquiryStatusExecuting.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get myPageOrderInquiryStatusExecuting;

  /// No description provided for @myPageOrderInquiryStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get myPageOrderInquiryStatusPending;

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

  /// No description provided for @myPageCancelOrderAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get myPageCancelOrderAction;

  /// No description provided for @myPageCancelRequestComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cancellation flow will be connected in a later implementation.'**
  String get myPageCancelRequestComingSoon;

  /// No description provided for @myPageWithdrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw this request?'**
  String get myPageWithdrawConfirmTitle;

  /// No description provided for @myPageWithdrawApplyConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This application will be withdrawn. Do you want to continue?'**
  String get myPageWithdrawApplyConfirmBody;

  /// No description provided for @myPageWithdrawOrderConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This resale order will be withdrawn. Do you want to continue?'**
  String get myPageWithdrawOrderConfirmBody;

  /// No description provided for @myPageWithdrawConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get myPageWithdrawConfirmAction;

  /// No description provided for @myPageWithdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your withdrawal request has been accepted.'**
  String get myPageWithdrawSuccess;

  /// No description provided for @myPageWithdrawFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to withdraw. Please try again later.'**
  String get myPageWithdrawFailure;

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

  /// No description provided for @walletDepositDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit Details'**
  String get walletDepositDetailTitle;

  /// No description provided for @walletHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Deposit History'**
  String get walletHistoryTitle;

  /// No description provided for @walletTransactionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get walletTransactionHistoryTitle;

  /// No description provided for @walletHistoryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get walletHistoryFilterAll;

  /// No description provided for @walletHistoryFilterDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get walletHistoryFilterDeposit;

  /// No description provided for @walletHistoryFilterWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get walletHistoryFilterWithdraw;

  /// No description provided for @walletDedicatedAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Dedicated Deposit Account'**
  String get walletDedicatedAccountTitle;

  /// No description provided for @walletProjectDepositAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Deposit Account'**
  String get walletProjectDepositAccountTitle;

  /// No description provided for @walletProjectOverseasDepositAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Overseas Deposit Account'**
  String get walletProjectOverseasDepositAccountTitle;

  /// No description provided for @walletProjectDomesticDepositSegment.
  ///
  /// In en, this message translates to:
  /// **'Japanese transfer'**
  String get walletProjectDomesticDepositSegment;

  /// No description provided for @walletProjectOverseasDepositSegment.
  ///
  /// In en, this message translates to:
  /// **'Overseas transfer'**
  String get walletProjectOverseasDepositSegment;

  /// No description provided for @walletProjectDepositBankInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Bank information'**
  String get walletProjectDepositBankInfoSection;

  /// No description provided for @walletProjectDepositRecipientInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Recipient information'**
  String get walletProjectDepositRecipientInfoSection;

  /// No description provided for @walletProjectDepositSwiftCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'SWIFT Code'**
  String get walletProjectDepositSwiftCodeLabel;

  /// No description provided for @walletProjectDepositBranchAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank address'**
  String get walletProjectDepositBranchAddressLabel;

  /// No description provided for @walletProjectDepositAccountHolderAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get walletProjectDepositAccountHolderAddressLabel;

  /// No description provided for @walletPaymentConfirmationSentNotice.
  ///
  /// In en, this message translates to:
  /// **'A payment notification has already been sent. You do not need to send it again.'**
  String get walletPaymentConfirmationSentNotice;

  /// No description provided for @walletPaymentConfirmationSentAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification time'**
  String get walletPaymentConfirmationSentAtLabel;

  /// No description provided for @walletDedicatedAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'This is your dedicated deposit account. Deposits are reflected automatically (minimum: ¥10,000). If unused for 3 months, the account may be changed.'**
  String get walletDedicatedAccountDescription;

  /// No description provided for @walletDepositTransferNotice.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer fees for investment deposits are borne by the customer. Deposits under a name other than your own cannot be accepted.\n* When making a transfer, please enter\n【{accountId}】 in the payer name or remarks.'**
  String walletDepositTransferNotice(Object accountId);

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

  /// No description provided for @walletStandbyBalanceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Standby Balance Transaction History'**
  String get walletStandbyBalanceHistoryTitle;

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

  /// No description provided for @walletBankSettingsRegisteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Registered Accounts'**
  String get walletBankSettingsRegisteredTitle;

  /// No description provided for @walletBankSettingsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No bank account has been registered yet. Add one to continue.'**
  String get walletBankSettingsEmptyMessage;

  /// No description provided for @walletBankSettingsAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get walletBankSettingsAddAction;

  /// No description provided for @walletBankSettingsAddSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Bank Account'**
  String get walletBankSettingsAddSheetTitle;

  /// No description provided for @walletBankSettingsAddSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the bank account information used for transfers.'**
  String get walletBankSettingsAddSheetDescription;

  /// No description provided for @walletBankSettingsAddEntrySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an account type'**
  String get walletBankSettingsAddEntrySheetTitle;

  /// No description provided for @walletBankSettingsAddDomesticOption.
  ///
  /// In en, this message translates to:
  /// **'Bank in Japan'**
  String get walletBankSettingsAddDomesticOption;

  /// No description provided for @walletBankSettingsAddOverseasOption.
  ///
  /// In en, this message translates to:
  /// **'Bank outside Japan'**
  String get walletBankSettingsAddOverseasOption;

  /// No description provided for @walletBankSettingsOverseasAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Overseas Bank Account'**
  String get walletBankSettingsOverseasAddTitle;

  /// No description provided for @walletBankSettingsOverseasAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the overseas bank account information used for transfers.'**
  String get walletBankSettingsOverseasAddDescription;

  /// No description provided for @walletBankSettingsCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get walletBankSettingsCancelAction;

  /// No description provided for @walletBankSettingsAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bank account added.'**
  String get walletBankSettingsAddSuccess;

  /// No description provided for @walletBankSettingsAddFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to add bank account. Please try again later.'**
  String get walletBankSettingsAddFailure;

  /// No description provided for @walletBankSettingsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get walletBankSettingsRequiredError;

  /// No description provided for @walletBankSettingsAccountHolderMismatchError.
  ///
  /// In en, this message translates to:
  /// **'The account holder name does not match your verified name.'**
  String get walletBankSettingsAccountHolderMismatchError;

  /// No description provided for @walletBankSettingsDomesticTip.
  ///
  /// In en, this message translates to:
  /// **'The withdrawal fee for domestic bank accounts is JPY 1,000.'**
  String get walletBankSettingsDomesticTip;

  /// No description provided for @walletBankSettingsOverseasBankNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example National Bank'**
  String get walletBankSettingsOverseasBankNameHint;

  /// No description provided for @walletBankSettingsOverseasBranchNameHint.
  ///
  /// In en, this message translates to:
  /// **'New York Main Branch'**
  String get walletBankSettingsOverseasBranchNameHint;

  /// No description provided for @walletBankSettingsBranchNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch number'**
  String get walletBankSettingsBranchNumberLabel;

  /// No description provided for @walletBankSettingsBranchNumberHint.
  ///
  /// In en, this message translates to:
  /// **'001'**
  String get walletBankSettingsBranchNumberHint;

  /// No description provided for @walletBankSettingsOverseasBranchNumberHint.
  ///
  /// In en, this message translates to:
  /// **'102'**
  String get walletBankSettingsOverseasBranchNumberHint;

  /// No description provided for @walletBankSettingsOverseasAccountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'1234567890'**
  String get walletBankSettingsOverseasAccountNumberHint;

  /// No description provided for @walletBankSettingsOverseasAccountHolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder name'**
  String get walletBankSettingsOverseasAccountHolderLabel;

  /// No description provided for @walletBankSettingsOverseasAccountHolderHint.
  ///
  /// In en, this message translates to:
  /// **'JOHN SMITH'**
  String get walletBankSettingsOverseasAccountHolderHint;

  /// No description provided for @walletBankSettingsOwnerAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder address'**
  String get walletBankSettingsOwnerAddressLabel;

  /// No description provided for @walletBankSettingsOwnerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'123 Example Avenue, New York, NY 10001, USA'**
  String get walletBankSettingsOwnerAddressHint;

  /// No description provided for @walletBankSettingsOwnerNationalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Account holder nationality'**
  String get walletBankSettingsOwnerNationalityLabel;

  /// No description provided for @walletBankSettingsOwnerNationalityHint.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get walletBankSettingsOwnerNationalityHint;

  /// No description provided for @walletBankSettingsSwiftCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'SWIFT / BIC'**
  String get walletBankSettingsSwiftCodeLabel;

  /// No description provided for @walletBankSettingsSwiftCodeHint.
  ///
  /// In en, this message translates to:
  /// **'EXNBUS33XXX'**
  String get walletBankSettingsSwiftCodeHint;

  /// No description provided for @walletBankSettingsBankCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank country'**
  String get walletBankSettingsBankCountryLabel;

  /// No description provided for @walletBankSettingsBankCountryHint.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get walletBankSettingsBankCountryHint;

  /// No description provided for @walletBankSettingsBranchAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch address'**
  String get walletBankSettingsBranchAddressLabel;

  /// No description provided for @walletBankSettingsBranchAddressHint.
  ///
  /// In en, this message translates to:
  /// **'456 Sample Street, New York, NY 10005, USA'**
  String get walletBankSettingsBranchAddressHint;

  /// No description provided for @walletBankSettingsOverseasTip.
  ///
  /// In en, this message translates to:
  /// **'The withdrawal fee for overseas bank accounts is JPY 10,000.'**
  String get walletBankSettingsOverseasTip;

  /// No description provided for @walletBankSettingsDomesticChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get walletBankSettingsDomesticChipLabel;

  /// No description provided for @walletBankSettingsOverseasChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Overseas'**
  String get walletBankSettingsOverseasChipLabel;

  /// No description provided for @walletBankSettingsDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get walletBankSettingsDeleteAction;

  /// No description provided for @walletBankSettingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Bank Account'**
  String get walletBankSettingsDeleteConfirmTitle;

  /// No description provided for @walletBankSettingsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this withdrawal account? This action cannot be undone.'**
  String get walletBankSettingsDeleteConfirmBody;

  /// No description provided for @walletBankSettingsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal account deleted.'**
  String get walletBankSettingsDeleteSuccess;

  /// No description provided for @walletBankSettingsDeleteFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete withdrawal account.'**
  String get walletBankSettingsDeleteFailure;

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

  /// No description provided for @walletPendingDepositEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'There are currently no applied funds awaiting deposit. We do not accept custody of investment funds before an application is made. Please make a deposit only after you have completed an application for an investment product and have been selected.'**
  String get walletPendingDepositEmptyMessage;

  /// No description provided for @walletPendingDepositEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'View fund list'**
  String get walletPendingDepositEmptyAction;

  /// No description provided for @walletPendingDepositUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'The application requiring a deposit could not be found.'**
  String get walletPendingDepositUnavailableMessage;

  /// No description provided for @walletProjectDepositAccountUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the deposit account for this project.'**
  String get walletProjectDepositAccountUnavailableMessage;

  /// No description provided for @walletWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Request'**
  String get walletWithdrawTitle;

  /// No description provided for @walletWithdrawAvailableAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Available to withdraw'**
  String get walletWithdrawAvailableAmountLabel;

  /// No description provided for @walletWithdrawLockedAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Non-withdrawable amount'**
  String get walletWithdrawLockedAmountTitle;

  /// No description provided for @walletWithdrawLockedBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get walletWithdrawLockedBreakdownTitle;

  /// No description provided for @walletWithdrawLockedReasonPrefix.
  ///
  /// In en, this message translates to:
  /// **'Note: '**
  String get walletWithdrawLockedReasonPrefix;

  /// No description provided for @walletWithdrawLockedStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Lock start'**
  String get walletWithdrawLockedStartLabel;

  /// No description provided for @walletWithdrawLockedReleaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Planned unlock'**
  String get walletWithdrawLockedReleaseLabel;

  /// No description provided for @walletWithdrawAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal amount'**
  String get walletWithdrawAmountLabel;

  /// No description provided for @walletWithdrawAmountHint.
  ///
  /// In en, this message translates to:
  /// **'¥100,000'**
  String get walletWithdrawAmountHint;

  /// No description provided for @walletWithdrawDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Transfer destination'**
  String get walletWithdrawDestinationLabel;

  /// No description provided for @walletWithdrawFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get walletWithdrawFeeLabel;

  /// No description provided for @walletWithdrawSelectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select destination'**
  String get walletWithdrawSelectDestination;

  /// No description provided for @walletWithdrawNeedAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'No withdrawal bank account is registered. Please add one first.'**
  String get walletWithdrawNeedAccountMessage;

  /// No description provided for @walletWithdrawNeedAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Add withdrawal account'**
  String get walletWithdrawNeedAccountAction;

  /// No description provided for @walletWithdrawProfileVerificationRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity verification required'**
  String get walletWithdrawProfileVerificationRequiredTitle;

  /// No description provided for @walletWithdrawProfileVerificationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete identity verification before submitting a withdrawal request.'**
  String get walletWithdrawProfileVerificationRequiredMessage;

  /// No description provided for @walletWithdrawProfileVerificationRequiredAction.
  ///
  /// In en, this message translates to:
  /// **'Go to identity verification'**
  String get walletWithdrawProfileVerificationRequiredAction;

  /// No description provided for @walletWithdrawProfileVerificationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity verification is under review'**
  String get walletWithdrawProfileVerificationPendingTitle;

  /// No description provided for @walletWithdrawProfileVerificationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Please submit your withdrawal request after the review is complete.'**
  String get walletWithdrawProfileVerificationPendingMessage;

  /// No description provided for @walletWithdrawPhoneVerificationRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Phone verification is required before you can submit a withdrawal.'**
  String get walletWithdrawPhoneVerificationRequiredMessage;

  /// No description provided for @walletWithdrawPhoneVerificationRequiredAction.
  ///
  /// In en, this message translates to:
  /// **'Go to phone verification'**
  String get walletWithdrawPhoneVerificationRequiredAction;

  /// No description provided for @walletWithdrawSelectSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Select transfer destination'**
  String get walletWithdrawSelectSheetTitle;

  /// No description provided for @walletWithdrawSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Withdraw Request'**
  String get walletWithdrawSubmitAction;

  /// No description provided for @walletWithdrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Withdraw Details'**
  String get walletWithdrawConfirmTitle;

  /// No description provided for @walletWithdrawEstimatedArrivalLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival'**
  String get walletWithdrawEstimatedArrivalLabel;

  /// No description provided for @walletWithdrawEstimatedArrivalValue.
  ///
  /// In en, this message translates to:
  /// **'1-3 business days'**
  String get walletWithdrawEstimatedArrivalValue;

  /// No description provided for @walletWithdrawNetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Net amount received'**
  String get walletWithdrawNetAmountLabel;

  /// No description provided for @walletWithdrawCodeSentTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code will be sent to'**
  String get walletWithdrawCodeSentTargetLabel;

  /// No description provided for @walletWithdrawConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'After confirmation, a verification code will be sent to your registered phone. Please complete identity verification.'**
  String get walletWithdrawConfirmHint;

  /// No description provided for @walletWithdrawConfirmSendCodeAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm and send code'**
  String get walletWithdrawConfirmSendCodeAction;

  /// No description provided for @walletWithdrawBackEditAction.
  ///
  /// In en, this message translates to:
  /// **'Back to edit'**
  String get walletWithdrawBackEditAction;

  /// No description provided for @walletWithdrawVerificationHint.
  ///
  /// In en, this message translates to:
  /// **'Once verification succeeds, this withdrawal request will be submitted.'**
  String get walletWithdrawVerificationHint;

  /// No description provided for @walletWithdrawCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent.'**
  String get walletWithdrawCodeSent;

  /// No description provided for @walletWithdrawCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code.'**
  String get walletWithdrawCodeRequired;

  /// No description provided for @walletWithdrawVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get walletWithdrawVerifyTitle;

  /// No description provided for @walletWithdrawCountdownLabel.
  ///
  /// In en, this message translates to:
  /// **'You can resend in {seconds}s'**
  String walletWithdrawCountdownLabel(Object seconds);

  /// No description provided for @walletWithdrawResendReady.
  ///
  /// In en, this message translates to:
  /// **'You can resend the verification code now'**
  String get walletWithdrawResendReady;

  /// No description provided for @walletWithdrawVerifyAmountHint.
  ///
  /// In en, this message translates to:
  /// **'After verification, a withdrawal request for {amount} will be submitted.'**
  String walletWithdrawVerifyAmountHint(Object amount);

  /// No description provided for @walletWithdrawVerifySubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Verify and submit'**
  String get walletWithdrawVerifySubmitAction;

  /// No description provided for @walletWithdrawSubmitPending.
  ///
  /// In en, this message translates to:
  /// **'Withdraw API will be connected in a later implementation.'**
  String get walletWithdrawSubmitPending;

  /// No description provided for @walletWithdrawAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid withdrawal amount.'**
  String get walletWithdrawAmountInvalid;

  /// No description provided for @walletWithdrawAmountExceedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'The withdrawal amount exceeds the available amount.'**
  String get walletWithdrawAmountExceedsAvailable;

  /// No description provided for @walletWithdrawInsufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Your balance is not enough to cover the withdrawal amount and fee.'**
  String get walletWithdrawInsufficientBalance;

  /// No description provided for @walletWithdrawSelectAccountFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination bank account.'**
  String get walletWithdrawSelectAccountFirst;

  /// No description provided for @walletWithdrawSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted.'**
  String get walletWithdrawSubmitSuccess;

  /// No description provided for @walletWithdrawSubmitFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the withdrawal request. Please try again later.'**
  String get walletWithdrawSubmitFailure;

  /// No description provided for @walletWithdrawCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get walletWithdrawCancelAction;

  /// No description provided for @walletWithdrawCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this withdrawal request?'**
  String get walletWithdrawCancelConfirmTitle;

  /// No description provided for @walletWithdrawCancelConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This unpaid withdrawal request will be cancelled. Do you want to continue?'**
  String get walletWithdrawCancelConfirmBody;

  /// No description provided for @walletWithdrawCancelConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm cancel'**
  String get walletWithdrawCancelConfirmAction;

  /// No description provided for @walletWithdrawCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request cancelled.'**
  String get walletWithdrawCancelSuccess;

  /// No description provided for @walletWithdrawCancelFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel the withdrawal request. Please try again later.'**
  String get walletWithdrawCancelFailure;

  /// No description provided for @walletWithdrawingAction.
  ///
  /// In en, this message translates to:
  /// **'Withdrawing'**
  String get walletWithdrawingAction;

  /// No description provided for @walletWithdrawHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get walletWithdrawHistoryAction;

  /// No description provided for @walletWithdrawingPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdrawing List'**
  String get walletWithdrawingPageTitle;

  /// No description provided for @walletWithdrawHistoryPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw History'**
  String get walletWithdrawHistoryPageTitle;

  /// No description provided for @walletWithdrawHistoryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get walletWithdrawHistoryFilterAll;

  /// No description provided for @walletWithdrawRecordEmpty.
  ///
  /// In en, this message translates to:
  /// **'No withdrawal records available.'**
  String get walletWithdrawRecordEmpty;

  /// No description provided for @walletWithdrawRecordFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get walletWithdrawRecordFeeLabel;

  /// No description provided for @walletWithdrawRecordApplyTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Applied at'**
  String get walletWithdrawRecordApplyTimeLabel;

  /// No description provided for @walletWithdrawRecordPaidTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed at'**
  String get walletWithdrawRecordPaidTimeLabel;

  /// No description provided for @walletWithdrawRecordBookedTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Booked time'**
  String get walletWithdrawRecordBookedTimeLabel;

  /// No description provided for @walletWithdrawRecordBankNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get walletWithdrawRecordBankNumberLabel;

  /// No description provided for @walletWithdrawRecordTypeBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get walletWithdrawRecordTypeBankTransfer;

  /// No description provided for @walletWithdrawRecordTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash withdrawal'**
  String get walletWithdrawRecordTypeCash;

  /// No description provided for @walletWithdrawRecordTypeGentlePay.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to GentlePay'**
  String get walletWithdrawRecordTypeGentlePay;

  /// No description provided for @walletWithdrawRecordStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get walletWithdrawRecordStatusPending;

  /// No description provided for @walletWithdrawRecordStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get walletWithdrawRecordStatusDone;

  /// No description provided for @walletWithdrawRecordStatusUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Processing payout'**
  String get walletWithdrawRecordStatusUnpaid;

  /// No description provided for @walletWithdrawRecordStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get walletWithdrawRecordStatusPaid;

  /// No description provided for @walletWithdrawRecordStatusFailedUnconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payout failed / unconfirmed'**
  String get walletWithdrawRecordStatusFailedUnconfirmed;

  /// No description provided for @walletWithdrawRecordStatusFailedConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payout failed / confirmed'**
  String get walletWithdrawRecordStatusFailedConfirmed;

  /// No description provided for @walletWithdrawRecordStatusRevoked.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get walletWithdrawRecordStatusRevoked;

  /// No description provided for @walletWithdrawRecordStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get walletWithdrawRecordStatusUnknown;

  /// No description provided for @myPagePendingEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No applications or lottery-waiting items.'**
  String get myPagePendingEmptyState;

  /// No description provided for @myPageOrderInquiryEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No order inquiries.'**
  String get myPageOrderInquiryEmptyState;

  /// No description provided for @myPageApplyHistoryEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No application history yet.'**
  String get myPageApplyHistoryEmptyState;

  /// No description provided for @myPageCoolingOffEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No contracts in the cooling-off period.'**
  String get myPageCoolingOffEmptyState;

  /// No description provided for @myPageInvestmentStatusEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No investment status records yet.'**
  String get myPageInvestmentStatusEmptyState;

  /// No description provided for @myPageOperatingFundsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No operating funds yet.'**
  String get myPageOperatingFundsEmptyState;

  /// No description provided for @myPageOperatingEndedFundsEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No operation-ended funds yet.'**
  String get myPageOperatingEndedFundsEmptyState;

  /// No description provided for @myPageOperatingFundsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Browse funds'**
  String get myPageOperatingFundsEmptyAction;

  /// No description provided for @myPageSectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load this section. Please try again.'**
  String get myPageSectionLoadError;

  /// No description provided for @myPageApplyHistoryListTitle.
  ///
  /// In en, this message translates to:
  /// **'Application History'**
  String get myPageApplyHistoryListTitle;

  /// No description provided for @myPageApplyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get myPageApplyFilterAll;

  /// No description provided for @myPageApplyFilterApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying'**
  String get myPageApplyFilterApplying;

  /// No description provided for @myPageApplyFilterPendingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get myPageApplyFilterPendingConfirmation;

  /// No description provided for @myPageApplyFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful'**
  String get myPageApplyFilterCompleted;

  /// No description provided for @myPageApplyFilterInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get myPageApplyFilterInvalid;

  /// No description provided for @myPageApplyStatusApplying.
  ///
  /// In en, this message translates to:
  /// **'Applying'**
  String get myPageApplyStatusApplying;

  /// No description provided for @myPageApplyStatusPendingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get myPageApplyStatusPendingConfirmation;

  /// No description provided for @myPageApplyStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purchase successful'**
  String get myPageApplyStatusCompleted;

  /// No description provided for @myPageApplyStatusInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get myPageApplyStatusInvalid;

  /// No description provided for @myPageApplyInvalidToast.
  ///
  /// In en, this message translates to:
  /// **'This application is no longer valid.'**
  String get myPageApplyInvalidToast;

  /// No description provided for @myPageApplyConfirmationPendingAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending since'**
  String get myPageApplyConfirmationPendingAtLabel;

  /// No description provided for @myPageApplyCompletedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed at'**
  String get myPageApplyCompletedAtLabel;

  /// No description provided for @myPageApplyInvalidAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Invalidated at'**
  String get myPageApplyInvalidAtLabel;

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

  /// No description provided for @myPageActiveFundDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Fund Detail'**
  String get myPageActiveFundDetailTitle;

  /// No description provided for @myPageActiveFundMetaTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract Info'**
  String get myPageActiveFundMetaTitle;

  /// No description provided for @myPageActiveFundValidInvestmentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Valid investment amount'**
  String get myPageActiveFundValidInvestmentAmountLabel;

  /// No description provided for @myPageActiveFundInvestUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Investment units'**
  String get myPageActiveFundInvestUnitsLabel;

  /// No description provided for @myPageActiveFundValidUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Valid units'**
  String get myPageActiveFundValidUnitsLabel;

  /// No description provided for @myPageActiveFundSellingUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Selling in progress'**
  String get myPageActiveFundSellingUnitsLabel;

  /// No description provided for @myPageActiveFundRemainingUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining units'**
  String get myPageActiveFundRemainingUnitsLabel;

  /// No description provided for @myPageActiveFundFloatingYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Floating'**
  String get myPageActiveFundFloatingYieldLabel;

  /// No description provided for @myPageInvestorTypeInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get myPageInvestorTypeInvestment;

  /// No description provided for @myPageInvestorTypeBorrowing.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get myPageInvestorTypeBorrowing;

  /// No description provided for @myPageInvestorReturnFixedYield.
  ///
  /// In en, this message translates to:
  /// **'Assumed yield {pct}%'**
  String myPageInvestorReturnFixedYield(Object pct);

  /// No description provided for @myPageInvestorReturnFloating.
  ///
  /// In en, this message translates to:
  /// **'Floating'**
  String get myPageInvestorReturnFloating;

  /// No description provided for @myPageInvestorReturnFixedFloating.
  ///
  /// In en, this message translates to:
  /// **'Fixed{pct}% + floating'**
  String myPageInvestorReturnFixedFloating(Object pct);

  /// No description provided for @myPageInvestorReturnBorrowRate.
  ///
  /// In en, this message translates to:
  /// **'Rate {pct}%'**
  String myPageInvestorReturnBorrowRate(Object pct);

  /// No description provided for @myPageActiveFundProcessIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Process ID'**
  String get myPageActiveFundProcessIdLabel;

  /// No description provided for @myPageActiveFundInvestorCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Investor class'**
  String get myPageActiveFundInvestorCodeLabel;

  /// No description provided for @myPageActiveFundAppliedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Applied at'**
  String get myPageActiveFundAppliedAtLabel;

  /// No description provided for @myPageActiveFundWithdrawnAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn at'**
  String get myPageActiveFundWithdrawnAtLabel;

  /// No description provided for @myPageActiveFundTotalBenefitLabel.
  ///
  /// In en, this message translates to:
  /// **'Total benefit'**
  String get myPageActiveFundTotalBenefitLabel;

  /// No description provided for @myPageActiveFundBenefitHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefit history'**
  String get myPageActiveFundBenefitHistoryTitle;

  /// No description provided for @myPageActiveFundBenefitAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Benefit amount'**
  String get myPageActiveFundBenefitAmountLabel;

  /// No description provided for @myPageActiveFundTaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get myPageActiveFundTaxLabel;

  /// No description provided for @myPageActiveFundNetBenefitLabel.
  ///
  /// In en, this message translates to:
  /// **'Net benefit'**
  String get myPageActiveFundNetBenefitLabel;

  /// No description provided for @myPageActiveFundReportAction.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get myPageActiveFundReportAction;

  /// No description provided for @myPageActiveFundReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Benefit report'**
  String get myPageActiveFundReportTitle;

  /// No description provided for @myPageActiveFundReportUnavailableNotice.
  ///
  /// In en, this message translates to:
  /// **'There are no related documents yet.'**
  String get myPageActiveFundReportUnavailableNotice;

  /// No description provided for @myPageActiveFundWithdrawAction.
  ///
  /// In en, this message translates to:
  /// **'Request withdrawal'**
  String get myPageActiveFundWithdrawAction;

  /// No description provided for @myPageActiveFundWithdrawDone.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn'**
  String get myPageActiveFundWithdrawDone;

  /// No description provided for @myPageActiveFundCoolingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Cooling Period'**
  String get myPageActiveFundCoolingPeriod;

  /// No description provided for @myPageActiveFundWithdrawConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit a withdrawal request?'**
  String get myPageActiveFundWithdrawConfirmTitle;

  /// No description provided for @myPageActiveFundWithdrawConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'A withdrawal request will be sent for this benefit.'**
  String get myPageActiveFundWithdrawConfirmBody;

  /// No description provided for @myPageActiveFundWithdrawConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get myPageActiveFundWithdrawConfirmAction;

  /// No description provided for @myPageActiveFundWithdrawSuccess.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request submitted.'**
  String get myPageActiveFundWithdrawSuccess;

  /// No description provided for @myPageActiveFundWithdrawFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the withdrawal request. Please try again later.'**
  String get myPageActiveFundWithdrawFailure;

  /// No description provided for @myPageActiveFundResaleAction.
  ///
  /// In en, this message translates to:
  /// **'Request resale'**
  String get myPageActiveFundResaleAction;

  /// No description provided for @myPageActiveFundResaleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Resale request will be connected in a later implementation.'**
  String get myPageActiveFundResaleComingSoon;

  /// No description provided for @myPageActiveFundBenefitEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No benefit history yet.'**
  String get myPageActiveFundBenefitEmptyState;

  /// No description provided for @myPageActiveFundBenefitLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load benefit history.'**
  String get myPageActiveFundBenefitLoadError;

  /// No description provided for @myPageActiveFundBenefitSeq.
  ///
  /// In en, this message translates to:
  /// **'Benefit #{seq}'**
  String myPageActiveFundBenefitSeq(int seq);

  /// No description provided for @myPageActiveFundBenefitPeriodRange.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end}'**
  String myPageActiveFundBenefitPeriodRange(Object start, Object end);

  /// No description provided for @myPageResaleOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell Order'**
  String get myPageResaleOrderTitle;

  /// No description provided for @myPageResaleTabOrder.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get myPageResaleTabOrder;

  /// No description provided for @myPageResaleTabConfirm.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get myPageResaleTabConfirm;

  /// No description provided for @myPageResaleFundNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Fund name'**
  String get myPageResaleFundNameLabel;

  /// No description provided for @myPageResaleInvestorTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Investor type'**
  String get myPageResaleInvestorTypeLabel;

  /// No description provided for @myPageResaleOrderMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Order method'**
  String get myPageResaleOrderMethodLabel;

  /// No description provided for @myPageResaleOrderMethodValue.
  ///
  /// In en, this message translates to:
  /// **'Sell order'**
  String get myPageResaleOrderMethodValue;

  /// No description provided for @myPageResaleAvailableUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available units'**
  String get myPageResaleAvailableUnitsLabel;

  /// No description provided for @myPageResaleSellUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sell units'**
  String get myPageResaleSellUnitsLabel;

  /// No description provided for @myPageResaleUnitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get myPageResaleUnitPriceLabel;

  /// No description provided for @myPageResaleFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Sell fee'**
  String get myPageResaleFeeLabel;

  /// No description provided for @myPageResaleFeeValue.
  ///
  /// In en, this message translates to:
  /// **'1.65% of transaction amount'**
  String get myPageResaleFeeValue;

  /// No description provided for @myPageResaleAgreementLabel.
  ///
  /// In en, this message translates to:
  /// **'Document confirmation'**
  String get myPageResaleAgreementLabel;

  /// No description provided for @myPageResaleAgreementBody.
  ///
  /// In en, this message translates to:
  /// **'I agree to the document below and submit a normal sell order.'**
  String get myPageResaleAgreementBody;

  /// No description provided for @myPageResaleAgreementSampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Assignment of contractual status agreement (sample)'**
  String get myPageResaleAgreementSampleLabel;

  /// No description provided for @myPageResaleTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get myPageResaleTotalAmountLabel;

  /// No description provided for @myPageResaleFeeAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee amount'**
  String get myPageResaleFeeAmountLabel;

  /// No description provided for @myPageResaleNetAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated receivable'**
  String get myPageResaleNetAmountLabel;

  /// No description provided for @myPageResaleValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter sell units and unit price, then agree to the document confirmation.'**
  String get myPageResaleValidationMessage;

  /// No description provided for @myPageResaleConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get myPageResaleConfirmButton;

  /// No description provided for @myPageResaleBackButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get myPageResaleBackButton;

  /// No description provided for @myPageResaleSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get myPageResaleSubmitButton;

  /// No description provided for @myPageResaleUnitsSuffix.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get myPageResaleUnitsSuffix;

  /// No description provided for @myPageResaleYenSuffix.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get myPageResaleYenSuffix;

  /// No description provided for @myPageResaleFlowOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter resale details'**
  String get myPageResaleFlowOrderTitle;

  /// No description provided for @myPageResaleFlowOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the quantity, asking price, and document confirmation before moving to the review step.'**
  String get myPageResaleFlowOrderSubtitle;

  /// No description provided for @myPageResaleFlowConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Review resale details'**
  String get myPageResaleFlowConfirmTitle;

  /// No description provided for @myPageResaleFlowConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If everything looks right, submit the sell order from this screen.'**
  String get myPageResaleFlowConfirmSubtitle;

  /// No description provided for @myPageResaleQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity and unit price you want to list.'**
  String get myPageResaleQuantityHint;

  /// No description provided for @myPageResaleQuickMax.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get myPageResaleQuickMax;

  /// No description provided for @myPageResaleLiveEstimateFormulaLabel.
  ///
  /// In en, this message translates to:
  /// **'Current order estimate'**
  String get myPageResaleLiveEstimateFormulaLabel;

  /// No description provided for @myPageResaleAgreementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents and confirmations'**
  String get myPageResaleAgreementSectionTitle;

  /// No description provided for @myPageResaleReviewSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get myPageResaleReviewSectionTitle;

  /// No description provided for @myPageResaleReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Review the listing conditions and expected proceeds before you place the order.'**
  String get myPageResaleReviewHint;

  /// No description provided for @myPageResaleSummarySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Expected proceeds'**
  String get myPageResaleSummarySectionTitle;

  /// No description provided for @myPageResaleFinalNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'The sell order will be sent after final confirmation'**
  String get myPageResaleFinalNoticeTitle;

  /// No description provided for @myPageResaleFinalNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Once submitted, the listing will proceed with these details. Please review the quantity, price, and expected proceeds one more time.'**
  String get myPageResaleFinalNoticeBody;

  /// No description provided for @myPageResaleFixedYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Fixed {ratio} yield'**
  String myPageResaleFixedYieldLabel(Object ratio);

  /// No description provided for @myPageResaleInvestorTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'Fixed {ratio} yield'**
  String myPageResaleInvestorTypeFallback(Object ratio);

  /// No description provided for @myPageResaleHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get myPageResaleHintTitle;

  /// No description provided for @myPageResaleFinalConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm selling {units} unit(s) of this project at {price} JPY per unit?'**
  String myPageResaleFinalConfirmMessage(Object price, Object units);

  /// No description provided for @myPageResaleSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sell order submitted.'**
  String get myPageResaleSubmitSuccess;

  /// No description provided for @myPageResaleSubmitFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the sell order. Please try again later.'**
  String get myPageResaleSubmitFailure;

  /// No description provided for @secondaryMarketListLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the flea market listings.'**
  String get secondaryMarketListLoadError;

  /// No description provided for @secondaryMarketDetailLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the flea market detail.'**
  String get secondaryMarketDetailLoadError;

  /// No description provided for @secondaryMarketDetailUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The listing could not be found.'**
  String get secondaryMarketDetailUnavailable;

  /// No description provided for @secondaryMarketDetailSoldOutMessage.
  ///
  /// In en, this message translates to:
  /// **'This listing has already sold out.'**
  String get secondaryMarketDetailSoldOutMessage;

  /// No description provided for @secondaryMarketBuyAction.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get secondaryMarketBuyAction;

  /// No description provided for @secondaryMarketOrderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Time'**
  String get secondaryMarketOrderTimeLabel;

  /// No description provided for @secondaryMarketInvestorTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Investor Type'**
  String get secondaryMarketInvestorTypeLabel;

  /// No description provided for @secondaryMarketSellUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Listed Units'**
  String get secondaryMarketSellUnitsLabel;

  /// No description provided for @secondaryMarketSoldUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Matched Units'**
  String get secondaryMarketSoldUnitsLabel;

  /// No description provided for @secondaryMarketRemainingUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining Units'**
  String get secondaryMarketRemainingUnitsLabel;

  /// No description provided for @secondaryMarketCompletionRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Fill Rate'**
  String get secondaryMarketCompletionRateLabel;

  /// No description provided for @secondaryMarketPricePerUnitCaption.
  ///
  /// In en, this message translates to:
  /// **'Per unit'**
  String get secondaryMarketPricePerUnitCaption;

  /// No description provided for @secondaryMarketOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Overview'**
  String get secondaryMarketOverviewTitle;

  /// No description provided for @secondaryMarketUpdateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get secondaryMarketUpdateTimeLabel;

  /// No description provided for @secondaryMarketOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get secondaryMarketOrderIdLabel;

  /// No description provided for @secondaryMarketActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Market Activity'**
  String get secondaryMarketActivityTitle;

  /// No description provided for @secondaryMarketApplicationsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get secondaryMarketApplicationsCountLabel;

  /// No description provided for @secondaryMarketDealsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Deals'**
  String get secondaryMarketDealsCountLabel;

  /// No description provided for @secondaryMarketLatestApplicationLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest Application'**
  String get secondaryMarketLatestApplicationLabel;

  /// No description provided for @secondaryMarketLatestDealLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest Deal'**
  String get secondaryMarketLatestDealLabel;

  /// No description provided for @secondaryMarketDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related Documents'**
  String get secondaryMarketDocumentsTitle;

  /// No description provided for @secondaryMarketDocumentPending.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get secondaryMarketDocumentPending;

  /// No description provided for @secondaryMarketDocumentOpenAction.
  ///
  /// In en, this message translates to:
  /// **'Open Document'**
  String get secondaryMarketDocumentOpenAction;

  /// No description provided for @secondaryMarketBuyOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy Order'**
  String get secondaryMarketBuyOrderTitle;

  /// No description provided for @secondaryMarketTradeTabBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get secondaryMarketTradeTabBuy;

  /// No description provided for @secondaryMarketTradeTabConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get secondaryMarketTradeTabConfirm;

  /// No description provided for @secondaryMarketBuyOrderMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Order Method'**
  String get secondaryMarketBuyOrderMethodLabel;

  /// No description provided for @secondaryMarketBuyOrderMethodValue.
  ///
  /// In en, this message translates to:
  /// **'Buy Order'**
  String get secondaryMarketBuyOrderMethodValue;

  /// No description provided for @secondaryMarketBuyAvailableUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Units'**
  String get secondaryMarketBuyAvailableUnitsLabel;

  /// No description provided for @secondaryMarketBuyUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy Units'**
  String get secondaryMarketBuyUnitsLabel;

  /// No description provided for @secondaryMarketBuyUnitPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get secondaryMarketBuyUnitPriceLabel;

  /// No description provided for @secondaryMarketBuyFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get secondaryMarketBuyFeeLabel;

  /// No description provided for @secondaryMarketBuyFeeValue.
  ///
  /// In en, this message translates to:
  /// **'1.65% of transaction amount'**
  String get secondaryMarketBuyFeeValue;

  /// No description provided for @secondaryMarketBuyAgreementLabel.
  ///
  /// In en, this message translates to:
  /// **'Document Confirmation'**
  String get secondaryMarketBuyAgreementLabel;

  /// No description provided for @secondaryMarketBuyAgreementBody.
  ///
  /// In en, this message translates to:
  /// **'I agree to the following documents and submit the purchase request.'**
  String get secondaryMarketBuyAgreementBody;

  /// No description provided for @secondaryMarketBuyAgreementSampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Review related document'**
  String get secondaryMarketBuyAgreementSampleLabel;

  /// No description provided for @secondaryMarketBuyConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get secondaryMarketBuyConfirmButton;

  /// No description provided for @secondaryMarketBuyBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get secondaryMarketBuyBackButton;

  /// No description provided for @secondaryMarketBuySubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Buy Order'**
  String get secondaryMarketBuySubmitButton;

  /// No description provided for @secondaryMarketBuyValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the buy units and agree to the document confirmation.'**
  String get secondaryMarketBuyValidationMessage;

  /// No description provided for @secondaryMarketBuyFlowInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Order Details'**
  String get secondaryMarketBuyFlowInputTitle;

  /// No description provided for @secondaryMarketBuyFlowInputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the quantity and review the documents before continuing.'**
  String get secondaryMarketBuyFlowInputSubtitle;

  /// No description provided for @secondaryMarketBuyFlowConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Review'**
  String get secondaryMarketBuyFlowConfirmTitle;

  /// No description provided for @secondaryMarketBuyFlowConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If everything looks correct, submit the purchase request from this screen.'**
  String get secondaryMarketBuyFlowConfirmSubtitle;

  /// No description provided for @secondaryMarketBuyQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Choose how many units you want to purchase.'**
  String get secondaryMarketBuyQuantityHint;

  /// No description provided for @secondaryMarketBuyQuickMax.
  ///
  /// In en, this message translates to:
  /// **'MAX'**
  String get secondaryMarketBuyQuickMax;

  /// No description provided for @secondaryMarketBuyLiveEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Live Estimate'**
  String get secondaryMarketBuyLiveEstimateTitle;

  /// No description provided for @secondaryMarketBuyLiveEstimateFormulaLabel.
  ///
  /// In en, this message translates to:
  /// **'Current order'**
  String get secondaryMarketBuyLiveEstimateFormulaLabel;

  /// No description provided for @secondaryMarketBuySummarySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get secondaryMarketBuySummarySectionTitle;

  /// No description provided for @secondaryMarketBuyAgreementSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents & Confirmation'**
  String get secondaryMarketBuyAgreementSectionTitle;

  /// No description provided for @secondaryMarketBuyStickyAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Payment'**
  String get secondaryMarketBuyStickyAmountLabel;

  /// No description provided for @secondaryMarketBuyReviewSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Review'**
  String get secondaryMarketBuyReviewSectionTitle;

  /// No description provided for @secondaryMarketBuyReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Review the details one last time before sending the purchase request.'**
  String get secondaryMarketBuyReviewHint;

  /// No description provided for @secondaryMarketBuyFinalNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'The purchase request will be sent after this final check'**
  String get secondaryMarketBuyFinalNoticeTitle;

  /// No description provided for @secondaryMarketBuyFinalNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'Once submitted, the purchase process will proceed based on this order. Please review the quantity and estimated payment carefully.'**
  String get secondaryMarketBuyFinalNoticeBody;

  /// No description provided for @secondaryMarketBuyTotalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase Total'**
  String get secondaryMarketBuyTotalAmountLabel;

  /// No description provided for @secondaryMarketBuyFeeAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get secondaryMarketBuyFeeAmountLabel;

  /// No description provided for @secondaryMarketBuyPaymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get secondaryMarketBuyPaymentAmountLabel;

  /// No description provided for @secondaryMarketBuyFinalConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get secondaryMarketBuyFinalConfirmTitle;

  /// No description provided for @secondaryMarketBuyFinalConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Confirm purchasing {units} units of this project at {price} yen per unit?'**
  String secondaryMarketBuyFinalConfirmMessage(Object price, Object units);

  /// No description provided for @secondaryMarketBuySubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase order submitted.'**
  String get secondaryMarketBuySubmitSuccess;

  /// No description provided for @secondaryMarketBuySubmitFailure.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the purchase order. Please try again later.'**
  String get secondaryMarketBuySubmitFailure;

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
  /// **'Enter your family name, given name, phonetic name, romanized name, and contact information.'**
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

  /// No description provided for @memberProfileFamilyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get memberProfileFamilyNameLabel;

  /// No description provided for @memberProfileFamilyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Tanaka'**
  String get memberProfileFamilyNameHint;

  /// No description provided for @memberProfileGivenNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get memberProfileGivenNameLabel;

  /// No description provided for @memberProfileGivenNameHint.
  ///
  /// In en, this message translates to:
  /// **'Taro'**
  String get memberProfileGivenNameHint;

  /// No description provided for @memberProfileFamilyNameKanaLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name (Kana)'**
  String get memberProfileFamilyNameKanaLabel;

  /// No description provided for @memberProfileFamilyNameKanaHint.
  ///
  /// In en, this message translates to:
  /// **'TANAKA'**
  String get memberProfileFamilyNameKanaHint;

  /// No description provided for @memberProfileGivenNameKanaLabel.
  ///
  /// In en, this message translates to:
  /// **'Given name (Kana)'**
  String get memberProfileGivenNameKanaLabel;

  /// No description provided for @memberProfileGivenNameKanaHint.
  ///
  /// In en, this message translates to:
  /// **'TARO'**
  String get memberProfileGivenNameKanaHint;

  /// No description provided for @memberProfileFamilyNameRomanLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name (Roman)'**
  String get memberProfileFamilyNameRomanLabel;

  /// No description provided for @memberProfileFamilyNameRomanHint.
  ///
  /// In en, this message translates to:
  /// **'TANAKA'**
  String get memberProfileFamilyNameRomanHint;

  /// No description provided for @memberProfileGivenNameRomanLabel.
  ///
  /// In en, this message translates to:
  /// **'Given name (Roman)'**
  String get memberProfileGivenNameRomanLabel;

  /// No description provided for @memberProfileGivenNameRomanHint.
  ///
  /// In en, this message translates to:
  /// **'TARO'**
  String get memberProfileGivenNameRomanHint;

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

  /// No description provided for @memberProfileSexLabel.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get memberProfileSexLabel;

  /// No description provided for @memberProfileSexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get memberProfileSexFemale;

  /// No description provided for @memberProfileSexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get memberProfileSexMale;

  /// No description provided for @memberProfileSexOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get memberProfileSexOther;

  /// No description provided for @memberProfileTaxCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country of residence'**
  String get memberProfileTaxCountryLabel;

  /// No description provided for @memberProfileTaxCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get memberProfileTaxCountryHint;

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
  /// **'1000001'**
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

  /// No description provided for @memberProfileDocumentGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload document guide'**
  String get memberProfileDocumentGuideTitle;

  /// No description provided for @memberProfileDocumentGuideBody.
  ///
  /// In en, this message translates to:
  /// **'Please submit one of the following identity verification documents.\n\n1. Residents\n- Individual Number Card (My Number Card, front side only)\n- Residence card\n- Special Permanent Resident Certificate\n- Driver\'s license\n\n2. Non-residents\n- Government-issued photo ID from your home country\n- Passport (photo page and bearer information page)\n\n3. Corporations (corporate account)\nPlease submit the following documents:\n- Certificate of Registered Matters (full historical record)\n- Identity verification document for the representative or transaction agent\n- If required, documents regarding beneficial owners'**
  String get memberProfileDocumentGuideBody;

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

  /// No description provided for @memberProfilePhotoDocumentFrontTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo ID (Front)'**
  String get memberProfilePhotoDocumentFrontTitle;

  /// No description provided for @memberProfilePhotoDocumentFrontDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload the front side'**
  String get memberProfilePhotoDocumentFrontDescription;

  /// No description provided for @memberProfilePhotoDocumentBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo ID (Back)'**
  String get memberProfilePhotoDocumentBackTitle;

  /// No description provided for @memberProfilePhotoDocumentBackDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload the back side'**
  String get memberProfilePhotoDocumentBackDescription;

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
  /// **'Upload your selfie, then complete the live face verification.'**
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

  /// No description provided for @memberProfileBankRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank region'**
  String get memberProfileBankRegionLabel;

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
  /// **'Step 5: Consent'**
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

  /// No description provided for @memberProfileSavingProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Uploading and saving...'**
  String get memberProfileSavingProgressMessage;

  /// No description provided for @memberProfilePhotoUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded successfully.'**
  String get memberProfilePhotoUploadSuccess;

  /// No description provided for @memberProfileSelfieUploadBypassedNotice.
  ///
  /// In en, this message translates to:
  /// **'Selfie upload is not supported in the test environment, so you can continue to the next step.'**
  String get memberProfileSelfieUploadBypassedNotice;

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
  /// **'JPY 3M to under 5M'**
  String get income3to5m;

  /// No description provided for @income5to7m.
  ///
  /// In en, this message translates to:
  /// **'JPY 5M to under 7M'**
  String get income5to7m;

  /// No description provided for @income7to10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 7M to under 10M'**
  String get income7to10m;

  /// No description provided for @income5to10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 5M to under 10M'**
  String get income5to10m;

  /// No description provided for @incomeOver10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 10M or more'**
  String get incomeOver10m;

  /// No description provided for @assetsUnder1m.
  ///
  /// In en, this message translates to:
  /// **'Under JPY 1M'**
  String get assetsUnder1m;

  /// No description provided for @assets1to3m.
  ///
  /// In en, this message translates to:
  /// **'JPY 1M to under 3M'**
  String get assets1to3m;

  /// No description provided for @assets3to5m.
  ///
  /// In en, this message translates to:
  /// **'JPY 3M to under 5M'**
  String get assets3to5m;

  /// No description provided for @assets1to5m.
  ///
  /// In en, this message translates to:
  /// **'JPY 1M to under 5M'**
  String get assets1to5m;

  /// No description provided for @assets5to10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 5M to under 10M'**
  String get assets5to10m;

  /// No description provided for @assets10to30m.
  ///
  /// In en, this message translates to:
  /// **'JPY 10M to under 30M'**
  String get assets10to30m;

  /// No description provided for @assetsOver10m.
  ///
  /// In en, this message translates to:
  /// **'JPY 10M or more'**
  String get assetsOver10m;

  /// No description provided for @assetsOver30m.
  ///
  /// In en, this message translates to:
  /// **'JPY 30M or more'**
  String get assetsOver30m;

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

  /// No description provided for @identityAuthCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to continue face verification.'**
  String get identityAuthCameraPermissionRequired;

  /// No description provided for @identityAuthCameraPermissionSettingsRequired.
  ///
  /// In en, this message translates to:
  /// **'Open system settings and allow camera access to continue face verification.'**
  String get identityAuthCameraPermissionSettingsRequired;

  /// No description provided for @permissionSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionSettingsTitle;

  /// No description provided for @permissionSettingsCameraMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera access is disabled. Open system settings and allow camera access.'**
  String get permissionSettingsCameraMessage;

  /// No description provided for @permissionSettingsPhotosMessage.
  ///
  /// In en, this message translates to:
  /// **'Photo library access is disabled. Open system settings and allow photo access.'**
  String get permissionSettingsPhotosMessage;

  /// No description provided for @permissionSettingsLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Location access is disabled. Open system settings and allow location access.'**
  String get permissionSettingsLocationMessage;

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
