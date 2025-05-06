class UFO extends GameObject {
  int shootCooldown = 200;
  int missileTimer;
  boolean firedMissile = false;

  UFO() {
    super(new PVector(), new PVector());
    loc = randomEdgePosition();
    vel = randomDirection();
    lives = 5;
    missileTimer = int(random(180, 600));
  }

  void act() {
    loc.add(vel);

    shootCooldown--;
    missileTimer--;

    if (shootCooldown <= 0) {
      shootAtPlayer();
      shootCooldown = 200;
    }

    if (!firedMissile && missileTimer <= 0) {
      fireMissile();
      firedMissile = true;
    }

    checkHits();
    checkOutOfBounds();
  }

  void show() {
    pushMatrix();
    translate(loc.x, loc.y);
    scale(0.7);
    drawUFO();
    popMatrix();
  }

  void shootAtPlayer() {
    PVector toPlayer = PVector.sub(player1.loc, loc);
    toPlayer.setMag(2);
    objects.add(new Bullet(loc.copy(), toPlayer, false));
  }

  void fireMissile() {
    objects.add(new Missile(loc.copy()));
  }

  void checkHits() {
    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);
      if (obj instanceof Bullet) {
        Bullet b = (Bullet) obj;
        if (b.fromPlayer && dist(loc.x, loc.y, b.loc.x, b.loc.y) < 35) {
          lives--;
          b.lives = 0;
          if (lives <= 0) {
            objects.add(new Explosion(loc.copy()));
          }
        }
      }
    }
  }

  void checkOutOfBounds() {
    if (loc.x < -100 || loc.x > width + 100 || loc.y < -100 || loc.y > height + 100) {
      lives = 0;
    }
  }

  void drawUFO() {
    fill(100);
    stroke(255);
    ellipse(0, 10, 70, 25);
    fill(180);
    arc(0, 5, 90, 40, PI, TWO_PI);
    fill(160, 255, 160);
    stroke(255);
    rectMode(CENTER);
    rect(0, -15, 40, 45, 20);
    fill(0);
    ellipse(-8, -20, 8, 8);
    ellipse(8, -20, 8, 8);
    stroke(0);
    line(-10, -5, 10, -5);
    for (int i = -8; i <= 8; i += 4) {
      line(i, -5, i, 0);
    }
  }

  PVector randomEdgePosition() {
    int edge = int(random(4));
    switch (edge) {
    case 0:
      return new PVector(0, random(height));         // Left
    case 1:
      return new PVector(width, random(height));     // Right
    case 2:
      return new PVector(random(width), 0);          // Top
    case 3:
      return new PVector(random(width), height);     // Bottom
    }
    return new PVector(width/2, height/2);
  }

  PVector randomDirection() {
    PVector target = new PVector(random(width), random(height));
    PVector dir = PVector.sub(target, loc);
    dir.setMag(1.5);
    return dir;
  }
}
