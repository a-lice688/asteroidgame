void drawGame() {

  boolean ufoExists = false;

  boolean missileExists = false;

  boolean upgradeExists = false;

  grid.display();
  grid.update();


  for (GameObject obj : objects) {
    if (obj instanceof UFO) ufoExists = true;
    if (obj instanceof Missile) missileExists = true;
    if (obj instanceof Upgrade) upgradeExists = true;
  }

  if (!ufoExists) {
    ufoSpawnTimer++;
    if (ufoSpawnTimer >= ufoSpawnInterval) {
      objects.add(new UFO());
      ufoSpawnTimer = 0;
      ufoSpawnInterval = int(random(660, 1000));
    }
  } else {
    ufoSpawnTimer = 0;
  }

  if (!upgradeExists) {
    upgradeSpawnTimer++;
    if (upgradeSpawnTimer >= upgradeSpawnInterval) {
      objects.add(new Upgrade());
      upgradeSpawnTimer = 0;
      upgradeSpawnInterval = int(random(450, 1000));
    }
  }

  // remove objects 
  
  for (int i = objects.size() - 1; i >= 0; i--) {
  GameObject obj = objects.get(i);
  if (obj.lives == 0 && !(obj instanceof Spaceship)) {

    if (obj instanceof Asteroid) {
      drawAsteroidParticles(obj.loc.copy());
    }
    if (obj instanceof UFO) {
      drawUFOParticles(obj.loc.copy());
    }

    objects.remove(i);
  } else {
    obj.act();
    obj.show();
  }
}

  drawFlareCount();

  if (dodgingMissile && missileExists) {
    drawMissileCountdown();
  } else {
    dodgingMissile = false;
    missileLockTime = 0;
  }

  drawLives(player1.lives);

  if (player1.lives == 0) {
    gameMode = GAMEOVER_LOSE;
  } else if (checkWinCondition()) {
    levelEndTime = millis();
    totalTimeTaken += (levelEndTime - levelStartTime);
    totalBulletsUsed += currentBulletsUsed;
    gameMode = (currentLevel == maxLevel) ? GAME_COMPLETE : LEVEL_COMPLETE;
  }

  drawTeleportCooldown();
}

void drawButton(String label, float x, float y, float w, float h) {
  fill(50);
  rect(x, y, w, h, 10);
  fill(255);
  text(label, x, y);
}

boolean overButton(float x, float y, float w, float h) {
  return mouseX > x - w/2 && mouseX < x + w/2 && mouseY > y - h/2 && mouseY < y + h/2;
}

boolean checkWinCondition() {
  for (GameObject obj : objects) {
    if (obj instanceof Asteroid && obj.lives > 0) {
      return false;
    }
  }
  return true;
}
