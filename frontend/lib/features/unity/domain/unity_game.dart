enum UnityGame {
  pizza(
    id: 'pizza',
    displayName: 'Pizza Game',
    unityScene: 'Assets/PizzaGame/Scenes/PizzaGame.unity',
    unityRoute: '/pizza',
  ),
  fishing(
    id: 'fishing',
    displayName: 'Fishing Game',
    unityScene: 'Assets/FishingGame/Scenes/FishingGame.unity',
    unityRoute: '/fishing',
  ),
  jumping(
    id: 'jumping',
    displayName: 'Jumping Game',
    unityScene: 'Assets/JumpingGame/Scenes/SampleScene.unity',
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
