//Alice Wang
//April 1

import java.util.ArrayList;

PFont customFont;
PFont customFontItalic;

color neonBlue = color(0, 255, 255);
color magenta = color(255, 0, 255);
color yellow = color(255, 255, 51);
color neonOrange = color(255, 95, 31);

final int INTRO = 0;
final int GAME = 1;
final int PAUSE = 2;
final int LEVEL_COMPLETE = 3;
final int GAME_COMPLETE = 4;
final int GAMEOVER_LOSE = 5;

int gameMode = INTRO;

int currentLevel = 1;
int maxLevel = 3;
int[] levelAsteroidCounts = {0, 3, 5, 8};

int levelStartTime;
int gameStartTime;
int levelEndTime; //delete this tomorrow
int totalTimeTaken; //delete this tomorrow

int currentBulletsUsed = 0;
int totalBulletsUsed = 0;

int[] bestTimes = new int[4];
int[] bestAmmo = new int[4];

boolean upkey, downkey, leftkey, rightkey, spacekey;

int flaresLeft = 50;         // current usable flares
int totalFlaresUsed = 0;     // total flares used across all levels
int currentFlaresUsed = 0;   // flares used this level
int flaresPerTime = 5;      // how many used per time

int missileLockTime = 0;
boolean dodgingMissile = false;

Spaceship player1;
ArrayList<GameObject> objects;

int ufoSpawnTimer = int(random(180, 300));
int ufoSpawnInterval = 1000;

int upgradeSpawnTimer = int(random(300, 450));
int upgradeSpawnInterval = int(random(450, 600));

TeleportGrid grid;


void setup() {
  size(1000, 800);
  
  customFont = createFont("Monocraft-Light.ttf", 40);
  customFontItalic = createFont("Monocraft-Light-Italic.ttf", 40);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  objects = new ArrayList<GameObject>();
  player1 = new Spaceship();
  grid = new TeleportGrid(80);
}

void draw() {
  background(0);
  switch (gameMode) {
  case INTRO:
    drawIntro();
    break;
  case GAME:
    drawGame();
    break;
  case PAUSE:
    drawPause();
    break;
  case LEVEL_COMPLETE:
    drawLevelComplete();
    break;
  case GAME_COMPLETE:
    drawGameComplete();
    break;
  case GAMEOVER_LOSE:
    drawLoseScreen();
    break;
  }
}
