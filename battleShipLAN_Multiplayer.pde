//https://forum.processing.org/two/discussion/18037/f1-key-event-checks
import javax.swing.JOptionPane;
import static java.awt.event.KeyEvent.*;
import processing.net.*;

Server server;
Client client;
Client inputClient;
int port;


Player p;
Player otherPlayer;
GameState gameState;
boolean serverInitiated = false;
boolean isClient = false;
Ship activeShip;
boolean mouseIsBeingDragged = false;

int fps = 24;

void setup() {
  textSetup();
  port = 31581;
  gameState = GameState.IDLE;
  size(500, 500);
  frameRate(fps);
  rectMode(CENTER);
  p = new Player(false);
  otherPlayer = new Player(true);
  for (Ship ship : otherPlayer.getShips()) {
    println(ship);
  }
}

void draw() {
  background(111);
  drawGrid();
  drawOverlay();
  if (gameState==GameState.P1_TURN || gameState==GameState.P2_TURN) {
    if (activeShip!=null) {
      activeShip.setPosition(getNewPosX(), getNewPosY());
      p.render();
    }
  } 

  try {
    inputClient = server.available();
    if (inputClient != null) {
      Resources.message("new message from client", inputClient.readString());
      println(inputClient.readString());
    }
  }
  catch(NullPointerException e) {
  }
}

void mouseClicked() {
  if ((server != null && gameState==GameState.P1_TURN) ||
    (client != null && gameState==GameState.P2_TURN)) {
    int x = getNewPosX();
    int y = getNewPosY();
    if (activeShip != null)
      activeShip = null;
    else {
      activeShip = p.getActiveShip(x, y);
    }
  }
}

void mouseReleased() {
  if ((server != null && gameState==GameState.P1_TURN) ||
    (client != null && gameState==GameState.P2_TURN)) {
    if (mouseIsBeingDragged) {
      mouseIsBeingDragged = false;
      activeShip = null;
    }
  }
}

void mouseDragged() {
  if ((server != null && gameState==GameState.P1_TURN) ||
    (client != null && gameState==GameState.P2_TURN)) {
    if (!mouseIsBeingDragged) {
      mouseIsBeingDragged = true;
      activeShip = p.getActiveShip(getNewPosX(), getNewPosY());
    }
  }
}

void mouseWheel(MouseEvent event) {
  if ((server != null && gameState==GameState.P1_TURN) ||
    (client != null && gameState==GameState.P2_TURN)) {
    boolean e = event.getCount() < 0;
    if (activeShip != null)
      activeShip.turn(e);
  }
}

void keyPressed() {

  if ((key==CODED && keyCode==java.awt.event.KeyEvent.VK_F1) || key=='h' || key =='H') {
    Resources.message("Help - BATTLESHIP", Constants.help);
  }
  if (key=='s' && gameState!=GameState.SERVER_INIT && !serverInitiated) {
    serverInit();
  }
  if (key=='j') {
    if (client != null)
      client.stop();

    String ipAddress = inputDialogString("battlefield", "enter ip address, default is 127.0.0.1");
    if (split(ipAddress, ".").length != 4) {
      Resources.message("battlefield", "ip address " + ipAddress + " is invalid. Will default to 127.0.0.1");
      ipAddress = "127.0.0.1";
    }

    client = new Client(this, ipAddress, inputDialogInt("battlefield", "enter port, default is 31581"));
  }
  if (key =='q') {
    quit();
  }
}



void serverInit() {
  if (client != null)
    client.stop();

  gameState = GameState.SERVER_INIT;
  server = new Server(this, port);
  serverInitiated = true;
  Resources.message("Server", "Hosting game, listening on socket " + Server.ip() + ":" + port + "\nWaiting for player to connect...");
}

int getNewPosX() {
  return (int)(mouseX / Constants.cellWidth) * Constants.cellWidth + (Constants.cellWidth/2);
}

int getNewPosY() {
  return (int)(mouseY / Constants.cellWidth) * Constants.cellWidth + (Constants.cellWidth/2);
}



void quit() {
  if (server != null && serverInitiated) {
    server.stop();
    Resources.message("Server Info", "Server has stopped");
  } else if (client != null & !serverInitiated) {
    client.stop();
    Resources.message("Client Info", "Client has been disconnected from server.");
  }
}




void serverEvent(Server server, Client client) {
  if (server != null && serverInitiated) {
    Resources.message("Client connected!", "A new client has been found! " + client.ip());

    gameState = java.lang.Math.random() > .5 ? GameState.P1_TURN : GameState.P2_TURN;

    if (gameState == GameState.P1_TURN) {
      Resources.message("Server has intiated!", "Server(you) will start by choosing your ships' positions and alignments."+"\nEach ship must be at least 1 unit apart. Use the left click to select a ship, move your mouse and use the scrollwheel to choose its rotation."
        +"\nPress [ENTER] when ready.");
      this.server.write("0,0");
    } else {
      Resources.message("Client " +client.ip() + " starts!", "Client " + client.ip() + " will start by choosing his/her ships' positions and alignment.");
      this.server.write("0,1");
    }
  }
}

void clientEvent(Client client) {
  //Resources.message( "New message from server!", "Server says:\n" + client.read());
  String[] decodedMessage = decodeMessage(client.readString());
  executeMessage(decodedMessage);
}

String[] decodeMessage(String message) {
  String[] messages = split(message, ',');
  return messages;
}

void executeMessage(String[] decodedMessage) {
  switch(decodedMessage[0]) {
  case "0":
    if (decodedMessage.length > 1) {
      if (decodedMessage[1] == "0")
        gameState = GameState.P1_TURN;
      else
        gameState = GameState.P2_TURN;
    }
    break;
  case "1":
    if (decodedMessage.length > 2) {
      try {
        int x = Integer.parseInt(decodedMessage[1]);
        int y = Integer.parseInt(decodedMessage[2]);
        Ship ship =p.getActiveShip(x, y);
        int index = ship.whoIsHere(x, y);
        if (index > -1) {
          ship.setDeadUnits(index);
          String deadCells = "";
          boolean[] deadUnits = ship.getDeadUnits();
          for (boolean b : deadUnits) {
            deadCells += "," + b;
          }
          String writeValue = "2,"+index+","+ship.getPosition().x+","+
            ship.getPosition().y+","+ship.getHeading()+","+
            p.getActiveShipIndex(x, y)+deadCells;

          if (server != null) {
            server.write(writeValue);
          } else
            client.write(writeValue);

          println(writeValue);
        }
      } 
      catch(NumberFormatException e) {
      }
    }
    break;
  case "2":
    break;
  default:
    break;
  }
}

//Server will always be P1_INIT!
enum GameState {
  P1_TURN, 
    P2_TURN, 
    IDLE, 
    HELP, 
    SERVER_INIT
}

void drawGrid() {
  for (int i = 0; i < Constants.boardWidth; i++) {
    //columns
    int x1 = i * width / Constants.boardWidth;
    int x2 = x1;
    int y1 = 0, y2 = height;

    //rows
    int y3 = i * height / Constants.boardWidth;
    int y4 = y3;
    int x3 = 0, x4 = width;

    line(x1, y1, x2, y2);
    line(x3, y3, x4, y4);
  }
}


String inputDialogString(String title, String body) {
  return JOptionPane.showInputDialog(null, body, title, JOptionPane.WARNING_MESSAGE);
}

int inputDialogInt(String title, String body) {
  int value = Constants.port;
  try {
    value = Integer.parseInt(JOptionPane.showInputDialog(null, body, title, JOptionPane.WARNING_MESSAGE));
  } 
  catch(NumberFormatException e) {
  }
  return value;
}

void drawOverlay() {
  if (gameState == GameState.IDLE) {
  }
  switch(gameState) {
  case IDLE:
    background(#4332EA);
    text(Constants.idleText, 50, 50);
    break;
  case SERVER_INIT:
    background(#EA32AD);
    text(Constants.initServerText, 50, 50);
    break;
  default:
    break;
  }
}

void textSetup() {
  textSize(20);
  textAlign(LEFT);
}
