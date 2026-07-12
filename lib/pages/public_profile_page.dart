import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../core/models/user_model.dart';
import '../profile/public_profile_api.dart';

class ProfileNotFoundPage extends StatelessWidget {
  const ProfileNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _MessageState(
          title: StringConst.playerNotFound,
          subtitle: StringConst.playerNotFoundSubtitle,
        ),
      ),
    );
  }
}

class PublicProfilePage extends StatefulWidget {
  const PublicProfilePage({
    super.key,
    required this.slug,
    PublicProfileApi? api,
  }) : _api = api;

  final String slug;
  final PublicProfileApi? _api;

  static final Uri appStoreUri = Uri.parse(StringConst.appStoreUrl);
  static final Uri playStoreUri = Uri.parse(StringConst.playStoreUrl);

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  late final PublicProfileApi _api = widget._api ?? PublicProfileApi();
  late Future<UserModel> _future;

  static const double _desktopBreakpoint = 900;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchBySlug(widget.slug);
  }

  Future<void> _openUri(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openUrl(String url) async {
    await _openUri(Uri.parse(url));
  }

  Future<void> _shareProfile() async {
    await Clipboard.setData(ClipboardData(text: Uri.base.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreenColor,
                ),
              );
            }

            if (snapshot.hasError) {
              final isNotFound =
                  snapshot.error is PublicProfileNotFoundException;
              return _MessageState(
                title: isNotFound
                    ? StringConst.playerNotFound
                    : StringConst.somethingWentWrong,
                subtitle: isNotFound
                    ? StringConst.playerNotFoundSubtitle
                    : StringConst.tryAgainLater,
              );
            }

            final user = snapshot.data!;
            return Column(
              children: [
                _ProfileHeader(
                  onDownloadApp: () => _openUrl(StringConst.appStoreUrl),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop =
                          constraints.maxWidth >= _desktopBreakpoint;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 48 : 20,
                                vertical: isDesktop ? 32 : 20,
                              ),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 1100),
                                child: isDesktop
                                    ? _DesktopHero(
                                        user: user,
                                        onRequestHitch: () =>
                                            _openUri(Uri.base),
                                      )
                                    : _MobileHero(
                                        user: user,
                                        onRequestHitch: () =>
                                            _openUri(Uri.base),
                                      ),
                              ),
                            ),
                            if (user.uploadedSportsPhotos.isNotEmpty)
                              _ActionGallery(
                                photoUrls: user.uploadedSportsPhotos
                                    .map((e) => e.url)
                                    .toList(),
                                isDesktop: isDesktop,
                              ),
                            _ProfileFooter(
                              isDesktop: isDesktop,
                              onShare: _shareProfile,
                              onChat: () => _openUri(Uri.base),
                              onOpenLink: _openUrl,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: StringConst.fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: StringConst.fontFamily,
                fontSize: 15,
                color: Color(0xFF5A5A5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onDownloadApp});

  final VoidCallback onDownloadApp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StringConst.hitch,
            style: TextStyle(
              fontFamily: StringConst.fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryGreenColor,
            ),
          ),
          Material(
            color: AppColors.primaryGreenColor,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              onTap: onDownloadApp,
              borderRadius: BorderRadius.circular(999),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Text(
                  StringConst.downloadApp,
                  style: TextStyle(
                    fontFamily: StringConst.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero({
    required this.user,
    required this.onRequestHitch,
  });

  final UserModel user;
  final VoidCallback onRequestHitch;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _ProfilePhoto(url: user.profilePicture, height: 420),
              const SizedBox(height: 16),
              _RequestHitchButton(onPressed: onRequestHitch),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 6,
          child: _ProfileDetails(user: user),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero({
    required this.user,
    required this.onRequestHitch,
  });

  final UserModel user;
  final VoidCallback onRequestHitch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfilePhoto(url: user.profilePicture, height: 320),
        const SizedBox(height: 16),
        _RequestHitchButton(onPressed: onRequestHitch),
        const SizedBox(height: 24),
        _ProfileDetails(user: user),
      ],
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    required this.url,
    required this.height,
  });

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                height: height,
                errorBuilder: (_, _, _) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 72, color: Color(0xFFBDBDBD)),
    );
  }
}

class _RequestHitchButton extends StatelessWidget {
  const _RequestHitchButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: AppColors.primaryGreenColor,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(999),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  StringConst.requestHitch,
                  style: TextStyle(
                    fontFamily: StringConst.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final location = user.locationDisplay;
    final gender = user.gender ?? '';
    final dupr = user.primaryDuprRating;
    final levelTitle = user.primaryLevelTitle;
    final hitchCount = user.reactIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.activeSports.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < user.activeSports.length; i++)
                _SportChip(
                  label: user.activeSports[i],
                  highlighted: i == 0,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Text(
          user.userName.isNotEmpty ? user.userName : 'Player',
          style: const TextStyle(
            fontFamily: StringConst.fontFamily,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: Colors.black,
          ),
        ),
        if (location.isNotEmpty || gender.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              if (location.isNotEmpty) ...[
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFF757575),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    location,
                    style: const TextStyle(
                      fontFamily: StringConst.fontFamily,
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              ],
              if (location.isNotEmpty && gender.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '·',
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                ),
              ],
              if (gender.isNotEmpty)
                Text(
                  gender,
                  style: const TextStyle(
                    fontFamily: StringConst.fontFamily,
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final sideBySide = constraints.maxWidth >= 360;
            final cards = <Widget>[
              if (dupr != null)
                _StatCard(
                  label: StringConst.duprRatingLabel,
                  value: _formatRating(dupr),
                  subtitle: levelTitle.isNotEmpty ? levelTitle : null,
                  valueColor: AppColors.primaryGreenColor,
                ),
              if (hitchCount > 0)
                _StatCard(
                  label: StringConst.totalHitchesLabel,
                  value: '$hitchCount',
                  subtitle: StringConst.matchesLabel,
                )
              else if (levelTitle.isNotEmpty && dupr == null)
                _StatCard(
                  label: StringConst.levelLabel,
                  value: levelTitle,
                ),
            ];

            if (cards.isEmpty) {
              return const SizedBox.shrink();
            }

            if (!sideBySide || cards.length == 1) {
              return Column(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 12),
                    cards[i],
                  ],
                ],
              );
            }

            return Row(
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  Expanded(child: cards[i]),
                ],
              ],
            );
          },
        ),
        if (user.bio.isNotEmpty) ...[
          const SizedBox(height: 20),
          _BioCard(bio: user.bio),
        ],
      ],
    );
  }

  String _formatRating(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(1);
    }
    return value.toStringAsFixed(2);
  }
}

class _SportChip extends StatelessWidget {
  const _SportChip({
    required this.label,
    required this.highlighted,
  });

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.backgroundColor
            : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: StringConst.fontFamily,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: highlighted ? AppColors.blueGreenColor : const Color(0xFF616161),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: StringConst.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: StringConst.fontFamily,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: valueColor ?? Colors.black,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: StringConst.fontFamily,
                fontSize: 13,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BioCard extends StatelessWidget {
  const _BioCard({required this.bio});

  final String bio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            StringConst.athleteBio,
            style: TextStyle(
              fontFamily: StringConst.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bio,
            style: const TextStyle(
              fontFamily: StringConst.fontFamily,
              fontSize: 14,
              height: 1.55,
              color: Color(0xFF5A5A5A),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionGallery extends StatelessWidget {
  const _ActionGallery({
    required this.photoUrls,
    required this.isDesktop,
  });

  final List<String> photoUrls;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final urls = photoUrls.take(6).toList();

    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 20,
        vertical: 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                StringConst.actionGallery,
                style: TextStyle(
                  fontFamily: StringConst.fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                StringConst.actionGallerySubtitle,
                style: TextStyle(
                  fontFamily: StringConst.fontFamily,
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 24),
              if (isDesktop && urls.length >= 3)
                _DesktopGalleryGrid(urls: urls)
              else
                _MobileGalleryGrid(urls: urls),
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopGalleryGrid extends StatelessWidget {
  const _DesktopGalleryGrid({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    final primary = urls[0];
    final rest = urls.skip(1).toList();

    return SizedBox(
      height: 420,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _GalleryImage(url: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _GalleryImage(
                          url: rest.isNotEmpty ? rest[0] : primary,
                        ),
                      ),
                      if (rest.length > 1) ...[
                        const SizedBox(width: 12),
                        Expanded(child: _GalleryImage(url: rest[1])),
                      ],
                    ],
                  ),
                ),
                if (rest.length > 2) ...[
                  const SizedBox(height: 12),
                  Expanded(
                    child: _GalleryImage(url: rest[2]),
                  ),
                ],
                if (rest.length > 3) ...[
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _GalleryImage(url: rest[3])),
                        if (rest.length > 4) ...[
                          const SizedBox(width: 12),
                          Expanded(child: _GalleryImage(url: rest[4])),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileGalleryGrid extends StatelessWidget {
  const _MobileGalleryGrid({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: urls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return _GalleryImage(url: urls[index]);
      },
    );
  }
}

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFFE0E0E0),
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      ),
    );
  }
}

class _ProfileFooter extends StatelessWidget {
  const _ProfileFooter({
    required this.isDesktop,
    required this.onShare,
    required this.onChat,
    required this.onOpenLink,
  });

  final bool isDesktop;
  final VoidCallback onShare;
  final VoidCallback onChat;
  final Future<void> Function(String url) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final links = [
      (StringConst.privacyPolicy, StringConst.privacyPolicyUrl),
      (StringConst.termsOfService, StringConst.termsOfServiceUrl),
      (StringConst.safetyCenter, StringConst.safetyCenterUrl),
      (StringConst.support, StringConst.supportUrl),
      (StringConst.careers, StringConst.careersUrl),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 48 : 20,
        32,
        isDesktop ? 48 : 20,
        40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _footerBrand()),
                    Expanded(
                      flex: 2,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          for (final link in links)
                            _FooterLink(
                              label: link.$1,
                              onTap: () => onOpenLink(link.$2),
                            ),
                        ],
                      ),
                    ),
                    _FooterIcons(onShare: onShare, onChat: onChat),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _footerBrand(),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        for (final link in links)
                          _FooterLink(
                            label: link.$1,
                            onTap: () => onOpenLink(link.$2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _FooterIcons(onShare: onShare, onChat: onChat),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _footerBrand() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConst.hitch,
          style: TextStyle(
            fontFamily: StringConst.fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 6),
        Text(
          StringConst.footerTagline,
          style: TextStyle(
            fontFamily: StringConst.fontFamily,
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: StringConst.fontFamily,
            fontSize: 13,
            color: Color(0xFF616161),
          ),
        ),
      ),
    );
  }
}

class _FooterIcons extends StatelessWidget {
  const _FooterIcons({
    required this.onShare,
    required this.onChat,
  });

  final VoidCallback onShare;
  final VoidCallback onChat;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleIconButton(icon: Icons.share_outlined, onTap: onShare),
        const SizedBox(width: 10),
        _CircleIconButton(icon: Icons.chat_bubble_outline, onTap: onChat),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF0F0F0),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: const Color(0xFF616161)),
        ),
      ),
    );
  }
}
