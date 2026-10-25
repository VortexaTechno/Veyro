
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../models/Inboxroom.dart';
import '../../models/MessageModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

int Index = 2;

class Chatapi extends MomentRepository {
  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization': Token,
        'awqeASERQW': '8/325*mAIOEN',
        'userid': UserId.toString(),
        'UserIP': UserIP,
      },
    ),
  );

  final List<InboxRoomModel> InboxRooms = [];

  Message messages = Message();

  // =====================================================
  // LOGGING HELPERS
  // =====================================================

  void _logRequest(
      String method,
      String endpoint, {
        dynamic data,
      }) {
    debugPrint('\n');
    debugPrint('╔══════════════════════════════════════════════');
    debugPrint('🚀 API REQUEST');
    debugPrint('➡️ METHOD: $method');
    debugPrint('➡️ BASE URL: ${dio.options.baseUrl}');
    debugPrint('➡️ ENDPOINT: $endpoint');
    debugPrint('➡️ USER ID: $UserId');

    if (data != null) {
      debugPrint('📤 REQUEST DATA: ${_describeData(data)}');
    }

    // Authorization token is intentionally not printed.
    debugPrint('╚══════════════════════════════════════════════');
  }

  String _describeData(dynamic data) {
    if (data is FormData) {
      return '''
Fields: ${data.fields}
Files: ${data.files.map((entry) {
        final file = entry.value;
        return {
          'field': entry.key,
          'filename': file.filename,
          'contentType': file.contentType?.toString(),
        };
      }).toList()}
''';
    }

    return data.toString();
  }

  void _logResponse(Response response) {
    debugPrint('\n');
    debugPrint('╔══════════════════════════════════════════════');
    debugPrint('✅ API RESPONSE');
    debugPrint('➡️ URL: ${response.realUri}');
    debugPrint('➡️ STATUS CODE: ${response.statusCode}');
    debugPrint('➡️ STATUS MESSAGE: ${response.statusMessage}');
    debugPrint('📥 RESPONSE BODY:');
    debugPrint('${response.data}', wrapWidth: 1024);
    debugPrint('╚══════════════════════════════════════════════');
    debugPrint('\n');
  }

  void _logDioError(DioException error) {
    debugPrint('\n');
    debugPrint('╔══════════════════════════════════════════════');
    debugPrint('❌ DIO API ERROR');
    debugPrint('➡️ URL: ${error.requestOptions.uri}');
    debugPrint('➡️ METHOD: ${error.requestOptions.method}');
    debugPrint('➡️ ERROR TYPE: ${error.type}');
    debugPrint('➡️ MESSAGE: ${error.message}');
    debugPrint('➡️ STATUS CODE: ${error.response?.statusCode}');
    debugPrint('➡️ STATUS MESSAGE: ${error.response?.statusMessage}');
    debugPrint('📥 ERROR RESPONSE BODY:');
    debugPrint(
      '${error.response?.data ?? 'No response body'}',
      wrapWidth: 1024,
    );
    debugPrint('➡️ ORIGINAL ERROR: ${error.error}');
    debugPrint('╚══════════════════════════════════════════════');
    debugPrint('\n');
  }

  void _logUnknownError(String operation, Object error, StackTrace stack) {
    debugPrint('\n');
    debugPrint('╔══════════════════════════════════════════════');
    debugPrint('❌ UNEXPECTED ERROR: $operation');
    debugPrint('➡️ ERROR: $error');
    debugPrint('➡️ STACK TRACE: $stack');
    debugPrint('╚══════════════════════════════════════════════');
    debugPrint('\n');
  }

  // =====================================================
  // GET INBOX ROOMS
  // =====================================================

  Future<List<InboxRoomModel>> GetInboxRooms(context) async {
    final endpoint = '/api/GetMyInboxRoom/$UserId';

    InboxRooms.clear();

    _logRequest('GET', endpoint);

    try {
      final Response response = await dio.get(endpoint);

      _logResponse(response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          for (final element in data) {
            InboxRooms.add(InboxRoomModel.fromJson(element));
          }
        } else {
          debugPrint(
            '⚠️ GetInboxRooms expected a List but received: '
                '${data.runtimeType}',
          );
        }
      }
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('GetInboxRooms', error, stack);
    }

    debugPrint('📦 Parsed inbox rooms: ${InboxRooms.length}');
    return InboxRooms;
  }

  // =====================================================
  // SEND IMAGE CHAT
  // =====================================================

  Future<Message> SentImageChat({
    context,
    image,
    userid,
  }) async {
    const endpoint = 'api/sendImage';

    try {
      if (image == null || image.path == null) {
        debugPrint('❌ SentImageChat: image is null');
        return Message();
      }

      final String filename =
          image.path.split(Platform.pathSeparator).last;

      final FormData formData = FormData.fromMap({
        'message': await MultipartFile.fromFile(
          image.path,
          filename: filename,
        ),
        'user_id': userid.toString(),
        'sender_id': UserId.toString(),
      });

      _logRequest('POST', endpoint, data: formData);

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse(response);

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['Messages'] != null) {
          final result = Message.fromJson(body['Messages']);
          messages = result;
          return result;
        }

        debugPrint('⚠️ SentImageChat: response has no "Messages" key');
      }
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('SentImageChat', error, stack);
    }

    return Message();
  }

  // =====================================================
  // DELETE INBOX ROOM
  // =====================================================

  Future<bool> deleteInboxRooms({
    context,
    inboxid,
  }) async {
    final endpoint = '/api/deleteInboxRoom/$inboxid';

    _logRequest('GET', endpoint);

    try {
      final Response response = await dio.get(endpoint);

      _logResponse(response);

      return response.statusCode == 200;
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('deleteInboxRooms', error, stack);
    }

    return false;
  }

  // =====================================================
  // DELETE AND BLOCK USER
  // =====================================================

  Future<bool> deleteandBlockInboxRooms({
    context,
    inboxid,
  }) async {
    final endpoint =
        '/api/deleteInboxRoomandBlockUser/$inboxid/$UserId';

    _logRequest('GET', endpoint);

    try {
      final Response response = await dio.get(endpoint);

      _logResponse(response);

      return response.statusCode == 200;
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('deleteandBlockInboxRooms', error, stack);
    }

    return false;
  }

  // =====================================================
  // READ INBOX ROOM
  // =====================================================

  Future<bool> ReadInboxRoom({
    context,
    InboxRoom,
  }) async {
    const endpoint = 'api/ReadInboxRoom';

    final FormData formData = FormData.fromMap({
      'inboxroomid': InboxRoom.toString(),
    });

    _logRequest('POST', endpoint, data: formData);

    try {
      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse(response);

      return response.statusCode == 200;
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('ReadInboxRoom', error, stack);
    }

    return false;
  }

  // =====================================================
  // SEND TEXT MESSAGE
  // =====================================================

  Future<Message> SendMessage({
    context,
    message,
    Senderid,
    userid,
  }) async {
    const endpoint = 'api/sendmessage';

    final FormData formData = FormData.fromMap({
      'message': message.toString(),
      'user_id': userid.toString(),
      'sender_id': Senderid.toString(),
    });

    _logRequest('POST', endpoint, data: formData);

    try {
      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse(response);

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['Messages'] != null) {
          final result = Message.fromJson(body['Messages']);
          messages = result;
          return result;
        }

        debugPrint('⚠️ SendMessage: response has no "Messages" key');
      }
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('SendMessage', error, stack);
    }

    return Message();
  }

  // =====================================================
  // SEND GIFT MESSAGE
  // =====================================================

  Future<Message> SendGiftMessage({
    context,
    giftid,
    Senderid,
    userid,
  }) async {
    const endpoint = 'api/sendgiftmessage';

    final FormData formData = FormData.fromMap({
      'gift_id': giftid.toString(),
      'user_id': userid.toString(),
      'sender_id': Senderid.toString(),
    });

    _logRequest('POST', endpoint, data: formData);

    try {
      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse(response);

      if (response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body['Messages'] != null) {
          final result = Message.fromJson(body['Messages']);
          messages = result;
          return result;
        }

        debugPrint('⚠️ SendGiftMessage: response has no "Messages" key');
      }
    } on DioException catch (error) {
      _logDioError(error);
    } catch (error, stack) {
      _logUnknownError('SendGiftMessage', error, stack);
    }

    return Message();
  }
}
