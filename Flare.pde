class Flare extends GameObject {
  int timer = 400;

  Flare(PVector loc, PVector vel) {
    super(loc, vel.mult(0.9));
  }

  void act() {
    loc.add(vel);
    timer--;
    if (timer <= 0) lives = 0;
  }

  void show() {
    fill(255, 150, 0);
    ellipse(loc.x, loc.y, 8, 8);
  }
}
