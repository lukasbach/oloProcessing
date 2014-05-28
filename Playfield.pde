class Playfield {
  int pfHeight;
  int pfTargetZoneWidth;
  int pfBaseZoneWidth;
  int flashBase1Tick;
  int flashBase2Tick;
  
  Playfield(int setupHeight, int setupTargetZoneWidth, int setupBaseZoneWidth) {
    pfHeight = setupHeight;
    pfTargetZoneWidth = setupTargetZoneWidth;
    pfBaseZoneWidth = setupBaseZoneWidth;
    
    flashBase1Tick = 255;
    flashBase2Tick = 255;
  }
  
  void display() {
    noStroke();
    
    // p1 target zone
    fill(p1BgColor);
    rect(
      pfBaseZoneWidth,
      0,
      pfTargetZoneWidth,
      pfHeight
    );
    
    // p2 target zone
    fill(p2BgColor);
    rect(
      pfBaseZoneWidth + pfTargetZoneWidth,
      0,
      pfTargetZoneWidth,
      pfHeight
    );
    
    // p1 base
    fill(getBaseColor(1));
    rect(
      0,
      0,
      pfBaseZoneWidth,
      pfHeight
    );
    
    // p2 base
    fill(getBaseColor(2));
    rect(
      pfBaseZoneWidth + pfTargetZoneWidth * 2,
      0,
      pfBaseZoneWidth,
      pfHeight
    );
    
    // Reduce base zone colors
    if(flashBase1Tick != 255) {
      flashBase1Tick++;
      //game.gameState++; // balls have been grabbed, go on with the game
    }
    if(flashBase2Tick != 255) {
      flashBase2Tick++;
      //game.gameState++; // balls have been grabbed, go on with the game
    }
  }
  
  color getBaseColor(int baseId) {
    if(baseId == 1) {
      return flashBase1Tick;
    } else {
      return flashBase2Tick;
    }
  }
  
  void initFlashBase(int baseId) {
    // Flash the color of a base for a short amount of time
    if(baseId == 1) { flashBase1Tick = 200; }
    if(baseId == 2) { flashBase2Tick = 200; }
  }
}
