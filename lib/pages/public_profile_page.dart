import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../profile/public_profile.dart';
import '../profile/public_profile_api.dart';

class ProfileNotFoundPage extends StatelessWidget {
  const ProfileNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: _MessageState(
          title: 'Player not found',
          subtitle: 'This profile link may be invalid or outdated.',
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

  static final Uri appStoreUri = Uri.parse(
    'https://apps.apple.com/app/hitch-find-players-court/id6444131087',
  );
  static final Uri playStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.willparton.hitch',
  );

  @override
  State<PublicProfilePage> createState() => _PublicProfilePageState();
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  late final PublicProfileApi _api = widget._api ?? PublicProfileApi();
  late Future<PublicProfile> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchBySlug(widget.slug);
  }

  Future<void> _openUri(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<PublicProfile>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final isNotFound =
                  snapshot.error is PublicProfileNotFoundException;
              return _MessageState(
                title: isNotFound ? 'Player not found' : 'Something went wrong',
                subtitle: isNotFound
                    ? 'This profile link may be invalid or outdated.'
                    : 'Please try again later.',
              );
            }

            final profile = snapshot.data!;
            return _ProfileBody(
              profile: profile,
              onOpenInHitch: () => _openUri(Uri.base),
              onGetIos: () => _openUri(PublicProfilePage.appStoreUri),
              onGetAndroid: () => _openUri(PublicProfilePage.playStoreUri),
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
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}


class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.profile,
    required this.onOpenInHitch,
    required this.onGetIos,
    required this.onGetAndroid,
  });

  final PublicProfile profile;
  final VoidCallback onOpenInHitch;
  final VoidCallback onGetIos;
  final VoidCallback onGetAndroid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final city = profile.cityDisplay;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: profile.profilePicture.isNotEmpty
                      ? NetworkImage(profile.profilePicture)
                      : null,
                  child: profile.profilePicture.isEmpty
                      ? Text(
                          profile.userName.isNotEmpty
                              ? profile.userName[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                profile.userName.isNotEmpty ? profile.userName : 'Player',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (city.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  city,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (profile.sports.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.sports
                      .map(
                        (sport) => Chip(
                          label: Text(sport),
                          backgroundColor: theme.colorScheme.primaryContainer,
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
                ),
              ],
              ..._levelRows(theme),
              if (profile.bio.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  profile.bio,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
              if (profile.sportsPhotos.isNotEmpty) ...[
                const SizedBox(height: 24),
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: profile.sportsPhotos.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          profile.sportsPhotos[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 120,
                            height: 120,
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 32),
              FilledButton(
                onPressed: onOpenInHitch,
                child: const Text('Open in Hitch'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onGetIos,
                child: const Text('Get the app — iOS'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onGetAndroid,
                child: const Text('Get the app — Android'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _levelRows(ThemeData theme) {
    final rows = <Widget>[];

    void addRow(String label, String value) {
      if (value.isEmpty) return;
      rows.add(const SizedBox(height: 8));
      rows.add(
        Text(
          '$label: $value',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    if (profile.pickleBallPlayerLevel.hasValue) {
      addRow('Pickleball', profile.pickleBallPlayerLevel.display);
    }
    if (profile.tennisBallPlayerLevel.hasValue) {
      addRow('Tennis', profile.tennisBallPlayerLevel.display);
    }
    if (profile.padelBallPlayerLevel.hasValue) {
      addRow('Padel', profile.padelBallPlayerLevel.display);
    }
    if (profile.level.isNotEmpty && rows.isEmpty) {
      addRow('Level', profile.level);
    }
    if (profile.isConnectedToDupr) {
      final parts = <String>[];
      if (profile.duprSingleRating != null) {
        parts.add('Singles ${profile.duprSingleRating}');
      }
      if (profile.duprDoubleRating != null) {
        parts.add('Doubles ${profile.duprDoubleRating}');
      }
      if (parts.isNotEmpty) {
        addRow('DUPR', parts.join(' · '));
      }
    }

    return rows;
  }
}
