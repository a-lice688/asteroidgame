public class Upgrade extends GameObject {

  int upgradeType;
  int timer = int(random(300, 600));

  public Upgrade() {
    super(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)));
    vel.setMag(random(0.5, 1.5));
  }


  void act() {

    timer--;

    if (timer <= 0) {
      lives = 0;
    }
  }

  public int generate() {
    int type = -1;
    if (checkForCollisions()) {
      type = int(random(3));
    }
    return type;
  }


  void show() {
    pushStyle();
    fill(yellow);
    stroke(yellow);
    circle(loc.x, loc.y, 50);
    popStyle();
  }


  boolean checkForCollisions() {
    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);

      if (obj instanceof Spaceship) {
        if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < d/2 + 20) {
          return true;
        }
      }
    }
    return false;
  }
}
