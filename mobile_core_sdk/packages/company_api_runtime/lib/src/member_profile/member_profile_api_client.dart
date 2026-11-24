import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'member_profile_region_dto.dart';
import 'corporate_detail_dto.dart';

typedef MemberProfileDioForPath = Dio Function(String path);

class MemberProfileApiPaths {
  const MemberProfileApiPaths._();

  static const corporateUpload =
      '/crowdfunding/corporate-verification/upload/photo';
  static const corporateReview = '/crowdfunding/corporate-verification/review';
  static const corporateSubmit = '/crowdfunding/corporate-verification/submit';
  static const corporateDetail = '/crowdfunding/corporate-verification/detail';
  static const String saveMemberInfo = '/crowdfunding/user/save-member-info';
  static const String uploadPhoto = '/crowdfunding/user/upload/photo';
  // Third-party contract: see fundex/README_API.md (ZipCloud postal lookup).
  static const String regionByZip = 'https://zipcloud.ibsnet.co.jp/api/search';
  static const String uploadRealPersonPhoto = '/member/real/person/upload';
  static const String uploadAvatar = '/member/user/avatar-upload';
}

class MemberProfileApiClient {
  MemberProfileApiClient({
    required MemberProfileDioForPath dioForPath,
    LegacyEnvelopeCodec? envelopeCodec,
    this.saveMemberInfoPath = MemberProfileApiPaths.saveMemberInfo,
    this.uploadPhotoPath = MemberProfileApiPaths.uploadPhoto,
    this.regionByZipPath = MemberProfileApiPaths.regionByZip,
    this.uploadRealPersonPhotoPath =
        MemberProfileApiPaths.uploadRealPersonPhoto,
    this.uploadAvatarPath = MemberProfileApiPaths.uploadAvatar,
  }) : _dioForPath = dioForPath,
       _envelopeCodec =
           envelopeCodec ??
           const LegacyEnvelopeCodec(
             profile: LegacyEnvelopeProfile(successCodes: <String>{'0', '200'}),
           );

  final MemberProfileDioForPath _dioForPath;
  final LegacyEnvelopeCodec _envelopeCodec;

  final String saveMemberInfoPath;
  final String uploadPhotoPath;
  final String regionByZipPath;
  final String uploadRealPersonPhotoPath;
  final String uploadAvatarPath;

  Future<({String fileId, String url})> uploadCorporateDocument({
    required String filename,
    required List<int> bytes,
    required String mimeType,
  }) async {
    const path = MemberProfileApiPaths.corporateUpload;
    final response = await _dioForPath(path).post<dynamic>(
      path,
      data: FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: filename,
          contentType: DioMediaType.parse(mimeType),
        ),
      }),
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
    );
    final payload = _envelopeCodec.toJsonMap(response.data);
    _envelopeCodec.assertSuccessIfEnvelope(
      payload,
      fallbackMessage: 'Corporate document upload failed.',
    );
    final document = payload['data'] ?? payload;
    final data = _envelopeCodec.toJsonMap(document);
    final url = document is String ? document : data['url'];
    if (url is! String || url.trim().isEmpty) {
      throw const FormatException('Missing corporate document URL');
    }
    return (fileId: data['fileId']?.toString() ?? '', url: url.trim());
  }

  Future<void> submitCorporate(Map<String, dynamic> application) =>
      _postCorporate(MemberProfileApiPaths.corporateSubmit, application);

  Future<void> reviewCorporate({
    required int id,
    required String reviewOp,
    required String customerMessage,
  }) {
    final message = customerMessage.trim();
    if (id <= 0 ||
        !const {'CUSTOMER_MAILED', 'RECEIVED'}.contains(reviewOp) ||
        (reviewOp == 'CUSTOMER_MAILED' && message.isEmpty)) {
      throw ArgumentError('Invalid corporate member action');
    }
    return _postCorporate(MemberProfileApiPaths.corporateReview, {
      'id': id,
      'reviewOp': reviewOp,
      if (message.isNotEmpty) 'customerMessage': message,
    });
  }

  Future<void> _postCorporate(
    String path,
    Map<String, dynamic> application,
  ) async {
    final response = await _dioForPath(
      path,
    ).post<dynamic>(path, data: application, options: authRequired(true));
    const codec = LegacyEnvelopeCodec();
    final payload = codec.toJsonMap(response.data);
    if (payload['code'] == null) {
      throw const FormatException('Missing submission result');
    }
    if (!codec.isSuccessCode(payload['code'])) {
      throw StateError(
        codec.resolveErrorMessage(
          payload,
          fallbackMessage: 'Corporate application rejected.',
        ),
      );
    }
  }

  Future<Uint8List> fetchCorporateAttachment(String reference) async {
    final client = _dioForPath(MemberProfileApiPaths.corporateDetail);
    final base = Uri.parse(client.options.baseUrl);
    final uri = base.resolve(reference);
    if (reference.trim().isEmpty ||
        !(uri.isScheme('https') || uri.isScheme('http')) ||
        uri.host.isEmpty)
      throw const FormatException('Invalid attachment URL');
    final response = await client.getUri<List<int>>(
      uri,
      options: authRequired(
        uri.origin == base.origin,
      ).copyWith(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty)
      throw const FormatException('Empty attachment');
    return bytes is Uint8List ? bytes : Uint8List.fromList(bytes);
  }

  Future<CorporateDetailDto> fetchCorporateDetail() async {
    const path = MemberProfileApiPaths.corporateDetail;
    final response = await _dioForPath(
      path,
    ).get<Map<String, dynamic>>(path, options: authRequired(true));
    const codec = LegacyEnvelopeCodec();
    final payload = codec.toJsonMap(response.data);
    if (!codec.isSuccessCode(payload['code'])) {
      throw StateError(
        codec.resolveErrorMessage(
          payload,
          fallbackMessage: 'Unable to load corporate verification.',
        ),
      );
    }
    if (!payload.containsKey('data')) {
      throw const FormatException('Missing corporate detail');
    }
    final data = payload['data'];
    if (data != null && data is! Map) {
      throw const FormatException('Invalid corporate detail');
    }
    return CorporateDetailDto.fromJson(codec.toJsonMap(data));
  }

  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    final response = await _dioForPath(regionByZipPath).get<dynamic>(
      regionByZipPath,
      queryParameters: <String, dynamic>{'zipcode': zip},
      // ZipCloud returns JSON with a text/plain content type.
      options: authRequired(false),
    );

    return _mapZipCloudRegions(_decodeZipCloudPayload(response.data));
  }

  Future<String> uploadDocumentPhoto({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadPhotoPath,
      filePath: normalizedPath,
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    return _envelopeCodec.extractDataString(
      payload,
      fallbackMessage: 'Failed to upload profile photo.',
      fallbackKeys: const <String>['url'],
    );
  }

  Future<void> uploadSelfiePhoto({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadRealPersonPhotoPath,
      filePath: normalizedPath,
    );
    final payload = _envelopeCodec.toJsonMap(response.data);
    _assertSelfieUploadSucceeded(
      responseData: response.data,
      payload: payload,
      fallbackMessage: 'Failed to upload profile photo.',
    );
  }

  Future<String> uploadAvatar({required String filePath}) async {
    final normalizedPath = _normalizeAndValidatePath(filePath);
    final response = await _uploadMultipart(
      path: uploadAvatarPath,
      filePath: normalizedPath,
    );

    final payload = _envelopeCodec.toJsonMap(response.data);
    return _envelopeCodec.extractDataString(
      payload,
      fallbackMessage: 'Failed to upload avatar.',
      fallbackKeys: const <String>['url'],
    );
  }

  Future<void> saveMemberInfo({required Map<String, dynamic> payload}) async {
    final response = await _dioForPath(saveMemberInfoPath)
        .post<Map<String, dynamic>>(
          saveMemberInfoPath,
          data: payload,
          options: authRequired(true),
        );

    _envelopeCodec.assertSuccessIfEnvelope(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to save member profile.',
      requireTruthyData: true,
    );
  }

  Future<Response<dynamic>> _uploadMultipart({
    required String path,
    required String filePath,
  }) async {
    return _dioForPath(path).post<dynamic>(
      path,
      data: FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(filePath),
      }),
      options: authRequired(
        true,
      ).copyWith(contentType: Headers.multipartFormDataContentType),
    );
  }

  String _normalizeAndValidatePath(String filePath) {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      throw StateError('Failed to upload profile photo.');
    }

    final file = File(normalizedPath);
    if (!file.existsSync()) {
      throw StateError('Failed to upload profile photo.');
    }
    return normalizedPath;
  }

  List<MemberProfileRegionDto> _mapZipCloudRegions(
    Map<String, dynamic> payload,
  ) {
    const fallbackMessage = 'Failed to lookup address by postal code.';
    final status = int.tryParse(payload['status']?.toString() ?? '');
    if (status != HttpStatus.ok) {
      final message = payload['message']?.toString().trim() ?? '';
      throw StateError(message.isEmpty ? fallbackMessage : message);
    }

    final results = _envelopeCodec.toJsonMapList(payload['results']);
    if (results.isEmpty) {
      return const <MemberProfileRegionDto>[];
    }

    final result = results.first;
    final prefecture = result['address1']?.toString().trim() ?? '';
    final city = result['address2']?.toString().trim() ?? '';
    final town = result['address3']?.toString().trim() ?? '';
    final cityAddress = '$city$town';

    return <MemberProfileRegionDto>[
      if (prefecture.isNotEmpty)
        MemberProfileRegionDto(
          jpName: prefecture,
          parentId: null,
          regionId: null,
          regionType: 0,
          roomName: '',
        ),
      if (cityAddress.isNotEmpty)
        MemberProfileRegionDto(
          jpName: cityAddress,
          parentId: null,
          regionId: null,
          regionType: 1,
          roomName: '',
        ),
    ];
  }

  Map<String, dynamic> _decodeZipCloudPayload(dynamic data) {
    if (data is String) {
      try {
        return _envelopeCodec.toJsonMap(jsonDecode(data));
      } on FormatException {
        throw StateError('Failed to lookup address by postal code.');
      }
    }
    return _envelopeCodec.toJsonMap(data);
  }

  void _assertSelfieUploadSucceeded({
    required dynamic responseData,
    required Map<String, dynamic> payload,
    required String fallbackMessage,
  }) {
    if (payload.isEmpty) {
      if (!_envelopeCodec.isTruthyData(responseData?.toString())) {
        throw StateError(fallbackMessage);
      }
      return;
    }

    if (_envelopeCodec.looksLikeEnvelope(payload)) {
      _envelopeCodec.assertSuccessIfEnvelope(
        payload,
        fallbackMessage: fallbackMessage,
        requireTruthyData: true,
      );
      return;
    }

    if (payload.containsKey('success') &&
        !_envelopeCodec.isTruthyData(payload['success'])) {
      throw StateError(fallbackMessage);
    }
    if (payload.containsKey('ok') &&
        !_envelopeCodec.isTruthyData(payload['ok'])) {
      throw StateError(fallbackMessage);
    }
  }
}
