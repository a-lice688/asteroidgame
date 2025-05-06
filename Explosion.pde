class Explosion extends GameObject {
  int timer = 15;

  Explosion(PVector loc) {
    super(loc, new PVector(), 1);
  }

  void act() {
    timer--;
    if (timer <= 0) lives = 0;
  }

  void show() {
    fill(255, 100, 0, map(timer, 0, 15, 0, 255));
    noStroke();
    ellipse(loc.x, loc.y, 30, 30);
  }
}
