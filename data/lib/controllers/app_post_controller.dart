import 'dart:io';

import 'package:data/utils/app_response.dart';
import 'package:conduit/conduit.dart';
import 'package:data/models/author.dart';
import 'package:data/models/post.dart';
import 'package:data/utils/app_utils.dart';

class AppPostController extends ResourceController {
  final ManagedContext managedContext;

  AppPostController(this.managedContext);

  @Operation.get("id")
  Future<Response> getPost(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final post = await managedContext.fetchObjectWithID<Post>(id);
      if (post == null) {
        return AppResponse.ok(message: "Пост не найден");
      }
      if (post.author?.id != currentAuthorId) {
        return AppResponse.ok(message: "У Вас нет доступа к посту");
      }
      post.backing.removeProperty("author");
      return AppResponse.ok(
          body: post.backing.contents, message: "Успешное получение поста");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка получения поста!!!");
    }
  }

  @Operation.post()
  Future<Response> createPost(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Post post) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final author = await managedContext.fetchObjectWithID<Author>(id);
      if (author == null) {
        final qCreateAuthor = Query<Author>(managedContext)..values.id = id;
        await qCreateAuthor.insert();
      }
      final qCreatePost = Query<Post>(managedContext)
        ..values.author?.id = id
        ..values.content = post.content;
      await qCreatePost.insert();
      return AppResponse.ok(message: "Успешное создание поста");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка создания поста!!!");
    }
  }

  @Operation.get()
  Future<Response> getPosts(
      @Bind.header(HttpHeaders.authorizationHeader) String header) async {
    try {
      // final id = AppUtils.getIdFromHeader(header);
      // final user = await managedContext.fetchObjectWithID<User>(id);
      // user?.removePropertiesFromBackingMap(
      //     [AppConst.accessToken, AppConst.refreshToken]);
      return AppResponse.ok(message: "Успешное получение постов");
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка получения постов!!!");
    }
  }
}
