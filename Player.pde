class Player {
  ArrayList<Float> ballsLeft = new ArrayList<Float>();
  int id;
  
  Player(int pId) {
    id = pId;
  }
  
  void addBallToList(float size) {
    ballsLeft.add(size);
  }
  
  float getCurrentBallSize() {
    return ballsLeft.get(ballsLeft.size() - 1);
  }
  
  void removeLastBall() {
    ballsLeft.remove(ballsLeft.size() - 1);
  }
  
  int getScore() {
    int score = 0;
    
    for ( Ball b: balls ) { // go through ball list
      if(  (b.playerId == 1 && b.isInArea("p2Target") && id == 1)
        || (b.playerId == 2 && b.isInArea("p1Target") && id == 2) ) {
        score++;  
      }
    }
    
    return score;
  }
}
