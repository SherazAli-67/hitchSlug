import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/string_const.dart';
import '../core/app_colors.dart';
import '../profile/city_players_api.dart';
import '../profile/open_in_app.dart';
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

  static const double _desktopBreakpoint = 900;

  bool _initialLoading = true;
  bool _loadingMore = false;
  Object? _error;
  final List<PublicCityPlayer> _players = [];
  String _displayCity = '';
  bool _hasMore = false;
  final Set<String> _seenIds = {};

  @override
  void initState() {
    super.initState();
    applyDefaultSeo();
    _displayCity = citySlugToDisplayName(widget.citySlug);
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _initialLoading = true;
      _error = null;
      _players.clear();
      _seenIds.clear();
      _hasMore = false;
    });

    try {
      final result = await _api.fetchByCity(
        widget.citySlug,
        radiusMiles: CityPlayersApi.defaultRadiusMiles,
        limit: CityPlayersApi.defaultPageSize,
        offset: 0,
      );
      if (!mounted) return;
      _appendPlayers(result.players);
      setState(() {
        _displayCity = _resolveDisplayCity(result);
        _hasMore = result.hasMore;
        _initialLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _initialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;

    setState(() => _loadingMore = true);
    try {
      final result = await _api.fetchByCity(
        widget.citySlug,
        radiusMiles: CityPlayersApi.defaultRadiusMiles,
        limit: CityPlayersApi.defaultPageSize,
        offset: _players.length,
      );
      if (!mounted) return;
      final beforeCount = _players.length;
      _appendPlayers(result.players);
      final added = _players.length - beforeCount;
      setState(() {
        if (result.displayCity.trim().isNotEmpty) {
          _displayCity = result.displayCity.trim();
        }
        _hasMore = result.hasMore && added > 0;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  void _appendPlayers(List<PublicCityPlayer> next) {
    for (final player in next) {
      final id = player.userID.trim().isNotEmpty
          ? player.userID.trim()
          : player.profileSlug.trim();
      if (id.isEmpty || _seenIds.contains(id)) continue;
      _seenIds.add(id);
      _players.add(player);
    }
  }

  String _resolveDisplayCity(CityPlayersResult result) {
    final fromApi = result.displayCity.trim();
    if (fromApi.isNotEmpty) return fromApi;
    return result.players
        .map((p) => p.city.trim())
        .firstWhere(
          (city) => city.isNotEmpty,
          orElse: () => citySlugToDisplayName(widget.citySlug),
        );
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
    final path = player.deepLinkPath(fallbackCitySlug: widget.citySlug);
    final profileUri = Uri.parse('${Uri.base.origin}$path');
    await launchUrl(profileUri, webOnlyWindowName: '_self');
  }

  Future<void> _letsPlay(PublicCityPlayer player) async {
    final slug = player.profileSlug.trim();
    if (slug.isEmpty) {
      return;
    }
    await openPlayerInApp(slug);
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return Title(
        title: StringConst.cityPlayersWebTitle(_displayCity),
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

    if (_error != null) {
      return Title(
        title: StringConst.cityPlayersWebTitle(_displayCity),
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

    return Title(
      title: StringConst.cityPlayersWebTitle(_displayCity),
      color: AppColors.primaryColorVariant1,
      child: PageShell(
        onLogoTap: _goToLanding,
        child: SelectionArea(
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
                        Semantics(
                          headingLevel: 1,
                          header: true,
                          child: Text(
                            '${StringConst.playersInCityTitle} $_displayCity',
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: isDesktop ? 40 : 32,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Semantics(
                          headingLevel: 5,
                          header: true,
                          child: Text(
                            StringConst.connectWithPartnersIn(_displayCity),
                            style: const TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColorVariant1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        if (_players.isEmpty)
                          const _MessageState(
                            title: StringConst.noPlayersInCity,
                            subtitle: StringConst.noPlayersInCitySubtitle,
                          )
                        else ...[
                          _PlayerGrid(
                            players: _players,
                            isDesktop: isDesktop,
                            onCardTap: _openProfile,
                            onLetsPlay: _letsPlay,
                          ),
                          if (_hasMore) ...[
                            const SizedBox(height: 28),
                            Center(
                              child: SizedBox(
                                width: isDesktop ? 220 : double.infinity,
                                child: FilledButton(
                                  onPressed: _loadingMore ? null : _loadMore,
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        AppColors.primaryGreenColor,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        AppColors.primaryGreenColor
                                            .withValues(alpha: 0.6),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _loadingMore
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          StringConst.loadMorePlayers,
                                          style: TextStyle(
                                            fontFamily: StringConst.fontFamily,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PlayerGrid extends StatelessWidget {
  const _PlayerGrid({
    required this.players,
    required this.isDesktop,
    required this.onCardTap,
    required this.onLetsPlay,
  });

  final List<PublicCityPlayer> players;
  final bool isDesktop;
  final ValueChanged<PublicCityPlayer> onCardTap;
  final ValueChanged<PublicCityPlayer> onLetsPlay;

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
                child: RepaintBoundary(
                  child: _PlayerCard(
                    player: player,
                    imageWidth: itemWidth,
                    alwaysShowLetsPlay: !isDesktop,
                    onTap: () => onCardTap(player),
                    onLetsPlay: () => onLetsPlay(player),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PlayerCard extends StatefulWidget {
  const _PlayerCard({
    required this.player,
    required this.imageWidth,
    required this.alwaysShowLetsPlay,
    required this.onTap,
    required this.onLetsPlay,
  });

  final PublicCityPlayer player;
  final double imageWidth;
  final bool alwaysShowLetsPlay;
  final VoidCallback onTap;
  final VoidCallback onLetsPlay;

  @override
  State<_PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<_PlayerCard> {
  bool _hovered = false;
  bool _focused = false;

  bool get _active => _hovered || _focused;

  bool get _showLetsPlay => widget.alwaysShowLetsPlay || _active;

  String get _subtitle {
    final player = widget.player;
    final parts = <String>[];
    if (player.primarySport.isNotEmpty) {
      parts.add(player.primarySport);
    }
    final levelTitle = player.primaryLevelTitle;
    final dupr = player.primaryDuprRating;
    if (levelTitle.isNotEmpty) {
      parts.add(levelTitle);
    } else if (dupr != null) {
      parts.add('DUPR ${dupr.toStringAsFixed(2)}');
    }
    return parts.join(' • ');
  }

  List<String> get _chips {
    final player = widget.player;
    final values = <String>[];
    final playStyle = player.playStyle.trim();
    if (playStyle.isNotEmpty) {
      values.add(playStyle);
    }
    for (final sport in player.activeSports.skip(1)) {
      values.add(sport);
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final subtitle = _subtitle;
    final chips = _chips;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: (value) => setState(() => _focused = value),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: _active ? AppColors.backgroundColor : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _active
                    ? AppColors.primaryColorVariant1
                    : const Color(0xFFE6E6E6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: _CardImage(
                            url: player.profilePicture,
                            displayWidth: widget.imageWidth,
                            semanticLabel:
                                StringConst.profilePhotoAlt(player.userName),
                          ),
                        ),
                      ),
                      if (player.playerTypeCoach)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreenColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              StringConst.playerTypeCoachValue,
                              style: TextStyle(
                                fontFamily: StringConst.fontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.userName.isNotEmpty
                              ? player.userName
                              : 'Player',
                          style: const TextStyle(
                            fontFamily: StringConst.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontFamily: StringConst.fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _active
                                  ? AppColors.textPrimaryColor
                                  : const Color(0xFF757575),
                            ),
                          ),
                        ],
                        if (chips.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final chip in chips)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _active
                                        ? Colors.white
                                        : const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    chip,
                                    style: const TextStyle(
                                      fontFamily: StringConst.fontFamily,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF5A5A5A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 14),
                        IgnorePointer(
                          ignoring: !_showLetsPlay,
                          child: AnimatedOpacity(
                            opacity: _showLetsPlay ? 1 : 0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: widget.onLetsPlay,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreenColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  StringConst.letsPlayLabel,
                                  style: TextStyle(
                                    fontFamily: StringConst.fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.url,
    required this.displayWidth,
    this.semanticLabel,
  });

  final String url;
  final double displayWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _placeholder();
    }
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheWidth = (displayWidth * dpr).round();
    return Semantics(
      image: true,
      label: semanticLabel,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth > 0 ? cacheWidth : null,
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
        semanticLabel: semanticLabel,
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
