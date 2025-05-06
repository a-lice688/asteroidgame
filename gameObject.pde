class GameObject {
  PVector loc, vel;
  int lives;
  float d;

  GameObject(PVector loc, PVector vel) {
    this.loc = loc.copy();
    this.vel = vel.copy();
    lives = 1;
  }

  GameObject(PVector loc, PVector vel, int _lives) {
    this.loc = loc.copy();
    this.vel = vel.copy();
    lives = _lives;
  }

  void act() {
  }

  void show() {
  }

  void wrapAround() {
    if (loc.x < 0) loc.x = width;
    if (loc.x > width) loc.x = 0;
    if (loc.y < 0) loc.y = height;
    if (loc.y > height) loc.y = 0;
  }
}
