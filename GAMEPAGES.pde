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

  for (int i = objects.size() - 1; i >= 0; i--) {
    GameObject obj = objects.get(i);
    if (obj.lives == 0 && !(obj instanceof Spaceship)) {
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

void drawTeleportCooldown() {

  pushStyle();
  float barWidth = 200;
  float barHeight = 20;

  float x = 50 + barWidth / 2;
  float y = height - 50;

  float percent = 1 - (float) player1.teleportInterval / player1.teleportCooldown;
  float currentWidth = barWidth * percent;

  stroke(255);
  noFill();
  rectMode(CENTER);
  rect(x, y, barWidth, barHeight);

  noStroke();
  fill(255);
  rectMode(CORNER);
  rect(x - barWidth / 2, y - barHeight / 2, currentWidth, barHeight);
  popStyle();
}
