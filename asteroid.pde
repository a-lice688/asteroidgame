class Asteroid extends GameObject {

  float rotate;
  float angle;

  Asteroid() {
    super(new PVector(random(width), random(height)), new PVector(random(-1, 1), random(-1, 1)), 3);
    vel.setMag(random(1, 2));
    d = lives * 30;

    rotate = random(-2, 2);
    angle = 0;
  }

  Asteroid(float x, float y, int lives) {
    super(new PVector(x, y), new PVector(random(-1, 1), random(-1, 1)), lives);
    vel.setMag(random(1, 2));
    d = lives * 30;

    rotate = random(-2, 2);
    angle = 0;
  }

  void show() {
    drawAsteroid();
  }

  void act() {
    loc.add(vel);
    wrapAround();
    checkForCollisions();
  }

  void checkForCollisions() {
    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);

      if (obj instanceof Bullet) {
        Bullet b = (Bullet) obj;
        if (b.fromPlayer && dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < d / 2 + obj.d / 2) {
          if (lives > 1) {
            objects.add(new Asteroid(loc.x, loc.y, lives - 1));
            objects.add(new Asteroid(loc.x, loc.y, lives - 1));
          }
          lives = 0;
          obj.lives = 0;
        }
      } else if (obj instanceof Spaceship) {
        if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < d/2 + 20) {
          if (player1.invulTimer == 0) {
            player1.lives--;
            player1.invulTimer = 60;
          }
          if (player1.lives > 0 && lives > 1) {
            objects.add(new Asteroid(loc.x, loc.y, lives - 1));
            objects.add(new Asteroid(loc.x, loc.y, lives - 1));
          }
          lives = 0;
          obj.lives = 0;
        }
      }
    }
  }


  void drawAsteroid() {
    pushStyle();
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(radians(angle));

    stroke(200);
    strokeWeight(2);
    fill(150);
    beginShape();
    vertex(0, -d * 0.5);
    vertex(d * 0.4, -d * 0.3);
    vertex(d * 0.3, d * 0.3);
    vertex(-d * 0.2, d * 0.4);
    vertex(-d * 0.5, 0);
    vertex(-d * 0.4, -d * 0.3);
    endShape(CLOSE);

    noStroke();
    fill(170);
    beginShape();
    vertex(-d * 0.1, -d * 0.1);
    vertex(d * 0.2, -d * 0.05);
    vertex(d * 0.1, d * 0.1);
    vertex(-d * 0.1, d * 0.05);
    endShape(CLOSE);

    ellipse(-d * 0.05, d * 0.05, d / 6, d / 6);
    ellipse(d * 0.1, d * 0.1, d / 8, d / 8);

    popMatrix();
    popStyle();

    angle += rotate;
  }
}
