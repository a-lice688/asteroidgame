class Spaceship extends GameObject {
  int lives = 10;

  int invulTimer = 0;

  boolean isThrusting = false;
  int thrustingTimer = 0;
  int thrustingDuration = 28;
  int thrustCooldownTimer;
  int thrustInterval = 100;

  int shootCooldown;
  PVector dir;

  int teleportInterval;
  int teleportCooldown = 600;

  boolean pulseActive = false;
  boolean pulsePushed = false;

  int pulseTimer = 80;



  /* key "d" -> (If thrustCooldown == 0)
   thrusting = true,
   thrustingCountdown = thrustTime
   
   While (thrusting == true)
   thrustingCountdown--,
   if (thrustingCountdown == 0)
   thrust ends,
   thrustCooldown = thrustCooldownTime
   
   While thrustCooldown > 0
   thrusting = false;
   */

  Spaceship() {
    super(new PVector(width / 2, height / 2), new PVector(0, 0));
    dir = new PVector(1, 0);
    shootCooldown = 0;
    teleportInterval = 0;
    d = 60;
  }

  void show() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(dir.heading());
    drawShip();
    popMatrix();

    if (pulseActive) drawPulse();
  }


  void act() {

    move();
    shoot();
    wrapAround();
    checkForCollisions();

    if (invulTimer > 0) {
      invulTimer--;
    }

    if (pulseActive) {
      pulseTimer--;
      if (pulseTimer <= 0) pulseActive = false;
    } else {
      pulsePushed = false;
    }

    if (teleportInterval > 0) {
      teleportInterval--;
    }
  }

  void move() {
    loc.add(vel);

    //speed limit
    float maxSpeed = 8.5;
    if (vel.mag() > maxSpeed) vel.setMag(maxSpeed);

    //acceleration
    if (upkey) {
      vel.add(dir.copy().mult(0.3));
      drawMovingParticles(loc, dir);
    }

    thrust();

    //deceleration
    vel.mult(0.97);

    //rotations
    if (leftkey) {
      dir.rotate(-radians(3));
      drawMovingParticles(loc, dir);
    }

    if (rightkey) {
      dir.rotate(radians(3));
      drawMovingParticles(loc, dir);
    }

    //shield
    if (downkey && invulTimer == 0) {
      invulTimer = 60;
    }
  }

  void thrust() {
    if (isThrusting && thrustingTimer > 0) {
      vel.add(dir.copy().mult(1));
      thrustingTimer--;
      if (thrustingTimer == 0) {
        isThrusting = false;
        thrustCooldownTimer = thrustInterval;
      }
    } else if (!isThrusting && thrustCooldownTimer > 0) {
      thrustCooldownTimer--;
    }
  }

  void shoot() {
    shootCooldown--;
    if (spacekey && shootCooldown <= 0) {
      strokeWeight(2);
      PVector bulletLoc = loc.copy();
      PVector bulletVel = dir.copy();
      objects.add(new Bullet(bulletLoc, bulletVel, true));
      shootCooldown = 15;
      currentBulletsUsed++;
    } else {
      strokeWeight(1);
    }
  }

  void teleport() {
    ArrayList<PVector> safeCells = new ArrayList<PVector>();

    for (int col = 0; col < grid.cols; col++) {
      for (int row = 0; row < grid.rows; row++) {
        if (!grid.unsafe[col][row]) {
          float x = col * grid.gridSize + grid.gridSize / 2;
          float y = row * grid.gridSize + grid.gridSize / 2;
          PVector candidate = new PVector(x, y);
          if (dist(candidate.x, candidate.y, loc.x, loc.y) > 100) {
            safeCells.add(candidate);
          }
        }
      }
    }

    if (safeCells.size() > 0) {
      int choice = int(random(safeCells.size()));
      loc = safeCells.get(choice);
    } else {
      println("No safe spot, try again later!");
    }
  }




  void reset() {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    dir = new PVector(1, 0);
    isThrusting = false;
    thrustingTimer = 0;
  }

  @Override
    void wrapAround() {
    float m = 1;

    if (loc.x < 0) {
      loc.x = width - m;
      loc.y = height - loc.y;
    } else if (loc.x > width) {
      loc.x = m;
      loc.y = height - loc.y;
    }

    if (loc.y < 0) {
      loc.y = height - m;
      loc.x = width - loc.x;
    } else if (loc.y > height) {
      loc.y = m;
      loc.x = width - loc.x;
    }
  }

  void checkForCollisions() {
    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);

      // Bullet collisions
      if (obj instanceof Bullet) {
        Bullet b = (Bullet) obj;
        if (!b.fromPlayer && dist(loc.x, loc.y, b.loc.x, b.loc.y) < d / 2 + b.d / 2) {
          if (invulTimer == 0) {
            lives--;
            invulTimer = 90; // 1.5 secs
          }
          b.lives = 0;
        }
      }

      // UFO collisions -> instant death
      else if (obj instanceof UFO) {
        if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < 30) {
          lives = 0;
          obj.lives = 0;
        }
      }

      // Missile collisions -> instant death
      else if (obj instanceof Missile) {
        if (dist(loc.x, loc.y, obj.loc.x, obj.loc.y) < 20) {
          lives = 0;
          obj.lives = 0;
        }
      } else if (obj instanceof Upgrade) {
        Upgrade upg = (Upgrade) obj;

        switch(upg.generate()) {
        case 0: // 5 secs invulnerability
          if (invulTimer <= 0) {
            invulTimer = 300;
            upg.lives = 0;
          }
          break;

        case 1: // bullet spamming into all directions for 3 secs
          for (int j = 0; j < 360; j += 15) {
            PVector dir = PVector.fromAngle(radians(j));
            dir.setMag(7);
            objects.add(new Bullet(loc.copy(), dir, true));
            upg.lives = 0;
          }

          break;

        case 2: // gravitational push
          for (GameObject object : objects) {
            if (object != this && !(object instanceof Bullet && ((Bullet)object).fromPlayer)) {
              float dx = object.loc.x - loc.x;
              float dy = object.loc.y - loc.y;
              float dist = sqrt(dx * dx + dy * dy);
              if (dist > 0) {
                float strength = map(dist, 0, width * 0.5, 5, 0.5);
                PVector force = new PVector(dx, dy).normalize().mult(strength);
                object.vel.add(force);

                object.vel.mult(0.4);
              }
            }
          }
          pulseActive = true;
          pulseTimer = 80;
          upg.lives = 0;
          break;
        }
      }
    }
  }


  void drawShip() {
    stroke(255);
    fill(180); // body

    // Main body
    beginShape();
    vertex(30, 0); // nose
    vertex(10, 12);
    vertex(-20, 8);
    vertex(-20, -8);
    vertex(10, -12);
    endShape(CLOSE);

    // Wings
    fill(150);
    beginShape();
    vertex(10, -12);
    vertex(-5, -30);
    vertex(-12, -28);
    vertex(-20, -8);
    endShape(CLOSE);

    beginShape();
    vertex(10, 12);
    vertex(-5, 30);
    vertex(-12, 28);
    vertex(-20, 8);
    endShape(CLOSE);

    // Cockpit
    fill(neonBlue);
    beginShape();
    vertex(5, -6);
    vertex(15, 0);
    vertex(5, 6);
    vertex(0, 0);
    endShape(CLOSE);

    // Red thing on the cockpit
    fill(255, 0, 0);
    triangle(20, -6, 20, 6, 10, 0);

    // Fire
    if (isThrusting && thrustingTimer > 0) {
      noStroke();
      for (int i = 0; i < 3; i++) {
        float flicker = random(4, 10);
        fill(255, 100, 0, 150); // orange fire
        ellipse(-25, 0, flicker * 2, flicker); // long fire

        fill(255, 200, 0, 100); // yellow inner fire
        ellipse(-20, 0, flicker, flicker / 2);
      }
    }

    if (invulTimer > 0) {
      pushStyle();
      noFill();
      float fading = map(invulTimer, 60, 0, 255, 0);
      stroke(neonBlue, fading);
      strokeWeight(2);
      ellipse(0, 0, 70, 70);
      popStyle();
    }
  }
  void drawPulse() {
    float radius = map(pulseTimer, 80, 0, 0, width * 1);
    pushStyle();
    noFill();
    stroke(255, 255, 100, 180);
    strokeWeight(3);
    ellipse(loc.x, loc.y, radius, radius);
    popStyle();
  }
}
