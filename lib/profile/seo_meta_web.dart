import 'dart:html' as html;
import '../constants/string_const.dart';

void applyDefaultSeo() {
  html.document.title = StringConst.webAppTitle;
  _setNamedMeta('description', StringConst.heroBody);
  _setPropertyMeta('og:title', StringConst.webAppTitle);
  _setPropertyMeta('og:description', StringConst.heroBody);
  _setPropertyMeta('og:type', 'website');
  _removePropertyMeta('og:image');
  _setCanonical('${html.window.location.origin}/');
  _clearSeoContent();
}

void applyProfileSeo({
  required String title,
  required String description,
  required String? imageUrl,
  required String canonicalUrl,
  required String heading,
  required String? profileImageUrl,
  required String profileImageAlt,
  required String bodyText,
}) {
  html.document.title = title;
  _setNamedMeta('description', description);
  _setPropertyMeta('og:title', title);
  _setPropertyMeta('og:description', description);
  _setPropertyMeta('og:type', 'profile');
  if (imageUrl != null && imageUrl.isNotEmpty) {
    _setPropertyMeta('og:image', imageUrl);
  } else {
    _removePropertyMeta('og:image');
  }
  _setCanonical(canonicalUrl);
  _fillSeoContent(
    heading: heading,
    profileImageUrl: profileImageUrl,
    profileImageAlt: profileImageAlt,
    bodyText: bodyText,
  );
}

void _setNamedMeta(String name, String content) {
  final head = html.document.head;
  if (head == null) {
    return;
  }
  var el = head.querySelector('meta[name="$name"]') as html.MetaElement?;
  if (el == null) {
    el = html.MetaElement()..name = name;
    head.append(el);
  }
  el.content = content;
}

void _setPropertyMeta(String property, String content) {
  final head = html.document.head;
  if (head == null) {
    return;
  }
  var el =
      head.querySelector('meta[property="$property"]') as html.MetaElement?;
  if (el == null) {
    el = html.MetaElement()..setAttribute('property', property);
    head.append(el);
  }
  el.content = content;
}

void _removePropertyMeta(String property) {
  html.document.head
      ?.querySelector('meta[property="$property"]')
      ?.remove();
}

void _setCanonical(String href) {
  final head = html.document.head;
  if (head == null) {
    return;
  }
  var el = head.querySelector('link[rel="canonical"]') as html.LinkElement?;
  if (el == null) {
    el = html.LinkElement()..rel = 'canonical';
    head.append(el);
  }
  el.href = href;
}

void _clearSeoContent() {
  final section = html.document.getElementById('seo-content');
  section?.children.clear();
}

void _fillSeoContent({
  required String heading,
  required String? profileImageUrl,
  required String profileImageAlt,
  required String bodyText,
}) {
  final section = html.document.getElementById('seo-content');
  if (section == null) {
    return;
  }
  section.children.clear();
  section.append(html.HeadingElement.h1()..text = heading);
  if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
    section.append(
      html.ImageElement()
        ..src = profileImageUrl
        ..alt = profileImageAlt,
    );
  }
  section.append(html.ParagraphElement()..text = bodyText);
}
