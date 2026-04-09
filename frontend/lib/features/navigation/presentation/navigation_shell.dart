import 'package:flutter/material.dart';
import 'package:m2m/core/config/app_config.dart';
import 'package:m2m/core/services/bluetooth_sensor_service.dart';
import 'package:m2m/l10n/app_localizations.dart';

import '../../games/domain/game_item.dart';
import '../../games/presentation/games_page.dart';
import '../../home/presentation/home_page.dart';
import '../../settings/presentation/pages/settings_page.dart';
import '../../stats/presentation/stats_page.dart';
import '../../unity/application/sensor_game_bridge.dart';
import '../../unity/presentation/unity_game_launch.dart';
import '../../unity/domain/unity_game.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _currentPageIndex = 0;
  int? _lastNavigationButton;
  DateTime _lastNavigationActionAt = DateTime.fromMillisecondsSinceEpoch(0);
  final BluetoothSensorService _sensorService = BluetoothSensorService.instance;
  final List<ScrollController> _pageScrollControllers = List<ScrollController>.generate(
    4,
    (_) => ScrollController(),
  );
  static const double _scrollStep = 260;
  static const Duration _navigationDebounce = Duration(milliseconds: 260);

  @override
  void initState() {
    super.initState();
    _sensorService.addListener(_onSensorChanged);
    _sensorService.ensureInitialized(autoConnect: true);
  }

  @override
  void dispose() {
    _sensorService.removeListener(_onSensorChanged);
    for (final controller in _pageScrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSensorChanged() {
    final button = _sensorService.activeButton;
    if (button == null) {
      // Release resets edge-trigger so same button can fire again next press.
      _lastNavigationButton = null;
      return;
    }

    if (button == _lastNavigationButton) {
      return;
    }

    final now = DateTime.now();
    if (now.difference(_lastNavigationActionAt) < _navigationDebounce) {
      return;
    }
    _lastNavigationButton = button;
    _lastNavigationActionAt = now;

    switch (button) {
      case 4:
        // Next right screen (equivalent to swipe left).
        _changeTabBy(1);
        break;
      case 10:
        // Next left screen (equivalent to swipe right).
        _changeTabBy(-1);
        break;
      case 1:
        _scrollCurrentPage(up: true);
        break;
      case 7:
        _scrollCurrentPage(up: false);
        break;
      case 8:
        _goHome();
        break;
    }
  }

  void _changeTabBy(int delta) {
    final next = (_currentPageIndex + delta).clamp(0, 3);
    if (next == _currentPageIndex) return;
    if (!mounted) return;
    setState(() {
      _currentPageIndex = next;
    });
  }

  void _goHome() {
    if (_currentPageIndex == 0 || !mounted) return;
    setState(() {
      _currentPageIndex = 0;
    });
  }

  void _scrollCurrentPage({required bool up}) {
    final controller = _pageScrollControllers[_currentPageIndex];
    if (!controller.hasClients) return;
    final offset = up ? -_scrollStep : _scrollStep;
    final target = (controller.offset + offset).clamp(
      0.0,
      controller.position.maxScrollExtent,
    );
    controller.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final games = _buildGames(context, localizations);

    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: <Widget>[
          PrimaryScrollController(
            controller: _pageScrollControllers[0],
            child: const HomePage(),
          ),
          PrimaryScrollController(
            controller: _pageScrollControllers[1],
            child: GamesPage(games: games),
          ),
          PrimaryScrollController(
            controller: _pageScrollControllers[2],
            child: const StatsPage(),
          ),
          PrimaryScrollController(
            controller: _pageScrollControllers[3],
            child: const SettingsPage(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: Colors.lightBlue.shade100,
        selectedIndex: _currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.home, color: Colors.black),
            icon: const Icon(Icons.home_outlined),
            label: localizations.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.sports_esports, color: Colors.black),
            icon: const Icon(Icons.sports_esports_outlined),
            label: localizations.games,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.leaderboard, color: Colors.black),
            icon: const Icon(Icons.leaderboard_outlined),
            label: localizations.data,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.settings, color: Colors.black),
            icon: const Icon(Icons.settings_outlined),
            label: localizations.settings,
          ),
        ],
      ),
    );
  }

  List<GameItem> _buildGames(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    Future<void> launch(UnityGame game) async {
      final bridge = SensorGameBridge.instance;
      final messenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      final allowDevBypass = AppConfig.allowGameLaunchWithoutSensor;
      await bridge.ensureInitialized();
      if (!mounted) return;
      final hasPreset = await bridge.hasPreset(game);
      if (!mounted) return;

      if (!allowDevBypass && !bridge.isSensorConnected) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Connect your BLE sensor in Settings before launching ${game.displayName}.',
              ),
            ),
          );
        return;
      }

      if (!allowDevBypass && !hasPreset) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'No calibration preset found for ${game.displayName}. Configure it in Settings > Game sensor presets.',
              ),
            ),
          );
        return;
      }

      await navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => UnityGameLaunchPage(game: game),
        ),
      );
    }

    return [
      GameItem(
        id: UnityGame.pizza.id,
        name: localizations.gamePizza,
        subtitle: 'Sensor lane taps and cooldown control',
        onTap: () => launch(UnityGame.pizza),
      ),
      GameItem(
        id: UnityGame.fishing.id,
        name: 'Fishing Game',
        subtitle: 'Sensor controls reel up/down axis',
        onTap: () => launch(UnityGame.fishing),
      ),
      GameItem(
        id: UnityGame.jumping.id,
        name: 'Jumping Game',
        subtitle: 'Sensor controls horizontal player movement',
        onTap: () => launch(UnityGame.jumping),
      ),
    ];
  }
}
