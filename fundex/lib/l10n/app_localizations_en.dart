// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle =>
      'Access your member portfolio and hotel booking privileges.';

  @override
  String get loginAccountLabel => 'Phone number or email';

  @override
  String get loginModeTitle => 'Choose login method';

  @override
  String get loginCodeLabel => 'Verification code';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get loginSendCodeSuccess => 'Verification code sent.';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginBrowseAsGuest => 'Browse without signing in (Guest mode)';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get pushDialogDefaultBlockTitle => 'This app is unavailable';

  @override
  String get pushDialogDefaultBlockBody =>
      'Please use the specified app instead.';

  @override
  String get pushDialogDefaultUpdateTitle => 'A new version is available';

  @override
  String get pushDialogDefaultUpdateBody =>
      'Please update to the latest version.';

  @override
  String get pushDialogDefaultCampaignTitle => 'Campaign Notice';

  @override
  String get pushDialogOpenStore => 'Open Store';

  @override
  String get pushDialogUpdateNow => 'Update';

  @override
  String get pushDialogUpdateLater => 'Later';

  @override
  String get pushDialogClose => 'OK';

  @override
  String get pushDialogOpenFailed => 'Unable to open the link.';

  @override
  String get discussionAvatarPageTitle => 'Avatar';

  @override
  String get discussionAvatarPreviewHint =>
      'Choose a default avatar or upload an image from your photo library.';

  @override
  String get discussionAvatarDefaultSectionTitle => 'Default avatars';

  @override
  String get discussionAvatarSaveAction => 'Save avatar';

  @override
  String get discussionAvatarSaveSuccess => 'Avatar updated.';

  @override
  String get discussionAvatarPickFailed =>
      'Failed to choose an image. Please try again.';

  @override
  String get profileImageSizeTooLarge =>
      'The image is too large. Please choose an image under 10MB.';

  @override
  String get discussionAvatarPhotoLibraryPermissionRequired =>
      'Allow photo library access to select an avatar image.';

  @override
  String get discussionAvatarCropTitle => 'Adjust avatar';

  @override
  String get discussionAvatarCropHint =>
      'Drag the image and pinch to zoom so the avatar fits inside the circle.';

  @override
  String get discussionAvatarCropApplyAction => 'Use this image';

  @override
  String get commonOpenSettings => 'Open Settings';

  @override
  String get pdfViewerPageTitle => 'PDF';

  @override
  String get pdfViewerOpenExternalTooltip => 'Open externally';

  @override
  String get pdfViewerOpenExternalLabel => 'Open externally';

  @override
  String get pdfViewerShareTooltip => 'Share';

  @override
  String get pdfViewerShareLabel => 'Share';

  @override
  String get pdfViewerLoadingLabel => 'Loading PDF...';

  @override
  String get pdfViewerLoadFailedLabel => 'Failed to load PDF.';

  @override
  String get pdfViewerInvalidUrlNotice => 'Invalid PDF URL.';

  @override
  String get pdfViewerOpenExternalFailedNotice => 'Unable to open PDF.';

  @override
  String get pdfViewerShareFailedNotice => 'Unable to share PDF.';

  @override
  String get imageViewerLoadingLabel => 'Loading image...';

  @override
  String get imageViewerLoadFailedLabel => 'Failed to load image.';

  @override
  String get imageViewerRetryLabel => 'Retry';

  @override
  String get imageViewerInvalidSourceNotice => 'Invalid image source.';

  @override
  String get webViewerLoadingLabel => 'Loading page...';

  @override
  String get webViewerLoadFailedLabel => 'Failed to load page.';

  @override
  String get webViewerInvalidUrlNotice => 'Invalid page URL.';

  @override
  String get imageViewerCloseTooltip => 'Close';

  @override
  String get favoriteAddedToast => 'Added to favorites';

  @override
  String get favoriteRemovedToast => 'Removed from favorites';

  @override
  String get networkOfflineBannerTitle => 'You\'re offline';

  @override
  String get networkOfflineBannerMessage =>
      'We\'ll refresh the latest data automatically when the connection returns.';

  @override
  String get networkAccessDeniedBannerTitle => 'Unable to access the network';

  @override
  String get networkAccessDeniedBannerMessage =>
      'Check your connection, or allow StellaVia network access in iPhone Settings.';

  @override
  String get loginForgotPassword => 'Forgot password';

  @override
  String get loginFootnote =>
      'Designed for global members with Japan-ready UX and privacy standards.';

  @override
  String get loginErrorSendCodeFailed =>
      'Unable to send code. Please try again later.';

  @override
  String get loginErrorInvalidCode =>
      'Sign in failed. Please verify your code.';

  @override
  String get loginEmailAccountInvalid =>
      'Please enter a valid email address for email sign in.';

  @override
  String get loginMobileAccountInvalid =>
      'Please enter a valid phone number for phone sign in.';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle =>
      'Set up secure access for investment, stays, and member privileges.';

  @override
  String get registerQuickTitle => 'Create your account';

  @override
  String get registerQuickSubtitle =>
      'Register with just your email and password. You can complete required details later.';

  @override
  String get registerModeTitle => 'Registration method';

  @override
  String get authModeEmail => 'Email';

  @override
  String get authModeMobile => 'Phone';

  @override
  String get splashBrandName => 'StellaVia';

  @override
  String get splashBrandSlogan => 'Investments become the road to tomorrow.';

  @override
  String get splashTagline => 'Real estate crowdfunding';

  @override
  String get authEntryHeadline =>
      'One sign-in for investment and hotel member services';

  @override
  String get authEntryDescription =>
      'Sign in with phone or email to manage investments, bookings, and member privileges.';

  @override
  String get authEntryPhoneLogin => 'Sign in with phone';

  @override
  String get authEntryEmailLogin => 'Sign in with email';

  @override
  String get authEntryNonMemberRegisterNow => 'Not a member? Register now';

  @override
  String get authBeforeMemberDirectLogin => 'Already a member? Sign in';

  @override
  String get authBeforeNonMemberRegister => 'Not a member? Register';

  @override
  String get authRegisterEntryHeadline => 'Choose registration method';

  @override
  String get authRegisterEntryDescription =>
      'Create your account with phone or email and manage all member services in one place.';

  @override
  String get authEntryPhoneRegister => 'Register with phone';

  @override
  String get authEntryEmailRegister => 'Register with email';

  @override
  String get authBackToLoginEntry => 'Back to sign-in options';

  @override
  String get authBackToRegisterEntry => 'Back to registration options';

  @override
  String get authIntlCodeLabel => 'Phone region code';

  @override
  String get authIntlCodePickerTitle => 'Select phone region code';

  @override
  String get authMethodFormSubtitle =>
      'Complete secure verification with a one-time code.';

  @override
  String get profileOnboardingTitle => 'Complete profile details';

  @override
  String get profileEditTitle => 'Edit profile details';

  @override
  String get profileOnboardingCardTitle =>
      'Profile confirmation before trading & booking';

  @override
  String get profileOnboardingCardSubtitle =>
      'To meet transaction and booking verification requirements, please complete your profile details. You can skip for now and return later.';

  @override
  String get profileEditCardTitle => 'Profile details';

  @override
  String get profileEditCardSubtitle =>
      'Your previous local input is retained and can be updated anytime.';

  @override
  String get profileLastSavedHint =>
      'Previously saved local details have been loaded.';

  @override
  String get profileSkipButton => 'Skip for now';

  @override
  String get profileStepName => 'Name';

  @override
  String get profileStepNameSubtitle =>
      'Enter family name first, then given name (JP-style order).';

  @override
  String get profileStepContact => 'Contact details';

  @override
  String get profileStepContactSubtitle =>
      'Enter address, phone, and email (auto-filled when available).';

  @override
  String get profileStepDocument => 'ID document photo';

  @override
  String get profileStepDocumentSubtitle =>
      'Upload an ID photo for future trading and booking verification.';

  @override
  String get profileFamilyNameLabel => 'Family name';

  @override
  String get profileFamilyNameHint => 'Enter family name';

  @override
  String get profileGivenNameLabel => 'Given name';

  @override
  String get profileGivenNameHint => 'Enter given name';

  @override
  String get profileAddressLabel => 'Address';

  @override
  String get profileAddressHint =>
      'Enter full address (prefecture/city/street/building)';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profilePhoneHint => 'Enter phone number';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailHint => 'Enter email address';

  @override
  String get profileDocumentPhotoLabel => 'ID document photo';

  @override
  String get profileDocumentAddPhoto => 'Upload document photo';

  @override
  String get profileDocumentChangePhoto => 'Change document photo';

  @override
  String get profileDocumentRemovePhoto => 'Remove document photo';

  @override
  String get profileDocumentTakePhoto => 'Take photo';

  @override
  String get profileDocumentPickFromGallery => 'Choose from gallery';

  @override
  String get profileDocumentHint =>
      'Please upload a clear, unobstructed document photo for later manual review.';

  @override
  String get profileDocumentAttachedBadge => 'Attached';

  @override
  String get profilePrevStep => 'Back';

  @override
  String get profileNextStep => 'Next';

  @override
  String get profileSaveButton => 'Save details';

  @override
  String get profileSavedTitle => 'Profile details saved';

  @override
  String get profileSavedAndContinueLoginMessage =>
      'Your details have been saved locally. You can continue to sign in.';

  @override
  String get profileSavedSnackbar => 'Profile details saved locally.';

  @override
  String get memberProfileAutoSavedToast => 'Saved.';

  @override
  String get memberProfileTemporarySaveAction => 'Save draft';

  @override
  String get memberProfilePhotoPreviewAction => 'Preview';

  @override
  String get memberProfileDraftImportTitle => 'Saved profile draft found';

  @override
  String get memberProfileDraftImportMessage =>
      'Do you want to import the saved draft from your last session?';

  @override
  String get memberProfileDraftImportAction => 'Import';

  @override
  String get memberProfileDraftImportSkipAction => 'Not now';

  @override
  String get profileIntakeValidationTitle => 'Incomplete profile details';

  @override
  String get profileFamilyNameRequired => 'Please enter your family name.';

  @override
  String get profileGivenNameRequired => 'Please enter your given name.';

  @override
  String get profileAddressRequired => 'Please enter your address.';

  @override
  String get profilePhoneRequired => 'Please enter a valid phone number.';

  @override
  String get profileEmailRequired => 'Please enter a valid email address.';

  @override
  String get profileDocumentPhotoRequired =>
      'Please upload an ID document photo.';

  @override
  String get profileDocumentPickFailed =>
      'Failed to select document photo. Please try again.';

  @override
  String get profileDocumentCameraPermissionRequired =>
      'Allow camera access to take a document photo.';

  @override
  String get profileDocumentPhotoLibraryPermissionRequired =>
      'Allow photo library access to select a document photo.';

  @override
  String get profileIncompleteBannerTitle => 'Profile details incomplete';

  @override
  String get profileIncompleteBannerSubtitle =>
      'Trading and booking require a complete profile.';

  @override
  String get profileIncompleteBannerBody =>
      'Please complete name, address, phone, email, and ID document photo before trading or booking.';

  @override
  String get profileGuardTitle => 'Profile details required';

  @override
  String get profileGuardMessage =>
      'Please complete your profile details before trading or booking.';

  @override
  String profileGuardMessageWithAction(Object actionLabel) {
    return 'Please complete your profile details before \"$actionLabel\".';
  }

  @override
  String get profileGuardCancel => 'Cancel';

  @override
  String get profileGuardGoFill => 'Complete now';

  @override
  String profileGuardPassMessage(Object actionLabel) {
    return 'Profile validation passed. You can continue with $actionLabel.';
  }

  @override
  String get profileStatusCardTitle => 'Profile detail status';

  @override
  String get profileStatusCompleted =>
      'Completed. Trading and booking are available.';

  @override
  String get profileStatusIncomplete =>
      'Incomplete. Please complete your details before trading or booking.';

  @override
  String get profileStatusLoadFailed =>
      'Unable to load profile status. Please try again.';

  @override
  String get profileEditEntryButton => 'Fill / Edit details';

  @override
  String get profileProtectedBookingAction => 'Booking';

  @override
  String get profileProtectedTradeAction => 'Trading';

  @override
  String get authMobileLoginTitle => 'Phone sign in';

  @override
  String get authEmailLoginTitle => 'Email sign in';

  @override
  String get authMobileRegisterTitle => 'Phone registration';

  @override
  String get authEmailRegisterTitle => 'Email registration';

  @override
  String get registerAccountLabel => 'Phone number or email';

  @override
  String get registerEmailAccountLabel => 'Email address';

  @override
  String get registerMobileAccountLabel => 'Phone number';

  @override
  String get registerCodeLabel => 'Verification code';

  @override
  String get registerSendCode => 'Send code';

  @override
  String get registerSendCodeSuccess => 'Registration code sent.';

  @override
  String get registerContactLabel => 'Contact info';

  @override
  String get registerContactHelperEmail =>
      'For email registration, enter your mobile number.';

  @override
  String get registerContactHelperMobile =>
      'Optional: enter your email for account linking.';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerInviteCodeLabel => 'Invite code (optional)';

  @override
  String get registerAcceptPolicy =>
      'I agree to the Terms of Service and Privacy Policy.';

  @override
  String get registerElectronicDeliveryDocumentTitle =>
      'Consent to Electronic Delivery of Documents';

  @override
  String get registerAntiSocialDocumentTitle =>
      'Statement and Pledge Regarding Non-Affiliation with Anti-Social Forces';

  @override
  String get registerPersonalInformationDocumentTitle =>
      'Confirmation Regarding the Handling of Personal Information';

  @override
  String get registerPolicyButton => 'View';

  @override
  String get registerPolicyTitle => 'Terms and Privacy';

  @override
  String get registerPolicyDescription =>
      'This screen demonstrates reusable policy presentation in a shared bottom sheet. Connect your legal policy content service here.';

  @override
  String get registerSubmit => 'Create Account';

  @override
  String get registerBackToLogin => 'Already have an account? Sign in';

  @override
  String get registerPasswordMismatchTitle => 'Passwords do not match';

  @override
  String get registerPasswordMismatchMessage =>
      'Please make sure both passwords are identical.';

  @override
  String get registerUiReadyTitle => 'Registration UI ready';

  @override
  String get registerUiReadyMessage =>
      'UI is complete and ready for API integration.';

  @override
  String get registerEmailMobileRequired =>
      'Mobile number is required for email registration.';

  @override
  String get registerEmailAccountInvalid =>
      'Please enter a valid email address for email registration.';

  @override
  String get registerMobileAccountInvalid =>
      'Please enter a valid phone number for phone registration.';

  @override
  String get registerSubmitFailed => 'Registration failed. Please try again.';

  @override
  String get registerSuccessTitle => 'Registration successful';

  @override
  String get registerSuccessMessage =>
      'Your account is created. Please sign in.';

  @override
  String get forgotPasswordTitle => 'Reset password';

  @override
  String get forgotPasswordSubtitle =>
      'Restore account access with secure verification.';

  @override
  String get forgotPasswordAccountLabel => 'Phone number or email';

  @override
  String get forgotPasswordCodeLabel => 'Verification code';

  @override
  String get forgotPasswordSendCode => 'Send code';

  @override
  String get forgotPasswordSendCodeSuccess => 'Verification code sent.';

  @override
  String get forgotPasswordNewPasswordLabel => 'New password';

  @override
  String get forgotPasswordConfirmPasswordLabel => 'Confirm new password';

  @override
  String get forgotPasswordSubmit => 'Update password';

  @override
  String get forgotPasswordMismatchTitle => 'Passwords do not match';

  @override
  String get forgotPasswordMismatchMessage =>
      'Please verify your new password and confirmation.';

  @override
  String get forgotPasswordUiReadyTitle => 'Reset UI ready';

  @override
  String get forgotPasswordUiReadyMessage =>
      'UI is complete and ready for API integration.';

  @override
  String get forgotPasswordRecoverFailed =>
      'Unable to recover access. Please verify your code.';

  @override
  String get commonOk => 'OK';

  @override
  String get commonBackToLogin => 'Back to sign in';

  @override
  String get homeTitle => 'Home';

  @override
  String get mainTabHome => 'Home';

  @override
  String get mainTabHotel => 'Hotels';

  @override
  String get mainTabDiscussion => 'Board';

  @override
  String get mainTabInvestment => 'Funds';

  @override
  String get mainTabProfile => 'Account';

  @override
  String get mainTabKizunark => 'KIZUNARK';

  @override
  String get mainTabSettings => 'Settings';

  @override
  String get homeHeroTitle => 'Investment Overview';

  @override
  String get homeHeroSubtitle =>
      'Quick view of portfolio, floating P/L, and available cash.';

  @override
  String get homeHeroAssetsLabel => 'Total assets';

  @override
  String get homeHeroPnlLabel => 'Floating P/L';

  @override
  String get homeHeroCashLabel => 'Available cash';

  @override
  String homeWelcomeUser(Object name) {
    return 'Welcome back, $name';
  }

  @override
  String get homeHeroTotalAssetsAmountLabel => 'Total assets';

  @override
  String get homeHeroMonthlyDelta => '+¥127,500 (vs last month +3.4%)';

  @override
  String get homeHeroActiveInvestmentLabel => 'Active investments';

  @override
  String get homeHeroTotalDividendsLabel => 'Total dividends';

  @override
  String get homeTopBannerTitle =>
      'Build future assets\nwith trusted real estate.';

  @override
  String get homeTopBannerBody =>
      'Invest smartly in carefully selected real estate in Japan from JPY 10,000.';

  @override
  String get homeTopBannerRegisterAction => 'Free Sign Up';

  @override
  String get homeGuestBrowsingTitle => 'Browsing without signing in';

  @override
  String get homeGuestBrowsingBody => 'An account is required to invest.';

  @override
  String get homeGuestRegisterBonusTitle => 'Free sign-up for new members';

  @override
  String get homeGuestRegisterBonusBar => 'Get ¥3,000 in investment credit.';

  @override
  String get homeAttractionSectionTitle => 'Why StellaVia';

  @override
  String get homeAttractionAreaTitle => 'Focused on hotels, inns,';

  @override
  String get homeAttractionAreaBody => ' and resorts.';

  @override
  String get homeAttractionStructureTitle => 'Stay at the property';

  @override
  String get homeAttractionStructureBody => ' you invested in.';

  @override
  String get homeAttractionFundsTitle => 'Protect your assets with';

  @override
  String get homeAttractionFundsBody => ' a two-layer shield.';

  @override
  String get homeAttractionAreaDetailBody =>
      'An investment designed to turn travel demand directly into returns.';

  @override
  String get homeAttractionStructureDetailBody =>
      'The travel experience itself can become part of the return.';

  @override
  String get homeAttractionShieldDetailBody =>
      'A structure where the company takes risk first.';

  @override
  String get homeAttractionShieldFirstLabel => 'Shield 1';

  @override
  String get homeAttractionShieldFirstBody =>
      'Subordinated investment by Stella Asset Co., Ltd.';

  @override
  String get homeAttractionShieldSecondLabel => 'Shield 2';

  @override
  String get homeAttractionShieldSecondBody =>
      'Investment by the operating company (TJ BROTHERS GROUP)';

  @override
  String get homeAttractionShieldFootnote =>
      'The amount of subordinated investment varies for each project (starting from 10%). Please see the project overview for details.';

  @override
  String get homeInvestmentFlowTitle => 'How to Invest';

  @override
  String get homeInvestmentFlowStep1Title => 'Sign Up';

  @override
  String get homeInvestmentFlowStep1Body =>
      'Register instantly with your email';

  @override
  String get homeInvestmentFlowStep2Title => 'Verify Identity';

  @override
  String get homeInvestmentFlowStep2Body =>
      'Complete secure identity verification';

  @override
  String get homeInvestmentFlowStep3Title => 'Start Investing';

  @override
  String get homeInvestmentFlowStep3Body =>
      'Invest in curated fund opportunities';

  @override
  String get homeReminderProfileTitle => 'Complete your profile to get started';

  @override
  String get homeReminderProfileBody =>
      'Identity verification required. 3 steps remaining.';

  @override
  String get homeReminderProfileBadge => 'Action needed';

  @override
  String get homeReminderVerifyAction => 'Verify';

  @override
  String get homeReminderEmailVerificationTitle => 'Email verification';

  @override
  String get homeReminderEmailVerificationBody =>
      'This account has no email address yet. Please enter and verify your email address.';

  @override
  String get homeReminderPhoneVerificationTitle => 'Phone verification';

  @override
  String get homeReminderPhoneVerificationBody =>
      'Phone verification is not complete for this account. Please verify your phone number.';

  @override
  String get homeReminderRealPersonVerificationTitle => 'Identity verification';

  @override
  String get homeReminderRealPersonVerificationBody =>
      'Real-person verification is not complete for this account. Please complete identity verification.';

  @override
  String get homeCelebrationBadge => 'WELCOME BONUS';

  @override
  String get homeCelebrationTitle => 'First Sign-Up Reward';

  @override
  String get homeCelebrationAmount => '¥2,500';

  @override
  String get homeCelebrationBody =>
      'Thanks for completing your first registration. We have added a 2,500 yen investment bonus to your account.';

  @override
  String get homeCelebrationPrimaryAction => 'Got it';

  @override
  String get memberProfileEditRequiresFaceVerificationTitle =>
      'Face verification required';

  @override
  String get memberProfileEditRequiresFaceVerificationMessage =>
      'Complete face verification before editing submitted identity information.';

  @override
  String get walletWithdrawRequiresFaceVerificationTitle =>
      'Face verification required';

  @override
  String get walletWithdrawRequiresFaceVerificationMessage =>
      'Complete face verification before continuing with the withdrawal.';

  @override
  String get homeReminderCoolingOffTitle => 'Cooling-off period in progress';

  @override
  String get homeReminderCoolingOffBody =>
      '\"Shinsaibashi Commercial Building\" Contract document issued 3/2 → Cancellation deadline 3/10 (8 days)';

  @override
  String get homeReminderCoolingOffBadge => '5 days left';

  @override
  String get homeReminderCoolingOffAction => 'Cancel contract';

  @override
  String get homeFeaturedFundsTitle => 'Latest Funds';

  @override
  String get homeViewAllAction => 'View All';

  @override
  String get homeOfficialSiteAction => 'StellaVia Office Site';

  @override
  String get homeOfficialSiteOpenFailed => 'Unable to open the official site.';

  @override
  String get homeEstimatedYieldLabel => 'Est. yield';

  @override
  String get homeFreeMarketTitle => 'Flea Market';

  @override
  String get homeFreeMarketStatusListed => 'Listed';

  @override
  String get homeFreeMarketSoldUnitsLabel => 'Matched Units';

  @override
  String get homeFreeMarketUnitPriceLabel => 'Unit Price';

  @override
  String get homeFreeMarketEmptyState =>
      'There are no public flea market listings right now.';

  @override
  String get homeTagOpen => 'Open';

  @override
  String get homeTagLottery => 'Lottery';

  @override
  String get homeTagUpcoming => 'Upcoming';

  @override
  String get homeActiveFundsTitle => 'Active Funds';

  @override
  String get homeInvestedAmountLabel => 'Investment amount';

  @override
  String get homeNextDividendLabel => 'Next Distribution';

  @override
  String get homeShowMoreAction => 'Show more';

  @override
  String get homeShowLessAction => 'Show less';

  @override
  String get homeMockFeaturedFundA =>
      'Akasaka Premium Residence, Minato, Tokyo';

  @override
  String get homeMockFeaturedFundB =>
      'Shinsaibashi Commercial Building, Chuo, Osaka';

  @override
  String get homeMockFeaturedFundC =>
      'Machiya Renovation Hotel, Higashiyama, Kyoto';

  @override
  String get homeMockFeaturedMetaA => '12 months ・ ¥200M';

  @override
  String get homeMockFeaturedMetaB => '18 months ・ ¥150M';

  @override
  String get homeMockFeaturedMetaC => '24 months ・ ¥300M';

  @override
  String get homeMockActiveFundA => 'Shibuya Office Building #12';

  @override
  String get homeMockActiveFundB => 'Nagoya Logistics Facility #09';

  @override
  String get homeMockActiveFundC => 'Fukuoka Residence Fund #07';

  @override
  String get homeMockActiveFundD => 'Sapporo Mixed-Use Fund #03';

  @override
  String get fundListTitle => 'Fund List';

  @override
  String get fundListFilterAll => 'All';

  @override
  String get fundListFilterOperating => 'Operating';

  @override
  String get fundListFilterOperatingEnded => 'Operation Ended';

  @override
  String get fundListFilterOpen => 'Open';

  @override
  String get fundListFilterUpcoming => 'Upcoming';

  @override
  String get fundListFilterFavorites => 'Favorites';

  @override
  String get fundListFilterClosed => 'Closed';

  @override
  String get fundListFilterCompleted => 'Completed';

  @override
  String get fundListFilterFailed => 'Failed';

  @override
  String get fundListYieldLabel => 'Yield';

  @override
  String get fundListPeriodLabel => 'Period';

  @override
  String fundListMinimumInvestmentValue(Object amount) {
    return 'From JPY $amount';
  }

  @override
  String get fundListMethodLabel => 'Method';

  @override
  String get fundListMethodLottery => 'Lottery';

  @override
  String get fundListGainTypeIncomeGain => 'Income Gain';

  @override
  String get fundListGainTypeCapitalGain => 'Capital Gain';

  @override
  String get fundListGainTypeMixed => 'Mixed (Income + Capital)';

  @override
  String get fundListMethodUnknown => 'Unknown';

  @override
  String fundListAppliedAmount(Object amount, Object progress) {
    return 'Applied $amount ($progress)';
  }

  @override
  String fundListOpenStartAt(Object start) {
    return 'Subscription starts $start';
  }

  @override
  String get fundListViewDetail => 'Details→';

  @override
  String get fundListLoadError => 'Failed to load funds. Please try again.';

  @override
  String get fundListRetry => 'Retry';

  @override
  String get fundListEmpty => 'No funds found for this filter.';

  @override
  String get fundListStatusOperating => 'Operating';

  @override
  String get fundListStatusOperatingEnded => 'Operation Ended';

  @override
  String get fundListStatusOpen => 'Open';

  @override
  String get fundListStatusUpcoming => 'Upcoming';

  @override
  String get fundListStatusClosed => 'Closed';

  @override
  String get fundListStatusCompleted => 'Completed';

  @override
  String get fundListStatusFailed => 'Failed';

  @override
  String get fundListStatusUnknown => 'Unknown';

  @override
  String fundListVolume(Object number) {
    return 'Vol. $number';
  }

  @override
  String get hotelTabHeadline => 'Hotel Booking Module (Framework)';

  @override
  String get hotelTabSubtitle =>
      'Search, list, detail, and booking flows will be integrated here next.';

  @override
  String get discussionTabHeadline => 'Investment Discussion Board (Framework)';

  @override
  String get discussionTabSubtitle =>
      'Interactive message-board area for replies, likes, pinning, and moderation.';

  @override
  String get discussionTabReplyAction => 'Reply';

  @override
  String get kizunarkSubtitle => 'Investor community';

  @override
  String get kizunarkInvestorOnlyNotice =>
      'Only verified investors can post & comment';

  @override
  String get kizunarkComposePlaceholder => 'Share your investment thoughts...';

  @override
  String get kizunarkAssociateFundAction => 'Link Fund';

  @override
  String get kizunarkAssociateFundSheetTitle => 'Select a Fund to Link';

  @override
  String get kizunarkAssociateFundEmpty =>
      'No active funds are available to link.';

  @override
  String get kizunarkPostAction => 'Post';

  @override
  String get kizunarkReplyPlaceholder => 'Write a comment...';

  @override
  String get kizunarkReplySendAction => 'Send';

  @override
  String get kizunarkJustNow => 'Just now';

  @override
  String kizunarkTimeMinutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String kizunarkTimeHoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get kizunarkFallbackDisplayName => 'Investor**';

  @override
  String get kizunarkFallbackHandle => 'usr***@';

  @override
  String get kizunarkInvestorBadge => 'Investor';

  @override
  String get kizunarkPostSuccessNotice => 'Post submitted.';

  @override
  String get kizunarkReplySuccessNotice => 'Comment sent.';

  @override
  String get kizunarkDeleteAction => 'Delete';

  @override
  String get kizunarkDeleteConfirmTitle => 'Delete this comment?';

  @override
  String get kizunarkDeleteConfirmBody => 'This action cannot be undone.';

  @override
  String get kizunarkDeleteCancelAction => 'Cancel';

  @override
  String get kizunarkDeleteConfirmAction => 'Delete';

  @override
  String get kizunarkDeleteSuccessNotice => 'Comment deleted.';

  @override
  String get kizunarkDeleteFailedNotice => 'Failed to delete comment.';

  @override
  String get kizunarkCopyAction => 'Copy';

  @override
  String get kizunarkCopySuccessNotice => 'Message copied.';

  @override
  String get kizunarkMenuCancelAction => 'Cancel';

  @override
  String get kizunarkLoginRequiredToPost =>
      'Please sign in to post and comment.';

  @override
  String get kizunarkGuestLoginPrompt =>
      'Sign in or create an account to comment.';

  @override
  String get kizunarkEmptyState => 'No posts yet. Start the first discussion.';

  @override
  String get investmentTabHeadline => 'Investment Module (Framework)';

  @override
  String get investmentTabSubtitle =>
      'Products, portfolio, subscriptions/redemptions, and statements will be added here.';

  @override
  String get investmentTabPortfolioLabel => 'Holdings';

  @override
  String get investmentTabWatchlistLabel => 'Watchlist';

  @override
  String get profileTabHeadline => 'Profile Center (Framework)';

  @override
  String get profileTabSubtitle =>
      'Manage account details, profile intake, preferences, and member status.';

  @override
  String get settingsTabHeadline => 'Settings';

  @override
  String get settingsTabSubtitle =>
      'Account, security, legal documents, and preference settings will be integrated here.';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSectionAccount => 'Account';

  @override
  String get menuSectionSecurity => 'Security';

  @override
  String get menuSectionDocsTax => 'Documents & Tax';

  @override
  String get menuSectionPreferences => 'Preferences';

  @override
  String get menuSectionSupport => 'Support';

  @override
  String get menuItemTheme => 'Theme';

  @override
  String get menuItemEditProfile => 'Member profile';

  @override
  String get memberProfileOverviewTitle => 'Member Profile';

  @override
  String get memberProfileOverviewStatusEmailUnbound => 'Email not linked';

  @override
  String get memberProfileOverviewStatusIncomplete => 'Incomplete';

  @override
  String get memberProfileOverviewStatusUnverified => 'Not verified';

  @override
  String get memberProfileOverviewStatusPending => 'Pending review';

  @override
  String get memberProfileOverviewStatusFailed => 'Verification failed';

  @override
  String get memberProfileOverviewStatusVerified => 'Verified';

  @override
  String get memberProfileOverviewUnverifiedTitle =>
      'Complete identity verification now (about 3 min)';

  @override
  String get memberProfileOverviewUnverifiedMessage =>
      'After identity verification, you can start investing with ¥3,000 in investment credit.';

  @override
  String get memberProfileOverviewFailedTitle => 'Verification failed';

  @override
  String get memberProfileOverviewFailedMessage =>
      'Restart the member profile intake flow to verify again.';

  @override
  String get memberProfileOverviewStartIntakeAction => 'Go to profile intake';

  @override
  String get commonEditText => 'Edit';

  @override
  String get commonReplaceText => 'Change';

  @override
  String get menuItemBankSettings => 'Bank account settings';

  @override
  String get menuItemChangePassword => 'Change password';

  @override
  String get menuItemTwoFactor => 'Two-factor authentication';

  @override
  String get settingsTwoFactorDescription =>
      'Manage phone verification and real-person verification status for sensitive actions.';

  @override
  String get settingsEmailVerificationTitle => 'Email verification';

  @override
  String get settingsPhoneVerificationTitle => 'Phone verification';

  @override
  String get settingsFaceVerificationTitle => 'Face verification';

  @override
  String get settingsVerificationStatusVerified => 'Verified';

  @override
  String get settingsVerificationStatusUnverified => 'Not verified';

  @override
  String get settingsVerificationEmailLabel => 'Verified email';

  @override
  String get settingsVerificationPhoneLabel => 'Verified number';

  @override
  String get settingsVerificationLastUpdatedLabel => 'Last verified';

  @override
  String get settingsEmailVerificationDescription =>
      'Send a verification code to your current email address and update the email verification status.';

  @override
  String get settingsCurrentEmailLabel => 'Current email address';

  @override
  String get settingsEmailUnavailable => 'No email address registered.';

  @override
  String get settingsEmailVerificationInputDescription =>
      'Enter the email address to use for verification and send a verification code.';

  @override
  String get settingsEmailAutoFillHint =>
      'Enter the verification code from the email to complete verification.';

  @override
  String get settingsEmailVerifyAction => 'Verify email address';

  @override
  String get settingsEmailCodeRequired => 'Enter the verification code first.';

  @override
  String get settingsEmailCodeSent => 'Verification code sent.';

  @override
  String get settingsEmailVerificationSuccess =>
      'Email verification completed.';

  @override
  String get settingsEmailVerifiedReadonlyDescription =>
      'A verified email address cannot be changed from this screen.';

  @override
  String get settingsPhoneVerificationDescription =>
      'Send a one-time code to your registered phone number and update verification status on this device.';

  @override
  String get settingsCurrentPhoneLabel => 'Current phone number';

  @override
  String get settingsPhoneUnavailable => 'No phone number registered.';

  @override
  String get settingsPhoneVerificationPhoneMissing =>
      'Register a phone number in your member profile first.';

  @override
  String get settingsPhoneVerificationInputDescription =>
      'Enter the phone number to use for verification and send a one-time code.';

  @override
  String get settingsPhoneAutoFillHint =>
      'On supported devices, the SMS verification code can appear as an autofill suggestion.';

  @override
  String get settingsPhoneVerifyAction => 'Verify phone number';

  @override
  String get settingsPhoneCodeRequired => 'Enter the verification code first.';

  @override
  String get settingsPhoneCodeSent => 'Verification code sent.';

  @override
  String get settingsPhoneVerificationSuccess =>
      'Phone verification completed.';

  @override
  String get settingsFaceVerificationDescription =>
      'Enable face verification on this device as a security measure. After setup, it will be used to confirm your identity for sensitive actions.';

  @override
  String get settingsFaceVerificationUploadTitle => 'Upload a selfie';

  @override
  String get settingsFaceVerificationUploadDescription =>
      'Upload a selfie for identity verification and face verification will start automatically. You can also retry it manually.';

  @override
  String get settingsFaceVerificationSelfieTitle =>
      'Selfie for identity verification';

  @override
  String get settingsFaceVerificationSelfieDescription =>
      'Face the camera directly and make sure your full face is clearly visible.';

  @override
  String get settingsFaceVerificationReverifyAction => 'Verify again';

  @override
  String get menuItemAnnualReport => 'Annual transaction report';

  @override
  String get menuItemContractList => 'Contract document list';

  @override
  String get menuItemMyNumber => 'My Number management';

  @override
  String get menuItemLanguage => 'Language';

  @override
  String get menuThemeSystem => 'Follow system';

  @override
  String get menuThemeLight => 'Light';

  @override
  String get menuThemeDark => 'Dark';

  @override
  String get menuItemFaqHelp => 'FAQ / Help';

  @override
  String get menuItemChatSupport => 'Chat support';

  @override
  String get menuItemContactUs => 'Contact us';

  @override
  String get menuItemOperatingCompany => 'About the operator';

  @override
  String get settingsContactTitle => 'Contact us';

  @override
  String get settingsContactDescription =>
      'If you have any questions or feedback, please feel free to contact us using the form below.';

  @override
  String get settingsContactNameLabel => 'Full name';

  @override
  String get settingsContactKanaLabel => 'Phonetic name';

  @override
  String get settingsContactKanaFamilySegment => 'SEI';

  @override
  String get settingsContactKanaGivenSegment => 'MEI';

  @override
  String get settingsContactEmailLabel => 'Email address';

  @override
  String get settingsContactEmailHint => 'example@mail.com';

  @override
  String get settingsContactCategoryLabel => 'Inquiry category';

  @override
  String get settingsContactCategoryPlaceholder => 'Please select';

  @override
  String get settingsContactCategoryInvestment => 'About investment';

  @override
  String get settingsContactCategoryAccount => 'About account or login';

  @override
  String get settingsContactCategoryWallet =>
      'About distributions or deposits and withdrawals';

  @override
  String get settingsContactCategoryEkyc =>
      'About identity verification (eKYC)';

  @override
  String get settingsContactCategoryOther => 'Other';

  @override
  String get settingsContactMessageLabel => 'Message';

  @override
  String get settingsContactMessageHint => 'Please enter your inquiry';

  @override
  String get settingsContactConfirmAction => 'Confirm';

  @override
  String get settingsContactConfirmTitle => 'Confirm inquiry details';

  @override
  String get settingsContactSubmitAction => 'Send';

  @override
  String get settingsContactSubmitSuccess => 'Your inquiry has been received.';

  @override
  String get settingsContactSuccessTitle => 'Your inquiry has been\nreceived';

  @override
  String get settingsContactSuccessBody =>
      'Thank you for contacting us.\nWe have sent a confirmation email. Please check your inbox.\nAfter reviewing your inquiry, we will generally reply within three business days.';

  @override
  String get settingsContactSuccessBackAction => 'Back to top page';

  @override
  String get settingsContactPhoneSectionTitle => 'Phone inquiries';

  @override
  String get settingsContactPhoneHours =>
      'Business hours: Weekdays 10:00–18:00 (excluding weekends and holidays)';

  @override
  String get settingsContactCallFailed => 'Could not open the phone app.';

  @override
  String get settingsCompanyMailFailed => 'Could not open the mail app.';

  @override
  String get settingsContactValidationName =>
      'Please enter your family name and given name.';

  @override
  String get settingsContactValidationKana =>
      'Please enter your phonetic name.';

  @override
  String get settingsContactValidationEmail =>
      'Please enter a valid email address.';

  @override
  String get settingsContactValidationCategory =>
      'Please select an inquiry category.';

  @override
  String get settingsContactValidationMessage => 'Please enter your message.';

  @override
  String get settingsOperatingCompanyTitle => 'Operating company';

  @override
  String get settingsContractListDescription =>
      'Review contract documents and reports for your invested projects.';

  @override
  String get settingsContractListEmptyState =>
      'No contract documents available.';

  @override
  String settingsContractListPdfCount(Object count) {
    return '$count PDFs';
  }

  @override
  String settingsContractListDocumentTypeCount(Object count) {
    return '$count document types';
  }

  @override
  String get settingsContractListLatestUpdatedLabel => 'Last updated';

  @override
  String get settingsContractListPendingLabel => 'PDF pending';

  @override
  String get settingsContractDetailTitle => 'Contract documents';

  @override
  String get settingsContractDetailRelatedFilesTitle => 'Related PDFs';

  @override
  String get settingsContractDetailMissingProject =>
      'Contract document details could not be found.';

  @override
  String get settingsContractDetailNoPdfAvailable =>
      'There are no PDFs available yet.';

  @override
  String get settingsCompanyTradeNameLabel => 'Trade name';

  @override
  String get settingsCompanyLicenseNumberLabel => 'License number';

  @override
  String get settingsCompanyLicenseTypeLabel => 'License type';

  @override
  String get settingsCompanyRepresentativeLabel => 'Representative';

  @override
  String get settingsCompanyHeadOfficeLabel => 'Head office';

  @override
  String get settingsCompanyTelLabel => 'TEL';

  @override
  String get settingsCompanyEmailLabel => 'Email';

  @override
  String get settingsCompanyEstablishedLabel => 'Established';

  @override
  String get settingsCompanyBusinessLabel => 'Main business';

  @override
  String get settingsCompanyManagerLabel => 'Business manager';

  @override
  String get settingsCompanyRelatedLinksTitle => 'Related links';

  @override
  String get settingsCompanyLinkTerms => 'Terms of use';

  @override
  String get settingsCompanyLinkPrivacy => 'Privacy policy';

  @override
  String get settingsCompanyLinkSolicitation => 'Solicitation policy';

  @override
  String get settingsCompanyLinkAntiSocial => 'Anti-social forces policy';

  @override
  String get menuVersionFootnote =>
      'StellaVia v1.0.0 · Real Estate Specified Joint Enterprise License No. XXX';

  @override
  String get menuDeleteAccountAction => 'Delete account';

  @override
  String get settingsDeleteAccountSupportTitle => 'Delete account';

  @override
  String get settingsDeleteAccountSupportMessage =>
      'Account deletion is not available in the app yet. Please contact customer support by phone.';

  @override
  String get settingsDeleteAccountCallAction => 'Call';

  @override
  String get menuDeleteAccountConfirmTitle => 'Delete account?';

  @override
  String get menuDeleteAccountConfirmBody =>
      'This action cannot be undone. The actual account deletion flow will be connected later.';

  @override
  String get menuDeleteAccountComingSoon =>
      'Account deletion flow will be connected in a later implementation.';

  @override
  String menuFeatureComingSoon(Object feature) {
    return '$feature will be connected in a later implementation.';
  }

  @override
  String get settingsLogoutConfirmTitle => 'Log out?';

  @override
  String get settingsLogoutConfirmBody =>
      'You will need to sign in again to continue using this account.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsLotteryTitle => 'Lottery result';

  @override
  String get notificationsLotterySubtitle =>
      'After API integration, lottery and deposit notifications will appear here.';

  @override
  String get notificationsSystemTitle => 'System notices';

  @override
  String get notificationsSystemSubtitle =>
      'Maintenance, statements, and legal updates.';

  @override
  String get notificationsTabImportant => 'Important';

  @override
  String get notificationsTabGeneral => 'Updates';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsNewsPushLabel => 'Receive news notifications';

  @override
  String notificationsMarkAllReadDone(int count) {
    return 'Marked $count items as read.';
  }

  @override
  String get notificationsAllReadAlreadyDone => 'No unread notifications.';

  @override
  String get notificationsEmptyImportant => 'No important notifications.';

  @override
  String get notificationsEmptyGeneral => 'No notifications.';

  @override
  String get notificationsEmptyGuest => 'Sign in to view notifications.';

  @override
  String get notificationsLoginRequired => 'Sign in required.';

  @override
  String get notificationsDetailNoContent => 'No details available.';

  @override
  String get notificationsDetailClose => 'Close';

  @override
  String get homeLogout => 'Sign out';

  @override
  String get uiErrorRequestFailed => 'Request failed. Please try again later.';

  @override
  String get uiErrorNetworkUnavailable =>
      'Network connection error. Please try again later.';

  @override
  String get uiErrorNetworkAccessDenied =>
      'Unable to access the network. Check your connection or system settings.';

  @override
  String get uiErrorAuthExpired => 'Session expired. Please sign in again.';

  @override
  String get uiErrorForbidden =>
      'You do not have permission to access this resource.';

  @override
  String get uiErrorServerUnavailable =>
      'Service is temporarily unavailable. Please try again later.';

  @override
  String get languageFollowSystem => 'Follow system';

  @override
  String get languageChinese => 'Simplified Chinese';

  @override
  String get languageTraditionalChinese => 'Traditional Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => 'Japanese';

  @override
  String get fundDetailEstimatedYieldAnnualLabel =>
      'Estimated yield (annualized)';

  @override
  String get fundDetailYieldDisclaimer => '※ Estimated, not guaranteed';

  @override
  String get fundDetailKeyFactsTitle => 'Key facts';

  @override
  String get fundDetailScheduleTitle => 'Offering & Operation Schedule';

  @override
  String get fundDetailTargetAmountLabel => 'Target amount';

  @override
  String get fundDetailInvestmentUnitLabel => 'Investment unit';

  @override
  String get fundDetailMaximumInvestmentPerPersonLabel =>
      'Maximum per investor';

  @override
  String get fundDetailFundTotalLabel => 'Fund size';

  @override
  String get fundDetailOfferCategoryLabel => 'Offering category';

  @override
  String get fundDetailRemainingDaysLabel => 'Days remaining';

  @override
  String get fundDetailMinimumInvestmentLabel => 'Minimum investment';

  @override
  String get fundDetailDividendLabel => 'Distribution';

  @override
  String get fundDetailDistributionDateLabel => 'Distribution Date';

  @override
  String get fundDetailLotteryDateLabel => 'Lottery date';

  @override
  String get fundDetailOfferingTargetsLabel => 'Offering targets';

  @override
  String get fundDetailPreferredStructureTitle => 'Senior/Junior Structure';

  @override
  String get fundDetailSeniorInvestmentLabel => 'Preferred';

  @override
  String get fundDetailJuniorInvestmentLabel => 'Subordinated';

  @override
  String get fundDetailPropertyInfoTitle => 'Property details';

  @override
  String get fundDetailLocationLabel => 'Location';

  @override
  String get fundDetailPropertyTypeLabel => 'Property type';

  @override
  String get fundDetailStructureLabel => 'Structure';

  @override
  String get fundDetailBuiltYearLabel => 'Built';

  @override
  String get fundDetailCoolingOffLabel => 'Cooling-off';

  @override
  String get fundDetailCoolingOffDefault =>
      '8 days from the day after document delivery';

  @override
  String get fundDetailMapClose => 'Close';

  @override
  String get fundDetailMapDestination => 'Destination';

  @override
  String get fundDetailMapCurrentLocation => 'Current';

  @override
  String get fundDetailMapDirections => 'Route';

  @override
  String get fundDetailMapOpenMapApp => 'Open maps app';

  @override
  String get fundDetailMapCancel => 'Cancel';

  @override
  String get fundDetailMapPermissionDenied =>
      'Location permission is not granted.';

  @override
  String get fundDetailMapUnavailable => 'Unable to load map data.';

  @override
  String get fundDetailContractOverviewTitle => 'Contract Summary';

  @override
  String get fundDetailContractTypeLabel => 'Contract type';

  @override
  String get fundDetailContractTypeValue => 'Silent partnership';

  @override
  String get fundDetailTargetPropertyTypeLabel => 'Target real estate type';

  @override
  String get fundDetailAppraisalValueLabel => 'Appraisal value';

  @override
  String get fundDetailAcquisitionPriceLabel => 'Planned acquisition price';

  @override
  String get fundDetailOfferPeriodLabel => 'Offering period';

  @override
  String get fundDetailOperationStartLabel => 'Planned start date';

  @override
  String get fundDetailOperationEndLabel => 'Planned end date';

  @override
  String get fundDetailOperatorInfoTitle => 'Operator information';

  @override
  String get fundDetailOperatorCompanyLabel => 'Operator';

  @override
  String get fundDetailPermitNumberLabel => 'License number';

  @override
  String get fundDetailRepresentativeLabel => 'Representative';

  @override
  String get fundDetailCompanyAddressLabel => 'Address';

  @override
  String get fundDetailOperatorCapitalLabel => 'Capital';

  @override
  String get fundDetailOperatorEstablishedLabel => 'Established';

  @override
  String get fundDetailOperatorBusinessStartLabel => 'Business start filing';

  @override
  String get fundDetailDocumentsTitle => 'Related documents';

  @override
  String get fundDetailDocumentReady => 'Tap to review';

  @override
  String fundDetailDocumentMultipleReady(int count) {
    return '$count PDF files';
  }

  @override
  String get fundDetailDocumentSelectTitle => 'Select document';

  @override
  String fundDetailDocumentPickerItem(int index) {
    return 'Document $index';
  }

  @override
  String get fundDetailDocumentUnavailable => 'Document URL not available';

  @override
  String get fundDetailPropertyPreviewBadge => 'Property preview';

  @override
  String get fundDetailCommentsTitle => 'Investor voices (KIZUNARK)';

  @override
  String get fundDetailCommentsPlaceholder =>
      'Comments are intentionally left empty for now. UI integration will be added later.';

  @override
  String get fundDetailCommentsPreviewAvatar => 'S';

  @override
  String get fundDetailCommentsPreviewUser => 'Sato**';

  @override
  String get fundDetailCommentsPreviewTime => '2h ago';

  @override
  String get fundDetailCommentsPreviewBody =>
      'The Hakuba project looks solid with steady resort demand. The planned return range of 1.5%–14.6% is wide, but upside could be meaningful depending on the sale.';

  @override
  String get fundDetailCommentsPreviewReplyCount => '3';

  @override
  String get fundDetailCommentsMoreAction => 'View more in KIZUNARK';

  @override
  String get fundDetailFinancialStatusAction =>
      'View operator financial status →';

  @override
  String get fundDetailFinancialStatusToast =>
      'The financial status page will be connected in a later implementation.';

  @override
  String get fundDetailApplyNowAction => 'Apply for lottery';

  @override
  String get fundDetailOpenSoonAction => 'Waiting for opening';

  @override
  String get fundDetailUnavailableAction => 'Unavailable now';

  @override
  String get fundDetailApplyComingSoonToast =>
      'The application flow will be connected in the next implementation.';

  @override
  String get lotteryApplyFlowTitle => 'Lottery Application';

  @override
  String get lotteryApplyStep1Title => '1. Enter units';

  @override
  String get lotteryApplyStep1BalanceLabel => 'Standby cash balance';

  @override
  String get lotteryApplyStep1DepositAction => 'Deposit';

  @override
  String get lotteryApplyStep1AmountLabel =>
      'Units to apply (1 unit = ¥100,000)';

  @override
  String lotteryApplyStep1AmountLabelWithRules(
    Object unitAmount,
    Object maxAmount,
  ) {
    return 'Units to apply (1 unit = $unitAmount / max $maxAmount)';
  }

  @override
  String get lotteryApplyStep1UnitPriceLabel => 'Price per unit';

  @override
  String get lotteryApplyStep1UnitCountLabel => 'Units';

  @override
  String get lotteryApplyStep1UnitSuffix => 'units';

  @override
  String get lotteryApplyStep1TotalAmountLabel => 'Order total';

  @override
  String lotteryApplyStep1MaximumUnitsNotice(Object maxUnits) {
    return 'You can apply for up to $maxUnits units.';
  }

  @override
  String lotteryApplyStep1MinimumUnitsNotice(Object minUnits) {
    return 'The minimum order is $minUnits unit.';
  }

  @override
  String get lotteryApplyStep1BalanceWarningTitle =>
      'Insufficient standby cash';

  @override
  String get lotteryApplyStep1BalanceWarningBody =>
      'Your balance is lower than the selected amount. Please deposit first, then continue the application.';

  @override
  String get lotteryApplyStep1BalanceWarningAction => 'Go to deposit';

  @override
  String get lotteryApplyStep1MaximumWarningTitle => 'Exceeded maximum limit';

  @override
  String get lotteryApplyStep1MaximumWarningBody =>
      'The selected amount exceeds the per-user limit for this project. Please reduce the number of units.';

  @override
  String get lotteryApplyStep1EstimatedDistributionLabel =>
      'Estimated distribution (before tax)';

  @override
  String get lotteryApplyStep1EstimatedDistributionSuffix => '/year';

  @override
  String get lotteryApplyStep1NextAction => 'Next: Documents';

  @override
  String get lotteryApplyStep2Title => '2. Review contract documents';

  @override
  String get lotteryApplyStep2Description =>
      'These documents are required for your investment decision. Please review and check all items.';

  @override
  String get lotteryApplyStep2OpenDocumentFirstNotice =>
      'Please open and review the document first.';

  @override
  String get lotteryApplyDocumentPreContractTitle =>
      'Pre-contract disclosure document';

  @override
  String get lotteryApplyDocumentPreContractSubtitle =>
      'PDF 12 pages | Includes key terms and risk notes';

  @override
  String get lotteryApplyDocumentAgreementTitle => 'Silent partnership terms';

  @override
  String get lotteryApplyDocumentAgreementSubtitle =>
      'PDF 8 pages | Contract terms and distribution details';

  @override
  String get lotteryApplyStep2InfoBody =>
      'Consent for electronic document delivery was collected during account registration. You can revoke or update it anytime in settings.';

  @override
  String get lotteryApplyStep2NextAction =>
      'Continue after confirming all documents';

  @override
  String get lotteryApplyStep3Title => '3. Confirm application details';

  @override
  String get lotteryApplyFundNameLabel => 'Fund';

  @override
  String get lotteryApplyInvestmentAmountLabel => 'Investment amount';

  @override
  String get lotteryApplyAnnualYieldPrefix => 'Annual';

  @override
  String get lotteryApplyNoticeTitle => 'Notice';

  @override
  String get lotteryApplyNoticeBody =>
      'This investment does not guarantee principal. If selected in the lottery, payment is required within the specified deadline.';

  @override
  String get lotteryApplyAgreementLabel =>
      'I have reviewed the above details and agree to proceed with the lottery application.';

  @override
  String get lotteryApplySubmitAction => 'Submit lottery application';

  @override
  String get lotteryApplySubmitFailedFallback =>
      'Failed to submit lottery application. Please try again later.';

  @override
  String get lotteryApplyStep4Headline => 'Lottery application submitted!';

  @override
  String lotteryApplyStep4Body(Object projectName) {
    return 'Your lottery application for \"$projectName\" has been completed. and you\'ll receive a notification in the app.';
  }

  @override
  String get lotteryApplyResultAnnouncementDateLabel =>
      'Result announcement date';

  @override
  String get lotteryApplyApplicationNumberLabel => 'Application number';

  @override
  String get lotteryApplyStep4HintBody =>
      'If selected, please complete payment within 8 days (including cooling-off period). If not selected, no action is needed. If minimum demand is not met, a review and lottery process still applies.';

  @override
  String get lotteryApplyBackHomeAction => 'Back to Home';

  @override
  String get lotteryApplyDemoCheckResultAction => 'View lottery result →';

  @override
  String get lotteryApplyStep5Headline => 'Selection notice';

  @override
  String lotteryApplyStep5Body(Object projectName) {
    return 'Congratulations! You were selected in the \"$projectName\" lottery. Please transfer funds to the designated account.';
  }

  @override
  String get lotteryApplyDeadlineLabel =>
      'Payment deadline (includes 8-day cooling-off)';

  @override
  String get lotteryApplyCoolingOffTitle => 'About cooling-off';

  @override
  String get lotteryApplyCoolingOffBody =>
      'You can cancel unconditionally within 8 days from the day after contract document delivery. Cancellation is also available during cooling-off even after payment.';

  @override
  String get lotteryApplyDepositAmountLabel => 'Payment amount';

  @override
  String get lotteryApplyBankNameLabel => 'Bank';

  @override
  String get lotteryApplyBankBranchLabel => 'Branch';

  @override
  String get lotteryApplyBankAccountLabel => 'Account';

  @override
  String get lotteryApplyBankHolderLabel => 'Account holder';

  @override
  String get lotteryApplyMockBankName => 'GMO Aozora Net Bank';

  @override
  String get lotteryApplyMockBankBranch => 'Corporate First Branch (101)';

  @override
  String get lotteryApplyMockBankAccount => 'Ordinary 1234567';

  @override
  String get lotteryApplyMockBankHolder => 'FUNDEX Co., Ltd.';

  @override
  String get lotteryApplyReportDepositAction => 'Report payment completed';

  @override
  String get lotteryApplyReportDepositSuccess =>
      'Payment completion report sent.';

  @override
  String get lotteryApplyReportDepositFailure =>
      'Failed to send the payment completion report. Please try again later.';

  @override
  String get lotteryApplyStandbyBalanceLabel => 'Standby cash balance';

  @override
  String get lotteryApplyStandbyPurchaseAction => 'Purchase with standby cash';

  @override
  String get lotteryApplyStandbyPurchaseConfirmTitle =>
      'Purchase with standby cash?';

  @override
  String lotteryApplyStandbyPurchaseConfirmBody(
    Object projectName,
    Object amount,
  ) {
    return 'Project: $projectName\nTransaction amount: $amount';
  }

  @override
  String get lotteryApplyStandbyPurchaseConfirmAction => 'Purchase';

  @override
  String get lotteryApplyStandbyPurchaseMissingProcess =>
      'Unable to confirm the purchase information. Please refresh and try again.';

  @override
  String get lotteryApplyStandbyShortageLabel => 'Shortage';

  @override
  String get lotteryApplyStandbyPurchaseSuccess =>
      'Purchased with standby cash.';

  @override
  String get lotteryApplyStandbyPurchaseFailure =>
      'Failed to purchase with standby cash.';

  @override
  String get lotteryApplyDepositReportConfirmedTitle =>
      'We have received your payment completion notice.';

  @override
  String get lotteryApplyDepositReportConfirmedBody =>
      'Thank you for your response.\nWe will review the details and proceed as quickly as possible.';

  @override
  String get lotteryApplyDepositReportBackAction => 'Back';

  @override
  String get lotteryApplyLaterDepositAction => 'Pay later';

  @override
  String get lotteryApplyCopyAction => 'Copy';

  @override
  String get lotteryApplyCopyAccountInfoAction => 'Copy account info';

  @override
  String get lotteryApplyCopyDoneToast => 'Copied';

  @override
  String get walletDepositTransferNameCopyAction => 'Copy payer name';

  @override
  String get lotteryApplyStep6Headline => 'Investment process completed';

  @override
  String get lotteryApplyStep6Body =>
      'We have confirmed your payment. \nDistribution schedules will be sent via notifications.';

  @override
  String get lotteryApplyReceiptLabel => 'Receipt No:';

  @override
  String get fundApplyVerificationRequiredTitle => 'Verification required';

  @override
  String get fundApplyVerificationRequiredMessage =>
      'Fund applications are available only to verified members. Please complete verification first.';

  @override
  String get fundDetailUnknownValue => '--';

  @override
  String get fundDetailProductSummaryTitle => 'Product Summary';

  @override
  String get fundDetailFeaturesTitle => 'Features';

  @override
  String get fundDetailReferenceVideoTitle => 'Reference video';

  @override
  String get fundDetailReferenceVideoLoadError => 'Failed to load the video.';

  @override
  String get fundDetailReferenceVideoOpenInBrowser => 'Play in browser';

  @override
  String get fundDetailReferenceVideoExternalHint =>
      'This video opens on an external page.';

  @override
  String get fundDetailReferenceVideoOpenFailed =>
      'Could not open the video page.';

  @override
  String get fundDetailReferenceVideoPlayAction => 'Play';

  @override
  String fundDetailInvestmentUnitValue(Object amount) {
    return '$amount円 / 1 unit';
  }

  @override
  String fundDetailMaximumInvestmentPerPersonValue(
    Object amount,
    Object units,
  ) {
    return '$amount円 / $units units';
  }

  @override
  String get fundDetailOneUnitSuffix => '(1 unit)';

  @override
  String get fundDetailMonthlyDistribution => 'Monthly';

  @override
  String get fundDetailQuarterlyDistribution => 'Quarterly';

  @override
  String get fundDetailSemiAnnualDistribution => 'Semi-annually';

  @override
  String get fundDetailAnnualDistribution => 'Annually';

  @override
  String get fundDetailPlannedDistributionRateLabel =>
      'Planned distribution rate (before tax)';

  @override
  String get fundDetailAchievementRateLabel => 'Funding achievement rate';

  @override
  String get fundDetailGainTypeTitle => 'Type of Return';

  @override
  String get fundDetailSubordinatedRatioLabel =>
      'Subordinated investment ratio';

  @override
  String get fundDetailGainTypeDescriptionTitle => 'About the Type of Return';

  @override
  String get fundDetailGainTypeIncomeGainTitle => '1. Income Gain';

  @override
  String get fundDetailGainTypeIncomeGainBody =>
      'Meaning: Regular income generated from held assets\n\nFeatures: Stable cash flow received monthly or quarterly\n\nExamples: Rental income from real estate, revenue from minpaku and hotel operations';

  @override
  String get fundDetailGainTypeCapitalGainTitle => '2. Capital Gain';

  @override
  String get fundDetailGainTypeCapitalGainBody =>
      'Meaning: Profit earned by selling an asset after its price increases\n\nFeatures: One-time profit realized when the asset is sold\n\nExamples: Profit from real estate sales';

  @override
  String get fundDetailGainTypeMixedTitle => '3. Mixed (Income + Capital)';

  @override
  String get fundDetailGainTypeMixedBody =>
      'Meaning: A strategy that targets both income gain and capital gain\n\nFeatures: Can expect both stable income such as dividends or interest and upside from price appreciation\n\nExamples: Rental income + profit from property sales';

  @override
  String get fundDetailTabPropertyOverview => 'Property overview';

  @override
  String get fundDetailTabIncomeScheme => 'Income scheme';

  @override
  String fundDetailPropertyCountHint(int count) {
    return 'This fund consists of $count properties.';
  }

  @override
  String fundDetailPropertyItemPrefix(int index) {
    return 'Property $index';
  }

  @override
  String get fundDetailPropertyNameLabel => 'Property name';

  @override
  String get fundDetailTransportationLabel => 'Transportation';

  @override
  String get fundDetailLandSectionTitle => 'Land';

  @override
  String get fundDetailLandCategoryLabel => 'Land category';

  @override
  String get fundDetailAreaLabel => 'Area';

  @override
  String get fundDetailRightsLabel => 'Rights';

  @override
  String get fundDetailBuildingSectionTitle => 'Building';

  @override
  String get fundDetailFloorAreaLabel => 'Floor area';

  @override
  String get fundDetailBuiltYearMonthLabel => 'Built year/month';

  @override
  String get fundDetailRegulationSectionTitle => 'Regulation';

  @override
  String get fundDetailLandUseZoneLabel => 'Land-use zone';

  @override
  String get fundDetailBuildingCoverageRatioLabel => 'Building coverage ratio';

  @override
  String get fundDetailFloorAreaRatioLabel => 'Floor area ratio';

  @override
  String get fundDetailOperationContractSectionTitle =>
      'Operation contract summary';

  @override
  String get fundDetailOperationTypeLabel => 'Operation type';

  @override
  String get fundDetailLandlordLabel => 'Landlord / principal';

  @override
  String get fundDetailTenantLabel => 'Tenant / contractor';

  @override
  String get fundDetailContractPeriodLabel => 'Contract period';

  @override
  String get fundDetailMonthlyRentLabel => 'Annual operating income';

  @override
  String get fundDetailContractAmendmentMethodLabel =>
      'Contract renewal method';

  @override
  String get fundDetailOtherImportantMattersLabel => 'Other important matters';

  @override
  String get fundDetailOperationTypeLeaseValue => 'Lease contract';

  @override
  String get fundDetailOperationTypeHotelValue =>
      'Hotel / vacation rental operation';

  @override
  String get fundDetailSchemeMarketEstimateNote =>
      '※ Figures are market-based estimates.';

  @override
  String get fundDetailSchemeBreakdownTitle => 'Investment breakdown';

  @override
  String get fundDetailSchemeIncomeTitle => 'Income';

  @override
  String get fundDetailSchemeExpenseTitle => 'Expenses';

  @override
  String get fundDetailSchemePropertyPriceLabel => 'Property price';

  @override
  String get fundDetailSchemeTotalInvestmentLabel => 'Total investment';

  @override
  String get fundDetailSchemeEstimatedAmountLabel => 'Estimated sale proceeds';

  @override
  String get fundDetailSchemeRentalIncomeLabel => 'Operating income';

  @override
  String get fundDetailSchemeIncomeTotalLabel => 'Income total ①';

  @override
  String get fundDetailSchemeLandMiscLabel => 'Land cost + miscellaneous';

  @override
  String get fundDetailSchemeDesignCostLabel => 'Design + construction cost';

  @override
  String get fundDetailSchemeBuildingCostLabel => 'Building cost';

  @override
  String get fundDetailSchemeMaintenanceFeeLabel => 'Maintenance fee';

  @override
  String get fundDetailSchemePublicUtilitiesTaxesLabel =>
      'Public charges and taxes';

  @override
  String get fundDetailSchemeFireInsurancePremiumLabel =>
      'Fire insurance premium';

  @override
  String get fundDetailSchemeBrokerageFeeLabel => 'Brokerage fee';

  @override
  String get fundDetailSchemeAmFeeLabel => 'AM fee';

  @override
  String get fundDetailSchemeAmFeeYear1Label => 'AM fee (Year 1)';

  @override
  String get fundDetailSchemeAmFeeYear2Label => 'AM fee (Year 2)';

  @override
  String get fundDetailSchemeAmCommissionLabel => 'AM commission';

  @override
  String get fundDetailSchemePublicOfferingFeeLabel =>
      'Public offering fees, etc.';

  @override
  String get fundDetailSchemeMarketingCostsLabel => 'Marketing costs';

  @override
  String get fundDetailSchemeAccountantFeeLabel => 'Accountant fee';

  @override
  String get fundDetailSchemeConsignmentFeeLabel =>
      'Consignment management fee';

  @override
  String get fundDetailSchemeNormalConsignmentFeeLabel =>
      'Exclusive consignment fee';

  @override
  String get fundDetailSchemeFundAdministratorFeeLabel =>
      'Fund administrator fee';

  @override
  String get fundDetailSchemeMiscExpensesLabel => 'Miscellaneous expenses';

  @override
  String get fundDetailSchemeSellExpensesLabel => 'Sale expenses';

  @override
  String get fundDetailSchemeOtherLabel => 'Other';

  @override
  String get fundDetailSchemeExpenseTotalLabel => 'Expense total ②';

  @override
  String get fundDetailSchemeDistributedCapitalFormula =>
      'Income ① − Expense ②';

  @override
  String get fundDetailSchemeDistributedCapitalTitle => 'Distributable capital';

  @override
  String get myPageTitle => 'My Page';

  @override
  String get myPageTotalAssetsLabel => 'Total assets';

  @override
  String get myPageWelcomeBack => 'Welcome back';

  @override
  String get myPageTotalAssetsCaption => 'Operating + standby cash';

  @override
  String get myPageMetricOperating => 'Operating';

  @override
  String get myPageMetricStandby => 'Standby cash';

  @override
  String get myPageMetricAccumulatedDistribution => 'Total distributions';

  @override
  String get myPageMetricLoanType => 'Lending';

  @override
  String get myPageAssetTrendTitle => 'Asset Trend';

  @override
  String get myPageDepositAction => 'Deposit';

  @override
  String get myPageWithdrawAction => 'Withdraw';

  @override
  String get myPagePendingApplicationsTitle => 'Pending Applications';

  @override
  String get myPageCoolingOffTitle => 'Cooling-off Period';

  @override
  String get myPageOrderInquirySectionTitle => 'Sell Order Inquiry';

  @override
  String get myPageOrderInquiryListTitle => 'Order Inquiry';

  @override
  String get myPageOperatingFundsTitle => 'Active Funds';

  @override
  String get myPageInvestmentStatusTitle => 'Investment Status';

  @override
  String get myPageLicenseNotice =>
      'Osaka Prefectural Governor Permit No. 22 (Official Permit) \n Type I, Type II, and Electronic Transaction Services';

  @override
  String get myPageActiveFundHeroEyebrow => 'MY FUND';

  @override
  String get myPageTransactionHistoryAction => 'Transaction History';

  @override
  String get myPageApplyAmountLabel => 'Application amount';

  @override
  String get myPageResultAnnouncementLabel => 'Result date';

  @override
  String get myPageResultAnnouncementTbd => 'TBD';

  @override
  String get myPageApplySubmittedAtLabel => 'Applied at';

  @override
  String get myPageApplyReviewedAtLabel => 'Reviewed at';

  @override
  String get myPageApplyPaymentNoticeLabel => 'Payment notice';

  @override
  String get myPageApplyPaidAtLabel => 'Paid at';

  @override
  String get myPageApplyCancellationRequestedAtLabel =>
      'Cancellation requested';

  @override
  String get myPageApplyCancelledAtLabel => 'Cancelled at';

  @override
  String get myPageInvestmentAmountLabel => 'Investment amount';

  @override
  String get myPageOrderTimeLabel => 'Order time';

  @override
  String get myPageOrderInvestorTypeLabel => 'Investor type';

  @override
  String get myPageOrderUnitsLabel => 'Ordered / Filled units';

  @override
  String get myPageOrderUnitPriceLabel => 'Order unit price';

  @override
  String get myPageOrderInquiryStatusExecuting => 'Active';

  @override
  String get myPageOrderInquiryStatusPending => 'Pending';

  @override
  String get myPageAccumulatedDistributionLabel => 'Total distributions';

  @override
  String get myPageDocumentDeliveryDateLabel => 'Document date';

  @override
  String get myPageCancelDeadlineLabel => 'Cancellation deadline';

  @override
  String get myPageCoolingOffFootnote =>
      '* Cooling-off cancellation is available for 8 days from the day after receiving the contract document.';

  @override
  String get myPageCancelRequestAction => 'Cancel';

  @override
  String get myPageCancelOrderAction => 'Cancel order';

  @override
  String get myPageCancelRequestComingSoon =>
      'Cancellation flow will be connected in a later implementation.';

  @override
  String get myPageWithdrawConfirmTitle => 'Withdraw this request?';

  @override
  String get myPageWithdrawApplyConfirmBody =>
      'This application will be withdrawn. Do you want to continue?';

  @override
  String get myPageWithdrawOrderConfirmBody =>
      'This resale order will be withdrawn. Do you want to continue?';

  @override
  String get myPageWithdrawConfirmAction => 'Withdraw';

  @override
  String get myPageWithdrawSuccess =>
      'Your withdrawal request has been accepted.';

  @override
  String get myPageWithdrawFailure =>
      'Failed to withdraw. Please try again later.';

  @override
  String get myPageDepositComingSoon =>
      'Deposit page will be connected in a later implementation.';

  @override
  String get myPageWithdrawComingSoon =>
      'Withdraw page will be connected in a later implementation.';

  @override
  String get myPageHistoryComingSoon =>
      'Transaction history page will be connected in a later implementation.';

  @override
  String get walletDepositTitle => 'Deposit';

  @override
  String get walletDepositDetailTitle => 'Deposit Details';

  @override
  String get walletHistoryTitle => 'Deposit History';

  @override
  String get walletTransactionHistoryTitle => 'Transaction History';

  @override
  String get walletHistoryFilterAll => 'All';

  @override
  String get walletHistoryFilterDeposit => 'Deposit';

  @override
  String get walletHistoryFilterWithdraw => 'Withdraw';

  @override
  String get walletDedicatedAccountTitle => 'Your Dedicated Deposit Account';

  @override
  String get walletProjectDepositAccountTitle => 'Project Deposit Account';

  @override
  String get walletDedicatedAccountDescription =>
      'This is your dedicated deposit account. Deposits are reflected automatically (minimum: ¥10,000). If unused for 3 months, the account may be changed.';

  @override
  String walletDepositTransferNotice(Object accountId) {
    return 'Bank transfer fees for investment deposits are borne by the customer. Deposits under a name other than your own cannot be accepted.\n* When making a transfer, please enter\n【$accountId】 in the payer name or remarks.';
  }

  @override
  String get walletBankNameLabel => 'Bank';

  @override
  String get walletBranchNameLabel => 'Branch';

  @override
  String get walletAccountTypeLabel => 'Type';

  @override
  String get walletAccountNumberLabel => 'Account No.';

  @override
  String get walletAccountHolderLabel => 'Account Holder';

  @override
  String get walletStandbyBalanceLabel => 'Standby Balance';

  @override
  String get walletStandbyBalanceHistoryTitle =>
      'Standby Balance Transaction History';

  @override
  String get walletHistorySectionTitle => 'Latest History';

  @override
  String get walletHistoryMoreAction => 'View All';

  @override
  String get walletHistoryEmpty => 'No history yet.';

  @override
  String get walletHistoryUnknownType => 'Record';

  @override
  String get walletBankAccountMissingDescription =>
      'No dedicated deposit account has been issued yet. Please apply for one before making a deposit.';

  @override
  String get walletBankAccountApplyAction => 'Apply for Account';

  @override
  String get walletBankAccountApplySuccess =>
      'Deposit account application submitted. Refreshing account info.';

  @override
  String get walletBankAccountApplyFailure =>
      'Failed to apply for a deposit account. Please try again later.';

  @override
  String get walletBankSettingsRegisteredTitle => 'Registered Accounts';

  @override
  String get walletBankSettingsEmptyMessage =>
      'No bank account has been registered yet. Add one to continue.';

  @override
  String get walletBankSettingsAddAction => 'Add Account';

  @override
  String get walletBankSettingsAddSheetTitle => 'Add Bank Account';

  @override
  String get walletBankSettingsAddSheetDescription =>
      'Enter the bank account information used for transfers.';

  @override
  String get walletBankSettingsAddEntrySheetTitle => 'Choose an account type';

  @override
  String get walletBankSettingsAddDomesticOption => 'Bank in Japan';

  @override
  String get walletBankSettingsAddOverseasOption => 'Bank outside Japan';

  @override
  String get walletBankSettingsOverseasAddTitle => 'Add Overseas Bank Account';

  @override
  String get walletBankSettingsOverseasAddDescription =>
      'Enter the overseas bank account information used for transfers.';

  @override
  String get walletBankSettingsCancelAction => 'Cancel';

  @override
  String get walletBankSettingsAddSuccess => 'Bank account added.';

  @override
  String get walletBankSettingsAddFailure =>
      'Failed to add bank account. Please try again later.';

  @override
  String get walletBankSettingsRequiredError => 'Please fill in all fields.';

  @override
  String get walletBankSettingsDomesticTip =>
      'The withdrawal fee for domestic bank accounts is JPY 1,000.';

  @override
  String get walletBankSettingsOverseasBankNameHint => 'Example National Bank';

  @override
  String get walletBankSettingsOverseasBranchNameHint => 'New York Main Branch';

  @override
  String get walletBankSettingsBranchNumberLabel => 'Branch number';

  @override
  String get walletBankSettingsBranchNumberHint => '001';

  @override
  String get walletBankSettingsOverseasBranchNumberHint => '102';

  @override
  String get walletBankSettingsOverseasAccountNumberHint => '1234567890';

  @override
  String get walletBankSettingsOverseasAccountHolderLabel =>
      'Account holder name';

  @override
  String get walletBankSettingsOverseasAccountHolderHint => 'JOHN SMITH';

  @override
  String get walletBankSettingsOwnerAddressLabel => 'Account holder address';

  @override
  String get walletBankSettingsOwnerAddressHint =>
      '123 Example Avenue, New York, NY 10001, USA';

  @override
  String get walletBankSettingsOwnerNationalityLabel =>
      'Account holder nationality';

  @override
  String get walletBankSettingsOwnerNationalityHint => 'United States';

  @override
  String get walletBankSettingsSwiftCodeLabel => 'SWIFT / BIC';

  @override
  String get walletBankSettingsSwiftCodeHint => 'EXNBUS33XXX';

  @override
  String get walletBankSettingsBankCountryLabel => 'Bank country';

  @override
  String get walletBankSettingsBankCountryHint => 'United States';

  @override
  String get walletBankSettingsBranchAddressLabel => 'Branch address';

  @override
  String get walletBankSettingsBranchAddressHint =>
      '456 Sample Street, New York, NY 10005, USA';

  @override
  String get walletBankSettingsOverseasTip =>
      'The withdrawal fee for overseas bank accounts is JPY 10,000.';

  @override
  String get walletBankSettingsDomesticChipLabel => 'Japan';

  @override
  String get walletBankSettingsOverseasChipLabel => 'Overseas';

  @override
  String get walletBankSettingsDeleteAction => 'Delete';

  @override
  String get walletBankSettingsDeleteConfirmTitle => 'Delete Bank Account';

  @override
  String get walletBankSettingsDeleteConfirmBody =>
      'Delete this withdrawal account? This action cannot be undone.';

  @override
  String get walletBankSettingsDeleteSuccess => 'Withdrawal account deleted.';

  @override
  String get walletBankSettingsDeleteFailure =>
      'Failed to delete withdrawal account.';

  @override
  String walletBankAccountExpireNotice(Object date) {
    return 'Please transfer by $date.';
  }

  @override
  String get walletHistoryPendingStatus => 'Pending';

  @override
  String get walletHistoryInflowLabel => 'Inflow';

  @override
  String get walletHistoryOutflowLabel => 'Outflow';

  @override
  String get walletAutoReflectedSuffix => '(Auto reflected)';

  @override
  String get walletDataLoadError => 'Failed to load deposit data.';

  @override
  String get walletPendingDepositEmptyMessage =>
      'There are no projects requiring a deposit.';

  @override
  String get walletPendingDepositUnavailableMessage =>
      'The application requiring a deposit could not be found.';

  @override
  String get walletProjectDepositAccountUnavailableMessage =>
      'Failed to load the deposit account for this project.';

  @override
  String get walletWithdrawTitle => 'Withdraw Request';

  @override
  String get walletWithdrawAvailableAmountLabel => 'Available to withdraw';

  @override
  String get walletWithdrawLockedAmountTitle => 'Non-withdrawable amount';

  @override
  String get walletWithdrawLockedBreakdownTitle => 'Breakdown';

  @override
  String get walletWithdrawLockedReasonPrefix => 'Note: ';

  @override
  String get walletWithdrawLockedStartLabel => 'Lock start';

  @override
  String get walletWithdrawLockedReleaseLabel => 'Planned unlock';

  @override
  String get walletWithdrawAmountLabel => 'Withdrawal amount';

  @override
  String get walletWithdrawAmountHint => '¥100,000';

  @override
  String get walletWithdrawDestinationLabel => 'Transfer destination';

  @override
  String get walletWithdrawFeeLabel => 'Fee';

  @override
  String get walletWithdrawSelectDestination => 'Select destination';

  @override
  String get walletWithdrawNeedAccountMessage =>
      'No withdrawal bank account is registered. Please add one first.';

  @override
  String get walletWithdrawNeedAccountAction => 'Add withdrawal account';

  @override
  String get walletWithdrawPhoneVerificationRequiredMessage =>
      'Phone verification is required before you can submit a withdrawal.';

  @override
  String get walletWithdrawPhoneVerificationRequiredAction =>
      'Go to phone verification';

  @override
  String get walletWithdrawSelectSheetTitle => 'Select transfer destination';

  @override
  String get walletWithdrawSubmitAction => 'Submit Withdraw Request';

  @override
  String get walletWithdrawConfirmTitle => 'Confirm Withdraw Details';

  @override
  String get walletWithdrawEstimatedArrivalLabel => 'Estimated arrival';

  @override
  String get walletWithdrawEstimatedArrivalValue => '1-3 business days';

  @override
  String get walletWithdrawNetAmountLabel => 'Net amount received';

  @override
  String get walletWithdrawCodeSentTargetLabel =>
      'Verification code will be sent to';

  @override
  String get walletWithdrawConfirmHint =>
      'After confirmation, a verification code will be sent to your registered phone. Please complete identity verification.';

  @override
  String get walletWithdrawConfirmSendCodeAction => 'Confirm and send code';

  @override
  String get walletWithdrawBackEditAction => 'Back to edit';

  @override
  String get walletWithdrawVerificationHint =>
      'Once verification succeeds, this withdrawal request will be submitted.';

  @override
  String get walletWithdrawCodeSent => 'Verification code sent.';

  @override
  String get walletWithdrawCodeRequired =>
      'Enter the 6-digit verification code.';

  @override
  String get walletWithdrawVerifyTitle => 'Verification';

  @override
  String walletWithdrawCountdownLabel(Object seconds) {
    return 'You can resend in ${seconds}s';
  }

  @override
  String get walletWithdrawResendReady =>
      'You can resend the verification code now';

  @override
  String walletWithdrawVerifyAmountHint(Object amount) {
    return 'After verification, a withdrawal request for $amount will be submitted.';
  }

  @override
  String get walletWithdrawVerifySubmitAction => 'Verify and submit';

  @override
  String get walletWithdrawSubmitPending =>
      'Withdraw API will be connected in a later implementation.';

  @override
  String get walletWithdrawAmountInvalid =>
      'Please enter a valid withdrawal amount.';

  @override
  String get walletWithdrawAmountExceedsAvailable =>
      'The withdrawal amount exceeds the available amount.';

  @override
  String get walletWithdrawInsufficientBalance =>
      'Your balance is not enough to cover the withdrawal amount and fee.';

  @override
  String get walletWithdrawSelectAccountFirst =>
      'Please select a destination bank account.';

  @override
  String get walletWithdrawSubmitSuccess => 'Withdrawal request submitted.';

  @override
  String get walletWithdrawSubmitFailure =>
      'Failed to submit the withdrawal request. Please try again later.';

  @override
  String get walletWithdrawCancelAction => 'Cancel';

  @override
  String get walletWithdrawCancelConfirmTitle =>
      'Cancel this withdrawal request?';

  @override
  String get walletWithdrawCancelConfirmBody =>
      'This unpaid withdrawal request will be cancelled. Do you want to continue?';

  @override
  String get walletWithdrawCancelConfirmAction => 'Confirm cancel';

  @override
  String get walletWithdrawCancelSuccess => 'Withdrawal request cancelled.';

  @override
  String get walletWithdrawCancelFailure =>
      'Failed to cancel the withdrawal request. Please try again later.';

  @override
  String get walletWithdrawingAction => 'Withdrawing';

  @override
  String get walletWithdrawHistoryAction => 'Withdraw History';

  @override
  String get walletWithdrawingPageTitle => 'Withdrawing List';

  @override
  String get walletWithdrawHistoryPageTitle => 'Withdraw History';

  @override
  String get walletWithdrawHistoryFilterAll => 'All';

  @override
  String get walletWithdrawRecordEmpty => 'No withdrawal records available.';

  @override
  String get walletWithdrawRecordFeeLabel => 'Fee';

  @override
  String get walletWithdrawRecordApplyTimeLabel => 'Applied at';

  @override
  String get walletWithdrawRecordPaidTimeLabel => 'Completed at';

  @override
  String get walletWithdrawRecordBookedTimeLabel => 'Booked time';

  @override
  String get walletWithdrawRecordBankNumberLabel => 'Bank account';

  @override
  String get walletWithdrawRecordTypeBankTransfer => 'Bank transfer';

  @override
  String get walletWithdrawRecordTypeCash => 'Cash withdrawal';

  @override
  String get walletWithdrawRecordTypeGentlePay => 'Withdraw to GentlePay';

  @override
  String get walletWithdrawRecordStatusPending => 'Processing';

  @override
  String get walletWithdrawRecordStatusDone => 'Completed';

  @override
  String get walletWithdrawRecordStatusUnpaid => 'Processing payout';

  @override
  String get walletWithdrawRecordStatusPaid => 'Paid';

  @override
  String get walletWithdrawRecordStatusFailedUnconfirmed =>
      'Payout failed / unconfirmed';

  @override
  String get walletWithdrawRecordStatusFailedConfirmed =>
      'Payout failed / confirmed';

  @override
  String get walletWithdrawRecordStatusRevoked => 'Cancelled';

  @override
  String get walletWithdrawRecordStatusUnknown => 'Unknown';

  @override
  String get myPagePendingEmptyState =>
      'No applications or lottery-waiting items.';

  @override
  String get myPageOrderInquiryEmptyState => 'No order inquiries.';

  @override
  String get myPageApplyHistoryEmptyState => 'No application history yet.';

  @override
  String get myPageCoolingOffEmptyState =>
      'No contracts in the cooling-off period.';

  @override
  String get myPageInvestmentStatusEmptyState =>
      'No investment status records yet.';

  @override
  String get myPageOperatingFundsEmptyState => 'No operating funds yet.';

  @override
  String get myPageOperatingEndedFundsEmptyState =>
      'No operation-ended funds yet.';

  @override
  String get myPageOperatingFundsEmptyAction => 'Browse funds';

  @override
  String get myPageSectionLoadError =>
      'Failed to load this section. Please try again.';

  @override
  String get myPageApplyHistoryListTitle => 'Application History';

  @override
  String get myPageApplyFilterAll => 'All';

  @override
  String get myPageApplyFilterApplying => 'Applying';

  @override
  String get myPageApplyFilterPendingConfirmation => 'Pending';

  @override
  String get myPageApplyFilterCompleted => 'Completed';

  @override
  String get myPageApplyFilterInvalid => 'Invalid';

  @override
  String get myPageApplyStatusApplying => 'Applying';

  @override
  String get myPageApplyStatusPendingConfirmation => 'Pending';

  @override
  String get myPageApplyStatusCompleted => 'Completed';

  @override
  String get myPageApplyStatusInvalid => 'Invalid';

  @override
  String get myPageApplyInvalidToast => 'This application is no longer valid.';

  @override
  String get myPageApplyConfirmationPendingAtLabel => 'Pending since';

  @override
  String get myPageApplyCompletedAtLabel => 'Completed at';

  @override
  String get myPageApplyInvalidAtLabel => 'Invalidated at';

  @override
  String get myPageApplyStatusUnderReview => 'Under review';

  @override
  String get myPageApplyStatusReviewed => 'Reviewed';

  @override
  String get myPageApplyStatusAwaitingPayment => 'Awaiting payment';

  @override
  String get myPageApplyStatusPaid => 'Paid';

  @override
  String get myPageApplyStatusCancellationReview => 'Cancellation in review';

  @override
  String get myPageApplyStatusCancelled => 'Cancelled';

  @override
  String myPageCoolingOffDeadlineRemaining(Object date, int days) {
    return 'Until $date ($days days left)';
  }

  @override
  String myPageCoolingOffDeadlineExpired(Object date) {
    return 'Expired on $date';
  }

  @override
  String get myPageActiveFundDetailTitle => 'Active Fund Detail';

  @override
  String get myPageActiveFundMetaTitle => 'Contract Info';

  @override
  String get myPageActiveFundValidInvestmentAmountLabel =>
      'Valid investment amount';

  @override
  String get myPageActiveFundInvestUnitsLabel => 'Investment units';

  @override
  String get myPageActiveFundValidUnitsLabel => 'Valid units';

  @override
  String get myPageActiveFundSellingUnitsLabel => 'Selling in progress';

  @override
  String get myPageActiveFundRemainingUnitsLabel => 'Remaining units';

  @override
  String get myPageActiveFundFloatingYieldLabel => 'Floating';

  @override
  String get myPageInvestorTypeInvestment => 'Investment';

  @override
  String get myPageInvestorTypeBorrowing => 'Loan';

  @override
  String myPageInvestorReturnFixedYield(Object pct) {
    return 'Fixed yield $pct%';
  }

  @override
  String get myPageInvestorReturnFloating => 'Floating';

  @override
  String myPageInvestorReturnFixedFloating(Object pct) {
    return 'Fixed + floating $pct%';
  }

  @override
  String myPageInvestorReturnBorrowRate(Object pct) {
    return 'Rate $pct%';
  }

  @override
  String get myPageActiveFundProcessIdLabel => 'Process ID';

  @override
  String get myPageActiveFundInvestorCodeLabel => 'Investor class';

  @override
  String get myPageActiveFundAppliedAtLabel => 'Applied at';

  @override
  String get myPageActiveFundWithdrawnAtLabel => 'Withdrawn at';

  @override
  String get myPageActiveFundTotalBenefitLabel => 'Total benefit';

  @override
  String get myPageActiveFundBenefitHistoryTitle => 'Benefit history';

  @override
  String get myPageActiveFundBenefitAmountLabel => 'Benefit amount';

  @override
  String get myPageActiveFundTaxLabel => 'Tax';

  @override
  String get myPageActiveFundNetBenefitLabel => 'Net benefit';

  @override
  String get myPageActiveFundReportAction => 'Report';

  @override
  String get myPageActiveFundReportTitle => 'Benefit report';

  @override
  String get myPageActiveFundReportUnavailableNotice =>
      'There are no related documents yet.';

  @override
  String get myPageActiveFundWithdrawAction => 'Request withdrawal';

  @override
  String get myPageActiveFundWithdrawDone => 'Withdrawn';

  @override
  String get myPageActiveFundCoolingPeriod => 'Cooling Period';

  @override
  String get myPageActiveFundWithdrawConfirmTitle =>
      'Submit a withdrawal request?';

  @override
  String get myPageActiveFundWithdrawConfirmBody =>
      'A withdrawal request will be sent for this benefit.';

  @override
  String get myPageActiveFundWithdrawConfirmAction => 'Submit';

  @override
  String get myPageActiveFundWithdrawSuccess => 'Withdrawal request submitted.';

  @override
  String get myPageActiveFundWithdrawFailure =>
      'Failed to submit the withdrawal request. Please try again later.';

  @override
  String get myPageActiveFundResaleAction => 'Request resale';

  @override
  String get myPageActiveFundResaleComingSoon =>
      'Resale request will be connected in a later implementation.';

  @override
  String get myPageActiveFundBenefitEmptyState => 'No benefit history yet.';

  @override
  String get myPageActiveFundBenefitLoadError =>
      'Failed to load benefit history.';

  @override
  String myPageActiveFundBenefitSeq(int seq) {
    return 'Benefit #$seq';
  }

  @override
  String myPageActiveFundBenefitPeriodRange(Object start, Object end) {
    return '$start - $end';
  }

  @override
  String get myPageResaleOrderTitle => 'Sell Order';

  @override
  String get myPageResaleTabOrder => 'Sell';

  @override
  String get myPageResaleTabConfirm => 'Order Details';

  @override
  String get myPageResaleFundNameLabel => 'Fund name';

  @override
  String get myPageResaleInvestorTypeLabel => 'Investor type';

  @override
  String get myPageResaleOrderMethodLabel => 'Order method';

  @override
  String get myPageResaleOrderMethodValue => 'Sell order';

  @override
  String get myPageResaleAvailableUnitsLabel => 'Available units';

  @override
  String get myPageResaleSellUnitsLabel => 'Sell units';

  @override
  String get myPageResaleUnitPriceLabel => 'Unit price';

  @override
  String get myPageResaleFeeLabel => 'Sell fee';

  @override
  String get myPageResaleFeeValue => '1.65% of transaction amount';

  @override
  String get myPageResaleAgreementLabel => 'Document confirmation';

  @override
  String get myPageResaleAgreementBody =>
      'I agree to the document below and submit a normal sell order.';

  @override
  String get myPageResaleAgreementSampleLabel =>
      'Assignment of contractual status agreement (sample)';

  @override
  String get myPageResaleTotalAmountLabel => 'Total amount';

  @override
  String get myPageResaleFeeAmountLabel => 'Fee amount';

  @override
  String get myPageResaleNetAmountLabel => 'Estimated receivable';

  @override
  String get myPageResaleValidationMessage =>
      'Enter sell units and unit price, then agree to the document confirmation.';

  @override
  String get myPageResaleConfirmButton => 'Confirm';

  @override
  String get myPageResaleBackButton => 'Edit';

  @override
  String get myPageResaleSubmitButton => 'Submit';

  @override
  String get myPageResaleUnitsSuffix => 'units';

  @override
  String get myPageResaleYenSuffix => 'JPY';

  @override
  String get myPageResaleFlowOrderTitle => 'Enter resale details';

  @override
  String get myPageResaleFlowOrderSubtitle =>
      'Set the quantity, asking price, and document confirmation before moving to the review step.';

  @override
  String get myPageResaleFlowConfirmTitle => 'Review resale details';

  @override
  String get myPageResaleFlowConfirmSubtitle =>
      'If everything looks right, submit the sell order from this screen.';

  @override
  String get myPageResaleQuantityHint =>
      'Enter the quantity and unit price you want to list.';

  @override
  String get myPageResaleQuickMax => 'MAX';

  @override
  String get myPageResaleLiveEstimateFormulaLabel => 'Current order estimate';

  @override
  String get myPageResaleAgreementSectionTitle => 'Documents and confirmations';

  @override
  String get myPageResaleReviewSectionTitle => 'Order details';

  @override
  String get myPageResaleReviewHint =>
      'Review the listing conditions and expected proceeds before you place the order.';

  @override
  String get myPageResaleSummarySectionTitle => 'Expected proceeds';

  @override
  String get myPageResaleFinalNoticeTitle =>
      'The sell order will be sent after final confirmation';

  @override
  String get myPageResaleFinalNoticeBody =>
      'Once submitted, the listing will proceed with these details. Please review the quantity, price, and expected proceeds one more time.';

  @override
  String myPageResaleFixedYieldLabel(Object ratio) {
    return 'Fixed $ratio yield';
  }

  @override
  String myPageResaleInvestorTypeFallback(Object ratio) {
    return 'Fixed $ratio yield';
  }

  @override
  String get myPageResaleHintTitle => 'Hint';

  @override
  String myPageResaleFinalConfirmMessage(Object price, Object units) {
    return 'Do you confirm selling $units unit(s) of this project at $price JPY per unit?';
  }

  @override
  String get myPageResaleSubmitSuccess => 'Sell order submitted.';

  @override
  String get myPageResaleSubmitFailure =>
      'Failed to submit the sell order. Please try again later.';

  @override
  String get secondaryMarketListLoadError =>
      'Failed to load the flea market listings.';

  @override
  String get secondaryMarketDetailLoadError =>
      'Failed to load the flea market detail.';

  @override
  String get secondaryMarketDetailUnavailable =>
      'The listing could not be found.';

  @override
  String get secondaryMarketDetailSoldOutMessage =>
      'This listing has already sold out.';

  @override
  String get secondaryMarketBuyAction => 'Buy';

  @override
  String get secondaryMarketOrderTimeLabel => 'Order Time';

  @override
  String get secondaryMarketInvestorTypeLabel => 'Investor Type';

  @override
  String get secondaryMarketSellUnitsLabel => 'Listed Units';

  @override
  String get secondaryMarketSoldUnitsLabel => 'Matched Units';

  @override
  String get secondaryMarketRemainingUnitsLabel => 'Remaining Units';

  @override
  String get secondaryMarketCompletionRateLabel => 'Fill Rate';

  @override
  String get secondaryMarketPricePerUnitCaption => 'Per unit';

  @override
  String get secondaryMarketOverviewTitle => 'Order Overview';

  @override
  String get secondaryMarketUpdateTimeLabel => 'Updated At';

  @override
  String get secondaryMarketOrderIdLabel => 'Order ID';

  @override
  String get secondaryMarketActivityTitle => 'Market Activity';

  @override
  String get secondaryMarketApplicationsCountLabel => 'Applications';

  @override
  String get secondaryMarketDealsCountLabel => 'Deals';

  @override
  String get secondaryMarketLatestApplicationLabel => 'Latest Application';

  @override
  String get secondaryMarketLatestDealLabel => 'Latest Deal';

  @override
  String get secondaryMarketDocumentsTitle => 'Related Documents';

  @override
  String get secondaryMarketDocumentPending => 'Preparing';

  @override
  String get secondaryMarketDocumentOpenAction => 'Open Document';

  @override
  String get secondaryMarketBuyOrderTitle => 'Buy Order';

  @override
  String get secondaryMarketTradeTabBuy => 'Buy';

  @override
  String get secondaryMarketTradeTabConfirm => 'Confirm';

  @override
  String get secondaryMarketBuyOrderMethodLabel => 'Order Method';

  @override
  String get secondaryMarketBuyOrderMethodValue => 'Buy Order';

  @override
  String get secondaryMarketBuyAvailableUnitsLabel => 'Available Units';

  @override
  String get secondaryMarketBuyUnitsLabel => 'Buy Units';

  @override
  String get secondaryMarketBuyUnitPriceLabel => 'Unit Price';

  @override
  String get secondaryMarketBuyFeeLabel => 'Fee';

  @override
  String get secondaryMarketBuyFeeValue => '1.65% of transaction amount';

  @override
  String get secondaryMarketBuyAgreementLabel => 'Document Confirmation';

  @override
  String get secondaryMarketBuyAgreementBody =>
      'I agree to the following documents and submit the purchase request.';

  @override
  String get secondaryMarketBuyAgreementSampleLabel =>
      'Review related document';

  @override
  String get secondaryMarketBuyConfirmButton => 'Continue';

  @override
  String get secondaryMarketBuyBackButton => 'Back';

  @override
  String get secondaryMarketBuySubmitButton => 'Submit Buy Order';

  @override
  String get secondaryMarketBuyValidationMessage =>
      'Enter the buy units and agree to the document confirmation.';

  @override
  String get secondaryMarketBuyFlowInputTitle => 'Enter Order Details';

  @override
  String get secondaryMarketBuyFlowInputSubtitle =>
      'Set the quantity and review the documents before continuing.';

  @override
  String get secondaryMarketBuyFlowConfirmTitle => 'Final Review';

  @override
  String get secondaryMarketBuyFlowConfirmSubtitle =>
      'If everything looks correct, submit the purchase request from this screen.';

  @override
  String get secondaryMarketBuyQuantityHint =>
      'Choose how many units you want to purchase.';

  @override
  String get secondaryMarketBuyQuickMax => 'MAX';

  @override
  String get secondaryMarketBuyLiveEstimateTitle => 'Live Estimate';

  @override
  String get secondaryMarketBuyLiveEstimateFormulaLabel => 'Current order';

  @override
  String get secondaryMarketBuySummarySectionTitle => 'Payment Summary';

  @override
  String get secondaryMarketBuyAgreementSectionTitle =>
      'Documents & Confirmation';

  @override
  String get secondaryMarketBuyStickyAmountLabel => 'Estimated Payment';

  @override
  String get secondaryMarketBuyReviewSectionTitle => 'Order Review';

  @override
  String get secondaryMarketBuyReviewHint =>
      'Review the details one last time before sending the purchase request.';

  @override
  String get secondaryMarketBuyFinalNoticeTitle =>
      'The purchase request will be sent after this final check';

  @override
  String get secondaryMarketBuyFinalNoticeBody =>
      'Once submitted, the purchase process will proceed based on this order. Please review the quantity and estimated payment carefully.';

  @override
  String get secondaryMarketBuyTotalAmountLabel => 'Purchase Total';

  @override
  String get secondaryMarketBuyFeeAmountLabel => 'Fee';

  @override
  String get secondaryMarketBuyPaymentAmountLabel => 'Total Payment';

  @override
  String get secondaryMarketBuyFinalConfirmTitle => 'Notice';

  @override
  String secondaryMarketBuyFinalConfirmMessage(Object price, Object units) {
    return 'Confirm purchasing $units units of this project at $price yen per unit?';
  }

  @override
  String get secondaryMarketBuySubmitSuccess => 'Purchase order submitted.';

  @override
  String get secondaryMarketBuySubmitFailure =>
      'Failed to submit the purchase order. Please try again later.';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkipChevron => 'Skip ›';

  @override
  String get commonOther => 'Other';

  @override
  String get memberProfileFlowTitle => 'Profile Information';

  @override
  String get memberProfileStep1Title => 'Step 1: Basic Info';

  @override
  String get memberProfileStep1Description =>
      'Enter your family name, given name, phonetic name, romanized name, and contact information.';

  @override
  String get memberProfileNameKanjiLabel => 'Full name';

  @override
  String get memberProfileNameKanjiHint => 'Taro Tanaka';

  @override
  String get memberProfileNameKanaLabel => 'Phonetic name';

  @override
  String get memberProfileNameKanaHint => 'TANAKA TARO';

  @override
  String get memberProfileFamilyNameLabel => 'Family name';

  @override
  String get memberProfileFamilyNameHint => 'Tanaka';

  @override
  String get memberProfileGivenNameLabel => 'Given name';

  @override
  String get memberProfileGivenNameHint => 'Taro';

  @override
  String get memberProfileFamilyNameKanaLabel => 'Family name (Kana)';

  @override
  String get memberProfileFamilyNameKanaHint => 'TANAKA';

  @override
  String get memberProfileGivenNameKanaLabel => 'Given name (Kana)';

  @override
  String get memberProfileGivenNameKanaHint => 'TARO';

  @override
  String get memberProfileFamilyNameRomanLabel => 'Family name (Roman)';

  @override
  String get memberProfileFamilyNameRomanHint => 'TANAKA';

  @override
  String get memberProfileGivenNameRomanLabel => 'Given name (Roman)';

  @override
  String get memberProfileGivenNameRomanHint => 'TARO';

  @override
  String get memberProfileBirthdayLabel => 'Date of birth';

  @override
  String get memberProfileBirthdayHint => 'Select your date of birth';

  @override
  String get memberProfileSexLabel => 'Sex';

  @override
  String get memberProfileSexFemale => 'Female';

  @override
  String get memberProfileSexMale => 'Male';

  @override
  String get memberProfileSexOther => 'Other';

  @override
  String get memberProfileTaxCountryLabel => 'Country of residence';

  @override
  String get memberProfileTaxCountryHint => 'Japan';

  @override
  String get memberProfileUnderageTitle =>
      'This service is available only to users aged 18 or older.';

  @override
  String get memberProfileUnderageBody =>
      'Under the Real Estate Specified Joint Enterprise Act, minors cannot apply for investments.';

  @override
  String get memberProfilePhoneLabel => 'Phone number';

  @override
  String get memberProfilePhoneHint => '090-1234-5678';

  @override
  String get memberProfileStep2Title => 'Step 2: Address Info';

  @override
  String get memberProfileStep2Description =>
      'Required for identity verification.';

  @override
  String get memberProfilePostalCodeLabel => 'Postal code';

  @override
  String get memberProfilePostalCodeHint => '1000001';

  @override
  String get memberProfileAddressSearch => 'Search address';

  @override
  String get memberProfileAddressSearchPending =>
      'Address lookup will be connected in a later implementation.';

  @override
  String get memberProfileAddressSearchZipError =>
      'Please enter a 7-digit postal code.';

  @override
  String get memberProfileAddressSearchEmpty =>
      'No address was found for this postal code.';

  @override
  String get memberProfileAddressSearchSelectTitle => 'Select an address';

  @override
  String get memberProfilePrefectureLabel => 'Prefecture';

  @override
  String get memberProfileCityAddressLabel => 'City / Street address';

  @override
  String get memberProfileCityAddressHint => '1-1-1 Marunouchi, Chiyoda-ku';

  @override
  String get memberProfileStep3Title => 'Step 3: Investor Suitability';

  @override
  String get memberProfileStep3Description =>
      'We confirm your investment experience under Article 25 of the Real Estate Specified Joint Enterprise Act.';

  @override
  String get memberProfileOccupationLabel => 'Occupation';

  @override
  String get memberProfileAnnualIncomeLabel => 'Annual income';

  @override
  String get memberProfileFinancialAssetsLabel => 'Financial assets';

  @override
  String get memberProfileInvestmentExperienceLabel =>
      'Investment experience (multiple selection allowed)';

  @override
  String get memberProfileInvestmentPurposeLabel => 'Investment purpose';

  @override
  String get memberProfileFundSourceLabel => 'Nature of investment funds';

  @override
  String get memberProfileFundSourceWarningTitle => 'Please be aware';

  @override
  String get memberProfileFundSourceWarningStandard =>
      'This product does not guarantee principal, and you may lose your full investment. Please invest only within surplus funds.';

  @override
  String get memberProfileFundSourceWarningHighRisk =>
      'This product does not guarantee principal, and you may lose your full investment. Investing with living funds or borrowed money is not recommended. Please invest within your surplus funds.';

  @override
  String get memberProfileRiskToleranceLabel => 'Risk tolerance';

  @override
  String get memberProfileStep4Title => 'Step 4: Identity Verification (eKYC)';

  @override
  String get memberProfileStep4Description =>
      'Please photograph your identity verification documents.';

  @override
  String get memberProfileDocumentGuideTitle => 'Upload document guide';

  @override
  String get memberProfileDocumentGuideBody =>
      'Please submit one of the following identity verification documents.\n\n1. Residents\n- Individual Number Card (My Number Card, front side only)\n- Residence card\n- Special Permanent Resident Certificate\n- Driver\'s license\n\n2. Non-residents\n- Government-issued photo ID from your home country\n- Passport (photo page and bearer information page)\n\n3. Corporations (corporate account)\nPlease submit the following documents:\n- Certificate of Registered Matters (full historical record)\n- Identity verification document for the representative or transaction agent\n- If required, documents regarding beneficial owners';

  @override
  String get memberProfileDocumentTypeLabel => 'Select document';

  @override
  String get memberProfilePhotoDocumentTitle => 'Photo ID (Front & Back)';

  @override
  String get memberProfilePhotoDocumentDescription => 'Tap to open the camera';

  @override
  String get memberProfilePhotoDocumentFrontTitle => 'Photo ID (Front)';

  @override
  String get memberProfilePhotoDocumentFrontDescription =>
      'Tap to upload the front side';

  @override
  String get memberProfilePhotoDocumentBackTitle => 'Photo ID (Back)';

  @override
  String get memberProfilePhotoDocumentBackDescription =>
      'Tap to upload the back side';

  @override
  String get memberProfileSelfieTitle => 'Take a selfie photo';

  @override
  String get memberProfileSelfieDescription => 'Face the camera directly';

  @override
  String get memberProfileUploadDocumentPending =>
      'Document capture will be connected in a later implementation.';

  @override
  String get memberProfileUploadSelfiePending =>
      'Selfie capture will be connected in a later implementation.';

  @override
  String get memberProfileStep5RealPersonTitle =>
      'Step 5: Real-Person Verification (Liveness)';

  @override
  String get memberProfileStep5RealPersonDescription =>
      'Upload your selfie, then complete the live face verification.';

  @override
  String get memberProfileStep5RealPersonSelfieRequired =>
      'Please upload a selfie photo first.';

  @override
  String get memberProfileStep5Title => 'Step 6: Bank Account';

  @override
  String get memberProfileStep5Description =>
      'Register the bank account for distribution transfers.';

  @override
  String get memberProfileBankRegionLabel => 'Bank region';

  @override
  String get memberProfileBankNameLabel => 'Financial institution';

  @override
  String get memberProfileBankNameHint => 'MUFG Bank';

  @override
  String get memberProfileBranchLabel => 'Branch';

  @override
  String get memberProfileBranchHint => 'Marunouchi Branch';

  @override
  String get memberProfileAccountTypeLabel => 'Account type';

  @override
  String get memberProfileAccountNumberLabel => 'Account number';

  @override
  String get memberProfileAccountNumberHint => '1234567';

  @override
  String get memberProfileAccountHolderLabel => 'Account holder (katakana)';

  @override
  String get memberProfileAccountHolderHint => 'TANAKA TARO';

  @override
  String get memberProfileNextConsent => 'Next: Consent Confirmation';

  @override
  String get memberProfileStep6Title => 'Step 5: Consent';

  @override
  String get memberProfileStep6Description =>
      'Please review the following items and agree to all of them.';

  @override
  String get memberProfileElectronicDeliveryTitle =>
      'Electronic delivery of documents';

  @override
  String get memberProfileElectronicDeliveryBody =>
      'We will deliver the following documents required under the Real Estate Specified Joint Enterprise Act electronically in the app as PDF files instead of on paper.';

  @override
  String get memberProfileElectronicDeliveryItem1 =>
      'Pre-contract disclosure document';

  @override
  String get memberProfileElectronicDeliveryItem2 =>
      'Contract conclusion document';

  @override
  String get memberProfileElectronicDeliveryItem3 =>
      'Property management report';

  @override
  String get memberProfileElectronicDeliveryItem4 =>
      'Business and asset status documents';

  @override
  String get memberProfileElectronicDeliveryFootnote =>
      '※ You may withdraw your consent to electronic delivery at any time from Settings. After withdrawal, documents will be mailed in paper form.';

  @override
  String get memberProfileElectronicDeliveryConsent =>
      'I agree to the electronic delivery method above.';

  @override
  String get memberProfileAntiSocialTitle =>
      'Declaration of not being an anti-social force';

  @override
  String get memberProfileAntiSocialBody =>
      'I represent and warrant that I am not, now or in the future, part of any anti-social force such as organized crime groups, members, affiliates, or similar entities.';

  @override
  String get memberProfileAntiSocialConsent =>
      'I declare that I do not belong to any anti-social force.';

  @override
  String get memberProfilePrivacyConsent =>
      'I agree to the handling of personal information and the privacy policy.';

  @override
  String get memberProfileAgreeAndComplete =>
      'Agree to all and complete registration';

  @override
  String get memberProfileCompletedToast =>
      'Profile information registration is complete.';

  @override
  String get memberProfileSavingProgressMessage => 'Uploading and saving...';

  @override
  String get memberProfilePhotoUploadSuccess => 'Photo uploaded successfully.';

  @override
  String get memberProfileSelfieUploadBypassedNotice =>
      'Selfie upload is not supported in the test environment, so you can continue to the next step.';

  @override
  String get occupationEmployee => 'Company employee';

  @override
  String get occupationSelfEmployed => 'Self-employed';

  @override
  String get occupationPublicServant => 'Public servant';

  @override
  String get occupationHomemaker => 'Homemaker';

  @override
  String get occupationStudent => 'Student';

  @override
  String get occupationPensioner => 'Pensioner';

  @override
  String get incomeUnder3m => 'Under JPY 3M';

  @override
  String get income3to5m => 'JPY 3M to 5M';

  @override
  String get income5to10m => 'JPY 5M to 10M';

  @override
  String get incomeOver10m => 'Over JPY 10M';

  @override
  String get assetsUnder1m => 'Under JPY 1M';

  @override
  String get assets1to5m => 'JPY 1M to 5M';

  @override
  String get assets5to10m => 'JPY 5M to 10M';

  @override
  String get assetsOver10m => 'Over JPY 10M';

  @override
  String get purposeAssetGrowth => 'Asset growth';

  @override
  String get purposeDividendIncome => 'Regular income from distributions';

  @override
  String get purposeIdleFunds => 'Managing surplus cash';

  @override
  String get purposeDiversification => 'Portfolio diversification';

  @override
  String get fundSourceSurplus => 'Surplus funds with no impact on daily life';

  @override
  String get fundSourceLivingFunds => 'Part of living expenses';

  @override
  String get fundSourceBorrowed => 'Borrowed money';

  @override
  String get riskToleranceAcceptLoss =>
      'I understand and can tolerate principal loss.';

  @override
  String get riskToleranceLowRisk => 'I only want low-risk investments.';

  @override
  String get riskToleranceHighRisk =>
      'I can tolerate high-risk, high-return investments.';

  @override
  String get documentTypeDriversLicense => 'Driver\'s license';

  @override
  String get documentTypeMyNumber => 'My Number card';

  @override
  String get documentTypeResidenceCard => 'Residence card';

  @override
  String get documentTypePassport => 'Passport';

  @override
  String get documentTypeOther => 'Other personal ID';

  @override
  String get accountTypeOrdinary => 'Ordinary';

  @override
  String get accountTypeChecking => 'Checking';

  @override
  String get prefectureTokyo => 'Tokyo';

  @override
  String get prefectureOsaka => 'Osaka';

  @override
  String get prefectureKanagawa => 'Kanagawa';

  @override
  String get prefectureAichi => 'Aichi';

  @override
  String get prefectureFukuoka => 'Fukuoka';

  @override
  String get memberProfileExperienceStocks => 'Stocks / ETF';

  @override
  String get memberProfileExperienceMutualFunds => 'Mutual funds';

  @override
  String get memberProfileExperienceRealEstate => 'Real estate investment';

  @override
  String get memberProfileExperienceRealEstateCrowdfunding =>
      'Real estate crowdfunding / FTK';

  @override
  String get memberProfileExperienceBonds => 'Bonds';

  @override
  String get memberProfileExperienceFxCrypto => 'FX / Crypto assets';

  @override
  String get memberProfileExperienceNone => 'No investment experience';

  @override
  String get identityAuthPageTitle => 'Identity Verification';

  @override
  String get identityAuthPageDescription =>
      'Use facial verification to complete real-person authentication for security-sensitive actions.';

  @override
  String get identityAuthStartAction => 'Start verification';

  @override
  String get identityAuthAlreadyVerified =>
      'Identity verification is already completed.';

  @override
  String get identityAuthVerifySuccess => 'Identity verification succeeded.';

  @override
  String get identityAuthVerifyFailed =>
      'Identity verification failed. Please try again.';

  @override
  String get identityAuthCollectFailed =>
      'Face capture failed. Please try again.';

  @override
  String get identityAuthLivenessNotConfigured =>
      'Liveness collector is not configured.';

  @override
  String get identityAuthBiometricNotConfigured =>
      'Biometric authentication is not configured.';

  @override
  String get identityAuthSensitiveBlocked =>
      'Unable to continue this sensitive action.';

  @override
  String get identityAuthCameraPermissionRequired =>
      'Allow camera access to continue face verification.';

  @override
  String get identityAuthCameraPermissionSettingsRequired =>
      'Open system settings and allow camera access to continue face verification.';

  @override
  String get permissionSettingsTitle => 'Permission required';

  @override
  String get permissionSettingsCameraMessage =>
      'Camera access is disabled. Open system settings and allow camera access.';

  @override
  String get permissionSettingsPhotosMessage =>
      'Photo library access is disabled. Open system settings and allow photo access.';

  @override
  String get permissionSettingsLocationMessage =>
      'Location access is disabled. Open system settings and allow location access.';

  @override
  String get identityAuthBaiduLicenseMissing =>
      'Baidu face SDK license is missing.';
}
