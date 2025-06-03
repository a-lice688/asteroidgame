void drawIntro() {
  background(0);
  fill(neonBlue);
  textSize(32);
  textFont(customFont);
  text("ASTEROID GAME", width/2, height/2 - 40);
  textSize(18);
  text("Press ENTER to Start", width/2, height/2 + 10);
}

void drawPause() {
  background(0);
  fill(yellow);
  textFont(customFontItalic);
  textSize(32);
  text("Paused - Press P to Resume", width/2, height/2);
}

void drawWinScreen() {
  background(0);
  levelEndTime = millis();
  int timeTaken = (levelEndTime - levelStartTime) / 1000;

  fill(magenta);
  textFont(customFont);
  textSize(28);
  text("LEVEL " + currentLevel + " COMPLETE!", width/2, height/2 - 60);
  text("Time: " + timeTaken + "s", width/2, height/2 - 30);
  text("Ammo Used: " + currentBulletsUsed, width/2, height/2);

  if (bestTimes[currentLevel] == 0 || timeTaken < bestTimes[currentLevel]) {
    bestTimes[currentLevel] = timeTaken;
  }
  if (bestAmmo[currentLevel] == 0 || currentBulletsUsed < bestAmmo[currentLevel]) {
    bestAmmo[currentLevel] = currentBulletsUsed;
  }

  if (currentLevel < maxLevel) {
    text("Press ENTER to Continue", width/2, height/2 + 40);
  } else {
    text("GAME COMPLETE! Press ENTER to Restart", width/2, height/2 + 40);
  }
}

void drawLoseScreen() {
  background(0);
  fill(neonOrange);
  textFont(customFont);
  textSize(32);
  text("GAME OVER", width/2, height/2 - 20);
  text("Press ENTER to Retry Level", width/2, height/2 + 20);
}

void drawLevelComplete() {
  background(0);
  int timeSoFar = totalTimeTaken / 1000;

  fill(magenta);
  textFont(customFont);
  textSize(28);
  text("LEVEL " + currentLevel + " COMPLETE!", width/2, height/2 - 60);
  text("Time So Far: " + timeSoFar + "s", width/2, height/2 - 30);
  text("Ammo Used So Far: " + totalBulletsUsed, width/2, height/2);

  drawButton("Next Level", width/2, height/2 + 40, 150, 40);
  drawButton("Retry Level", width/2, height/2 + 90, 150, 40);
  drawButton("Return to Home", width/2, height/2 + 140, 150, 40);
}

void drawGameComplete() {
  background(0);
  int finalTime = totalTimeTaken / 1000;

  fill(yellow);
  textFont(customFont);
  textSize(32);
  text("GAME COMPLETE!", width/2, height/2 - 60);
  text("Total Time: " + finalTime + "s", width/2, height/2 - 30);
  text("Total Ammo Used: " + totalBulletsUsed, width/2, height/2);

  drawButton("Return to Home", width/2, height/2 + 60, 200, 50);
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

//default font
void drawFlareCount() {
  pushStyle();
  textFont(createFont("Arial", 16));
  fill(255, 150, 0);
  textAlign(RIGHT, TOP);
  text("Flares left: " + flaresLeft, width - 10, 10);
  popStyle();
}

//default font
void drawMissileCountdown() {
  pushStyle();
  textFont(createFont("Arial", 30));
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  int secondsLeft = max(0, 15 - missileLockTime / 60);
  text("DODGE! " + secondsLeft, width / 2, height / 2);
  popStyle();
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
