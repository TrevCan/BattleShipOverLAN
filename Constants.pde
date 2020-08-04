static class Constants {
  public static final PVector offset = new PVector(0, 0);
  public static final int cellWidth = 50; // the cell width in pixels
  public static final int boardWidth = 10; //board width in cells
  public static final float shipMultiplier = 0.7; //reduction for ship rendering.
  public static final int maxWidth = 500, maxHeight = 500;
  public static final int minPosition = -25;
  public static final int shipWidth = 35;
  public static final int shipHeight = 35;
  public static final int port = 31581;
  public static final color skinColor = #FFFFFF; //white
  public static final color deadSkinColor = #BF1313; //red
  public static final color incorrectPlacingSkinColor = #E36D1E;
  public static final String idleText = "Welcome to BattleShip over LAN!...\n"+
    "You can host a game: [s]\n"+
    "...or join one: [j]\n"+
    "[F1] or [h] to show help message";
  public static final String initServerText = "Welcome to BattleShip over LAN!...\n"+
    "Waiting for another player to join..."+
    "\n"+
    "[F1] or [h] to show help message";


  public static final String help = "Battleship game\n10 * 10 board\n2 player game\n"+
    "each player has:\n"+
    "- 4x 1u ships\n"+
    "- 3x 2u ships\n"+
    "- 2x 3u ships\n"+
    "- 1x 4u ship\n"+
    "At the start of the game each player must choose the location for each of the ships.\nEach ship must be at least 1 unit apart from  the other ships in all directions.\nThe player can rotate the ship and choose its x and y coordinates using mouse input.\n"+
    "SHORTCUTS:\n"+
    "- F1 *or* h   --> HELP.- shows this message.\n"+
    "- s     --> HOST GAME.- creates a server in host\'s computer.\n"+
    "- j     --> JOIN GAME.- asks for host\'s socket and attempts to connect.\n"+
    "- q     --> QUIT or END SERVER .- ends server or disconnects from server.\n"+
    "- [ENTER]  --> READY .- sends message to opponent, giving him/her the next turn.";
}
