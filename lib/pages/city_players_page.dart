import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../profile/city_players_api.dart';
import '../profile/profile_slug.dart';
import '../profile/seo_meta.dart';
import '../widgets/page_shell.dart';

class CityPlayersPage extends StatefulWidget {
  const CityPlayersPage({
    super.key,
    required this.citySlug,
    CityPlayersApi? api,
  }) : _api = api;

  final String citySlug;
  final CityPlayersApi? _api;

  @override
  State<CityPlayersPage> createState() => _CityPlayersPageState();
}

class _CityPlayersPageState extends State<CityPlayersPage> {
  late final CityPlayersApi _api = widget._api ?? CityPlayersApi();
  late Future<CityPlayersResult> _future;

  static const double _desktopBreakpoint = 900;

  @override
  void initState() {
    super.initState();
    applyDefaultSeo();
    _future = _api.fetchByCity(widget.citySlug);
  }

  Future<void> _goToLanding() async {
    final landingUri = Uri.parse('${Uri.base.origin}/');
    await launchUrl(landingUri, webOnlyWindowName: '_self');
  }

  Future<void> _openProfile(PublicCityPlayer player) async {
    final slug = player.profileSlug.trim();
    if (slug.isEmpty) {
      return;
    }
    final profileUri = Uri.parse('${Uri.base.origin}/player/$slug');
    await launchUrl(profileUri, webOnlyWindowName: '_self');
  }

  String get _fallbackCityName => citySlugToDisplayName(widget.citySlug);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CityPlayersResult>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Title(
            title: StringConst.cityPlayersWebTitle(_fallbackCityName),
            color: AppColors.primaryColorVariant1,
            child: PageShell(
              onLogoTap: _goToLanding,
              centerBody: true,
              child: const CircularProgressIndicator(
                color: AppColors.primaryGreenColor,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Title(
            title: StringConst.cityPlayersWebTitle(_fallbackCityName),
            color: AppColors.primaryColorVariant1,
            child: PageShell(
              onLogoTap: _goToLanding,
              centerBody: true,
              child: const _MessageState(
                title: StringConst.somethingWentWrong,
                subtitle: StringConst.tryAgainLater,
              ),
            ),
          );
        }

        final result = snapshot.data!;
        final displayCity = result.players
                .map((p) => p.city.trim())
                .firstWhere(
                  (city) => city.isNotEmpty,
                  orElse: () => _fallbackCityName,
                );

        return Title(
          title: StringConst.cityPlayersWebTitle(displayCity),
          color: AppColors.primaryColorVariant1,
          child: PageShell(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${StringConst.playersInCityTitle} $displayCity',
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: isDesktop ? 40 : 32,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            StringConst.browsePlayersSubtitle,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 15,
                              color: Color(0xFF5A5A5A),
                            ),
                          ),
                          const SizedBox(height: 28),
                          if (result.players.isEmpty)
                            const _MessageState(
                              title: StringConst.noPlayersInCity,
                              subtitle: StringConst.noPlayersInCitySubtitle,
                            )
                          else
                            _PlayerGrid(
                              players: result.players,
                              isDesktop: isDesktop,
                              onTap: _openProfile,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PlayerGrid extends StatelessWidget {
  const _PlayerGrid({
    required this.players,
    required this.isDesktop,
    required this.onTap,
  });

  final List<PublicCityPlayer> players;
  final bool isDesktop;
  final ValueChanged<PublicCityPlayer> onTap;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isDesktop ? 3 : 1;
    final spacing = isDesktop ? 20.0 : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth =
            (width - spacing * (crossAxisCount - 1)) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final player in players)
              SizedBox(
                width: itemWidth,
                child: _PlayerCard(
                  player: player,
                  onTap: () => onTap(player),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.player,
    required this.onTap,
  });

  final PublicCityPlayer player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sports = player.activeSports;
    final city = player.city.trim();
    final rating = player.primaryDuprRating;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E6E6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: player.profilePicture.isEmpty
                        ? Container(
                            color: const Color(0xFFEEEEEE),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.person,
                              size: 36,
                              color: Color(0xFFBDBDBD),
                            ),
                          )
                        : Image.network(
                            player.profilePicture,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: const Color(0xFFEEEEEE),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.userName.isNotEmpty ? player.userName : 'Player',
                        style: const TextStyle(
                          fontFamily: StringConst.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      if (city.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Color(0xFF757575),
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                city,
                                style: const TextStyle(
                                  fontFamily: StringConst.fontFamily,
                                  fontSize: 13,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (sports.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (var i = 0; i < sports.length; i++)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? AppColors.primaryColorVariant1
                                          .withValues(alpha: 0.15)
                                      : const Color(0xFFF3F3F3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  sports[i],
                                  style: TextStyle(
                                    fontFamily: StringConst.fontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: i == 0
                                        ? AppColors.textPrimaryColor
                                        : const Color(0xFF5A5A5A),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      if (rating != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          'DUPR ${rating.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: StringConst.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreenColor,
                          ),
                        ),
                      ] else if (player.level.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          player.level,
                          style: const TextStyle(
                            fontFamily: StringConst.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A5A5A),
                          ),
                        ),
                      ],
                    ],
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
