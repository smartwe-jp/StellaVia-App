import 'dart:io';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';
import 'member_profile_region_dto.dart';

typedef MemberProfileDioForPath = Dio Function(String path);

class MemberProfileApiPaths {
  const MemberProfileApiPaths._();

  static const String saveMemberInfo = '/crowdfunding/user/save-member-info';
  static const String uploadPhoto = '/crowdfunding/user/upload/photo';
  static const String regionByZip = '/crowdfunding/user/region/zip';
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

  Future<List<MemberProfileRegionDto>> fetchRegionsByZip({
    required String zip,
  }) async {
    final response = await _dioForPath(regionByZipPath)
        .get<Map<String, dynamic>>(
          regionByZipPath,
          queryParameters: <String, dynamic>{'zip': zip},
          options: authRequired(true),
        );

    final rows = _extractRegionRows(
      _envelopeCodec.toJsonMap(response.data),
      fallbackMessage: 'Failed to lookup address by postal code.',
    );

    return rows
        .map((Map<String, dynamic> row) => MemberProfileRegionDto.fromJson(row))
        .toList(growable: false);
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

  List<Map<String, dynamic>> _extractRegionRows(
    Map<String, dynamic> payload, {
    required String fallbackMessage,
  }) {
    final dataRows = _envelopeCodec.extractDataList(
      payload,
      fallbackMessage: fallbackMessage,
    );
    if (dataRows.isNotEmpty) {
      return dataRows;
    }
    return _envelopeCodec.toJsonMapList(payload['rows']);
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
