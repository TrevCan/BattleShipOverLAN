class Player {

  private Ship[] ships = new Ship[10];
  boolean isReady;

  public Player(boolean isOtherPlayer) {
    isReady = false;
    if (isOtherPlayer) {
      for (int i = 0; i < 10; i++) {
        ships[i] = new Ship(1, -25, -25, isOtherPlayer);
        ships[i].setHeading(90);
      }
    } else {
      int c = 0;
      int units = 1;
      for (int i = 4; i > 0; i--) {      
        for (int j = i; j > 0; j--) {
          if ( c % 2 == 0) {
            ships[c] = new Ship(units, 25 + Constants.cellWidth * c, 25, isOtherPlayer); 
            ships[c].turn(true);
          } else {
            ships[c] = new Ship(units, 25 + Constants.cellWidth * c, height - 25, isOtherPlayer); 
            ships[c].setHeading(270);
          }
          c++;
        }
        units++;
      }
    }
  }

  public void render() {
    for (Ship ship : getShips()) {
      ship.render();
    }
  }

  private Ship[] getShips() {
    return this.ships;
  }

  public Ship getActiveShip(int x, int y) {
    for (int i = 0; i < getShips().length; i++) {
      if (getShips()[i].isHere(x, y)) {
        return getShips()[i];
      }
    }
    return null;
  }
  public int getActiveShipIndex(int x, int y) {
    for (int i = 0; i < getShips().length; i++) {
      if (getShips()[i].isHere(x, y)) {
        return i;
      }
    }
    return -1;
  }
}
