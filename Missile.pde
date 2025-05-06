class Missile extends GameObject {
  GameObject target;

  Missile(PVector start) {
    super(start.copy(), new PVector());
    target = player1;
  }

  void act() {
    findTarget();
    chaseTarget();
    checkForCollisions();
    checkDodgingTimeout();

    if (loc.x < 0 || loc.x > width || loc.y < 0 || loc.y > height) {
      lives = 0;
    }
  }

  void show() {
    fill(255, 50, 50);
    ellipse(loc.x, loc.y, 10, 10);
  }

  void findTarget() {
    if (target == null || target.lives == 0 || target instanceof Spaceship) {
      ArrayList<GameObject> flares = new ArrayList<GameObject>();
      for (GameObject obj : objects) {
        if (obj instanceof Flare) {
          flares.add(obj);
        }
      }

      if (!flares.isEmpty()) {
        target = flares.get((int)random(flares.size()));
        dodgingMissile = false;
      } else {
        target = player1;
        if (!dodgingMissile) {
          dodgingMissile = true;
          missileLockTime = 0;
        }
      }
    }
  }

  void chaseTarget() {
    loc.add(vel);
    PVector dir = PVector.sub(target.loc, loc);
    dir.setMag(0.5);
    vel.add(dir);
    vel.limit(2);
  }

  void checkForCollisions() {
    if (target instanceof Flare && dist(loc.x, loc.y, target.loc.x, target.loc.y) < 10) {
      target.lives = 0;
      lives = 0;
      objects.add(new Explosion(loc.copy()));
    }

    if (target instanceof Spaceship && dist(loc.x, loc.y, target.loc.x, target.loc.y) < 20) {
      player1.lives = 0;
      lives = 0;
    }
  }

  void checkDodgingTimeout() {
    if (dodgingMissile) missileLockTime++;
    if (dodgingMissile && missileLockTime > 900) {
      lives = 0;
      objects.add(new Explosion(loc.copy()));
      dodgingMissile = false;
    }
  }
}
