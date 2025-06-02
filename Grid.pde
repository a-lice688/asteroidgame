class TeleportGrid {

  int cols, rows;
  float gridSize;
  boolean[][] unsafe;

  TeleportGrid(float initGridSize) {
    this.gridSize = initGridSize;
    cols = int(width / initGridSize) + 1; // covers the remainder pixels
    rows = int(height / initGridSize) + 1;
    unsafe = new boolean[cols][rows];
  }

  void update() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        unsafe[i][j] = false;
      }
    }

    for (GameObject obj : objects) {
      if (obj instanceof Asteroid || obj instanceof UFO || obj instanceof Missile || (obj instanceof Bullet && !((Bullet)obj).fromPlayer)) {

        int currX = int(obj.loc.x / gridSize);
        int currY = int(obj.loc.y / gridSize);

        if (obj.d > 120) {
          for (int deltaX = -1; deltaX <= 2; deltaX++) {
            for (int deltaY = -1; deltaY <= 2; deltaY++) {
              int nextX = currX + deltaX;
              int nextY = currY + deltaY;
              if (nextX >= 0 && nextX < cols && nextY >= 0 && nextY < rows) {
                unsafe[nextX][nextY] = true;
              }
            }
          }
        } else {
          for (int deltaX = 0; deltaX <= 1; deltaX++) {
            for (int deltaY = 0; deltaY <= 1; deltaY++) {
              int nextX = currX + deltaX;
              int nextY = currY + deltaY;
              if (nextX >= 0 && nextX < cols && nextY >= 0 && nextY < rows) {
                unsafe[nextX][nextY] = true;
              }
            }
          }
        }
      }
    }
  }



    boolean isSafe(PVector pos) {
      int gridX = int(pos.x / gridSize);
      int gridY = int(pos.y / gridSize);

      if (gridX < 0 || gridX >= cols || gridY < 0 || gridY >= rows) {
        return false;
      }

      return !unsafe[gridX][gridY];
    }

    void display() {
      noFill();
      stroke(80);
      for (int i = 0; i < cols; i++) {
        for (int j = 0; j < rows; j++) {
          rect(i * gridSize, j * gridSize, gridSize, gridSize);
          if (unsafe[i][j]) {
            fill(255, 0, 0, 60);
            rect(i * gridSize, j * gridSize, gridSize, gridSize);
            noFill();
          }
        }
      }
    }
  }
