class Bullet extends GameObject {
  boolean fromPlayer;
  int timer;

  Bullet(PVector loc, PVector dir, boolean fromPlayer) {
    super(loc, dir.copy().setMag(8), 1);
    this.fromPlayer = fromPlayer;
    d = 8;
    timer = 200;
  }
 
  //UFO bullets
  Bullet(PVector loc, PVector dir) {
    super(loc, dir.copy().setMag(6), 1);
    this.fromPlayer = false;
    d = 6;
    timer = 400;
  }

  void act() {
    loc.add(vel);
    timer--;
    if (timer == 0) lives = 0;
    if (fromPlayer) wrapAround();
  }

  void show() {
    if (fromPlayer) {
      fill(magenta);
      stroke(255);
      circle(loc.x, loc.y, d + 3);
    } else {
      fill(255);
      stroke(255);
      circle(loc.x, loc.y, d + 5);
    }
  }
}
