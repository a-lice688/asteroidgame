class Spaceship extends GameObject {
  int lives = 3;

  int invulTimer = 0;

  boolean isThrusting = false;
  int thrustingCountdown = 0;
  int thrustTime = 35;
  int thrustCooldown;
  int thrustCooldownTime = 100;

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

  int shootCooldown;
  PVector dir;

  Spaceship() {
    super(new PVector(width / 2, height / 2), new PVector(0, 0));
    dir = new PVector(1, 0);
    shootCooldown = 0;
  }

  void show() {
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(dir.heading());
    drawShip();
    popMatrix();
  }


  void act() {
    move();
    shoot();
    wrapAround();
    checkForCollisions();

    if (invulTimer > 0) {
      invulTimer--;
    }
  }

  void move() {
    loc.add(vel);

    //speed limit
    float maxSpeed = 5;
    if (vel.mag() > maxSpeed) vel.setMag(maxSpeed);

    //acceleration
    if (upkey) vel.add(dir.copy().mult(0.07));
    thrust();

    //deceleration
    vel.mult(0.97);

    //rotations
    if (leftkey) dir.rotate(-radians(3));
    if (rightkey) dir.rotate(radians(3));

    //shield
    if (downkey && invulTimer == 0) {
      invulTimer = 60;
    }
  }

  void thrust() {
    if (isThrusting && thrustingCountdown > 0) {
      vel.add(dir.copy().mult(1));
      thrustingCountdown--;
      if (thrustingCountdown == 0) {
        isThrusting = false;
        thrustCooldown = thrustCooldownTime;
      }
    } else if (!isThrusting && thrustCooldown > 0) {
      thrustCooldown--;
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

  void reset() {
    loc = new PVector(width/2, height/2);
    vel = new PVector(0, 0);
    dir = new PVector(1, 0);
    isThrusting = false;
    thrustingCountdown = 0;
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
    if (isThrusting && thrustingCountdown > 0) {
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
}
