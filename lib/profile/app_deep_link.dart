import '../constants/string_const.dart';

Uri buildAppDeepLinkUri(String slug) {
  return Uri.parse('${StringConst.appDeepLinkScheme}:///player/$slug');
}
