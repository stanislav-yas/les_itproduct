import 'package:conduit/conduit.dart';
import 'post.dart';

class Author extends ManagedObject<_Author> implements _Author {}

class _Author {
  @primaryKey
  int? id;
  ManagedSet<Post>? postList;
}
