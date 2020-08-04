class Ship {
  private int units;
  private color skinColor;
  //the heading of the PVector is not used,
  //since it is the angle based on the line
  //generated between the position of the vector
  //and the canvas reference and the 0.
  private PVector position; // x and y coordinates from 0 to 9
  private int heading; //angle in degrees
  private int sWidth, sHeight;
  private boolean isDead;
  private boolean[] deadUnits;
  private boolean isOtherPlayerShip;
  public Ship(int units, int posX, int posY, boolean isOtherPlayerShip) {
    this.isOtherPlayerShip = isOtherPlayerShip;
    this.units = units > 0 ? units: 1;
    posX = constrain(posX, Constants.minPosition, Constants.maxWidth);
    posY = constrain(posY, Constants.minPosition, Constants.maxHeight);
    this.position = new PVector(0, 0);
    setPosition(posX, posY);
    setHeading(0);
    sWidth = Constants.shipWidth;
    sHeight = Constants.shipHeight;
    setIsDead(false);
    deadUnits = new boolean[units]; 
    for (boolean unit : deadUnits) {
      unit = false;
    }
  }

  public void render() {

    if (isDead) {
      fill(Constants.deadSkinColor);
    } else 
    fill(Constants.skinColor);
    PVector newPosition = position;
    newPosition.add(Constants.offset);

    if (units == 1) {
      circle(newPosition.x, newPosition.y, sWidth);
    } else {
      for (int i = 0; i < units; i++) {
        if (!(!deadUnits[i] && isOtherPlayerShip)) {
          if (deadUnits[i] || isDead)
            fill(Constants.deadSkinColor);
          else 
          fill(Constants.skinColor);

          switch(heading) {

          case -270:
          case 90:
            rect(newPosition.x, newPosition.y + Constants.cellWidth * i, sWidth, sHeight);
            break;
          case -180:
          case 180:
            rect(newPosition.x - Constants.cellWidth * i, newPosition.y, sWidth, sHeight);
            break;
          case -90:
          case 270:
            rect(newPosition.x, newPosition.y - Constants.cellWidth * i, sWidth, sHeight);
            break;
          default:
            rect(newPosition.x + Constants.cellWidth * i, newPosition.y, sWidth, sHeight);
            break;
          }
        }
      }
    }
  }

  public int getUnits() {
    return this.units;
  }

  public void setUnits(int units) {
    this.units = units;
  }

  public PVector getPosition() {
    return this.position;
  }

  public void setPosition(int posX, int posY) {
    this.position.set(posX, posY);
  }

  public int getHeading() {
    return this.heading;
  }

  public void setHeading(int heading) {
    this.heading = heading;
  }

  //will turn in increments of 90°
  public void turn(boolean clockwise) {
    if (clockwise)
      this.heading += 90;
    else
      this.heading -= 90;

    if (this.heading >= 360 || this.heading <= -360)
      this.heading = 0;
  }

  public void setIsDead(boolean dead) {
    this.isDead = dead;
  }

  public void setDeadUnits(int index) {
    try {

      if (getUnits() == 1)
        isDead = true;
      else {


        deadUnits[index] = true;
        boolean value = false;
        for (boolean b : deadUnits) {
          if (b)
            value = true;
          else {
            value = false;
            return;
          }
        }
        if (value)
          setIsDead(true);
      }
    }
    catch(IndexOutOfBoundsException e) {
      Resources.message("BattleShip has failed!", "You were probably not expecting this, yet an error has occured:\n" + e.toString());
    }
  }

  public boolean[] getDeadUnits() {
    return this.deadUnits;
  }

  public boolean isDead() {
    return isDead;
  }

  public boolean isHere(int x, int y) {
    boolean returnValue = false;
    if (position.x == x && position.y == y) {
      returnValue = true;
    } else if ((position.x == x && units > 1) || (position.y == y && units > 1)) {
      int mouseAxis, axisPosition, relativePosition;
      if (position.x != x) {            
        mouseAxis = x;
        axisPosition = (int)position.x;
      } else {
        mouseAxis = y;
        axisPosition = (int)position.y;
      }
      relativePosition = abs(mouseAxis - axisPosition);
      int unitCount = relativePosition / Constants.cellWidth + 1;
      if (unitCount <= units) {
        returnValue = true;
      }
    }
    return returnValue;
  }

  //function returns the index of the cell
  //which matches the location
  //returns -1 if no cell is there
  public int whoIsHere(int x, int y) {
    int returnValue = -1;
    if (isDead)
      return -1;
    if (position.x == x && position.y == y) {
      returnValue = 0;
    } else if ((position.x == x && units > 1) || (position.y == y && units > 1)) {
      int mouseAxis, axisPosition, relativePosition;
      if (position.x != x) {            
        mouseAxis = x;
        axisPosition = (int)position.x;
      } else {
        mouseAxis = y;
        axisPosition = (int)position.y;
      }
      relativePosition = abs(mouseAxis - axisPosition);
      int unitCount = relativePosition / Constants.cellWidth + 1;
      int selectedIndex = relativePosition / Constants.cellWidth;
      if (unitCount <= units) {
        returnValue = selectedIndex;
      }
    }
    return returnValue;
  }
  String toString() {
    return "X: " + position.x + "  y: " + position.y + "\n"+
      "heading: " + this.heading + "\n"+
      "units: " + this.units;
  }
}
