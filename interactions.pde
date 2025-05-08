void keyPressed() {
  // Movement keys
  if (keyCode == UP) upkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == RIGHT) rightkey = true;

  // reset
  if (key == ENTER) {
    if (gameMode == INTRO || gameMode == GAME_COMPLETE) {
      currentLevel = 1;

      totalFlaresUsed = 0;
      flaresLeft = 50;

      totalBulletsUsed = 0;
      totalTimeTaken = 0;

      gameStartTime = millis();
      levelStartTime = millis();

      resetGame();
      gameMode = GAME;
    } else if (gameMode == GAMEOVER_LOSE) {
      resetGame();
      gameMode = GAME;
    }
  }

  //pause
  if (key == 'p') {
    if (gameMode == GAME) gameMode = PAUSE;
    else if (gameMode == PAUSE) gameMode = GAME;
  }

  //thrust
  if (key == 'd') {
    if (!player1.isThrusting && player1.thrustCooldown == 0 && player1.thrustingCountdown == 0) {
      player1.isThrusting = true;
      player1.thrustingCountdown = player1.thrustTime;
    }
  }

  //flares
  if (key == 'f' && flaresLeft >= flaresPerTime) {
    for (int i = 0; i < flaresPerTime; i++) {
      PVector flareVel = new PVector(random(-1, 1), random(-1, 1)).mult(0.7);
      objects.add(new Flare(player1.loc.copy(), flareVel));
    }
    flaresLeft -= flaresPerTime;
    currentFlaresUsed += flaresPerTime;
    totalFlaresUsed += flaresPerTime;
  }

  //shoot
  if (key == ' ') {
    spacekey = true;
  }

  //shield
  if (keyCode == DOWN) {
    downkey = true;
    if (player1.invulTimer == 0) {
      player1.invulTimer = 60;
    }
  }
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

void keyReleased() {
  if (keyCode == UP) upkey = false;
  if (keyCode == DOWN) downkey = false;
  if (keyCode == LEFT) leftkey = false;
  if (keyCode == RIGHT) rightkey = false;
  if (key == ' ') spacekey = false;
}
