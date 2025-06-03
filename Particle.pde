class Particle extends GameObject {
  float opacity;
  color col;
  float size;

  Particle(PVector loc, PVector vel, color col, float size) {
    super(loc.copy(), vel.copy());
    this.col = col;
    this.size = size;
    this.opacity = 255;
  }

  void act() {
    loc.add(vel);
    opacity -= 4;
    if (opacity <= 0) {
      lives = 0;
    }
  }

  void show() {
    noStroke();
    fill(col, opacity);
    ellipse(loc.x, loc.y, size, size);
  }
}

//outside of the class

void drawUFOParticles(PVector center) {
  for (int i = 0; i < 25; i++) {
    float vx = random(-3, 3);
    float vy = random(-3, 3);
    PVector vel = new PVector(vx, vy);
    color[] ufoColours = {color(0, 255, 255), color(255, 0, 255), color(255, 255, 255)};
    color col = ufoColours[int(random(ufoColours.length))];
    objects.add(new Particle(center, vel, col, random(5, 12)));
  }
}

void drawAsteroidParticles(PVector center) {
  for (int i = 0; i < 20; i++) {
    float vx = random(-3, 3);
    float vy = random(-3, 3);
    PVector vel = new PVector(vx, vy);
    color[] asteroidColours = {color(150, 150, 150), color(100, 100, 100), color(200, 200, 200)};
    color col = asteroidColours[int(random(asteroidColours.length))];
    objects.add(new Particle(center, vel, col, random(5, 10)));
  }
}

void drawMovingParticles(PVector center, PVector dir) {
  for (int i = 0; i < 10; i++) {
    PVector offset = PVector.fromAngle(dir.heading() + PI).mult(10);
    PVector pos = center.copy().add(offset);
    PVector vel = dir.copy().rotate(random(-PI/4, PI/4)).mult(-random(0.5, 2));
    color[] movingColours = {color(0, 150, 255), color(100, 200, 255), color(neonBlue)};
    color col = movingColours[int(random(movingColours.length))];
    objects.add(new Particle(pos, vel, col, random(4, 8)));
  }
}
