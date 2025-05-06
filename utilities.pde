void drawIntro() {
  background(0);
  fill(neonBlue);
  textSize(32);
  text("ASTEROID GAME", width/2, height/2 - 40);
  textSize(18);
  text("Press ENTER to Start", width/2, height/2 + 10);
}

void drawPause() {
  fill(yellow);
  text("Paused - Press P to Resume", width/2, height/2);
}

void drawWinScreen() {
  background(0);
  levelEndTime = millis();
  int timeTaken = (levelEndTime - levelStartTime) / 1000;

  fill(magenta);
  text("LEVEL " + currentLevel + " COMPLETE!", width/2, height/2 - 60);
  text("Time: " + timeTaken + "s", width/2, height/2 - 30);
  text("Ammo Used: " + currentBulletsUsed, width/2, height/2);

  // Store best records
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
  text("GAME OVER", width/2, height/2 - 20);
  text("Press ENTER to Retry Level", width/2, height/2 + 20);
}

void drawLevelComplete() {
  background(0);
  int timeSoFar = totalTimeTaken / 1000;

  fill(magenta);
  text("LEVEL " + currentLevel + " COMPLETE!", width/2, height/2 - 60);
  text("Time So Far: " + timeSoFar + "s", width/2, height/2 - 30);
  text("Ammo Used So Far: " + totalBulletsUsed, width/2, height/2);

  // Buttons
  drawButton("Next Level", width/2, height/2 + 40, 150, 40);
  drawButton("Retry Level", width/2, height/2 + 90, 150, 40);
  drawButton("Return to Home", width/2, height/2 + 140, 150, 40);
}

void drawGameComplete() {
  background(0);
  int finalTime = totalTimeTaken / 1000;

  fill(yellow);
  text("GAME COMPLETE!", width/2, height/2 - 60);
  text("Total Time: " + finalTime + "s", width/2, height/2 - 30);
  text("Total Ammo Used: " + totalBulletsUsed, width/2, height/2);

  drawButton("Return to Home", width/2, height/2 + 60, 200, 50);
}
