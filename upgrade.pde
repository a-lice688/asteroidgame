public class Upgrade extends GameObject {

  int upgradeType;
  int timer = int(random(300, 600));
  boolean showPulse = false;
  int pulseTimer = 0;

  Upgrade() {
    super(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)));
    vel.setMag(random(0.5, 1.5));
    d = 50;
  }

  void act() {
    if (!showPulse) {
      timer--;
      if (timer <= 0) {
        lives = 0;
      }
    } else {
      pulseTimer--;
      if (pulseTimer <= 0) {
        showPulse = false;
        lives = 0;
      }
    }

    loc.add(vel);
    wrapAround();
  }

  int generate() {
    int type = -1;
    if (checkForCollisions()) {
      type = int(random(3));
    }
    return type;
  }

  void show() {
    /*

     if (showPulse) {
     pulseRing();
     }
     
     */

    pushMatrix();
    translate(loc.x, loc.y);
    pushStyle();

    float pulse = 10 + 5 * sin(frameCount * 0.1);
    float angle = frameCount * 0.02;

    noStroke();
    fill(255, 255, 100, 40);
    ellipse(0, 0, d + pulse, d + pulse);

    stroke(255, 255, 150, 100);
    strokeWeight(2);
    noFill();
    pushMatrix();
    rotate(angle);
    ellipse(0, 0, d + 10, d + 10);
    popMatrix();

    stroke(yellow);
    strokeWeight(2);
    fill(255, 255, 100);
    ellipse(0, 0, d, d);

    fill(255, 255, 255, 200);
    noStroke();
    ellipse(0, 0, d * 0.35, d * 0.35);

    stroke(255, 255, 200, 120);
    for (int i = 0; i < 8; i++) {
      float a = angle + i * TWO_PI / 8;
      float x = cos(a) * d * 0.6;
      float y = sin(a) * d * 0.6;
      point(x, y);
    }

    popStyle();
    popMatrix();
  }


  boolean checkForCollisions() {
    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);
      if (obj instanceof Spaceship) {
        if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < d / 2 + 20) {
          return true;
        }
      }
    }
    return false;
  }

  void triggerPulse() {
    showPulse = true;
    pulseTimer = 30;
  }
}
