void resetGame() {
  player1 = new Spaceship();
  objects = new ArrayList<GameObject>();
  objects.add(player1);
  objects.add(new UFO());

  flaresUsed = 0;
  missileLockTime = 0;
  dodgingMissile = false;
  currentBulletsUsed = 0;

  levelStartTime = millis();

  for (int i = 0; i < levelAsteroidCounts[currentLevel]; i++) {
    objects.add(new Asteroid());
  }
}
