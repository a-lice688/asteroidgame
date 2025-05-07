void mouseReleased() {
  if (gameMode == INTRO) {
    currentLevel = 1;
    totalBulletsUsed = 0;
    totalTimeTaken = 0;
    globalStartTime = millis();
    resetGame();
    gameMode = GAME;
  } else if (gameMode == PAUSE) {
    gameMode = GAME;
  } else if (gameMode == GAME_COMPLETE || gameMode == GAMEOVER_LOSE) {
    currentLevel = 1;
    totalBulletsUsed = 0;
    totalTimeTaken = 0;
    gameMode = INTRO;
  }
}


void keyPressed() {
  // Movement keys
  if (keyCode == UP) upkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == RIGHT) rightkey = true;

  // reset
  if (key == ENTER) {
    if (gameMode == INTRO || gameMode == GAME_COMPLETE || gameMode == GAMEOVER_LOSE) {
      currentLevel = 1;
      totalBulletsUsed = 0;
      totalTimeTaken = 0;
      globalStartTime = millis();
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
  if (key == 'f' && flaresAvailable > 0 && flaresUsed < maxFlares) {
    for (int i = 0; i < flaresAvailable; i++) {
      PVector flareVel = new PVector(random(-1, 1), random(-1, 1)).mult(0.5);
      objects.add(new Flare(player1.loc.copy(), flareVel));
    }
    flaresUsed += flaresAvailable;
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

void keyReleased() {
  if (keyCode == UP) upkey = false;
  if (keyCode == DOWN) downkey = false;
  if (keyCode == LEFT) leftkey = false;
  if (keyCode == RIGHT) rightkey = false;
  if (key == ' ') spacekey = false;
}
