import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

import '../domain/game_item.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({
    super.key,
    required this.games,
  });

  final List<GameItem> games;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final allGames = games;
    final continueGame = allGames.isNotEmpty ? allGames.first : null;
    final favourites =
        allGames.length > 1 ? <GameItem>[allGames[1], allGames.last] : allGames;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            Center(
              child: Text(
                localizations.games,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (continueGame != null) ...[
              const _SectionTitle('Continue Playing'),
              const SizedBox(height: 10),
              _ContinueCard(game: continueGame),
              const SizedBox(height: 22),
            ],
            if (favourites.isNotEmpty) ...[
              const _SectionTitle('Favourites'),
              const SizedBox(height: 10),
              Row(
                children: favourites.take(2).map((game) {
                  final palette = _paletteFor(game.id);
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: game == favourites.first ? 12 : 0,
                      ),
                      child: _FavouriteCard(game: game, palette: palette),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 22),
            ],
            const _SectionTitle('All Games'),
            const SizedBox(height: 10),
            for (final game in allGames) ...[
              _GameRowTile(
                game: game,
                palette: _paletteFor(game.id),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }

  _GamePalette _paletteFor(String id) {
    if (id.contains('pizza')) {
      return const _GamePalette(
        emoji: '🍕',
        start: Color(0xFF14B8A6),
        end: Color(0xFF0D9488),
      );
    }
    if (id.contains('jump')) {
      return const _GamePalette(
        emoji: '🦘',
        start: Color(0xFF06B6D4),
        end: Color(0xFF0284C7),
      );
    }
    return const _GamePalette(
      emoji: '🎣',
      start: Color(0xFF06B6D4),
      end: Color(0xFF0891B2),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.game});

  final GameItem game;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(game.id);
    return Container(
      height: 148,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.start, palette.end],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'EXERCISE',
                      style: TextStyle(
                        color: Color(0xE6FFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child:
                      Text(palette.emoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Text(
                '5 MIN REMAINING',
                style: TextStyle(
                  color: Color(0xE6FFFFFF),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: game.onTap,
                child: Container(
                  height: 36,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: palette.end,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _GamePalette _paletteFor(String id) {
    if (id.contains('pizza')) {
      return const _GamePalette(
        emoji: '🍕',
        start: Color(0xFF14B8A6),
        end: Color(0xFF0D9488),
      );
    }
    if (id.contains('jump')) {
      return const _GamePalette(
        emoji: '🦘',
        start: Color(0xFF06B6D4),
        end: Color(0xFF0284C7),
      );
    }
    return const _GamePalette(
      emoji: '🎣',
      start: Color(0xFF06B6D4),
      end: Color(0xFF0891B2),
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({required this.game, required this.palette});

  final GameItem game;
  final _GamePalette palette;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: game.onTap,
      child: Container(
        height: 156,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [palette.start, palette.end],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EXERCISE',
              style: TextStyle(
                color: Color(0xE6FFFFFF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              game.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
            const Spacer(),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'START',
                style: TextStyle(
                  color: palette.end,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameRowTile extends StatelessWidget {
  const _GameRowTile({required this.game, required this.palette});

  final GameItem game;
  final _GamePalette palette;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: game.onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.start, palette.end],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child:
                    Text(palette.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const Text(
                    'EXERCISE',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.start, palette.end],
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GamePalette {
  const _GamePalette({
    required this.emoji,
    required this.start,
    required this.end,
  });

  final String emoji;
  final Color start;
  final Color end;
}
