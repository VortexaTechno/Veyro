
import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../models/CommentsModel.dart';
import '../../models/Likemodel.dart';
import '../../models/PostsModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';

int Index = 2;
int PostIndex = 2;
int FollowIndex = 2;

class Momentapi extends MomentRepository {
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

  List<Postes> GeneralPostes = [];
  List<Postes> GetMyPostslist = [];

  Comments Commentss = Comments();
  Like Likes = Like();
  Postes post = Postes();

  // =========================================================
  // LOGGING HELPERS
  // =========================================================

  void _logRequest(
      String apiName,
      String method,
      String endpoint, {
        dynamic data,
      }) {
    print('\n========== $apiName REQUEST ==========');
    print('URL: ${dio.options.baseUrl}$endpoint');
    print('METHOD: $method');
    print('USER ID: $UserId');

    if (data != null) {
      print('REQUEST DATA: $data');
    }

    print('======================================');
  }

  void _logResponse(String apiName, Response response) {
    print('\n========== $apiName RESPONSE ==========');
    print('URL: ${response.requestOptions.uri}');
    print('METHOD: ${response.requestOptions.method}');
    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE HEADERS: ${response.headers}');
    print('RESPONSE BODY: ${response.data}');
    print('=======================================\n');
  }

  void _logDioError(String apiName, DioException error) {
    print('\n========== $apiName DIO ERROR ==========');
    print('URL: ${error.requestOptions.uri}');
    print('METHOD: ${error.requestOptions.method}');
    print('STATUS CODE: ${error.response?.statusCode}');
    print('RESPONSE BODY: ${error.response?.data}');
    print('ERROR TYPE: ${error.type}');
    print('ERROR MESSAGE: ${error.message}');
    print('========================================\n');
  }

  void _logUnknownError(
      String apiName,
      Object error,
      StackTrace stackTrace,
      ) {
    print('\n========== $apiName UNKNOWN ERROR ==========');
    print('ERROR: $error');
    print('STACK TRACE: $stackTrace');
    print('============================================\n');
  }

  void _showApiError(dynamic context, dynamic data) {
    if (context == null || data is! Map) return;

    final errNum = data['errNum'];

    if (errNum != null) {
      Dialogs().ShowErrorRegesterToast(errNum, context);
    }
  }

  void _handleDioError(
      String apiName,
      DioException error, {
        dynamic context,
        bool showToast = false,
      }) {
    _logDioError(apiName, error);

    if (showToast) {
      _showApiError(context, error.response?.data);
    }
  }

  // =========================================================
  // GET POSTS
  // =========================================================

  Future<List<Postes>> GetPosts(context) async {
    PostIndex = 2;

    try {
      final endpoint = '/api/GetPosts/$UserId';

      _logRequest('GET POSTS', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('GET POSTS', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data['Postes'] is Map &&
            data['Postes']['date'] is Map &&
            data['Postes']['date']['data'] is List) {
          final List list = data['Postes']['date']['data'];
          final List ste = data['Postes']['posts'] is List
              ? data['Postes']['posts']
              : [];

          for (final element in list) {
            GeneralPostes.add(Postes.fromJson(element));
          }

          Provider.of<MomentViewModel>(
            context,
            listen: false,
          ).GetLikedPost(ste);
        } else {
          print('GET POSTS: Unexpected response format.');
        }
      }
    } on DioException catch (e) {
      _handleDioError('GET POSTS', e, context: context, showToast: true);
    } catch (e, stackTrace) {
      _logUnknownError('GET POSTS', e, stackTrace);
    }

    return GeneralPostes;
  }

  // =========================================================
  // GET FOLLOWING POSTS
  // =========================================================

  Future<List<Postes>> GetFollowPostes(context) async {
    FollowIndex = 2;

    try {
      final endpoint = '/api/GetPostsUserFollowing/$UserId';

      _logRequest('GET FOLLOW POSTS', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('GET FOLLOW POSTS', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data['Postes'] is Map &&
            data['Postes']['data'] is List) {
          final List list = data['Postes']['data'];

          for (final element in list) {
            GeneralPostes.add(Postes.fromJson(element));
          }
        } else {
          print('GET FOLLOW POSTS: Unexpected response format.');
        }
      }
    } on DioException catch (e) {
      _handleDioError(
        'GET FOLLOW POSTS',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('GET FOLLOW POSTS', e, stackTrace);
    }

    return GeneralPostes;
  }

  // =========================================================
  // LOAD MORE FOLLOWING POSTS
  // =========================================================

  Future<List<Postes>> AddmoreFollowPosts(context) async {
    final endpoint =
        '/api/GetPostsUserFollowing/$UserId?page=$FollowIndex';

    try {
      _logRequest('LOAD MORE FOLLOW POSTS', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('LOAD MORE FOLLOW POSTS', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data['Postes'] is Map &&
            data['Postes']['data'] is List) {
          final List list = data['Postes']['data'];

          if (list.isNotEmpty) {
            FollowIndex++;
          }

          for (final element in list) {
            GeneralPostes.add(Postes.fromJson(element));
          }

          print('FOLLOW INDEX: $FollowIndex');
          print('LOADED POSTS: ${list.length}');
        } else {
          print('LOAD MORE FOLLOW POSTS: Unexpected response format.');
        }
      }
    } on DioException catch (e) {
      _handleDioError(
        'LOAD MORE FOLLOW POSTS',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('LOAD MORE FOLLOW POSTS', e, stackTrace);
    }

    return GeneralPostes;
  }

  // =========================================================
  // LOAD MORE POSTS
  // =========================================================

  Future<List<Postes>> AddmorePosts(context) async {
    final endpoint = '/api/GetPosts/$UserId?page=$PostIndex';

    try {
      _logRequest('LOAD MORE POSTS', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('LOAD MORE POSTS', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data['Postes'] is Map &&
            data['Postes']['date'] is Map &&
            data['Postes']['date']['data'] is List) {
          final List list = data['Postes']['date']['data'];

          if (list.isNotEmpty) {
            PostIndex++;
          }

          print('INDEX: $Index');
          print('POST INDEX: $PostIndex');
          print('NEW POSTS COUNT: ${list.length}');

          for (final element in list) {
            GeneralPostes.add(Postes.fromJson(element));
          }

          print('TOTAL POSTS: ${GeneralPostes.length}');
        } else {
          print('LOAD MORE POSTS: Unexpected response format.');
        }
      }
    } on DioException catch (e) {
      _handleDioError(
        'LOAD MORE POSTS',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('LOAD MORE POSTS', e, stackTrace);
    }

    return GeneralPostes;
  }

  // =========================================================
  // REPORT POST
  // =========================================================

  Future<bool> ReportPost({context, Postid}) async {
    bool status = false;
    const endpoint = 'api/AddPostReport';

    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
        'reason': 'Post',
      });

      _logRequest(
        'REPORT POST',
        'POST',
        endpoint,
        data: {
          'user_id': UserId.toString(),
          'post_id': Postid.toString(),
          'reason': 'Post',
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('REPORT POST', response);

      status = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'REPORT POST',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('REPORT POST', e, stackTrace);
    }

    return status;
  }

  // =========================================================
  // REPORT USER
  // =========================================================

  Future<bool> ReportUser({context, Userid}) async {
    bool status = false;
    const endpoint = 'api/AddUserReport';

    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      _logRequest(
        'REPORT USER',
        'POST',
        endpoint,
        data: {
          'sender_id': UserId.toString(),
          'user_id': Userid.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('REPORT USER', response);

      status = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'REPORT USER',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('REPORT USER', e, stackTrace);
    }

    return status;
  }

  // =========================================================
  // BLOCK USER
  // =========================================================

  Future<bool> BlockUser({context, Userid}) async {
    bool status = false;
    const endpoint = 'api/AddBlockList';

    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      _logRequest(
        'BLOCK USER',
        'POST',
        endpoint,
        data: {
          'sender_id': UserId.toString(),
          'user_id': Userid.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('BLOCK USER', response);

      status = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'BLOCK USER',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('BLOCK USER', e, stackTrace);
    }

    return status;
  }

  // =========================================================
  // UNBLOCK USER
  // =========================================================

  Future<bool> UnBlockUser({context, Userid}) async {
    bool status = false;
    const endpoint = 'api/UnBlockUser';

    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      _logRequest(
        'UNBLOCK USER',
        'POST',
        endpoint,
        data: {
          'sender_id': UserId.toString(),
          'user_id': Userid.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('UNBLOCK USER', response);

      status = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'UNBLOCK USER',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('UNBLOCK USER', e, stackTrace);
    }

    return status;
  }

  // =========================================================
  // GET MY POSTS
  // =========================================================

  Future<List<Postes>> GetMyPosts(context) async {
    final endpoint = '/api/GetMyPosts/$UserId';

    try {
      _logRequest('GET MY POSTS', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('GET MY POSTS', response);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['Postes'] is List) {
          final List list = data['Postes'];

          for (final element in list) {
            GetMyPostslist.add(Postes.fromJson(element));
          }
        } else {
          print('GET MY POSTS: Unexpected response format.');
        }
      }
    } on DioException catch (e) {
      _handleDioError(
        'GET MY POSTS',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('GET MY POSTS', e, stackTrace);
    }

    return GetMyPostslist;
  }

  // =========================================================
  // DELETE POST
  // =========================================================

  Future<bool> DeletePost({context, postid}) async {
    bool deleted = false;
    final endpoint = '/api/Deletemypost/$postid';

    try {
      _logRequest('DELETE POST', 'GET', endpoint);

      final Response response = await dio.get(endpoint);

      _logResponse('DELETE POST', response);

      deleted = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'DELETE POST',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('DELETE POST', e, stackTrace);
    }

    return deleted;
  }

  // =========================================================
  // ADD COMMENT
  // =========================================================

  Future<Comments> AddComment({
    context,
    Comment,
    Postid,
  }) async {
    const endpoint = 'api/AddComment';

    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
        'Comment': Comment.toString(),
      });

      _logRequest(
        'ADD COMMENT',
        'POST',
        endpoint,
        data: {
          'user_id': UserId.toString(),
          'post_id': Postid.toString(),
          'Comment': Comment.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('ADD COMMENT', response);

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['Comment'] is Map) {
        Commentss = Comments.fromJson(response.data['Comment']);
      } else {
        print('ADD COMMENT: Unexpected response format.');
      }
    } on DioException catch (e) {
      _handleDioError(
        'ADD COMMENT',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('ADD COMMENT', e, stackTrace);
    }

    return Commentss;
  }

  // =========================================================
  // REPLY TO COMMENT
  // =========================================================

  Future<Comments> ReplayComment({
    context,
    Commentid,
    Replay,
  }) async {
    const endpoint = 'api/ReplayComment';

    try {
      final formData = FormData.fromMap({
        'Comment_id': Commentid.toString(),
        'Replay': Replay.toString(),
      });

      _logRequest(
        'REPLY COMMENT',
        'POST',
        endpoint,
        data: {
          'Comment_id': Commentid.toString(),
          'Replay': Replay.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('REPLY COMMENT', response);

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['Comment'] is Map) {
        Commentss = Comments.fromJson(response.data['Comment']);
      } else {
        print('REPLY COMMENT: Unexpected response format.');
      }
    } on DioException catch (e) {
      _handleDioError(
        'REPLY COMMENT',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('REPLY COMMENT', e, stackTrace);
    }

    return Commentss;
  }

  // =========================================================
  // LIKE POST
  // =========================================================

  Future<Like> LikePost({Postid}) async {
    const endpoint = 'api/AddLike';

    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
      });

      _logRequest(
        'LIKE POST',
        'POST',
        endpoint,
        data: {
          'user_id': UserId.toString(),
          'post_id': Postid.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('LIKE POST', response);

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['Like'] is Map) {
        Likes = Like.fromJson(response.data['Like']);
      } else {
        print('LIKE POST: Unexpected response format.');
      }
    } on DioException catch (e) {
      _handleDioError('LIKE POST', e);
    } catch (e, stackTrace) {
      _logUnknownError('LIKE POST', e, stackTrace);
    }

    return Likes;
  }

  // =========================================================
  // REMOVE LIKE
  // =========================================================

  Future<bool> RemoveLike({context, Postid}) async {
    bool deleted = false;
    const endpoint = 'api/RemoveLike';

    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
      });

      _logRequest(
        'REMOVE LIKE',
        'POST',
        endpoint,
        data: {
          'user_id': UserId.toString(),
          'post_id': Postid.toString(),
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('REMOVE LIKE', response);

      deleted = response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(
        'REMOVE LIKE',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('REMOVE LIKE', e, stackTrace);
    }

    return deleted;
  }

  // =========================================================
  // ADD POST
  // =========================================================

  Future<Postes> AddPost({
    context,
    tittle,
    image,
  }) async {
    const endpoint = 'api/AddPost';

    try {
      final Map<String, dynamic> map = {
        'user_id': UserId.toString(),
        'content': tittle.toString(),
      };

      if (image != null) {
        map['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split(RegExp(r'[/\\]')).last,
        );
      }

      final FormData formData = FormData.fromMap(map);

      _logRequest(
        'ADD POST',
        'POST',
        endpoint,
        data: {
          'user_id': UserId.toString(),
          'content': tittle.toString(),
          'image': image?.path ?? 'No image',
        },
      );

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logResponse('ADD POST', response);

      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['Postes'] is Map) {
        post = Postes.fromJson(response.data['Postes']);
      } else {
        print('ADD POST: Unexpected response format.');
      }
    } on DioException catch (e) {
      _handleDioError(
        'ADD POST',
        e,
        context: context,
        showToast: true,
      );
    } catch (e, stackTrace) {
      _logUnknownError('ADD POST', e, stackTrace);
    }

    return post;
  }
}
