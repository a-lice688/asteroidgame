
void resetGame() {
  player1 = new Spaceship();
  objects = new ArrayList<GameObject>();
  objects.add(player1);
  objects.add(new UFO());

  missileLockTime = 0;
  dodgingMissile = false;

  levelStartTime = millis();
  currentFlaresUsed = 0;
  currentBulletsUsed = 0;


  for (int i = 0; i < levelAsteroidCounts[currentLevel]; i++) {
    objects.add(new Asteroid());
  }
}
