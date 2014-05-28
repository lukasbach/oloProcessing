class Gui {
  boolean displayGameOverMessage;
  
  Gui() {
    displayGameOverMessage = false;
  }
  
  void render() {
    renderScore(1);
    renderScore(2);
    renderPreviewBalls(1);
    renderPreviewBalls(2);
  }
  
  void renderScore(int pId) {
    int score;
    
    textSize(50);
    
    if(pId == 1) { 
      score = player1.getScore(); 
      fill(p1Color);
      
      text(
        score,
        40,
        60);
    } else { 
      score = player2.getScore(); 
      fill(p2Color);
      
      text(
        score,
        width - 80,
        60);
    }
    
    if(displayGameOverMessage) {
      displayGameOverMessage();
      waitForGameRestart();
    }
  }
  
  void renderPreviewBalls(int pId) {
    ArrayList<Float> ballsLeft = new ArrayList<Float>();
    color col;
    int xValue;
    
    if(pId == 1) { 
      for(Float item: player1.ballsLeft) ballsLeft.add(item); 
      xValue = 20;
      col = p1BgColor;
    } else {
      for(Float item: player2.ballsLeft) ballsLeft.add(item); 
      xValue = width - 20;
      col = p2BgColor;
    }
    int yValue = 20;
    int yOffset = 18;
    
    for(Float bSize: ballsLeft) {
      noStroke();
      fill(col);
      ellipse(xValue, height - yValue, bSize/4, bSize/4);
      yValue += yOffset;
      println("abc");
    }
  }
  
  void displayGameOverMessage() {
    int winnerId = game.getWinnerId();
    
    textSize(50);
    noStroke();
    
    if(winnerId == 1) {
      fill(p1Color);
      rect(0, height/4, width, height/2);      

      fill(#ffffff);
      text(
        "Player 1 wins!",
        width/2 - 180,
        height/2 + 15);
    }
    if(winnerId == 2) {
      fill(p2Color);
      rect(0, height/4, width, height/2);      

      fill(#ffffff);
      text(
        "Player 2 wins!",
        width/2 - 180,
        height/2 + 15);
    }
    if(winnerId == 3) {
      fill(defeatColor);
      rect(0, height/4, width, height/2);      

      fill(#ffffff);
      text(
        "Defeat!",
        width/2 - 80,
        height/2 + 15);
    }
  }
  
  void waitForGameRestart() {
    if(mousePressed) {
      displayGameOverMessage = false;
      game.reset();
    }
  }
}
