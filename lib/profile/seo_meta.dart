import '../constants/string_const.dart';
import '../core/models/user_model.dart';
import 'seo_meta_stub.dart'
    if (dart.library.html) 'seo_meta_web.dart' as impl;

void applyDefaultSeo() {
  impl.applyDefaultSeo();
}

void applyProfileSeo(UserModel user, {required Uri pageUrl}) {
  final name = user.userName.trim().isEmpty ? 'Player' : user.userName.trim();
  final title = StringConst.profileWebTitle(user.userName);
  final description = StringConst.profileMetaDescription(
    playerName: user.userName,
    sports: user.activeSports,
    location: user.locationDisplay,
  );
  final imageUrl =
      user.profilePicture.trim().isEmpty ? null : user.profilePicture.trim();
  final canonical = Uri(
    scheme: pageUrl.scheme,
    host: pageUrl.host,
    port: pageUrl.hasPort ? pageUrl.port : null,
    path: pageUrl.path,
  );

  impl.applyProfileSeo(
    title: title,
    description: description,
    imageUrl: imageUrl,
    canonicalUrl: canonical.toString(),
    heading: name,
    profileImageUrl: imageUrl,
    profileImageAlt: StringConst.profilePhotoAlt(user.userName),
    bodyText: user.bio.trim().isNotEmpty ? user.bio.trim() : description,
  );
}
