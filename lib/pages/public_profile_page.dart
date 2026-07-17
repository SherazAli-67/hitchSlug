import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../core/models/user_model.dart';
import '../profile/open_in_app.dart';
import '../profile/public_profile_api.dart';
import '../widgets/page_shell.dart';

class ProfileNotFoundPage extends StatelessWidget {
  const ProfileNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageShell(
      centerBody: true,
      child: _MessageState(
        title: StringConst.playerNotFound,
        subtitle: StringConst.playerNotFoundSubtitle,
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

  Future<void> _goToLanding() async {
    final landingUri = Uri.parse('${Uri.base.origin}/');
    await launchUrl(landingUri, webOnlyWindowName: '_self');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return PageShell(
            onLogoTap: _goToLanding,
            centerBody: true,
            child: const CircularProgressIndicator(
              color: AppColors.primaryGreenColor,
            ),
          );
        }

        if (snapshot.hasError) {
          final isNotFound = snapshot.error is PublicProfileNotFoundException;
          return PageShell(
            onLogoTap: _goToLanding,
            centerBody: true,
            child: _MessageState(
              title: isNotFound
                  ? StringConst.playerNotFound
                  : StringConst.somethingWentWrong,
              subtitle: isNotFound
                  ? StringConst.playerNotFoundSubtitle
                  : StringConst.tryAgainLater,
            ),
          );
        }

        final user = snapshot.data!;
        return PageShell(
          onLogoTap: _goToLanding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48 : 20,
                  vertical: isDesktop ? 40 : 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: _ProfileHero(
                      user: user,
                      slug: widget.slug,
                      isDesktop: isDesktop,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.slug,
    required this.isDesktop,
  });

  final UserModel user;
  final String slug;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 45,
            child: _PhotoCollage(user: user),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 55,
            child: _ProfileDetails(user: user, slug: slug),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PhotoCollage(user: user),
        const SizedBox(height: 28),
        _ProfileDetails(user: user, slug: slug),
      ],
    );
  }
}

class _PhotoCollage extends StatelessWidget {
  const _PhotoCollage({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final sportsUrls =
        user.uploadedSportsPhotos.map((e) => e.url).where((u) => u.isNotEmpty);
    final sportsList = sportsUrls.toList();
    final bottomLeft = sportsList.isNotEmpty ? sportsList[0] : '';
    final bottomRight = sportsList.length > 1 ? sportsList[1] : '';

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: _GridImage(url: user.profilePicture),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final side = (constraints.maxWidth - 8) / 2;
            return SizedBox(
              height: side,
              child: Row(
                children: [
                  Expanded(child: _GridImage(url: bottomLeft)),
                  const SizedBox(width: 8),
                  Expanded(child: _GridImage(url: bottomRight)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _GridImage extends StatelessWidget {
  const _GridImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: url.isEmpty
          ? _placeholder()
          : Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 48, color: Color(0xFFBDBDBD)),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({
    required this.user,
    required this.slug,
  });

  final UserModel user;
  final String slug;

  @override
  Widget build(BuildContext context) {
    final location = user.locationDisplay;
    final gender = user.gender ?? '';
    final dupr = user.primaryDuprRating;
    final levelTitle = user.primaryLevelTitle;
    final hitchCount = user.reactIds.length;
    final profileSlug =
        user.profileSlug.isNotEmpty ? user.profileSlug : slug;

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
          const SizedBox(height: 18),
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
          const SizedBox(height: 12),
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
        const SizedBox(height: 24),
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
          const SizedBox(height: 24),
          _BioCard(bio: user.bio),
        ],
        if (profileSlug.isNotEmpty) ...[
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.headerFooterColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            ),
            onPressed: () => openPlayerInApp(profileSlug),
            child: const Text(
              StringConst.letsPlayLabel,
              style: TextStyle(
                fontFamily: StringConst.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blueGreenColor,
              ),
            ),
          ),
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
            ? AppColors.headerFooterColor
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
        border: Border.all(color: const Color(0xFFE8E8E8)),
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
