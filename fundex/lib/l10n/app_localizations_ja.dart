// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginSubtitle => '会員向け投資・宿泊特典へ安全にアクセス。';

  @override
  String get loginAccountLabel => '電話番号またはメール';

  @override
  String get loginModeTitle => 'ログイン方法を選択';

  @override
  String get loginCodeLabel => '認証コード';

  @override
  String get loginSendCode => 'コード送信';

  @override
  String get loginSubmit => 'ログイン';

  @override
  String get loginBrowseAsGuest => 'ログインせずに閲覧する（ゲストモード）';

  @override
  String get loginCreateAccount => '新規登録';

  @override
  String get commonClose => '閉じる';

  @override
  String get pdfViewerPageTitle => 'PDF';

  @override
  String get pdfViewerOpenExternalTooltip => '外部アプリで開く';

  @override
  String get pdfViewerOpenExternalLabel => '外部アプリで開く';

  @override
  String get pdfViewerLoadingLabel => 'PDFを読み込んでいます…';

  @override
  String get pdfViewerLoadFailedLabel => 'PDFの読み込みに失敗しました。';

  @override
  String get pdfViewerInvalidUrlNotice => 'PDFのURLが無効です。';

  @override
  String get pdfViewerOpenExternalFailedNotice => 'PDFを開けませんでした。';

  @override
  String get imageViewerLoadingLabel => '画像を読み込んでいます…';

  @override
  String get imageViewerLoadFailedLabel => '画像の読み込みに失敗しました。';

  @override
  String get imageViewerRetryLabel => '再試行';

  @override
  String get imageViewerInvalidSourceNotice => '画像ソースが無効です。';

  @override
  String get webViewerLoadingLabel => 'ページを読み込んでいます…';

  @override
  String get webViewerLoadFailedLabel => 'ページの読み込みに失敗しました。';

  @override
  String get webViewerInvalidUrlNotice => 'ページのURLが無効です。';

  @override
  String get imageViewerCloseTooltip => '閉じる';

  @override
  String get favoriteAddedToast => 'お気に入りに追加しました';

  @override
  String get favoriteRemovedToast => 'お気に入りから削除しました';

  @override
  String get networkOfflineBannerTitle => '現在オフラインです';

  @override
  String get networkOfflineBannerMessage => '接続が回復すると最新データを自動で更新します。';

  @override
  String get loginForgotPassword => 'パスワードを忘れた場合';

  @override
  String get loginFootnote => '日本市場とグローバル利用を意識した、上質で安全なUX設計。';

  @override
  String get loginErrorSendCodeFailed => 'コード送信に失敗しました。後でもう一度お試しください。';

  @override
  String get loginErrorInvalidCode => 'ログインに失敗しました。認証コードを確認してください。';

  @override
  String get loginEmailAccountInvalid => 'メールログインには有効なメールアドレスを入力してください。';

  @override
  String get loginMobileAccountInvalid => '電話ログインには有効な電話番号を入力してください。';

  @override
  String get registerTitle => '新規会員登録';

  @override
  String get registerSubtitle => '投資・予約・会員特典に使う安全なアカウントを設定します。';

  @override
  String get registerQuickTitle => 'アカウントを作成';

  @override
  String get registerQuickSubtitle =>
      'メールアドレスとパスワードだけで登録ができます。投資に必要な情報は後からいつでも入力できます。';

  @override
  String get registerModeTitle => '登録方法';

  @override
  String get authModeEmail => 'メール';

  @override
  String get authModeMobile => '電話';

  @override
  String get splashBrandName => 'StellaVia';

  @override
  String get splashBrandSlogan => '投資は未来の「道」となり、明日を照らす。';

  @override
  String get splashTagline => '不動産クラウドファンディング';

  @override
  String get authEntryHeadline => '投資・宿泊会員サービスをひとつのログインで';

  @override
  String get authEntryDescription => '電話番号またはメールでログインし、投資・予約・会員特典をまとめて管理できます。';

  @override
  String get authEntryPhoneLogin => '電話でログイン';

  @override
  String get authEntryEmailLogin => 'メールでログイン';

  @override
  String get authEntryNonMemberRegisterNow => '会員ではありませんか？ 今すぐ登録';

  @override
  String get authBeforeMemberDirectLogin => '会員の方はこちらからログイン';

  @override
  String get authBeforeNonMemberRegister => '非会員の方は新規登録';

  @override
  String get authRegisterEntryHeadline => '登録方法を選択';

  @override
  String get authRegisterEntryDescription =>
      '電話番号またはメールでアカウントを作成し、会員サービスを一元管理します。';

  @override
  String get authEntryPhoneRegister => '電話で登録';

  @override
  String get authEntryEmailRegister => 'メールで登録';

  @override
  String get authBackToLoginEntry => 'ログイン方法へ戻る';

  @override
  String get authBackToRegisterEntry => '登録方法へ戻る';

  @override
  String get authIntlCodeLabel => '電話国番号';

  @override
  String get authIntlCodePickerTitle => '電話国番号を選択';

  @override
  String get authMethodFormSubtitle => '認証コードで安全に確認を完了します。';

  @override
  String get profileOnboardingTitle => '詳細情報の入力';

  @override
  String get profileEditTitle => '詳細情報を編集';

  @override
  String get profileOnboardingCardTitle => '取引・宿泊前の本人情報確認';

  @override
  String get profileOnboardingCardSubtitle =>
      '取引・宿泊の確認要件のため詳細情報を入力してください。あとで入力することもできます。';

  @override
  String get profileEditCardTitle => '詳細情報';

  @override
  String get profileEditCardSubtitle => '前回ローカル保存した内容を保持したまま再編集できます。';

  @override
  String get profileLastSavedHint => '前回保存したローカル情報を読み込みました。';

  @override
  String get profileSkipButton => 'あとで入力';

  @override
  String get profileStepName => '氏名';

  @override
  String get profileStepNameSubtitle => '日本式の順序で姓・名を入力します。';

  @override
  String get profileStepContact => '連絡先';

  @override
  String get profileStepContactSubtitle => '住所・電話・メールを入力します（利用可能な場合は自動入力）。';

  @override
  String get profileStepDocument => '本人確認書類の写真';

  @override
  String get profileStepDocumentSubtitle => '後続の取引・宿泊確認のため書類写真をアップロードします。';

  @override
  String get profileFamilyNameLabel => '姓';

  @override
  String get profileFamilyNameHint => '姓を入力';

  @override
  String get profileGivenNameLabel => '名';

  @override
  String get profileGivenNameHint => '名を入力';

  @override
  String get profileAddressLabel => '住所';

  @override
  String get profileAddressHint => '住所を入力（都道府県 / 市区町村 / 番地 / 建物名）';

  @override
  String get profilePhoneLabel => '電話番号';

  @override
  String get profilePhoneHint => '電話番号を入力';

  @override
  String get profileEmailLabel => 'メールアドレス';

  @override
  String get profileEmailHint => 'メールアドレスを入力';

  @override
  String get profileDocumentPhotoLabel => '本人確認書類の写真';

  @override
  String get profileDocumentAddPhoto => '書類写真をアップロード';

  @override
  String get profileDocumentChangePhoto => '書類写真を変更';

  @override
  String get profileDocumentRemovePhoto => '書類写真を削除';

  @override
  String get profileDocumentTakePhoto => '写真を撮る';

  @override
  String get profileDocumentPickFromGallery => '写真ライブラリから選択';

  @override
  String get profileDocumentHint => '後続の確認作業のため、鮮明で文字が見える書類写真をアップロードしてください。';

  @override
  String get profileDocumentAttachedBadge => '添付済み';

  @override
  String get profilePrevStep => '戻る';

  @override
  String get profileNextStep => '次へ';

  @override
  String get profileSaveButton => '保存';

  @override
  String get profileSavedTitle => '詳細情報を保存しました';

  @override
  String get profileSavedAndContinueLoginMessage =>
      '詳細情報はローカルに保存されました。続けてログインできます。';

  @override
  String get profileSavedSnackbar => '詳細情報をローカルに保存しました。';

  @override
  String get memberProfileAutoSavedToast => '保存しました。';

  @override
  String get memberProfileDraftImportTitle => '保存済みの入力内容があります';

  @override
  String get memberProfileDraftImportMessage => '前回保存した入力内容を読み込みますか？';

  @override
  String get memberProfileDraftImportAction => '読み込む';

  @override
  String get memberProfileDraftImportSkipAction => '読み込まない';

  @override
  String get profileIntakeValidationTitle => '入力未完了';

  @override
  String get profileFamilyNameRequired => '姓を入力してください。';

  @override
  String get profileGivenNameRequired => '名を入力してください。';

  @override
  String get profileAddressRequired => '住所を入力してください。';

  @override
  String get profilePhoneRequired => '有効な電話番号を入力してください。';

  @override
  String get profileEmailRequired => '有効なメールアドレスを入力してください。';

  @override
  String get profileDocumentPhotoRequired => '本人確認書類の写真をアップロードしてください。';

  @override
  String get profileDocumentPickFailed => '書類写真の選択に失敗しました。再度お試しください。';

  @override
  String get profileIncompleteBannerTitle => '詳細情報が未完了です';

  @override
  String get profileIncompleteBannerSubtitle => '取引・宿泊には詳細情報の完了が必要です。';

  @override
  String get profileIncompleteBannerBody =>
      '氏名、住所、電話、メール、本人確認書類の写真を入力後に取引または宿泊手続きを進めてください。';

  @override
  String get profileGuardTitle => '先に詳細情報の入力が必要です';

  @override
  String get profileGuardMessage => '取引または宿泊の前に詳細情報を入力してください。';

  @override
  String profileGuardMessageWithAction(Object actionLabel) {
    return '「$actionLabel」の前に詳細情報の入力が必要です。';
  }

  @override
  String get profileGuardCancel => 'キャンセル';

  @override
  String get profileGuardGoFill => '入力する';

  @override
  String profileGuardPassMessage(Object actionLabel) {
    return '詳細情報の確認が完了しました。$actionLabelを続けられます。';
  }

  @override
  String get profileStatusCardTitle => '詳細情報の状態';

  @override
  String get profileStatusCompleted => '完了済み。取引・宿泊を進められます。';

  @override
  String get profileStatusIncomplete => '未完了。取引・宿泊前に詳細情報を入力してください。';

  @override
  String get profileStatusLoadFailed => '詳細情報の状態を読み込めませんでした。';

  @override
  String get profileEditEntryButton => '入力 / 編集';

  @override
  String get profileProtectedBookingAction => '宿泊予約';

  @override
  String get profileProtectedTradeAction => '取引';

  @override
  String get authMobileLoginTitle => '電話ログイン';

  @override
  String get authEmailLoginTitle => 'メールログイン';

  @override
  String get authMobileRegisterTitle => '電話登録';

  @override
  String get authEmailRegisterTitle => 'メール登録';

  @override
  String get registerAccountLabel => '電話番号またはメール';

  @override
  String get registerEmailAccountLabel => 'メールアドレス';

  @override
  String get registerMobileAccountLabel => '電話番号';

  @override
  String get registerCodeLabel => '認証コード';

  @override
  String get registerSendCode => 'コード送信';

  @override
  String get registerSendCodeSuccess => '登録用コードを送信しました。';

  @override
  String get registerContactLabel => '連絡先情報';

  @override
  String get registerContactHelperEmail => 'メール登録の場合は電話番号を入力してください。';

  @override
  String get registerContactHelperMobile => '任意：アカウント連携用メールを入力できます。';

  @override
  String get registerPasswordLabel => 'パスワード';

  @override
  String get registerConfirmPasswordLabel => 'パスワード確認';

  @override
  String get registerInviteCodeLabel => '招待コード（任意）';

  @override
  String get registerAcceptPolicy => '利用規約とプライバシーポリシーに同意します。';

  @override
  String get registerPolicyButton => '表示';

  @override
  String get registerPolicyTitle => '規約とプライバシー';

  @override
  String get registerPolicyDescription =>
      'この画面は共通のボトムシートUIを利用したサンプルです。正式な法務コンテンツ連携に置き換えてください。';

  @override
  String get registerSubmit => 'アカウントを作成';

  @override
  String get registerBackToLogin => '既にアカウントをお持ちですか？ ログインへ';

  @override
  String get registerPasswordMismatchTitle => 'パスワードが一致しません';

  @override
  String get registerPasswordMismatchMessage => '2つのパスワードが同一であることを確認してください。';

  @override
  String get registerUiReadyTitle => '登録UIは実装済みです';

  @override
  String get registerUiReadyMessage => 'UI実装は完了しました。次はAPI連携です。';

  @override
  String get registerEmailMobileRequired => 'メール登録には電話番号が必要です。';

  @override
  String get registerEmailAccountInvalid => 'メール登録には有効なメールアドレスを入力してください。';

  @override
  String get registerMobileAccountInvalid => '電話登録には有効な電話番号を入力してください。';

  @override
  String get registerSubmitFailed => '登録に失敗しました。後でもう一度お試しください。';

  @override
  String get registerSuccessTitle => '登録完了';

  @override
  String get registerSuccessMessage => 'アカウントを作成しました。ログインしてください。';

  @override
  String get forgotPasswordTitle => 'パスワード再設定';

  @override
  String get forgotPasswordSubtitle => '安全な認証でアカウントアクセスを復旧します。';

  @override
  String get forgotPasswordAccountLabel => '電話番号またはメール';

  @override
  String get forgotPasswordCodeLabel => '認証コード';

  @override
  String get forgotPasswordSendCode => 'コード送信';

  @override
  String get forgotPasswordSendCodeSuccess => '認証コードを送信しました。';

  @override
  String get forgotPasswordNewPasswordLabel => '新しいパスワード';

  @override
  String get forgotPasswordConfirmPasswordLabel => '新しいパスワード確認';

  @override
  String get forgotPasswordSubmit => 'パスワード更新';

  @override
  String get forgotPasswordMismatchTitle => 'パスワードが一致しません';

  @override
  String get forgotPasswordMismatchMessage => '新しいパスワードと確認入力を見直してください。';

  @override
  String get forgotPasswordUiReadyTitle => '再設定UIは実装済みです';

  @override
  String get forgotPasswordUiReadyMessage => 'UI実装は完了しました。次はAPI連携です。';

  @override
  String get forgotPasswordRecoverFailed => 'アクセス復旧に失敗しました。認証コードを確認してください。';

  @override
  String get commonOk => 'OK';

  @override
  String get commonBackToLogin => 'ログインへ戻る';

  @override
  String get homeTitle => 'ホーム';

  @override
  String get mainTabHome => 'ホーム';

  @override
  String get mainTabHotel => 'ホテル';

  @override
  String get mainTabDiscussion => '掲示板';

  @override
  String get mainTabInvestment => 'ファンド';

  @override
  String get mainTabProfile => 'マイページ';

  @override
  String get mainTabKizunark => 'KIZUNARK';

  @override
  String get mainTabSettings => '設定';

  @override
  String get homeHeroTitle => '投資サマリー';

  @override
  String get homeHeroSubtitle => '保有状況、評価損益、利用可能資金をすぐに確認できます。';

  @override
  String get homeHeroAssetsLabel => '総資産';

  @override
  String get homeHeroPnlLabel => '評価損益';

  @override
  String get homeHeroCashLabel => '利用可能資金';

  @override
  String homeWelcomeUser(Object name) {
    return 'おかえりなさい、$name';
  }

  @override
  String get homeHeroTotalAssetsAmountLabel => '総資産額';

  @override
  String get homeHeroMonthlyDelta => '+¥127,500（前月比 +3.4%）';

  @override
  String get homeHeroActiveInvestmentLabel => '運用中';

  @override
  String get homeHeroTotalDividendsLabel => '累計分配金';

  @override
  String get homeGuestBrowsingTitle => 'ログインせずに閲覧中';

  @override
  String get homeGuestBrowsingBody => '投資するにはアカウントが必要です';

  @override
  String get homeReminderProfileTitle => '本人情報を入力して出資を始めましょう';

  @override
  String get homeReminderProfileBody => 'ご投資・ご出金には本人確認が必要です。あと3ステップで完了します。';

  @override
  String get homeReminderProfileBadge => '要対応';

  @override
  String get homeReminderEmailVerificationTitle => 'メールアドレス確認';

  @override
  String get homeReminderEmailVerificationBody =>
      'このアカウントはメールアドレスがないため、メールアドレスを入力して確認してください';

  @override
  String get homeReminderPhoneVerificationTitle => '電話番号認証';

  @override
  String get homeReminderPhoneVerificationBody =>
      'このアカウントは電話番号認証が未完了です。電話番号を入力して認証してください';

  @override
  String get homeReminderRealPersonVerificationTitle => '本人確認';

  @override
  String get homeReminderRealPersonVerificationBody =>
      'このアカウントは本人確認が未完了です。本人確認を完了してください';

  @override
  String get homeReminderCoolingOffTitle => 'クーリングオフ期間中';

  @override
  String get homeReminderCoolingOffBody =>
      '「商業ビル心斎橋」契約書面交付日 3/2 → 取消期限 3/10（8日間）';

  @override
  String get homeReminderCoolingOffBadge => '残り5日';

  @override
  String get homeReminderCoolingOffAction => '取消手続き';

  @override
  String get homeFeaturedFundsTitle => '注目ファンド';

  @override
  String get homeViewAllAction => '一覧を見る';

  @override
  String get homeEstimatedYieldLabel => '想定利回り';

  @override
  String get homeFreeMarketTitle => 'フリーマーケット';

  @override
  String get homeFreeMarketStatusListed => '出品中';

  @override
  String get homeFreeMarketSoldUnitsLabel => '約定口数';

  @override
  String get homeFreeMarketUnitPriceLabel => '販売単価';

  @override
  String get homeFreeMarketEmptyState => '現在公開中のフリーマーケット案件はありません。';

  @override
  String get homeTagOpen => '募集中';

  @override
  String get homeTagLottery => '抽選';

  @override
  String get homeTagUpcoming => '募集前';

  @override
  String get homeActiveFundsTitle => '運用中ファンド';

  @override
  String get homeInvestedAmountLabel => '投資額';

  @override
  String get homeNextDividendLabel => '次回分配予定';

  @override
  String get homeShowMoreAction => 'もっと見る';

  @override
  String get homeShowLessAction => '表示を減らす';

  @override
  String get homeMockFeaturedFundA => '東京都港区 プレミアムレジデンス赤坂';

  @override
  String get homeMockFeaturedFundB => '大阪市中央区 商業ビル心斎橋';

  @override
  String get homeMockFeaturedFundC => '京都市東山区 町家リノベホテル';

  @override
  String get homeMockFeaturedMetaA => '12ヶ月 ・ 2億円';

  @override
  String get homeMockFeaturedMetaB => '18ヶ月 ・ 1.5億円';

  @override
  String get homeMockFeaturedMetaC => '24ヶ月 ・ 3億円';

  @override
  String get homeMockActiveFundA => '渋谷区 オフィスビル #12';

  @override
  String get homeMockActiveFundB => '名古屋市 物流施設 #09';

  @override
  String get homeMockActiveFundC => '福岡市 レジデンスファンド #07';

  @override
  String get homeMockActiveFundD => '札幌市 複合施設ファンド #03';

  @override
  String get fundListTitle => 'ファンド一覧';

  @override
  String get fundListFilterAll => 'すべて';

  @override
  String get fundListFilterOperating => '運用中';

  @override
  String get fundListFilterOperatingEnded => '運用終了';

  @override
  String get fundListFilterOpen => '募集中';

  @override
  String get fundListFilterUpcoming => '募集前';

  @override
  String get fundListFilterFavorites => 'お気に入り';

  @override
  String get fundListFilterClosed => '募集終了';

  @override
  String get fundListFilterCompleted => '募集完成';

  @override
  String get fundListFilterFailed => '募集失敗';

  @override
  String get fundListYieldLabel => '利回り';

  @override
  String get fundListPeriodLabel => '運用期間';

  @override
  String get fundListMethodLabel => '募集方式';

  @override
  String get fundListMethodLottery => '抽選';

  @override
  String get fundListGainTypeIncomeGain => 'インカムゲイン';

  @override
  String get fundListGainTypeCapitalGain => 'キャピタルゲイン';

  @override
  String get fundListGainTypeMixed => '混合型（インカム＋キャピタル）';

  @override
  String get fundListMethodUnknown => '未設定';

  @override
  String fundListAppliedAmount(Object amount, Object progress) {
    return '応募金額 $amount（$progress）';
  }

  @override
  String fundListOpenStartAt(Object start) {
    return '募集開始 $start〜';
  }

  @override
  String get fundListViewDetail => '詳細→';

  @override
  String get fundListLoadError => 'ファンド一覧の取得に失敗しました。再度お試しください。';

  @override
  String get fundListRetry => '再試行';

  @override
  String get fundListEmpty => 'この条件に一致するファンドがありません。';

  @override
  String get fundListStatusOperating => '運用中';

  @override
  String get fundListStatusOperatingEnded => '運用終了';

  @override
  String get fundListStatusOpen => '募集中';

  @override
  String get fundListStatusUpcoming => '募集前';

  @override
  String get fundListStatusClosed => '募集終了';

  @override
  String get fundListStatusCompleted => '募集完成';

  @override
  String get fundListStatusFailed => '募集失敗';

  @override
  String get fundListStatusUnknown => '未設定';

  @override
  String fundListVolume(Object number) {
    return 'Vol. $number';
  }

  @override
  String get hotelTabHeadline => 'ホテル予約モジュール（枠組み）';

  @override
  String get hotelTabSubtitle => '今後ここに検索・一覧・詳細・予約フローを実装します。';

  @override
  String get discussionTabHeadline => '投資ディスカッション掲示板（枠組み）';

  @override
  String get discussionTabSubtitle => '返信・いいね・固定表示・審査に対応する掲示板型UIを今後実装します。';

  @override
  String get discussionTabReplyAction => '返信';

  @override
  String get kizunarkSubtitle => '投資家コミュニティ';

  @override
  String get kizunarkInvestorOnlyNotice => '投資家のみ投稿・コメントできます';

  @override
  String get kizunarkComposePlaceholder => '投資の話題を共有しよう...';

  @override
  String get kizunarkAssociateFundAction => '関連ファンド';

  @override
  String get kizunarkAssociateFundSheetTitle => '関連するファンドを選択';

  @override
  String get kizunarkAssociateFundEmpty => '関連できる運用中のファンドがありません。';

  @override
  String get kizunarkPostAction => '投稿';

  @override
  String get kizunarkReplyPlaceholder => 'コメントを入力...';

  @override
  String get kizunarkReplySendAction => '送信';

  @override
  String get kizunarkJustNow => 'たった今';

  @override
  String kizunarkTimeMinutesAgo(int count) {
    return '$count分前';
  }

  @override
  String kizunarkTimeHoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String get kizunarkFallbackDisplayName => '投資家**';

  @override
  String get kizunarkFallbackHandle => 'user***@';

  @override
  String get kizunarkInvestorBadge => '投資家';

  @override
  String get kizunarkPostSuccessNotice => '投稿しました！';

  @override
  String get kizunarkReplySuccessNotice => 'コメントを投稿しました！';

  @override
  String get kizunarkDeleteAction => '削除';

  @override
  String get kizunarkDeleteConfirmTitle => 'このコメントを削除しますか？';

  @override
  String get kizunarkDeleteConfirmBody => '削除したコメントは元に戻せません。';

  @override
  String get kizunarkDeleteCancelAction => 'キャンセル';

  @override
  String get kizunarkDeleteConfirmAction => '削除する';

  @override
  String get kizunarkDeleteSuccessNotice => 'コメントを削除しました。';

  @override
  String get kizunarkDeleteFailedNotice => 'コメントの削除に失敗しました。';

  @override
  String get kizunarkCopyAction => 'コピー';

  @override
  String get kizunarkCopySuccessNotice => 'メッセージをコピーしました。';

  @override
  String get kizunarkMenuCancelAction => 'キャンセル';

  @override
  String get kizunarkLoginRequiredToPost => '投稿・コメントにはログインが必要です';

  @override
  String get kizunarkGuestLoginPrompt => 'コメントするには、ログインまたは新規登録してください。';

  @override
  String get kizunarkEmptyState => 'まだ投稿がありません。最初の話題を投稿しましょう。';

  @override
  String get investmentTabHeadline => '投資関連モジュール（枠組み）';

  @override
  String get investmentTabSubtitle => '商品一覧、保有、申込/解約、明細などを今後実装します。';

  @override
  String get investmentTabPortfolioLabel => '保有案件';

  @override
  String get investmentTabWatchlistLabel => 'ウォッチ';

  @override
  String get profileTabHeadline => '個人センター（枠組み）';

  @override
  String get profileTabSubtitle => 'アカウント情報、詳細情報入力、設定、会員状態を管理します。';

  @override
  String get settingsTabHeadline => '設定';

  @override
  String get settingsTabSubtitle => 'アカウント・セキュリティ・法定書面・各種設定をここに統合します。';

  @override
  String get menuTitle => 'メニュー';

  @override
  String get menuSectionAccount => 'アカウント';

  @override
  String get menuSectionSecurity => 'セキュリティ';

  @override
  String get menuSectionDocsTax => '書類・税務';

  @override
  String get menuSectionPreferences => '設定';

  @override
  String get menuSectionSupport => 'サポート';

  @override
  String get menuItemTheme => 'テーマ';

  @override
  String get menuItemEditProfile => '会員情報の編集';

  @override
  String get memberProfileOverviewTitle => '会員基本情報';

  @override
  String get commonEditText => '編集';

  @override
  String get menuItemBankSettings => '銀行口座設定';

  @override
  String get menuItemChangePassword => 'パスワード変更';

  @override
  String get menuItemTwoFactor => '二段階認証';

  @override
  String get settingsTwoFactorDescription => '重要な操作に備えて、電話番号認証と本人確認の状態を管理します。';

  @override
  String get settingsEmailVerificationTitle => 'メール認証';

  @override
  String get settingsPhoneVerificationTitle => '電話番号認証';

  @override
  String get settingsFaceVerificationTitle => '本人確認';

  @override
  String get settingsVerificationStatusVerified => '認証済み';

  @override
  String get settingsVerificationStatusUnverified => '未認証';

  @override
  String get settingsVerificationEmailLabel => '認証済みメール';

  @override
  String get settingsVerificationPhoneLabel => '認証済み番号';

  @override
  String get settingsVerificationLastUpdatedLabel => '最終認証';

  @override
  String get settingsEmailVerificationDescription =>
      '現在のメールアドレスに認証コードを送信して、メール認証状態を更新します。';

  @override
  String get settingsCurrentEmailLabel => '現在のメールアドレス';

  @override
  String get settingsEmailUnavailable => 'メールアドレスが未登録です。';

  @override
  String get settingsEmailVerificationInputDescription =>
      '認証に使用するメールアドレスを入力して、認証コードを送信してください。';

  @override
  String get settingsEmailAutoFillHint => 'メールに届いた認証コードを入力して認証を完了してください。';

  @override
  String get settingsEmailVerifyAction => 'メールアドレスを認証';

  @override
  String get settingsEmailCodeRequired => '認証コードを入力してください。';

  @override
  String get settingsEmailCodeSent => '認証コードを送信しました。';

  @override
  String get settingsEmailVerificationSuccess => 'メール認証が完了しました。';

  @override
  String get settingsEmailVerifiedReadonlyDescription =>
      '認証済みのメールアドレスは、この画面から変更できません。';

  @override
  String get settingsPhoneVerificationDescription =>
      '登録済みの電話番号にワンタイムコードを送信して、この端末での認証状態を更新します。';

  @override
  String get settingsCurrentPhoneLabel => '現在の電話番号';

  @override
  String get settingsPhoneUnavailable => '電話番号が未登録です。';

  @override
  String get settingsPhoneVerificationPhoneMissing => '先に会員情報から電話番号を登録してください。';

  @override
  String get settingsPhoneVerificationInputDescription =>
      '認証に使用する電話番号を入力して、ワンタイムコードを送信してください。';

  @override
  String get settingsPhoneAutoFillHint =>
      'SMSに含まれる認証コードは、対応端末では自動入力候補として表示されます。';

  @override
  String get settingsPhoneVerifyAction => '電話番号を認証';

  @override
  String get settingsPhoneCodeRequired => '認証コードを入力してください。';

  @override
  String get settingsPhoneCodeSent => '認証コードを送信しました。';

  @override
  String get settingsPhoneVerificationSuccess => '電話番号認証が完了しました。';

  @override
  String get settingsFaceVerificationDescription =>
      'セキュリティ設定として、この端末で顔認証を有効にします。登録後は重要操作時の本人確認に利用されます。';

  @override
  String get settingsFaceVerificationUploadTitle => '自撮り写真のアップロード';

  @override
  String get settingsFaceVerificationUploadDescription =>
      '本人確認用の自撮り写真をアップロードすると、自動で顔認証を開始します。必要に応じて再実行もできます。';

  @override
  String get settingsFaceVerificationSelfieTitle => '本人確認用の自撮り写真';

  @override
  String get settingsFaceVerificationSelfieDescription =>
      '正面を向いて、顔全体がはっきり写るように撮影してください。';

  @override
  String get settingsFaceVerificationReverifyAction => '再認証';

  @override
  String get menuItemAnnualReport => '年間取引報告書';

  @override
  String get menuItemContractList => '契約書面一覧';

  @override
  String get menuItemMyNumber => 'マイナンバー管理';

  @override
  String get menuItemLanguage => '言語';

  @override
  String get menuThemeSystem => 'システム設定に従う';

  @override
  String get menuThemeLight => 'ライト';

  @override
  String get menuThemeDark => 'ダーク';

  @override
  String get menuItemFaqHelp => 'FAQ・ヘルプ';

  @override
  String get menuItemChatSupport => 'チャットサポート';

  @override
  String get menuItemContactUs => 'お問い合わせ';

  @override
  String get menuItemOperatingCompany => '運営会社について';

  @override
  String get settingsContactTitle => 'お問い合わせ';

  @override
  String get settingsContactDescription =>
      'ご質問・ご意見がございましたら、以下のフォームよりお気軽にお問い合わせください。';

  @override
  String get settingsContactNameLabel => '氏名（姓名）';

  @override
  String get settingsContactKanaLabel => 'フリガナ';

  @override
  String get settingsContactKanaFamilySegment => 'セイ';

  @override
  String get settingsContactKanaGivenSegment => 'メイ';

  @override
  String get settingsContactEmailLabel => 'メールアドレス';

  @override
  String get settingsContactEmailHint => 'example@mail.com';

  @override
  String get settingsContactCategoryLabel => 'お問い合わせカテゴリ';

  @override
  String get settingsContactCategoryPlaceholder => '選択してください';

  @override
  String get settingsContactCategoryInvestment => '出資・投資について';

  @override
  String get settingsContactCategoryAccount => 'アカウント・ログインについて';

  @override
  String get settingsContactCategoryWallet => '分配金・入出金について';

  @override
  String get settingsContactCategoryEkyc => '本人確認（eKYC）について';

  @override
  String get settingsContactCategoryOther => 'その他';

  @override
  String get settingsContactMessageLabel => 'お問い合わせ内容';

  @override
  String get settingsContactMessageHint => 'お問い合わせ内容をご記入ください';

  @override
  String get settingsContactSubmitAction => '送信';

  @override
  String get settingsContactSubmitSuccess => 'お問い合わせを受け付けました。';

  @override
  String get settingsContactPhoneSectionTitle => 'お電話でのお問い合わせ';

  @override
  String get settingsContactPhoneHours => '受付時間：平日 10:00〜18:00（土日祝除く）';

  @override
  String get settingsContactCallFailed => '電話アプリを起動できませんでした。';

  @override
  String get settingsContactValidationName => '姓と名を入力してください。';

  @override
  String get settingsContactValidationKana => 'フリガナを入力してください。';

  @override
  String get settingsContactValidationEmail => '有効なメールアドレスを入力してください。';

  @override
  String get settingsContactValidationCategory => 'お問い合わせカテゴリを選択してください。';

  @override
  String get settingsContactValidationMessage => 'お問い合わせ内容を入力してください。';

  @override
  String get settingsOperatingCompanyTitle => '運営会社';

  @override
  String get settingsContractListDescription => '出資済みプロジェクトごとの契約書面と報告書を確認できます。';

  @override
  String get settingsContractListEmptyState => '表示できる契約書面はありません。';

  @override
  String settingsContractListPdfCount(Object count) {
    return 'PDF $count件';
  }

  @override
  String settingsContractListDocumentTypeCount(Object count) {
    return '書面 $count種';
  }

  @override
  String get settingsContractListLatestUpdatedLabel => '最終更新';

  @override
  String get settingsContractListPendingLabel => 'PDF準備中';

  @override
  String get settingsContractDetailTitle => '契約書面';

  @override
  String get settingsContractDetailRelatedFilesTitle => '関連PDF';

  @override
  String get settingsContractDetailMissingProject => '契約書面情報が見つかりません。';

  @override
  String get settingsContractDetailNoPdfAvailable => '閲覧できるPDFはまだありません。';

  @override
  String get settingsCompanyTradeNameLabel => '商号';

  @override
  String get settingsCompanyLicenseNumberLabel => '許可番号';

  @override
  String get settingsCompanyLicenseTypeLabel => '許可種別';

  @override
  String get settingsCompanyRepresentativeLabel => '代表者';

  @override
  String get settingsCompanyHeadOfficeLabel => '本社';

  @override
  String get settingsCompanyTelLabel => 'TEL';

  @override
  String get settingsCompanyEstablishedLabel => '設立';

  @override
  String get settingsCompanyBusinessLabel => '主な事業';

  @override
  String get settingsCompanyManagerLabel => '業務管理者';

  @override
  String get settingsCompanyRelatedLinksTitle => '関連リンク';

  @override
  String get settingsCompanyLinkTerms => '利用規約';

  @override
  String get settingsCompanyLinkPrivacy => 'プライバシーポリシー';

  @override
  String get settingsCompanyLinkSolicitation => '勧誘方針';

  @override
  String get settingsCompanyLinkAntiSocial => '反社会勢力への対応';

  @override
  String get menuVersionFootnote => 'StellaVia v1.0.0 ・ 不動産特定共同事業 第XXX号';

  @override
  String get menuDeleteAccountAction => 'アカウントを削除（退会）';

  @override
  String get menuDeleteAccountConfirmTitle => '退会しますか？';

  @override
  String get menuDeleteAccountConfirmBody => 'この操作は取り消せません。退会申請機能は後続で接続します。';

  @override
  String get menuDeleteAccountComingSoon => '退会申請機能は次の実装で接続します。';

  @override
  String menuFeatureComingSoon(Object feature) {
    return '$feature は次の実装で接続します。';
  }

  @override
  String get notificationsTitle => 'お知らせ';

  @override
  String get notificationsLotteryTitle => '抽選結果';

  @override
  String get notificationsLotterySubtitle => 'API連携後、抽選結果と入金案内の通知をここに表示します。';

  @override
  String get notificationsSystemTitle => 'システム通知';

  @override
  String get notificationsSystemSubtitle => 'メンテナンス、報告書、法令関連のお知らせ。';

  @override
  String get notificationsTabImportant => '重要';

  @override
  String get notificationsTabGeneral => 'お知らせ';

  @override
  String get notificationsMarkAllRead => '全て既読';

  @override
  String get notificationsNewsPushLabel => 'ニュースを通知で受け取る';

  @override
  String notificationsMarkAllReadDone(int count) {
    return '$count件を既読にしました。';
  }

  @override
  String get notificationsAllReadAlreadyDone => '未読のお知らせはありません。';

  @override
  String get notificationsEmptyImportant => '重要なお知らせはありません。';

  @override
  String get notificationsEmptyGeneral => 'お知らせはありません。';

  @override
  String get notificationsEmptyGuest => 'ログインするとお知らせを確認できます。';

  @override
  String get notificationsLoginRequired => 'ログインが必要です。';

  @override
  String get notificationsDetailNoContent => '詳細はありません。';

  @override
  String get notificationsDetailClose => '閉じる';

  @override
  String get homeLogout => 'ログアウト';

  @override
  String get uiErrorRequestFailed => 'リクエストに失敗しました。後でもう一度お試しください。';

  @override
  String get uiErrorNetworkUnavailable => 'ネットワーク接続に問題があります。後でもう一度お試しください。';

  @override
  String get uiErrorAuthExpired => 'セッションの有効期限が切れました。再度ログインしてください。';

  @override
  String get uiErrorForbidden => 'このリソースにアクセスする権限がありません。';

  @override
  String get uiErrorServerUnavailable => 'サービスは一時的に利用できません。後でもう一度お試しください。';

  @override
  String get languageFollowSystem => 'システムに従う';

  @override
  String get languageChinese => '簡体中文';

  @override
  String get languageTraditionalChinese => '繁體中文';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get fundDetailEstimatedYieldAnnualLabel => '想定利回り（年率）';

  @override
  String get fundDetailYieldDisclaimer => '※ 想定であり、保証するものではありません';

  @override
  String get fundDetailKeyFactsTitle => '基本情報';

  @override
  String get fundDetailFundTotalLabel => '募集金額';

  @override
  String get fundDetailMinimumInvestmentLabel => '最低投資額';

  @override
  String get fundDetailDividendLabel => '配当';

  @override
  String get fundDetailLotteryDateLabel => '抽選日';

  @override
  String get fundDetailOfferingTargetsLabel => '募集対象';

  @override
  String get fundDetailPreferredStructureTitle => '優先劣後構造';

  @override
  String get fundDetailSeniorInvestmentLabel => '優先出資';

  @override
  String get fundDetailJuniorInvestmentLabel => '劣後出資';

  @override
  String get fundDetailPropertyInfoTitle => '物件情報';

  @override
  String get fundDetailLocationLabel => '所在地';

  @override
  String get fundDetailPropertyTypeLabel => '種別';

  @override
  String get fundDetailStructureLabel => '構造';

  @override
  String get fundDetailBuiltYearLabel => '竣工';

  @override
  String get fundDetailCoolingOffLabel => 'クーリングオフ';

  @override
  String get fundDetailCoolingOffDefault => '書面交付日翌日から8日間';

  @override
  String get fundDetailMapClose => '閉じる';

  @override
  String get fundDetailMapDestination => '目的地';

  @override
  String get fundDetailMapCurrentLocation => '現在地';

  @override
  String get fundDetailMapDirections => '行き方';

  @override
  String get fundDetailMapOpenMapApp => 'マップアプリを開く';

  @override
  String get fundDetailMapCancel => 'キャンセル';

  @override
  String get fundDetailMapPermissionDenied => '位置情報の利用が許可されていません。';

  @override
  String get fundDetailMapUnavailable => '地図情報を取得できませんでした。';

  @override
  String get fundDetailContractOverviewTitle => '契約概要（法定記載事項）';

  @override
  String get fundDetailContractTypeLabel => '契約形態';

  @override
  String get fundDetailContractTypeValue => '匿名組合型';

  @override
  String get fundDetailTargetPropertyTypeLabel => '対象不動産の種類';

  @override
  String get fundDetailAppraisalValueLabel => '不動産鑑定評価額';

  @override
  String get fundDetailAcquisitionPriceLabel => '取得予定価格';

  @override
  String get fundDetailOfferPeriodLabel => '募集期間';

  @override
  String get fundDetailOperationStartLabel => '運用開始予定日';

  @override
  String get fundDetailOperationEndLabel => '運用終了予定日';

  @override
  String get fundDetailOperatorInfoTitle => '事業者情報';

  @override
  String get fundDetailOperatorCompanyLabel => '運営会社';

  @override
  String get fundDetailPermitNumberLabel => '許可番号';

  @override
  String get fundDetailRepresentativeLabel => '代表者';

  @override
  String get fundDetailCompanyAddressLabel => '所在地';

  @override
  String get fundDetailOperatorCapitalLabel => '資本金';

  @override
  String get fundDetailOperatorEstablishedLabel => '設立';

  @override
  String get fundDetailOperatorBusinessStartLabel => '事業開始届出';

  @override
  String get fundDetailDocumentsTitle => '関連書面';

  @override
  String get fundDetailDocumentReady => 'タップして確認';

  @override
  String fundDetailDocumentMultipleReady(int count) {
    return '$count件のPDF';
  }

  @override
  String get fundDetailDocumentSelectTitle => '書面を選択';

  @override
  String fundDetailDocumentPickerItem(int index) {
    return '書面 $index';
  }

  @override
  String get fundDetailDocumentUnavailable => '書面URL未設定';

  @override
  String get fundDetailPropertyPreviewBadge => '物件プレビュー';

  @override
  String get fundDetailCommentsTitle => '投資家の声（KIZUNARK）';

  @override
  String get fundDetailCommentsPlaceholder => 'コメント機能は今回未実装です。UIのみ後続で接続します。';

  @override
  String get fundDetailCommentsPreviewAvatar => '佐';

  @override
  String get fundDetailCommentsPreviewUser => '佐藤**';

  @override
  String get fundDetailCommentsPreviewTime => '2時間前';

  @override
  String get fundDetailCommentsPreviewBody =>
      '白馬PJの案件、リゾート需要が堅調ですね。予定分配率1.5%～14.6%のレンジは幅があるが、売却益次第で大きいリターン。';

  @override
  String get fundDetailCommentsPreviewReplyCount => '3';

  @override
  String get fundDetailCommentsMoreAction => 'KIZUNARKでもっと見る';

  @override
  String get fundDetailFinancialStatusAction => '事業者の財務状況を確認する →';

  @override
  String get fundDetailFinancialStatusToast => '財務状況ページは次の実装で接続します。';

  @override
  String get fundDetailApplyNowAction => '抽選に申し込む';

  @override
  String get fundDetailOpenSoonAction => '募集開始を待つ';

  @override
  String get fundDetailUnavailableAction => '現在申込できません';

  @override
  String get fundDetailApplyComingSoonToast => '申込フローは次の実装で接続します。';

  @override
  String get lotteryApplyFlowTitle => '抽選申込';

  @override
  String get lotteryApplyStep1Title => '① 申込口数を入力';

  @override
  String get lotteryApplyStep1BalanceLabel => '待機資金残高';

  @override
  String get lotteryApplyStep1DepositAction => '入金する';

  @override
  String get lotteryApplyStep1AmountLabel => '申込口数（1口 = 10万円）';

  @override
  String lotteryApplyStep1AmountLabelWithRules(
    Object unitAmount,
    Object maxAmount,
  ) {
    return '申込口数（1口 = $unitAmount / 上限 $maxAmount）';
  }

  @override
  String get lotteryApplyStep1UnitPriceLabel => '1口あたり';

  @override
  String get lotteryApplyStep1UnitCountLabel => '申込口数';

  @override
  String get lotteryApplyStep1UnitSuffix => '口';

  @override
  String get lotteryApplyStep1TotalAmountLabel => '申込総額';

  @override
  String lotteryApplyStep1MaximumUnitsNotice(Object maxUnits) {
    return '最大 $maxUnits口まで申込できます。';
  }

  @override
  String lotteryApplyStep1MinimumUnitsNotice(Object minUnits) {
    return '最小申込口数は $minUnits口です。';
  }

  @override
  String get lotteryApplyStep1BalanceWarningTitle => '待機資金が不足しています';

  @override
  String get lotteryApplyStep1BalanceWarningBody =>
      '申込金額に対して残高が不足しています。先にご入金のうえ、お申込みください。';

  @override
  String get lotteryApplyStep1BalanceWarningAction => '入金ページへ';

  @override
  String get lotteryApplyStep1MaximumWarningTitle => '上限を超えています';

  @override
  String get lotteryApplyStep1MaximumWarningBody =>
      '申込金額が1人あたりの上限を超えています。口数を減らして再入力してください。';

  @override
  String get lotteryApplyStep1EstimatedDistributionLabel => '想定分配金（税引前）';

  @override
  String get lotteryApplyStep1EstimatedDistributionSuffix => '/年';

  @override
  String get lotteryApplyStep1NextAction => '次へ：書面確認';

  @override
  String get lotteryApplyStep2Title => '② 契約書面の確認';

  @override
  String get lotteryApplyStep2Description =>
      '投資判断に必要な書面です。すべてご確認のうえ、チェックしてください。';

  @override
  String get lotteryApplyStep2OpenDocumentFirstNotice => '先に書面を開いてご確認ください。';

  @override
  String get lotteryApplyDocumentPreContractTitle => '契約締結前交付書面';

  @override
  String get lotteryApplyDocumentPreContractSubtitle =>
      'PDF 12ページ ｜ 重要事項・リスク説明を含む';

  @override
  String get lotteryApplyDocumentAgreementTitle => '匿名組合契約約款';

  @override
  String get lotteryApplyDocumentAgreementSubtitle => 'PDF 8ページ ｜ 契約条件・分配方法の詳細';

  @override
  String get lotteryApplyStep2InfoBody =>
      '書面の電子交付に関する同意は、会員登録時に取得済みです。設定画面からいつでも撤回・変更できます。';

  @override
  String get lotteryApplyStep2NextAction => 'すべて確認してから次へ';

  @override
  String get lotteryApplyStep3Title => '③ 申込内容の確認';

  @override
  String get lotteryApplyFundNameLabel => 'ファンド名';

  @override
  String get lotteryApplyInvestmentAmountLabel => '出資金額';

  @override
  String get lotteryApplyAnnualYieldPrefix => '年率';

  @override
  String get lotteryApplyNoticeTitle => 'ご注意';

  @override
  String get lotteryApplyNoticeBody =>
      '本投資は元本保証ではありません。抽選に当選した場合、指定期限内にご入金が必要です。';

  @override
  String get lotteryApplyAgreementLabel => '上記内容を確認し、抽選申込に同意します';

  @override
  String get lotteryApplySubmitAction => '抽選に申し込む';

  @override
  String get lotteryApplySubmitFailedFallback =>
      '抽選申込に失敗しました。しばらくしてから再度お試しください。';

  @override
  String get lotteryApplyStep4Headline => '抽選申込が完了しました！';

  @override
  String lotteryApplyStep4Body(Object projectName) {
    return '「$projectName」の抽選に申し込みました。抽選結果は下記の日程で発表予定です。結果はアプリの通知でお知らせいたします。';
  }

  @override
  String get lotteryApplyResultAnnouncementDateLabel => '抽選結果発表日';

  @override
  String get lotteryApplyApplicationNumberLabel => '申込番号';

  @override
  String get lotteryApplyStep4HintBody =>
      '当選した場合、8日以内にご入金ください（クーリングオフ期間を含みます）。落選の場合はお手続き不要です。※ 募集人数未達の場合も先着順に審査し、抽選を実施します。';

  @override
  String get lotteryApplyBackHomeAction => 'ホームに戻る';

  @override
  String get lotteryApplyDemoCheckResultAction => '抽選結果を確認する →';

  @override
  String get lotteryApplyStep5Headline => '当選のお知らせ';

  @override
  String lotteryApplyStep5Body(Object projectName) {
    return '「$projectName」の抽選に当選しました。下記の入金期限までに指定口座へお振込みください。';
  }

  @override
  String get lotteryApplyDeadlineLabel => '入金期限（クーリングオフ8日間含む）';

  @override
  String get lotteryApplyCoolingOffTitle => 'クーリングオフについて';

  @override
  String get lotteryApplyCoolingOffBody =>
      '契約書面交付日の翌日から8日間は無条件解除が可能です。入金後もクーリングオフ期間中は解約可能です。';

  @override
  String get lotteryApplyDepositAmountLabel => '入金金額';

  @override
  String get lotteryApplyBankNameLabel => '振込先';

  @override
  String get lotteryApplyBankBranchLabel => '支店';

  @override
  String get lotteryApplyBankAccountLabel => '口座番号';

  @override
  String get lotteryApplyBankHolderLabel => '名義';

  @override
  String get lotteryApplyMockBankName => 'GMOあおぞらネット銀行';

  @override
  String get lotteryApplyMockBankBranch => '法人第一支店（101）';

  @override
  String get lotteryApplyMockBankAccount => '普通 1234567';

  @override
  String get lotteryApplyMockBankHolder => 'ファンデックス（カ';

  @override
  String get lotteryApplyReportDepositAction => '入金完了を報告';

  @override
  String get lotteryApplyLaterDepositAction => 'あとで入金する';

  @override
  String get lotteryApplyCopyAction => 'コピー';

  @override
  String get lotteryApplyCopyDoneToast => 'コピーしました';

  @override
  String get lotteryApplyStep6Headline => '出資手続きが完了しました';

  @override
  String get lotteryApplyStep6Body =>
      '入金を確認しました。運用開始までお待ちください。分配スケジュールは通知でお知らせします。';

  @override
  String get lotteryApplyReceiptLabel => '受付番号：';

  @override
  String get fundApplyVerificationRequiredTitle => '未認証';

  @override
  String get fundApplyVerificationRequiredMessage =>
      'ファンド申込は認証済み会員のみご利用いただけます。先に認証を完了してください。';

  @override
  String get fundDetailUnknownValue => '--';

  @override
  String get fundDetailOneUnitSuffix => '（1口）';

  @override
  String get fundDetailMonthlyDistribution => '毎月';

  @override
  String get fundDetailQuarterlyDistribution => '四半期毎';

  @override
  String get fundDetailSemiAnnualDistribution => '半年毎';

  @override
  String get fundDetailAnnualDistribution => '年1回';

  @override
  String get fundDetailPlannedDistributionRateLabel => '予定分配率（税引前）';

  @override
  String get fundDetailAchievementRateLabel => '募集達成率';

  @override
  String get fundDetailGainTypeTitle => '収益の種類';

  @override
  String get fundDetailGainTypeDescriptionTitle => '収益の種類の説明';

  @override
  String get fundDetailGainTypeIncomeGainTitle => '1. インカムゲイン（Income Gain）';

  @override
  String get fundDetailGainTypeIncomeGainBody =>
      '意味：保有資産から得られる定期的な収入\n\n特徴：毎月や四半期ごとに安定して入るお金\n\n例：不動産の賃料収入、民泊・ホテル運営收益';

  @override
  String get fundDetailGainTypeCapitalGainTitle => '2. キャピタルゲイン（Capital Gain）';

  @override
  String get fundDetailGainTypeCapitalGainBody =>
      '意味：資産価格の値上がりによる売却益\n\n特徴：資産を売ったときに得られる一時的な利益\n\n例：不動産の売却益';

  @override
  String get fundDetailGainTypeMixedTitle => '3. 混合型（インカム＋キャピタル）';

  @override
  String get fundDetailGainTypeMixedBody =>
      '意味：インカムゲインとキャピタルゲインの両方を狙う運用\n\n特徴：配当・利息などの安定収入と値上がり益の両方を期待できる\n\n例：賃料収入＋物件売却益';

  @override
  String get fundDetailTabPropertyOverview => '物件概要';

  @override
  String get fundDetailTabIncomeScheme => '想定収支スキーム';

  @override
  String fundDetailPropertyCountHint(int count) {
    return '本ファンドは$count棟の物件で構成されています。';
  }

  @override
  String fundDetailPropertyItemPrefix(int index) {
    return '物件$index';
  }

  @override
  String get fundDetailPropertyNameLabel => '物件名称';

  @override
  String get fundDetailTransportationLabel => '交通';

  @override
  String get fundDetailLandSectionTitle => '土地';

  @override
  String get fundDetailLandCategoryLabel => '地目';

  @override
  String get fundDetailAreaLabel => '面積';

  @override
  String get fundDetailRightsLabel => '権利';

  @override
  String get fundDetailBuildingSectionTitle => '建物';

  @override
  String get fundDetailFloorAreaLabel => '床面積';

  @override
  String get fundDetailBuiltYearMonthLabel => '築年月';

  @override
  String get fundDetailRegulationSectionTitle => '法令';

  @override
  String get fundDetailLandUseZoneLabel => '用途地域';

  @override
  String get fundDetailBuildingCoverageRatioLabel => '建ぺい率';

  @override
  String get fundDetailFloorAreaRatioLabel => '容積率';

  @override
  String get fundDetailOperationContractSectionTitle => '運営委託契約の概要';

  @override
  String get fundDetailOperationTypeLabel => '運営種類';

  @override
  String get fundDetailLandlordLabel => '貸主/委託者';

  @override
  String get fundDetailTenantLabel => '借主/受託者';

  @override
  String get fundDetailContractPeriodLabel => '契約期間';

  @override
  String get fundDetailMonthlyRentLabel => '運営収益年額';

  @override
  String get fundDetailContractAmendmentMethodLabel => '契約更改の方法';

  @override
  String get fundDetailOtherImportantMattersLabel => 'その他重要な事項';

  @override
  String get fundDetailOperationTypeLeaseValue => '賃貸借契約';

  @override
  String get fundDetailOperationTypeHotelValue => 'ホテル・民泊運営';

  @override
  String get fundDetailSchemeMarketEstimateNote => '※ 市場の想定数値となります。';

  @override
  String get fundDetailSchemeBreakdownTitle => '出資金の内訳';

  @override
  String get fundDetailSchemeIncomeTitle => '収入';

  @override
  String get fundDetailSchemeExpenseTitle => '支出';

  @override
  String get fundDetailSchemePropertyPriceLabel => '物件価格';

  @override
  String get fundDetailSchemeTotalInvestmentLabel => '出資総額';

  @override
  String get fundDetailSchemeEstimatedAmountLabel => '売却収益';

  @override
  String get fundDetailSchemeRentalIncomeLabel => '運営収益';

  @override
  String get fundDetailSchemeIncomeTotalLabel => '収入合計 ①';

  @override
  String get fundDetailSchemeLandMiscLabel => '土地原価+諸費用';

  @override
  String get fundDetailSchemeDesignCostLabel => '設計費用と建築費用';

  @override
  String get fundDetailSchemeBuildingCostLabel => '建物原価';

  @override
  String get fundDetailSchemeMaintenanceFeeLabel => '維持管理費';

  @override
  String get fundDetailSchemePublicUtilitiesTaxesLabel => '公租公課';

  @override
  String get fundDetailSchemeFireInsurancePremiumLabel => '火災保険料';

  @override
  String get fundDetailSchemeBrokerageFeeLabel => '仲介手数料';

  @override
  String get fundDetailSchemeAmFeeLabel => 'AMフィー';

  @override
  String get fundDetailSchemeAmFeeYear1Label => 'AMフィー（1年目）';

  @override
  String get fundDetailSchemeAmFeeYear2Label => 'AMフィー（2年目）';

  @override
  String get fundDetailSchemeAmCommissionLabel => 'AM手数料';

  @override
  String get fundDetailSchemePublicOfferingFeeLabel => '公募募集手数料など';

  @override
  String get fundDetailSchemeMarketingCostsLabel => 'マーケティング費用';

  @override
  String get fundDetailSchemeAccountantFeeLabel => '税理士報酬';

  @override
  String get fundDetailSchemeConsignmentFeeLabel => '委託管理費';

  @override
  String get fundDetailSchemeNormalConsignmentFeeLabel => '専属委託管理費';

  @override
  String get fundDetailSchemeFundAdministratorFeeLabel => 'ファンド管理人FEE';

  @override
  String get fundDetailSchemeMiscExpensesLabel => '諸経費';

  @override
  String get fundDetailSchemeSellExpensesLabel => '売却費用';

  @override
  String get fundDetailSchemeOtherLabel => 'その他';

  @override
  String get fundDetailSchemeExpenseTotalLabel => '支出合計 ②';

  @override
  String get fundDetailSchemeDistributedCapitalFormula => '収入① − 支出②';

  @override
  String get fundDetailSchemeDistributedCapitalTitle => '分配原資';

  @override
  String get myPageTitle => 'マイページ';

  @override
  String get myPageTotalAssetsLabel => '総資産額';

  @override
  String get myPageTotalAssetsCaption => '運用中 + 待機資金 + 分配金';

  @override
  String get myPageMetricOperating => '運用中';

  @override
  String get myPageMetricStandby => '待機資金';

  @override
  String get myPageMetricAccumulatedDistribution => '累計分配';

  @override
  String get myPageMetricLoanType => '貸付型';

  @override
  String get myPageDepositAction => '入金';

  @override
  String get myPageWithdrawAction => '出金';

  @override
  String get myPagePendingApplicationsTitle => '申込中・抽選待ち';

  @override
  String get myPageCoolingOffTitle => 'クーリングオフ期間中（契約成立）';

  @override
  String get myPageOrderInquirySectionTitle => '売却注文照会';

  @override
  String get myPageOrderInquiryListTitle => '注文照会';

  @override
  String get myPageOperatingFundsTitle => '運用中ファンド';

  @override
  String get myPageTransactionHistoryAction => '取引履歴を見る';

  @override
  String get myPageApplyAmountLabel => '申込金額';

  @override
  String get myPageResultAnnouncementLabel => '結果発表';

  @override
  String get myPageResultAnnouncementTbd => '未定';

  @override
  String get myPageApplySubmittedAtLabel => '申込日時';

  @override
  String get myPageApplyReviewedAtLabel => '審査日時';

  @override
  String get myPageApplyPaymentNoticeLabel => '入金案内';

  @override
  String get myPageApplyPaidAtLabel => '入金日時';

  @override
  String get myPageApplyCancellationRequestedAtLabel => 'キャンセル申請';

  @override
  String get myPageApplyCancelledAtLabel => 'キャンセル完了';

  @override
  String get myPageInvestmentAmountLabel => '投資額';

  @override
  String get myPageOrderTimeLabel => '注文時間';

  @override
  String get myPageOrderInvestorTypeLabel => '出資者種別';

  @override
  String get myPageOrderUnitsLabel => '注文数量 / 約定数量';

  @override
  String get myPageOrderUnitPriceLabel => '注文単価';

  @override
  String get myPageOrderInquiryStatusExecuting => '実行中';

  @override
  String get myPageOrderInquiryStatusPending => '確認待ち';

  @override
  String get myPageAccumulatedDistributionLabel => '累計分配金';

  @override
  String get myPageDocumentDeliveryDateLabel => '書面交付日';

  @override
  String get myPageCancelDeadlineLabel => '取消期限';

  @override
  String get myPageCoolingOffFootnote =>
      '※ 契約締結時交付書面を受領した日の翌日から8日間はクーリングオフ（無条件解除）が可能です。';

  @override
  String get myPageCancelRequestAction => 'キャンセル';

  @override
  String get myPageCancelOrderAction => '取消注文';

  @override
  String get myPageCancelRequestComingSoon => 'キャンセル申請機能は次の実装で接続します。';

  @override
  String get myPageWithdrawConfirmTitle => '撤回しますか？';

  @override
  String get myPageWithdrawApplyConfirmBody => 'この申込を撤回します。よろしいですか？';

  @override
  String get myPageWithdrawOrderConfirmBody => 'この売却注文を撤回します。よろしいですか？';

  @override
  String get myPageWithdrawConfirmAction => '撤回する';

  @override
  String get myPageWithdrawSuccess => '撤回を受け付けました。';

  @override
  String get myPageWithdrawFailure => '撤回に失敗しました。時間をおいて再度お試しください。';

  @override
  String get myPageDepositComingSoon => '入金画面は次の実装で接続します。';

  @override
  String get myPageWithdrawComingSoon => '出金画面は次の実装で接続します。';

  @override
  String get myPageHistoryComingSoon => '取引履歴画面は次の実装で接続します。';

  @override
  String get walletDepositTitle => '入金';

  @override
  String get walletHistoryTitle => '入金履歴';

  @override
  String get walletTransactionHistoryTitle => '取引履歴';

  @override
  String get walletHistoryFilterAll => 'すべて';

  @override
  String get walletHistoryFilterDeposit => '入金';

  @override
  String get walletHistoryFilterWithdraw => '出金';

  @override
  String get walletDedicatedAccountTitle => 'お客様専用の入金口座';

  @override
  String get walletDedicatedAccountDescription =>
      'この口座はお客様専用の入金口座です。入金は自動的に口座に反映されます。（最低入金額：¥10,000）\n3ヶ月間利用がない場合、入金口座が変更される場合があります。';

  @override
  String get walletBankNameLabel => '銀行名';

  @override
  String get walletBranchNameLabel => '支店名';

  @override
  String get walletAccountTypeLabel => '口座種別';

  @override
  String get walletAccountNumberLabel => '口座番号';

  @override
  String get walletAccountHolderLabel => '口座名義';

  @override
  String get walletStandbyBalanceLabel => '待機資金残高';

  @override
  String get walletStandbyBalanceHistoryTitle => '待機資金取引履歴';

  @override
  String get walletHistorySectionTitle => '最新履歴';

  @override
  String get walletHistoryMoreAction => 'すべて見る';

  @override
  String get walletHistoryEmpty => '履歴はまだありません。';

  @override
  String get walletHistoryUnknownType => '取引';

  @override
  String get walletBankAccountMissingDescription =>
      'お客様専用の入金口座がまだありません。口座を申請してからご入金ください。';

  @override
  String get walletBankAccountApplyAction => '口座を申請する';

  @override
  String get walletBankAccountApplySuccess => '入金口座を申請しました。情報を更新します。';

  @override
  String get walletBankAccountApplyFailure => '口座申請に失敗しました。時間をおいて再度お試しください。';

  @override
  String get walletBankSettingsRegisteredTitle => '登録済み口座';

  @override
  String get walletBankSettingsEmptyMessage =>
      '登録済みの銀行口座がありません。下のボタンから口座を追加してください。';

  @override
  String get walletBankSettingsAddAction => '口座を追加';

  @override
  String get walletBankSettingsAddSheetTitle => '銀行口座を追加';

  @override
  String get walletBankSettingsAddSheetDescription =>
      '振込先として利用する銀行口座情報を入力してください。';

  @override
  String get walletBankSettingsAddEntrySheetTitle => '追加する口座を選択';

  @override
  String get walletBankSettingsAddDomesticOption => '日本国内銀行';

  @override
  String get walletBankSettingsAddOverseasOption => '日本以外の銀行';

  @override
  String get walletBankSettingsOverseasAddTitle => '海外銀行口座を追加';

  @override
  String get walletBankSettingsOverseasAddDescription =>
      '日本以外の銀行口座情報を入力してください。';

  @override
  String get walletBankSettingsCancelAction => 'キャンセル';

  @override
  String get walletBankSettingsAddSuccess => '銀行口座を追加しました。';

  @override
  String get walletBankSettingsAddFailure => '銀行口座の追加に失敗しました。時間をおいて再度お試しください。';

  @override
  String get walletBankSettingsRequiredError => 'すべての項目を入力してください。';

  @override
  String get walletBankSettingsDomesticTip => '国内口座からの出金手数料は 1,000 円です。';

  @override
  String get walletBankSettingsBranchNumberLabel => '支店番号';

  @override
  String get walletBankSettingsBranchNumberHint => '001';

  @override
  String get walletBankSettingsOverseasAccountHolderLabel => '口座名義';

  @override
  String get walletBankSettingsOverseasAccountHolderHint => 'DIAOWEN';

  @override
  String get walletBankSettingsOwnerAddressLabel => '口座名義人住所';

  @override
  String get walletBankSettingsOwnerAddressHint => '大阪府大阪市...';

  @override
  String get walletBankSettingsOwnerNationalityLabel => '口座名義人国籍';

  @override
  String get walletBankSettingsOwnerNationalityHint => '中国';

  @override
  String get walletBankSettingsSwiftCodeLabel => 'SWIFT / BIC';

  @override
  String get walletBankSettingsSwiftCodeHint => 'AAAABBCCDDD';

  @override
  String get walletBankSettingsBankCountryLabel => '銀行所在国';

  @override
  String get walletBankSettingsBankCountryHint => '日本';

  @override
  String get walletBankSettingsBranchAddressLabel => '支店住所';

  @override
  String get walletBankSettingsBranchAddressHint => '東京都千代田区...';

  @override
  String get walletBankSettingsOverseasTip => '海外口座からの出金手数料は 10,000 円です。';

  @override
  String get walletBankSettingsDomesticChipLabel => '日本国内';

  @override
  String get walletBankSettingsOverseasChipLabel => '海外';

  @override
  String get walletBankSettingsDeleteAction => '削除';

  @override
  String get walletBankSettingsDeleteConfirmTitle => '口座の削除';

  @override
  String get walletBankSettingsDeleteConfirmBody =>
      'この出金口座を削除しますか？この操作は取り消せません。';

  @override
  String get walletBankSettingsDeleteSuccess => '出金口座を削除しました。';

  @override
  String get walletBankSettingsDeleteFailure => '出金口座の削除に失敗しました。';

  @override
  String walletBankAccountExpireNotice(Object date) {
    return '$date まで、期限内にお振込みください';
  }

  @override
  String get walletHistoryPendingStatus => '未完了';

  @override
  String get walletHistoryInflowLabel => '入金';

  @override
  String get walletHistoryOutflowLabel => '出金';

  @override
  String get walletAutoReflectedSuffix => '（自動反映）';

  @override
  String get walletDataLoadError => '入金情報の取得に失敗しました。';

  @override
  String get walletWithdrawTitle => '出金申請';

  @override
  String get walletWithdrawAvailableAmountLabel => '出金可能額';

  @override
  String get walletWithdrawAmountLabel => '出金金額';

  @override
  String get walletWithdrawAmountHint => '¥100,000';

  @override
  String get walletWithdrawDestinationLabel => '振込先';

  @override
  String get walletWithdrawFeeLabel => '手数料';

  @override
  String get walletWithdrawSelectDestination => '振込先を選択';

  @override
  String get walletWithdrawNeedAccountMessage => '出金先口座が未登録です。先に口座を追加してください。';

  @override
  String get walletWithdrawNeedAccountAction => '出金口座を追加';

  @override
  String get walletWithdrawPhoneVerificationRequiredMessage =>
      '出金するには、先に電話認証を完了してください。';

  @override
  String get walletWithdrawPhoneVerificationRequiredAction => '電話認証へ進む';

  @override
  String get walletWithdrawSelectSheetTitle => '振込先を選択';

  @override
  String get walletWithdrawSubmitAction => '出金申請';

  @override
  String get walletWithdrawConfirmTitle => '出金内容を確認';

  @override
  String get walletWithdrawEstimatedArrivalLabel => '着金予定日';

  @override
  String get walletWithdrawEstimatedArrivalValue => '1-3営業日';

  @override
  String get walletWithdrawNetAmountLabel => '実際の着金額';

  @override
  String get walletWithdrawCodeSentTargetLabel => '認証コードの送信先';

  @override
  String get walletWithdrawConfirmHint =>
      '確認すると、ご登録の電話番号へ認証コードを送信します。本人確認を完了してください。';

  @override
  String get walletWithdrawConfirmSendCodeAction => '確認してコードを送信';

  @override
  String get walletWithdrawBackEditAction => '戻って修正';

  @override
  String get walletWithdrawVerificationHint => 'コード認証が完了すると、この内容で出金申請を送信します。';

  @override
  String get walletWithdrawCodeSent => '認証コードを送信しました。';

  @override
  String get walletWithdrawCodeRequired => '6桁の認証コードを入力してください。';

  @override
  String get walletWithdrawVerifyTitle => '本人確認';

  @override
  String walletWithdrawCountdownLabel(Object seconds) {
    return '$seconds秒後に再送できます';
  }

  @override
  String get walletWithdrawResendReady => '認証コードを再送できます';

  @override
  String walletWithdrawVerifyAmountHint(Object amount) {
    return '認証が完了すると、$amount の出金申請を送信します。';
  }

  @override
  String get walletWithdrawVerifySubmitAction => '認証して送信';

  @override
  String get walletWithdrawSubmitPending => '出金機能は次の実装で接続します。';

  @override
  String get walletWithdrawAmountInvalid => '有効な出金金額を入力してください。';

  @override
  String get walletWithdrawInsufficientBalance => '出金金額と手数料を含めた残高が不足しています。';

  @override
  String get walletWithdrawSelectAccountFirst => '出金先口座を選択してください。';

  @override
  String get walletWithdrawSubmitSuccess => '出金申請を送信しました。';

  @override
  String get walletWithdrawSubmitFailure => '出金申請の送信に失敗しました。時間をおいて再度お試しください。';

  @override
  String get walletWithdrawCancelAction => 'キャンセル';

  @override
  String get walletWithdrawCancelConfirmTitle => '出金申請を取消しますか？';

  @override
  String get walletWithdrawCancelConfirmBody => '未送金の出金申請を取消します。よろしいですか？';

  @override
  String get walletWithdrawCancelConfirmAction => '取消する';

  @override
  String get walletWithdrawCancelSuccess => '出金申請を取消しました。';

  @override
  String get walletWithdrawCancelFailure => '出金申請の取消に失敗しました。時間をおいて再度お試しください。';

  @override
  String get walletWithdrawingAction => '出金中';

  @override
  String get walletWithdrawHistoryAction => '出金履歴';

  @override
  String get walletWithdrawingPageTitle => '出金中一覧';

  @override
  String get walletWithdrawHistoryPageTitle => '出金履歴';

  @override
  String get walletWithdrawHistoryFilterAll => 'すべて';

  @override
  String get walletWithdrawRecordEmpty => '表示できる出金記録がありません。';

  @override
  String get walletWithdrawRecordFeeLabel => '手数料';

  @override
  String get walletWithdrawRecordApplyTimeLabel => '申請日時';

  @override
  String get walletWithdrawRecordPaidTimeLabel => '反映日時';

  @override
  String get walletWithdrawRecordBookedTimeLabel => '予約日時';

  @override
  String get walletWithdrawRecordBankNumberLabel => '振込先口座';

  @override
  String get walletWithdrawRecordTypeBankTransfer => '銀行振込';

  @override
  String get walletWithdrawRecordTypeCash => '現金引き出し';

  @override
  String get walletWithdrawRecordTypeGentlePay => 'GentlePay へ出金';

  @override
  String get walletWithdrawRecordStatusPending => '処理中';

  @override
  String get walletWithdrawRecordStatusDone => '完了';

  @override
  String get walletWithdrawRecordStatusUnpaid => '送金中';

  @override
  String get walletWithdrawRecordStatusPaid => '送金済み';

  @override
  String get walletWithdrawRecordStatusFailedUnconfirmed => '送金失敗・未確認';

  @override
  String get walletWithdrawRecordStatusFailedConfirmed => '送金失敗・確認済み';

  @override
  String get walletWithdrawRecordStatusRevoked => 'キャンセル';

  @override
  String get walletWithdrawRecordStatusUnknown => '状態不明';

  @override
  String get myPagePendingEmptyState => '申込中または抽選待ちの案件はありません。';

  @override
  String get myPageOrderInquiryEmptyState => '注文照会はありません。';

  @override
  String get myPageApplyHistoryEmptyState => 'お申込み履歴はありません。';

  @override
  String get myPageCoolingOffEmptyState => 'クーリングオフ期間中の案件はありません。';

  @override
  String get myPageOperatingFundsEmptyState => '運用中のファンドはありません。';

  @override
  String get myPageOperatingFundsEmptyAction => 'ファンド一覧へ';

  @override
  String get myPageSectionLoadError => 'このセクションの取得に失敗しました。再度お試しください。';

  @override
  String get myPageApplyHistoryListTitle => 'お申込み履歴一覧';

  @override
  String get myPageApplyFilterAll => 'すべて';

  @override
  String get myPageApplyFilterApplying => '申込中';

  @override
  String get myPageApplyFilterPendingConfirmation => '確認待ち';

  @override
  String get myPageApplyFilterCompleted => '完了';

  @override
  String get myPageApplyFilterInvalid => '失効';

  @override
  String get myPageApplyStatusApplying => '申込中';

  @override
  String get myPageApplyStatusPendingConfirmation => '確認待ち';

  @override
  String get myPageApplyStatusCompleted => '完了';

  @override
  String get myPageApplyStatusInvalid => '失効';

  @override
  String get myPageApplyConfirmationPendingAtLabel => '確認待ち';

  @override
  String get myPageApplyCompletedAtLabel => '完了日';

  @override
  String get myPageApplyInvalidAtLabel => '失効日';

  @override
  String get myPageApplyStatusUnderReview => '審査中';

  @override
  String get myPageApplyStatusReviewed => '審査済み';

  @override
  String get myPageApplyStatusAwaitingPayment => '入金待ち';

  @override
  String get myPageApplyStatusPaid => '入金済み';

  @override
  String get myPageApplyStatusCancellationReview => 'キャンセル審査中';

  @override
  String get myPageApplyStatusCancelled => 'キャンセル済み';

  @override
  String myPageCoolingOffDeadlineRemaining(Object date, int days) {
    return '$dateまで（残り$days日）';
  }

  @override
  String myPageCoolingOffDeadlineExpired(Object date) {
    return '$dateで期限終了';
  }

  @override
  String get myPageActiveFundDetailTitle => '運用中ファンド詳細';

  @override
  String get myPageActiveFundMetaTitle => '契約情報';

  @override
  String get myPageActiveFundValidInvestmentAmountLabel => '有効投資額';

  @override
  String get myPageActiveFundInvestUnitsLabel => '投資口数';

  @override
  String get myPageActiveFundValidUnitsLabel => '有効口数';

  @override
  String get myPageActiveFundRemainingUnitsLabel => '残口数';

  @override
  String get myPageActiveFundProcessIdLabel => 'プロセスID';

  @override
  String get myPageActiveFundInvestorCodeLabel => '投資者区分';

  @override
  String get myPageActiveFundAppliedAtLabel => '申込日時';

  @override
  String get myPageActiveFundWithdrawnAtLabel => '出金日時';

  @override
  String get myPageActiveFundTotalBenefitLabel => '総収益';

  @override
  String get myPageActiveFundBenefitHistoryTitle => '収益履歴';

  @override
  String get myPageActiveFundBenefitAmountLabel => '分配金';

  @override
  String get myPageActiveFundTaxLabel => '源泉税';

  @override
  String get myPageActiveFundNetBenefitLabel => '税引後';

  @override
  String get myPageActiveFundWithdrawAction => '出金依頼';

  @override
  String get myPageActiveFundWithdrawDone => '出金済み';

  @override
  String get myPageActiveFundWithdrawConfirmTitle => '出金依頼を送信しますか？';

  @override
  String get myPageActiveFundWithdrawConfirmBody => 'この分配金の出金依頼を送信します。よろしいですか？';

  @override
  String get myPageActiveFundWithdrawConfirmAction => '送信する';

  @override
  String get myPageActiveFundWithdrawSuccess => '出金依頼を送信しました。';

  @override
  String get myPageActiveFundWithdrawFailure =>
      '出金依頼の送信に失敗しました。しばらくしてから再度お試しください。';

  @override
  String get myPageActiveFundResaleAction => '転売申請';

  @override
  String get myPageActiveFundResaleComingSoon => '転売申請機能は次の実装で接続します。';

  @override
  String get myPageActiveFundBenefitEmptyState => '収益履歴はまだありません。';

  @override
  String get myPageActiveFundBenefitLoadError => '収益履歴の取得に失敗しました。';

  @override
  String myPageActiveFundBenefitSeq(int seq) {
    return '第$seq回分配';
  }

  @override
  String myPageActiveFundBenefitPeriodRange(Object start, Object end) {
    return '$start 〜 $end';
  }

  @override
  String get myPageResaleOrderTitle => '売却注文';

  @override
  String get myPageResaleTabOrder => '売却';

  @override
  String get myPageResaleTabConfirm => 'ご注文内容';

  @override
  String get myPageResaleFundNameLabel => 'ファンド名';

  @override
  String get myPageResaleInvestorTypeLabel => '出資者種別';

  @override
  String get myPageResaleOrderMethodLabel => '注文方法';

  @override
  String get myPageResaleOrderMethodValue => '売却注文';

  @override
  String get myPageResaleAvailableUnitsLabel => '売却可能口数';

  @override
  String get myPageResaleSellUnitsLabel => '売却口数';

  @override
  String get myPageResaleUnitPriceLabel => '売却単価';

  @override
  String get myPageResaleFeeLabel => '売却手数料';

  @override
  String get myPageResaleFeeValue => '取引金額の1.65%';

  @override
  String get myPageResaleAgreementLabel => '書面確認';

  @override
  String get myPageResaleAgreementBody => '以下の書面に同意し、内容を承諾したので、通常注文を申込みます。';

  @override
  String get myPageResaleAgreementSampleLabel => '契約上の地位の譲渡契約書（サンプル）';

  @override
  String get myPageResaleTotalAmountLabel => '売却総額';

  @override
  String get myPageResaleFeeAmountLabel => '手数料';

  @override
  String get myPageResaleNetAmountLabel => '受取予定額';

  @override
  String get myPageResaleValidationMessage => '売却口数・売却単価を入力し、書面確認に同意してください。';

  @override
  String get myPageResaleConfirmButton => '確認';

  @override
  String get myPageResaleBackButton => '修正する';

  @override
  String get myPageResaleSubmitButton => '申込する';

  @override
  String get myPageResaleUnitsSuffix => '口';

  @override
  String get myPageResaleYenSuffix => '円';

  @override
  String get myPageResaleFlowOrderTitle => '売却内容を入力';

  @override
  String get myPageResaleFlowOrderSubtitle => '口数と売却単価、書面確認を済ませて次の確認ステップへ進みます。';

  @override
  String get myPageResaleFlowConfirmTitle => '売却内容を最終確認';

  @override
  String get myPageResaleFlowConfirmSubtitle => '内容に問題がなければ、このまま売却注文を送信してください。';

  @override
  String get myPageResaleQuantityHint => '売却したい口数と売却単価を入力してください。';

  @override
  String get myPageResaleQuickMax => 'MAX';

  @override
  String get myPageResaleLiveEstimateFormulaLabel => '現在の注文内容';

  @override
  String get myPageResaleAgreementSectionTitle => '書面と確認事項';

  @override
  String get myPageResaleReviewSectionTitle => 'ご注文内容';

  @override
  String get myPageResaleReviewHint =>
      '出品条件と受取予定額をご確認のうえ、問題がなければこのまま注文を確定してください。';

  @override
  String get myPageResaleSummarySectionTitle => '受取予定';

  @override
  String get myPageResaleFinalNoticeTitle => '最終確認後に売却注文を送信します';

  @override
  String get myPageResaleFinalNoticeBody =>
      '送信後は注文内容に基づいて出品処理が進みます。口数、単価、受取予定額をもう一度ご確認ください。';

  @override
  String myPageResaleFixedYieldLabel(Object ratio) {
    return '固定$ratio収益率';
  }

  @override
  String myPageResaleInvestorTypeFallback(Object ratio) {
    return '固定$ratio収益率';
  }

  @override
  String get myPageResaleHintTitle => 'ヒント';

  @override
  String myPageResaleFinalConfirmMessage(Object price, Object units) {
    return '単価$price円でこのプロジェクトの持分$units口を売却することを確認しますか？';
  }

  @override
  String get myPageResaleSubmitSuccess => '売却申込を送信しました。';

  @override
  String get myPageResaleSubmitFailure => '売却申込の送信に失敗しました。しばらくしてから再度お試しください。';

  @override
  String get secondaryMarketListLoadError => 'フリーマーケット一覧の読み込みに失敗しました。';

  @override
  String get secondaryMarketDetailLoadError => 'フリーマーケット詳細の読み込みに失敗しました。';

  @override
  String get secondaryMarketDetailUnavailable => '対象の出品情報が見つかりませんでした。';

  @override
  String get secondaryMarketDetailSoldOutMessage => 'この出品はすでに売り切れています。';

  @override
  String get secondaryMarketBuyAction => '購入';

  @override
  String get secondaryMarketOrderTimeLabel => '注文時間';

  @override
  String get secondaryMarketInvestorTypeLabel => '出資者種別';

  @override
  String get secondaryMarketSellUnitsLabel => '販売口数';

  @override
  String get secondaryMarketSoldUnitsLabel => '約定口数';

  @override
  String get secondaryMarketRemainingUnitsLabel => '残口数';

  @override
  String get secondaryMarketCompletionRateLabel => '成約率';

  @override
  String get secondaryMarketPricePerUnitCaption => '1口あたり';

  @override
  String get secondaryMarketOverviewTitle => '取引概要';

  @override
  String get secondaryMarketUpdateTimeLabel => '更新時間';

  @override
  String get secondaryMarketOrderIdLabel => '注文ID';

  @override
  String get secondaryMarketActivityTitle => 'マーケット動向';

  @override
  String get secondaryMarketApplicationsCountLabel => '申込件数';

  @override
  String get secondaryMarketDealsCountLabel => '成立件数';

  @override
  String get secondaryMarketLatestApplicationLabel => '最新申込';

  @override
  String get secondaryMarketLatestDealLabel => '最新成立';

  @override
  String get secondaryMarketDocumentsTitle => '関連書面';

  @override
  String get secondaryMarketDocumentPending => '資料準備中';

  @override
  String get secondaryMarketDocumentOpenAction => '閲覧する';

  @override
  String get secondaryMarketBuyOrderTitle => '購入注文';

  @override
  String get secondaryMarketTradeTabBuy => '購入';

  @override
  String get secondaryMarketTradeTabConfirm => '確認';

  @override
  String get secondaryMarketBuyOrderMethodLabel => '注文方法';

  @override
  String get secondaryMarketBuyOrderMethodValue => '購入注文';

  @override
  String get secondaryMarketBuyAvailableUnitsLabel => '購入可能口数';

  @override
  String get secondaryMarketBuyUnitsLabel => '購入口数';

  @override
  String get secondaryMarketBuyUnitPriceLabel => '購入単価';

  @override
  String get secondaryMarketBuyFeeLabel => '購入手数料';

  @override
  String get secondaryMarketBuyFeeValue => '取引金額の1.65%';

  @override
  String get secondaryMarketBuyAgreementLabel => '書面確認';

  @override
  String get secondaryMarketBuyAgreementBody =>
      '以下の書面に同意し、内容を承諾したうえで購入申込を行います。';

  @override
  String get secondaryMarketBuyAgreementSampleLabel => '関連書面を確認する';

  @override
  String get secondaryMarketBuyConfirmButton => '確認へ';

  @override
  String get secondaryMarketBuyBackButton => '戻る';

  @override
  String get secondaryMarketBuySubmitButton => '購入申込';

  @override
  String get secondaryMarketBuyValidationMessage => '購入口数を入力し、書面確認に同意してください。';

  @override
  String get secondaryMarketBuyFlowInputTitle => '購入内容を入力';

  @override
  String get secondaryMarketBuyFlowInputSubtitle =>
      '数量と書面確認を済ませて、次の確認ステップへ進みます。';

  @override
  String get secondaryMarketBuyFlowConfirmTitle => '購入内容を最終確認';

  @override
  String get secondaryMarketBuyFlowConfirmSubtitle =>
      '内容に問題がなければ、このまま購入申込を送信してください。';

  @override
  String get secondaryMarketBuyQuantityHint => '購入したい口数を選択してください。';

  @override
  String get secondaryMarketBuyQuickMax => 'MAX';

  @override
  String get secondaryMarketBuyLiveEstimateTitle => '金額シミュレーション';

  @override
  String get secondaryMarketBuyLiveEstimateFormulaLabel => '現在の注文内容';

  @override
  String get secondaryMarketBuySummarySectionTitle => 'お支払い予定';

  @override
  String get secondaryMarketBuyAgreementSectionTitle => '書面と確認事項';

  @override
  String get secondaryMarketBuyStickyAmountLabel => '予定支払額';

  @override
  String get secondaryMarketBuyReviewSectionTitle => 'ご注文内容';

  @override
  String get secondaryMarketBuyReviewHint =>
      '内容をご確認のうえ、問題がなければこのまま申込を確定してください。';

  @override
  String get secondaryMarketBuyFinalNoticeTitle => '最終確認後に購入申込を送信します';

  @override
  String get secondaryMarketBuyFinalNoticeBody =>
      '送信後は申込内容に基づいて購入処理が進みます。数量と支払予定額をもう一度ご確認ください。';

  @override
  String get secondaryMarketBuyTotalAmountLabel => '購入総額';

  @override
  String get secondaryMarketBuyFeeAmountLabel => '手数料';

  @override
  String get secondaryMarketBuyPaymentAmountLabel => 'お支払い金額';

  @override
  String get secondaryMarketBuyFinalConfirmTitle => 'ヒント';

  @override
  String secondaryMarketBuyFinalConfirmMessage(Object price, Object units) {
    return '単価$price円でこのプロジェクトの持分$units口を購入することを確認しますか？';
  }

  @override
  String get secondaryMarketBuySubmitSuccess => '購入申込を送信しました。';

  @override
  String get secondaryMarketBuySubmitFailure =>
      '購入申込の送信に失敗しました。しばらくしてから再度お試しください。';

  @override
  String get commonNext => '次へ';

  @override
  String get commonSkipChevron => 'スキップ ›';

  @override
  String get commonOther => 'その他';

  @override
  String get memberProfileFlowTitle => '本人情報の入力';

  @override
  String get memberProfileStep1Title => 'Step 1：基本情報';

  @override
  String get memberProfileStep1Description => '姓・名、フリガナ、ローマ字氏名、連絡先を入力してください';

  @override
  String get memberProfileNameKanjiLabel => '氏名（漢字）';

  @override
  String get memberProfileNameKanjiHint => '田中 太郎';

  @override
  String get memberProfileNameKanaLabel => 'フリガナ';

  @override
  String get memberProfileNameKanaHint => 'タナカ タロウ';

  @override
  String get memberProfileFamilyNameLabel => '姓（漢字）';

  @override
  String get memberProfileFamilyNameHint => '田中';

  @override
  String get memberProfileGivenNameLabel => '名（漢字）';

  @override
  String get memberProfileGivenNameHint => '太郎';

  @override
  String get memberProfileFamilyNameKanaLabel => '姓（カナ）';

  @override
  String get memberProfileFamilyNameKanaHint => 'タナカ';

  @override
  String get memberProfileGivenNameKanaLabel => '名（カナ）';

  @override
  String get memberProfileGivenNameKanaHint => 'タロウ';

  @override
  String get memberProfileFamilyNameRomanLabel => '姓（ローマ字）';

  @override
  String get memberProfileFamilyNameRomanHint => 'TANAKA';

  @override
  String get memberProfileGivenNameRomanLabel => '名（ローマ字）';

  @override
  String get memberProfileGivenNameRomanHint => 'TARO';

  @override
  String get memberProfileBirthdayLabel => '生年月日';

  @override
  String get memberProfileBirthdayHint => '生年月日を選択';

  @override
  String get memberProfileUnderageTitle => '本サービスは18歳以上の方のみご利用いただけます。';

  @override
  String get memberProfileUnderageBody => '不動産特定共同事業法に基づき、未成年者の投資申込はお受けできません。';

  @override
  String get memberProfilePhoneLabel => '電話番号';

  @override
  String get memberProfilePhoneHint => '090-1234-5678';

  @override
  String get memberProfileStep2Title => 'Step 2：住所情報';

  @override
  String get memberProfileStep2Description => '本人確認に必要です';

  @override
  String get memberProfilePostalCodeLabel => '郵便番号';

  @override
  String get memberProfilePostalCodeHint => '100-0001';

  @override
  String get memberProfileAddressSearch => '住所検索';

  @override
  String get memberProfileAddressSearchPending => '住所検索は次の実装で接続します。';

  @override
  String get memberProfileAddressSearchZipError => '郵便番号は7桁で入力してください。';

  @override
  String get memberProfileAddressSearchEmpty => '該当する住所が見つかりませんでした。';

  @override
  String get memberProfileAddressSearchSelectTitle => '候補から住所を選択';

  @override
  String get memberProfilePrefectureLabel => '都道府県';

  @override
  String get memberProfileCityAddressLabel => '市区町村・番地';

  @override
  String get memberProfileCityAddressHint => '千代田区丸の内1-1-1';

  @override
  String get memberProfileStep3Title => 'Step 3：投資者適合性確認';

  @override
  String get memberProfileStep3Description =>
      '不動産特定共同事業法第25条に基づき、お客様の投資経験等を確認いたします。';

  @override
  String get memberProfileOccupationLabel => 'ご職業';

  @override
  String get memberProfileAnnualIncomeLabel => '年収';

  @override
  String get memberProfileFinancialAssetsLabel => '金融資産';

  @override
  String get memberProfileInvestmentExperienceLabel => '投資経験（複数選択可）';

  @override
  String get memberProfileInvestmentPurposeLabel => '投資目的';

  @override
  String get memberProfileFundSourceLabel => '投資資金の性質';

  @override
  String get memberProfileFundSourceWarningTitle => 'ご注意ください';

  @override
  String get memberProfileFundSourceWarningStandard =>
      '本商品は元本保証ではなく、出資金の全額を失う可能性があります。余裕資金の範囲内でのご投資をお願いいたします。';

  @override
  String get memberProfileFundSourceWarningHighRisk =>
      '本商品は元本保証ではなく、出資金の全額を失う可能性があります。生活資金や借入金での投資は推奨しておりません。余裕資金の範囲内でのご投資をお願いいたします。';

  @override
  String get memberProfileRiskToleranceLabel => 'リスク許容度';

  @override
  String get memberProfileStep4Title => 'Step 4：本人確認（eKYC）';

  @override
  String get memberProfileStep4Description => '本人確認書類を撮影してください';

  @override
  String get memberProfileDocumentTypeLabel => '書類を選択';

  @override
  String get memberProfilePhotoDocumentTitle => '書類を撮影（表・裏）';

  @override
  String get memberProfilePhotoDocumentDescription => 'タップしてカメラを起動';

  @override
  String get memberProfilePhotoDocumentFrontTitle => '書類を撮影（表面）';

  @override
  String get memberProfilePhotoDocumentFrontDescription => 'タップして表面をアップロード';

  @override
  String get memberProfilePhotoDocumentBackTitle => '書類を撮影（裏面）';

  @override
  String get memberProfilePhotoDocumentBackDescription => 'タップして裏面をアップロード';

  @override
  String get memberProfileSelfieTitle => '自撮り写真を撮影';

  @override
  String get memberProfileSelfieDescription => '正面を向いて撮影';

  @override
  String get memberProfileUploadDocumentPending => '書類撮影機能は次の実装で接続します。';

  @override
  String get memberProfileUploadSelfiePending => 'セルフィー撮影機能は次の実装で接続します。';

  @override
  String get memberProfileStep5RealPersonTitle => 'Step 5：実人確認（顔認証）';

  @override
  String get memberProfileStep5RealPersonDescription =>
      '自撮り写真をアップロードし、顔のライブ認証を行ってください';

  @override
  String get memberProfileStep5RealPersonSelfieRequired =>
      '先に自撮り写真のアップロードを完了してください。';

  @override
  String get memberProfileStep5Title => 'Step 6：銀行口座登録';

  @override
  String get memberProfileStep5Description => '分配金の振込先を登録してください';

  @override
  String get memberProfileBankNameLabel => '金融機関名';

  @override
  String get memberProfileBankNameHint => '三菱UFJ銀行';

  @override
  String get memberProfileBranchLabel => '支店名';

  @override
  String get memberProfileBranchHint => '丸の内支店';

  @override
  String get memberProfileAccountTypeLabel => '口座種類';

  @override
  String get memberProfileAccountNumberLabel => '口座番号';

  @override
  String get memberProfileAccountNumberHint => '1234567';

  @override
  String get memberProfileAccountHolderLabel => '口座名義（カタカナ）';

  @override
  String get memberProfileAccountHolderHint => 'タナカ タロウ';

  @override
  String get memberProfileNextConsent => '次へ：同意事項の確認';

  @override
  String get memberProfileStep6Title => 'Step 7：同意事項の確認';

  @override
  String get memberProfileStep6Description => '以下の事項をご確認いただき、すべてに同意してください。';

  @override
  String get memberProfileElectronicDeliveryTitle => '書面の電子交付について';

  @override
  String get memberProfileElectronicDeliveryBody =>
      '当社は、不動産特定共同事業法に基づく以下の書面を、紙面ではなく電子的方法（PDFファイルによるアプリ内交付）により交付いたします。';

  @override
  String get memberProfileElectronicDeliveryItem1 => '契約締結前交付書面';

  @override
  String get memberProfileElectronicDeliveryItem2 => '契約締結時交付書面';

  @override
  String get memberProfileElectronicDeliveryItem3 => '財産の管理に関する報告書';

  @override
  String get memberProfileElectronicDeliveryItem4 => '業務及び財産の状況に関する書類';

  @override
  String get memberProfileElectronicDeliveryFootnote =>
      '※ 電子交付の同意は、設定画面からいつでも撤回できます。撤回後は紙面にて書面を郵送いたします。';

  @override
  String get memberProfileElectronicDeliveryConsent => '上記の電子交付方法に同意します';

  @override
  String get memberProfileAntiSocialTitle => '反社会的勢力でないことの確約';

  @override
  String get memberProfileAntiSocialBody =>
      '私は、現在および将来にわたり、暴力団、暴力団員、暴力団準構成員、暴力団関係企業、総会屋、社会運動等標ぼうゴロ、特殊知能暴力集団等の反社会的勢力に該当しないことを表明・確約いたします。';

  @override
  String get memberProfileAntiSocialConsent => '反社会的勢力に該当しないことを確約します';

  @override
  String get memberProfilePrivacyConsent => '個人情報の取扱い・プライバシーポリシーに同意します';

  @override
  String get memberProfileAgreeAndComplete => 'すべてに同意して登録を完了する';

  @override
  String get memberProfileCompletedToast => '本人情報の登録が完了しました。';

  @override
  String get memberProfileSavingProgressMessage => 'アップロード保存中...';

  @override
  String get memberProfilePhotoUploadSuccess => '画像をアップロードしました。';

  @override
  String get memberProfileSelfieUploadBypassedNotice =>
      'テスト環境では自撮り画像のアップロードが未対応のため、このまま次へ進めます。';

  @override
  String get occupationEmployee => '会社員';

  @override
  String get occupationSelfEmployed => '自営業';

  @override
  String get occupationPublicServant => '公務員';

  @override
  String get occupationHomemaker => '主婦/主夫';

  @override
  String get occupationStudent => '学生';

  @override
  String get occupationPensioner => '年金受給者';

  @override
  String get incomeUnder3m => '300万円未満';

  @override
  String get income3to5m => '300〜500万円';

  @override
  String get income5to10m => '500〜1000万円';

  @override
  String get incomeOver10m => '1000万円以上';

  @override
  String get assetsUnder1m => '100万円未満';

  @override
  String get assets1to5m => '100〜500万円';

  @override
  String get assets5to10m => '500〜1000万円';

  @override
  String get assetsOver10m => '1000万円以上';

  @override
  String get purposeAssetGrowth => '資産形成（長期的な資産の増加）';

  @override
  String get purposeDividendIncome => '分配金による定期収入';

  @override
  String get purposeIdleFunds => '余裕資金の運用';

  @override
  String get purposeDiversification => 'ポートフォリオの分散';

  @override
  String get fundSourceSurplus => '余裕資金（生活に影響のない資金）';

  @override
  String get fundSourceLivingFunds => '生活資金の一部';

  @override
  String get fundSourceBorrowed => '借入金';

  @override
  String get riskToleranceAcceptLoss => '元本毀損リスクを理解し許容できる';

  @override
  String get riskToleranceLowRisk => '低リスクの投資のみ希望';

  @override
  String get riskToleranceHighRisk => '高リスク・高リターンも許容できる';

  @override
  String get documentTypeDriversLicense => '運転免許証';

  @override
  String get documentTypeMyNumber => 'マイナンバーカード';

  @override
  String get documentTypeResidenceCard => '在留カード';

  @override
  String get documentTypePassport => 'パスポート';

  @override
  String get documentTypeOther => 'その他（個人証明書）';

  @override
  String get accountTypeOrdinary => '普通';

  @override
  String get accountTypeChecking => '当座';

  @override
  String get prefectureTokyo => '東京都';

  @override
  String get prefectureOsaka => '大阪府';

  @override
  String get prefectureKanagawa => '神奈川県';

  @override
  String get prefectureAichi => '愛知県';

  @override
  String get prefectureFukuoka => '福岡県';

  @override
  String get memberProfileExperienceStocks => '株式・ETF';

  @override
  String get memberProfileExperienceMutualFunds => '投資信託';

  @override
  String get memberProfileExperienceRealEstate => '不動産投資';

  @override
  String get memberProfileExperienceRealEstateCrowdfunding => '不動産クラファン/FTK';

  @override
  String get memberProfileExperienceBonds => '債券';

  @override
  String get memberProfileExperienceFxCrypto => 'FX・暗号資産';

  @override
  String get memberProfileExperienceNone => '投資経験なし';

  @override
  String get identityAuthPageTitle => '本人確認';

  @override
  String get identityAuthPageDescription =>
      'セキュリティが必要な操作のために、顔認証で本人確認を完了してください。';

  @override
  String get identityAuthStartAction => '認証を開始';

  @override
  String get identityAuthAlreadyVerified => '本人確認はすでに完了しています。';

  @override
  String get identityAuthVerifySuccess => '本人確認が完了しました。';

  @override
  String get identityAuthVerifyFailed => '本人確認に失敗しました。再度お試しください。';

  @override
  String get identityAuthCollectFailed => '顔の撮影に失敗しました。再度お試しください。';

  @override
  String get identityAuthLivenessNotConfigured => '顔認証機能の設定が未完了です。';

  @override
  String get identityAuthBiometricNotConfigured => '生体認証機能の設定が未完了です。';

  @override
  String get identityAuthSensitiveBlocked => 'この重要な操作を続行できません。';

  @override
  String get identityAuthBaiduLicenseMissing => 'Baidu顔認証ライセンスが設定されていません。';
}
