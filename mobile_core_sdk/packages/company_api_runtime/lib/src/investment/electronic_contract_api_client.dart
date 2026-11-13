import 'dart:convert';
import 'dart:typed_data';

import 'package:core_network/core_network.dart';

import '../envelope/legacy_envelope_codec.dart';

typedef ContractProgressEntry = ({String actor, String content, String time});

typedef ElectronicContractDetail = ({
  bool canSign,
  Object type,
  String title,
  List<ContractProgressEntry> progress,
});

/// Member Swagger, ElectronicContract and Home Web Page groups.
class ElectronicContractApiClient {
  ElectronicContractApiClient(this._dio);
  final Dio _dio;
  static const _codec = LegacyEnvelopeCodec(
    profile: LegacyEnvelopeProfile(successCodes: {'0', '200'}),
  );

  Future<ElectronicContractDetail> detail(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/member/home/notice/details',
      queryParameters: {'id': id},
      options: authRequired(true),
    );
    final data = _codec.extractDataMap(
      _codec.toJsonMap(response.data),
      fallbackMessage: 'Contract unavailable',
    );
    final operations = data['opList'];
    return (
      title: (data['noticeTypeName'] ?? data['title'] ?? '').toString().trim(),
      progress:
          [
                for (final entry in _codec.toJsonMapList(data['commentList']))
                  (
                    actor:
                        (entry['userName'] ??
                                entry['user'] ??
                                entry['operator'] ??
                                '')
                            .toString()
                            .trim(),
                    content:
                        (entry['content'] ??
                                entry['comment'] ??
                                entry['desc'] ??
                                '')
                            .toString()
                            .trim(),
                    time: (entry['createTime'] ?? entry['time'] ?? '')
                        .toString()
                        .trim(),
                  ),
              ]
              .where(
                (entry) =>
                    entry.actor.isNotEmpty ||
                    entry.content.isNotEmpty ||
                    entry.time.isNotEmpty,
              )
              .toList(),
      canSign: operations is List && operations.contains('done'),
      type: (data['noticeType'] ?? data['contractTypeValue'] ?? '') as Object,
    );
  }

  Future<Uint8List> pdf(String id) async {
    final options = authRequired(true)..responseType = ResponseType.bytes;
    final response = await _dio.get<List<int>>(
      '/member/electronic/contract/view',
      queryParameters: {'bizId': id},
      options: options,
    );
    final bytes = response.data ?? [];
    if (ascii.decode(bytes.take(5).toList(), allowInvalid: true) == '%PDF-') {
      return Uint8List.fromList(bytes);
    }
    final payload = _codec.toJsonMap(jsonDecode(utf8.decode(bytes)));
    final data = _codec.extractDataMap(
      payload,
      fallbackMessage: 'Contract PDF unavailable',
    );
    final uri = Uri.tryParse(
      (data['url'] ?? data['fileUrl'] ?? payload['url'] ?? '').toString(),
    );
    return _fileFromUrl(uri);
  }

  /// A null result means the service accepted delivery to the member's email.
  Future<Uint8List?> download(String id, String email) async {
    final response = await _dio.post<List<int>>(
      '/member/electronic/contract/download',
      data: {'bizId': id, 'targetEmail': email},
      options: authRequired(true)..responseType = ResponseType.bytes,
    );
    final bytes = response.data ?? [];
    if (ascii.decode(bytes.take(5).toList(), allowInvalid: true) == '%PDF-') {
      return Uint8List.fromList(bytes);
    }
    final payload = _codec.toJsonMap(jsonDecode(utf8.decode(bytes)));
    if (payload.isEmpty)
      throw const FormatException('Missing download response');
    _codec.assertSuccessIfEnvelope(payload, fallbackMessage: 'Download failed');
    final data = _codec.toJsonMap(payload['data']);
    final url = data['url'] ?? data['fileUrl'] ?? payload['url'];
    if (url == null) {
      if (!_codec.isSuccessCode(payload['code']))
        throw const FormatException('Unknown download response');
      return null;
    }
    return _fileFromUrl(Uri.tryParse(url.toString()));
  }

  Future<Uint8List> _fileFromUrl(Uri? uri) async {
    if (uri == null || !uri.isScheme('https') || uri.host.isEmpty) {
      throw const FormatException('Missing contract PDF');
    }
    // Signed file URLs can belong to storage outside the member API.
    final storage = Dio();
    try {
      final file = await storage.getUri<List<int>>(
        uri,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(file.data!);
    } finally {
      storage.close();
    }
  }

  Future<void> sign(String id, Uint8List png) async {
    final permission = await detail(id);
    if (!permission.canSign) throw StateError('Signature no longer available');
    final upload = await _dio.post<Map<String, dynamic>>(
      '/member/electronic/contract/upload',
      data: FormData.fromMap({
        'bizId': id,
        'index': '1',
        'file': MultipartFile.fromBytes(
          png,
          filename: 'signature.png',
          contentType: DioMediaType('image', 'png'),
        ),
      }),
      options: authRequired(true),
    );
    _requireSuccess(upload);
    final confirm = await _dio.post<Map<String, dynamic>>(
      '/member/electronic/contract/confirm',
      data: {'bizId': id, 'contractTypeValue': permission.type},
      options: authRequired(true),
    );
    _requireSuccess(confirm);
  }

  void _requireSuccess(Response<Map<String, dynamic>> response) {
    final data = _codec.toJsonMap(response.data);
    if (!_codec.isSuccessCode(data['code']) ||
        !_codec.isSuccessEnvelope(data, requireTruthyData: true)) {
      _codec.throwFailure(data, fallbackMessage: 'Contract signature failed');
    }
  }
}
