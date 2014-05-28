class MotionArrow {
  PVector vPositionStart;
  PVector vPositionEnd;
  color col;
  
  MotionArrow(PVector vP, int playerId) {
    vPositionStart = vP;
    vPositionEnd = vP;
    
    if(playerId == 1) {
      col = p1Color;
    } else if(playerId == 2) {
      col = p2Color;
    }
  }
  
  void update() {
    vPositionEnd = new PVector(mouseX, mouseY);
    
    stroke(col);
    strokeWeight(6);
    line(vPositionStart.x, vPositionStart.y, vPositionEnd.x, vPositionEnd.y);
  }
  
  PVector getMotion() {
    PVector vMotion = vPositionEnd.get();
    vMotion.sub(vPositionStart);
    return vMotion;
  }
}
