enum UnityGame {
  pizza(
    id: 'pizza',
    displayName: 'Pizza Game',
    unityScene: 'PizzaGame',
    unityRoute: '/pizza',
  ),
  fishing(
    id: 'fishing',
    displayName: 'Fishing Game',
    unityScene: 'FishingGame',
    unityRoute: '/fishing',
  ),
  jumping(
    id: 'jumping',
    displayName: 'Jumping Game',
    unityScene: 'JumpingGame',
    unityRoute: '/jumping',
  );

  const UnityGame({
    required this.id,
    required this.displayName,
    required this.unityScene,
    required this.unityRoute,
  });

  final String id;
  final String displayName;
  final String unityScene;
  final String unityRoute;
}
