
import 'dart:io';

import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/Repositores/Chat_repositores/Chat_api.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class InboxroomViewModel extends ChangeNotifier {
  List<InboxRoomModel> Inboxrooms = [];

  bool showloading = false;
  bool showloading2 = false;
  bool InboxLoading = false;
  bool ImageLoading = false;

  TextEditingController textEditingController =
  TextEditingController();

  int inroomid = 0;
  int defaultindex = 0;

  dynamic ChatuserImage;

  final ImagePicker _picker2 = ImagePicker();

  // ==================== LOGGING ====================

  void _logStart(String operation, [dynamic data]) {
    debugPrint('\n========== $operation START ==========');
    if (data != null) {
      debugPrint('📤 DATA: $data');
    }
  }

  void _logSuccess(String operation, [dynamic data]) {
    debugPrint('✅ $operation SUCCESS');
    if (data != null) {
      debugPrint('📥 RESULT: $data');
    }
    debugPrint('========== $operation END ==========\n');
  }

  void _logError(
      String operation,
      Object error,
      StackTrace stackTrace,
      ) {
    debugPrint('❌ $operation ERROR');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
    debugPrint('========== $operation END ==========\n');
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  int _findInboxIndex(dynamic id) {
    return Inboxrooms.indexWhere(
          (element) => element.id.toString() == id.toString(),
    );
  }

  void _addMessageToInbox({
    required dynamic id,
    required Message value,
  }) {
    final index = _findInboxIndex(id);

    if (index == -1) {
      debugPrint('⚠️ Inbox not found for ID: $id');
      return;
    }

    Inboxrooms[index].message?.add(value);
    Inboxrooms[index].updatedAt = value.createdAt;

    debugPrint('✅ Message added to inbox: $id');
  }

  // ==================== BLOCK USER ====================

  Future<void> BlockUser({
    dynamic id,
    dynamic UserId,
  }) async {
    const operation = 'BlockUser';
    _logStart(operation, {
      'inboxId': id,
      'userId': UserId,
    });

    ShowGlopalLoading();

    try {
      final result = await Momentapi().BlockUser(
        Userid: UserId,
      );

      if (result == true) {
        CheckBlocked = true;
        UserBlockedId = UserId.toString();

        Inboxrooms.removeWhere(
              (element) => element.id.toString() == id.toString(),
        );

        _logSuccess(operation, {
          'blockedUserId': UserBlockedId,
          'remainingInboxCount': Inboxrooms.length,
        });
      } else {
        CheckBlocked = false;
        debugPrint('⚠️ $operation returned false');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  // ==================== INDEX ====================

  void changdefaultindex({dynamic value}) {
    defaultindex = _toInt(value) ?? 0;
    debugPrint('📌 defaultindex changed: $defaultindex');
    notifyListeners();
  }

  // ==================== SPINNERS ====================

  void showSpinner() {
    showloading = true;
    notifyListeners();
  }

  void hideSpinner() {
    showloading = false;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners();
  }

  void hideSpinner2() {
    showloading2 = false;
    notifyListeners();
  }

  // ==================== PICK CHAT IMAGE ====================

  Future<bool> getChatRoomImage() async {
    const operation = 'getChatRoomImage';
    _logStart(operation);

    try {
      final pickedFile = await _picker2.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) {
        debugPrint('ℹ️ Image selection cancelled');
        return false;
      }

      final originalFile = File(pickedFile.path);

      // Wait for cropping to finish before returning.
      await Cropimage(originalFile);

      final selected = ChatuserImage != null;

      _logSuccess(operation, {
        'selected': selected,
        'path': selected ? ChatuserImage.path : null,
      });

      return selected;
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> Cropimage(dynamic value) async {
    const operation = 'Cropimage';
    _logStart(operation, {
      'path': value?.path,
    });

    try {
      if (value == null || value.path == null) {
        debugPrint('⚠️ No image provided for cropping');
        return;
      }

      final CroppedFile? croppedFile =
      await ImageCropper().cropImage(
        sourcePath: value.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        ChatuserImage = File(croppedFile.path);

        _logSuccess(operation, {
          'croppedPath': croppedFile.path,
        });
      } else {
        debugPrint('ℹ️ Cropping cancelled; keeping original image');
        ChatuserImage = File(value.path);
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // ==================== GET INBOX ROOMS ====================

  Future<void> GetInboxroom({dynamic context}) async {
    const operation = 'GetInboxroom';
    _logStart(operation, {
      'alreadyLoaded': InboxLoading,
    });

    if (!InboxLoading) {
      ShowGlopalLoading();
    }

    try {
      final value = await Chatapi().GetInboxRooms(context);

      Inboxrooms = value;
      InboxLoading = true;

      _logSuccess(operation, {
        'inboxCount': Inboxrooms.length,
        'inboxIds': Inboxrooms.map((e) => e.id).toList(),
      });
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  // ==================== DELETE INBOX ROOM ====================

  Future<void> DeleteInboxroom({
    dynamic context,
    dynamic inboxid,
  }) async {
    const operation = 'DeleteInboxroom';
    _logStart(operation, {
      'inboxId': inboxid,
    });

    ShowGlopalLoading();

    try {
      final result = await Chatapi().deleteInboxRooms(
        context: context,
        inboxid: inboxid.toString(),
      );

      if (result == true) {
        Inboxrooms.removeWhere(
              (element) =>
          element.id.toString() == inboxid.toString(),
        );

        _logSuccess(operation, {
          'inboxId': inboxid,
          'remainingInboxCount': Inboxrooms.length,
        });
      } else {
        debugPrint('⚠️ $operation returned false');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  // ==================== DELETE AND BLOCK ====================

  Future<void> DeleteAndBlockUserInboxroom({
    dynamic context,
    dynamic inboxid,
  }) async {
    const operation = 'DeleteAndBlockUserInboxroom';
    _logStart(operation, {
      'inboxId': inboxid,
    });

    ShowGlopalLoading();

    try {
      final result = await Chatapi().deleteandBlockInboxRooms(
        context: context,
        inboxid: inboxid.toString(),
      );

      if (result == true) {
        Inboxrooms.removeWhere(
              (element) =>
          element.id.toString() == inboxid.toString(),
        );

        _logSuccess(operation, {
          'inboxId': inboxid,
          'remainingInboxCount': Inboxrooms.length,
        });
      } else {
        debugPrint('⚠️ $operation returned false');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  // ==================== ADD INBOX ROOM ====================

  void AddnewInboxRoom({
    required InboxRoomModel value,
  }) {
    final exists = Inboxrooms.any(
          (element) => element.id.toString() == value.id.toString(),
    );

    if (exists) {
      debugPrint('⚠️ Inbox already exists: ${value.id}');
      return;
    }

    Inboxrooms.add(value);

    debugPrint('✅ New inbox added: ${value.id}');
    notifyListeners();
  }

  // ==================== ADD MESSAGE TO INBOX ====================

  void AddMessageInbox({
    required Message value,
    dynamic id,
    dynamic context,
  }) {
    const operation = 'AddMessageInbox';
    _logStart(operation, {
      'inboxId': id,
      'messageId': value.id,
      'message': value.message,
    });

    try {
      _addMessageToInbox(
        id: id,
        value: value,
      );

      final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      );

      if (value.inboxroomId == user.ChatRoom?.id) {
        user.addtochatRoom(value);
        debugPrint('✅ Message added to currently open chat');
      }

      _logSuccess(operation);
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  // ==================== RESET CURRENT ROOM ====================

  void ExistChatRoom() {
    inroomid = 0;
    debugPrint('📌 Current inbox reset');
    notifyListeners();
  }

  // ==================== READ INBOX ROOM ====================

  Future<void> ReadInboxRoom({
    dynamic id,
    dynamic context,
  }) async {
    const operation = 'ReadInboxRoom';
    _logStart(operation, {
      'inboxId': id,
    });

    final parsedId = _toInt(id);

    if (parsedId == null) {
      debugPrint('❌ Invalid inbox ID: $id');
      return;
    }

    final inboxIndex = _findInboxIndex(parsedId);

    if (inboxIndex == -1) {
      debugPrint('⚠️ Inbox not found locally: $parsedId');
    }

    inroomid = parsedId;
    showSpinner();

    try {
      final result = await Chatapi().ReadInboxRoom(
        InboxRoom: inroomid,
        context: context,
      );

      if (result == true) {
        _logSuccess(operation, {
          'inboxId': inroomid,
          'result': true,
        });
      } else {
        debugPrint('⚠️ $operation returned false');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      hideSpinner();
    }
  }

  // ==================== READ CURRENT ROOM AGAIN ====================

  Future<void> AlreadyinInboxRoom({
    dynamic context,
  }) async {
    const operation = 'AlreadyinInboxRoom';
    _logStart(operation, {
      'inboxId': inroomid,
    });

    if (inroomid == 0) {
      debugPrint('⚠️ No current inbox selected');
      return;
    }

    showSpinner();

    try {
      final result = await Chatapi().ReadInboxRoom(
        InboxRoom: inroomid,
        context: context,
      );

      if (result == true) {
        _logSuccess(operation, {
          'inboxId': inroomid,
        });
      } else {
        debugPrint('⚠️ $operation returned false');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      hideSpinner();
    }
  }

  // ==================== SEND IMAGE ====================

  Future<void> SentImageChat({
    dynamic context,
    usermodel? userinfo,
    dynamic id,
  }) async {
    const operation = 'SentImageChat';

    _logStart(operation, {
      'inboxId': id,
      'receiverId': userinfo?.id,
      'imagePath': ChatuserImage?.path,
    });

    if (ChatuserImage == null) {
      debugPrint('❌ Cannot send image: no image selected');
      return;
    }

    final LoginViewmodel user =
    Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    ImageLoading = true;
    notifyListeners();

    try {
      final value = await Chatapi().SentImageChat(
        image: ChatuserImage,
        context: context,
        userid: userinfo?.id,
      );

      _logSuccess(operation, {
        'messageId': value.id,
        'inboxRoomId': value.inboxroomId,
        'createdAt': value.createdAt,
      });

      _addMessageToInbox(
        id: id,
        value: value,
      );

      if (user.ChatRoom?.id == 0) {
        user.UpdateChatRoom(
          value: InboxRoomModel(
            numberUnread: 0,
            id: value.inboxroomId,
            message: [],
            lastMessage: value.message,
            createdAt: value.createdAt,
            updatedAt: value.updatedAt,
            senderId: UserId,
            sender: user.userinfo,
            userId: userinfo?.id.toString(),
            user: userinfo,
          ),
        );
      }

      if (value.inboxroomId == user.ChatRoom?.id) {
        user.addtochatRoom(value);
      }

      // Clear the selected image after a successful API call.
      ChatuserImage = null;
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      ImageLoading = false;
      notifyListeners();
    }
  }

  // ==================== SEND TEXT MESSAGE ====================

  Future<void> SendMessage({
    dynamic id,
    dynamic context,
    dynamic message,
    usermodel? userinfo,
  }) async {
    const operation = 'SendMessage';

    _logStart(operation, {
      'inboxId': id,
      'receiverId': userinfo?.id,
      'senderId': UserId,
      'message': message,
    });

    final LoginViewmodel user =
    Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    try {
      final value = await Chatapi().SendMessage(
        message: message,
        userid: userinfo?.id,
        Senderid: UserId,
        context: context,
      );

      if (value.id != null) {
        _logSuccess(operation, {
          'messageId': value.id,
          'inboxRoomId': value.inboxroomId,
          'createdAt': value.createdAt,
        });

        _addMessageToInbox(
          id: id,
          value: value,
        );

        if (user.ChatRoom?.id == 0) {
          user.UpdateChatRoom(
            value: InboxRoomModel(
              numberUnread: 0,
              id: value.inboxroomId,
              message: [],
              lastMessage: value.message,
              createdAt: value.createdAt,
              updatedAt: value.updatedAt,
              senderId: UserId,
              sender: user.userinfo,
              userId: userinfo?.id.toString(),
              user: userinfo,
            ),
          );
        }

        if (value.inboxroomId == user.ChatRoom?.id) {
          user.addtochatRoom(value);
        }

        textEditingController.clear();
      } else {
        debugPrint('❌ $operation failed: returned message ID is null');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  // ==================== SEND GIFT MESSAGE ====================

  Future<void> SendGiftMessage({
    dynamic id,
    dynamic context,
    dynamic gift,
    usermodel? userinfo,
  }) async {
    const operation = 'SendGiftMessage';

    _logStart(operation, {
      'inboxId': id,
      'receiverId': userinfo?.id,
      'giftId': gift?['id'],
      'giftPrice': gift?['price'],
    });

    ShowGlopalLoading();

    final LoginViewmodel user =
    Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    try {
      final value = await Chatapi().SendGiftMessage(
        giftid: gift['id'],
        userid: userinfo?.id,
        Senderid: UserId,
        context: context,
      );

      if (value.id != null) {
        _logSuccess(operation, {
          'messageId': value.id,
          'inboxRoomId': value.inboxroomId,
        });

        user.RemoveCoins(cost: gift['price']);

        _addMessageToInbox(
          id: id,
          value: value,
        );

        if (user.ChatRoom?.id == 0) {
          user.UpdateChatRoom(
            value: InboxRoomModel(
              numberUnread: 0,
              id: value.inboxroomId,
              message: [],
              lastMessage: value.message,
              createdAt: value.createdAt,
              updatedAt: value.updatedAt,
              senderId: UserId,
              sender: user.userinfo,
              userId: userinfo?.id.toString(),
              user: userinfo,
            ),
          );
        }

        if (value.inboxroomId == user.ChatRoom?.id) {
          user.addtochatRoom(value);
        }

        textEditingController.clear();
      } else {
        debugPrint('❌ $operation failed: returned message ID is null');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  // ==================== SEND MESSAGE IN ROOM ====================

  Future<void> SendMessageInRoom({
    dynamic context,
    dynamic message,
    dynamic userid,
  }) async {
    const operation = 'SendMessageInRoom';

    _logStart(operation, {
      'receiverId': userid,
      'senderId': UserId,
      'message': message,
    });

    showSpinner2();

    try {
      final value = await Chatapi().SendMessage(
        message: message,
        userid: userid,
        Senderid: UserId,
        context: context,
      );

      if (value.id != null) {
        defaultindex = value.inboxroomId ?? 0;

        _logSuccess(operation, {
          'messageId': value.id,
          'inboxRoomId': value.inboxroomId,
          'defaultindex': defaultindex,
        });

        textEditingController.clear();
      } else {
        debugPrint('❌ $operation failed: returned message ID is null');
      }
    } catch (error, stackTrace) {
      _logError(operation, error, stackTrace);
    } finally {
      hideSpinner2();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
