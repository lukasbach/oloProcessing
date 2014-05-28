class Game {
  int gameState;
  MotionArrow mArrow;
  
  // currentPlayer: saves the id of the current player
  int currentPlayer = 1;
  
  // isMotionArrow: Boolean saving if the user is creating a new motion currently
  boolean isMotionArrow; // false
  
  // isCurrentBallRolling: Boolean saving if the last placed ball is still rolling
  boolean isCurrentBallRolling; // false
  
  Game() {
    gameState = 1;
    isMotionArrow = false;
    isCurrentBallRolling = false;
    
    generateBallSizes();
  }
  
  void tick() {
    if(gameState == 1) {
      // gameState1: Waiting for player creating motionArrow
      drawPseudoBall();
      if(waitForMArrow()) {
        gameState++;
      }
    } else if(gameState == 2) {
      // gameState2: Waiting for player end creation of motionArrow
      drawPseudoBall();
      mArrow.update();
      if(waitForMArrowFinish()){
        gameState++;
      }
    } else if(gameState == 3) {
      // gameState3: Waiting for placed ball to stop rolling
      if(!isCurrentBallRolling) {
        gameState++;
        togglePlayer();
      }
    } else if(gameState == 4) {
      // Grab balls in enemy base zone
      grabBalls();
      
      if(hasGameEnded()) {
        gui.displayGameOverMessage = true;
        gameState = 5;
      } else {
        gameState = 1;
      }
    }
  }
  
  boolean hasGameEnded() {
    if( player1.ballsLeft.size() == 0 && player2.ballsLeft.size() == 0) {
      return true;
    } else {
      return false;
    }
  }
  
  int getWinnerId() {
    if(player1.getScore() > player2.getScore()) {
      return 1;
    } else if(player2.getScore() > player1.getScore()) {
      return 2;
    } else {
      return 3; // draw
    }
  }
  
  void togglePlayer() { // Toggles the current player only if the next one has still balls left
    if(currentPlayer == 1 && player2.ballsLeft.size() > 0) {
       currentPlayer = 2; 
     } else if(player1.ballsLeft.size() > 0) { 
      currentPlayer = 1; 
    }
  }
  
  boolean waitForMArrow() {
    // Returns true if motion arrow creation has started
    
    if(mousePressed) {
      mArrow = new MotionArrow(new PVector(mouseX, mouseY), currentPlayer);
      //game.isMotionArrow = true;
      return true;
    } else {
      return false;
    }
  }
  
  boolean waitForMArrowFinish() {
    if(mouseReleasedEvent) {    // Disable creating new motion
      //game.isMotionArrow = false;
      game.isCurrentBallRolling = true;
      
      // Calculate motion of new ball
      PVector vMotionNewBall = mArrow.getMotion();
      
      // Decrease motion
      vMotionNewBall.set( vMotionNewBall.x*0.2, vMotionNewBall.y*0.2 );
      
      // Get ball size and remove ball from list
      float ballSize;
      if(currentPlayer == 1) {
        ballSize = player1.getCurrentBallSize();
        player1.removeLastBall();
      } else {
        ballSize = player2.getCurrentBallSize();
        player2.removeLastBall();
        
      }
      
      // Create new ball with that motion
      Ball newb = new Ball(currentPlayer, ballSize, vMotionNewBall);
      balls.add(newb);
      
      mouseReleasedEvent = false;
      
      return true;
    } else {
      return false;
    }
  }
  
  void grabBalls() {
    int grabbedBalls = 0;
    boolean grabbedFromBase1 = false;
    boolean grabbedFromBase2 = false;
    
    // List of balls that are being removed after the first for loop
    ArrayList<Ball> removeBalls = new ArrayList<Ball>();
    
    for ( Ball b: balls ) {
      if( b.isInArea("p2Base") ) {
        player2.addBallToList(b.size);
        removeBalls.add(b);
        grabbedBalls++;
        grabbedFromBase2 = true;
      } else if( b.isInArea("p1Base") ) {
        player1.addBallToList(b.size);
        removeBalls.add(b);
        grabbedBalls++;
        grabbedFromBase1 = true;
      }
    }
    
    // Remove balls that have been tagged for removing
    for ( Ball b: removeBalls ) {
      balls.remove(b);
    }
    
    if(grabbedBalls == 0) {
      gameState++;
    } else {
      if(grabbedFromBase1) {
        pf.initFlashBase(1);
      }
      if(grabbedFromBase2) {
        pf.initFlashBase(2);
      }
    }
  }
  
  void generateBallSizes() {
    for(int i = 0; i < amountOfBalls; i++) {
      float ballSize = random(setup_minBallSize, setup_maxBallSize);
      player1.addBallToList(ballSize);
      player2.addBallToList(ballSize);
    }
  }
  
  void drawPseudoBall() {
    PVector vSpawnPosition;
    float size;
    color col;
    if(currentPlayer == 1) { 
      vSpawnPosition = spawnP1.get();
      size = player1.getCurrentBallSize();
      col = p1Color;
    } else { 
      vSpawnPosition = spawnP2.get(); 
      size = player2.getCurrentBallSize(); 
      col = p2Color;
    }
    
    fill(col);
    ellipse(vSpawnPosition.x, vSpawnPosition.y, size, size);
  }
  
  void reset() {
    // Remove balls
    ArrayList<Ball> removeBalls = new ArrayList<Ball>();
    for ( Ball b: balls ) removeBalls.add(b);
    for ( Ball b: removeBalls ) balls.remove(b);
    
    // Reset vars
    amountOfBalls = setup_amountOfBalls;
    gameState = 1;
    currentPlayer = 1;
    isMotionArrow = false;
    isCurrentBallRolling = false;
    player1 = new Player(1);
    player2 = new Player(2);
    
    // Generate new balls
    generateBallSizes();
  }
}
