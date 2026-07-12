import 'package:flutter_test/flutter_test.dart';

import 'package:hitch_profile_slug_deeplink/constants/string_const.dart';
import 'package:hitch_profile_slug_deeplink/main.dart';
import 'package:hitch_profile_slug_deeplink/pages/landing_page.dart';
import 'package:hitch_profile_slug_deeplink/profile/profile_slug.dart';

void main() {
  test('extractProfileSlug reads last segment after player', () {
    expect(
      extractProfileSlug(
        Uri.parse('https://links.hitchplayerfinder.com/player/thomas-jp'),
      ),
      'thomas-jp',
    );
    expect(
      extractProfileSlug(
        Uri.parse(
          'https://links.hitchplayerfinder.com/pickleball-partners/player/ottawa/3.0-3.99-dupr/thomas-jp',
        ),
      ),
      'thomas-jp',
    );
    expect(
      extractProfileSlug(Uri.parse('https://links.hitchplayerfinder.com/')),
      isNull,
    );
  });

  testWidgets('landing page renders for root path', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(uri: Uri.parse('https://links.hitchplayerfinder.com/')),
    );
    expect(find.byType(LandingPage), findsOneWidget);
    expect(find.text(StringConst.downloadApp), findsOneWidget);
    expect(find.textContaining(StringConst.headlineAccent), findsOneWidget);
    expect(find.text(StringConst.socialBadge), findsOneWidget);
  });
}
