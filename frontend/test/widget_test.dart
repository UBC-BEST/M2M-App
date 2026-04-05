import 'package:flutter_test/flutter_test.dart';
import 'package:m2m/features/games/domain/game_item.dart';
import 'package:m2m/features/games/presentation/games_page.dart';
import 'package:flutter/material.dart';
import 'package:m2m/l10n/app_localizations.dart';

void main() {
  testWidgets('games page renders and handles tap',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      TestApp(
        games: <GameItem>[
          GameItem(
            id: 'pizza',
            name: 'Pizza Game',
            subtitle: 'Tap to launch',
            onTap: () => tapped = true,
          ),
        ],
      ),
    );

    expect(find.text('Pizza Game'), findsOneWidget);
    await tester.tap(find.text('Pizza Game'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}

class TestApp extends StatelessWidget {
  const TestApp({super.key, required this.games});

  final List<GameItem> games;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GamesPage(games: games),
    );
  }
}
