class StringConst {
  static const webAppTitle = 'Hitch: Racket Partners';
  static const profileTitleSuffix = 'Hitch Racket Player';
  static const fontFamily = 'PlusJakartaSans';

  static String profileWebTitle(String playerName) {
    final name = playerName.trim();
    if (name.isEmpty) {
      return webAppTitle;
    }
    return '$name - $profileTitleSuffix';
  }

  static String profileMetaDescription({
    required String playerName,
    List<String> sports = const [],
    String location = '',
  }) {
    final name = playerName.trim().isEmpty ? 'Player' : playerName.trim();
    final parts = <String>['$name on Hitch'];
    if (sports.isNotEmpty) {
      parts.add(sports.join(', '));
    }
    if (location.trim().isNotEmpty) {
      parts.add(location.trim());
    }
    parts.add('Find racket sports partners.');
    return parts.join('. ');
  }

  static String profilePhotoAlt(String playerName) {
    final name = playerName.trim().isEmpty ? 'Player' : playerName.trim();
    return '$name profile photo';
  }

  static String sportsPhotoAlt(String playerName) {
    final name = playerName.trim().isEmpty ? 'Player' : playerName.trim();
    return '$name sports photo';
  }

  static const hitch = 'Hitch';
  static const downloadApp = 'Download App';
  static const socialBadge = '# Not a dating app.';
  static const headlineLead = 'Connect with Your Next';
  static const headlineAccent = 'Match Locally';
  static const heroBody =
      'Hitch is the kinetic curator for racket sports. Find skilled partners, book premier courts, and level up your game with a community that plays as hard as you do.';

  static const appStoreUrl =
      'https://apps.apple.com/us/app/hitch-player-finder/id6670320911';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.willparton.hitch';

  static const appDeepLinkScheme = 'hitch';
  static const letsPlayLabel = "Let's Play";

  static const followUs = 'Follow us';
  static const getInTouch = 'Get in touch:';
  static const contactEmail = 'will@hitchplayerfinders.com';
  static const contactEmailUrl = 'mailto:will@hitchplayerfinders.com';
  static const instagramUrl = 'https://www.instagram.com/hitch.pf/';
  static const footerRegions = 'US | CA | UK | AUS';
  static const footerCopyright = '© 2026 · Hitch, Limited Partnership';

  static const profileSlugKey = 'profileSlug';
  static const locationStringArrayKey = 'locationStringArray';

  static const matchTypeKey = 'matchType';
  static const genderTypeKey = 'genderType';
  static const availableDaysToPlayKey = 'availableDaysToPlay';
  static const isAvailableInMorningKey = 'isAvailableInMorning';
  static const isAvailableDailyKey = 'isAvailableDaily';
  static const uploadedFilesKey = 'uploadedFiles';
  static const isReviewedKey = 'isReviewed';
  static const clubKey = 'club';

  static const playerTypeCoachValue = 'Coach';
  static const playerTypeTennisValue = 'Tennis';
  static const playerTypePadelValue = 'Padel';
  static const playerTypePickleBallValue = 'Pickleball';

  static const requestHitch = 'Request Hitch';
  static const athleteBio = 'Athlete Bio';
  static const duprRatingLabel = 'DUPR RATING';
  static const totalHitchesLabel = 'TOTAL HITCHES';
  static const levelLabel = 'LEVEL';
  static const matchesLabel = 'Matches';
  static const actionGallery = 'Action Gallery';
  static const actionGallerySubtitle =
      'Moments from recent matches and training sessions';
  static const playerNotFound = 'Player not found';
  static const playerNotFoundSubtitle =
      'This profile link may be invalid or outdated.';
  static const somethingWentWrong = 'Something went wrong';
  static const tryAgainLater = 'Please try again later.';
  static const privacyPolicy = 'Privacy Policy';
  static const termsOfService = 'Terms of Service';
  static const safetyCenter = 'Safety Center';
  static const support = 'Support';
  static const careers = 'Careers';
  static const privacyPolicyUrl = 'https://hitchplayerfinder.com/privacy';
  static const termsOfServiceUrl = 'https://hitchplayerfinder.com/terms';
  static const safetyCenterUrl = 'https://hitchplayerfinder.com/safety';
  static const supportUrl = 'https://hitchplayerfinder.com/support';
  static const careersUrl = 'https://hitchplayerfinder.com/careers';
}
