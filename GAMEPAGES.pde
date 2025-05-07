void drawGame() {
  ufoSpawnTimer++;
  boolean ufoExists = false;
  boolean missileExists = false;

  for (GameObject obj : objects) {
    if (obj instanceof UFO) ufoExists = true;
    if (obj instanceof Missile) missileExists = true;
  }

  if (!ufoExists) {
    ufoSpawnTimer++;
    if (ufoSpawnTimer >= ufoSpawnInterval) {
      objects.add(new UFO());
      ufoSpawnTimer = 0;
      ufoSpawnInterval = int(random(600, 1000));
    }
  } else {
    ufoSpawnTimer = 0;
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
}

void drawButton(String label, float x, float y, float w, float h) {
  fill(50);
  rect(x, y, w, h, 10);
  fill(255);
  text(label, x, y);
}

void mousePressed() {
  if (gameMode == LEVEL_COMPLETE) {
    if (overButton(width/2, height/2 + 40, 150, 40)) {
      currentLevel++;
      resetGame();
      gameMode = GAME;
    } else if (overButton(width/2, height/2 + 90, 150, 40)) {
      resetGame();
      gameMode = GAME;
    } else if (overButton(width/2, height/2 + 140, 150, 40)) {
      gameMode = INTRO;
    }
  } else if (gameMode == GAME_COMPLETE) {
    if (overButton(width/2, height/2 + 60, 200, 50)) {
      gameMode = INTRO;
    }
  }
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


void drawLives(int lives) {
  for (int i = 0; i < lives; i++) {
    float x = 30 + i * 20;
    float y = 30;
    fill(magenta);
    stroke(255);
    triangle(x, y - 10, x - 7, y + 7, x + 7, y + 7);
  }
}

void drawFlareCount() {

  pushStyle();
  fill(255, 150, 0);
  textAlign(RIGHT, TOP);
  textSize(16);
  text("Flares left: " + (maxFlares - flaresUsed), width - 10, 10);
  popStyle();
}

void drawMissileCountdown() {
  pushStyle();
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  textSize(30);
  int secondsLeft = max(0, 15 - missileLockTime / 60);
  text("DODGE! " + secondsLeft, width / 2, height / 2);
  popStyle();
}
