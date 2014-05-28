class Ball {
  int playerId;
  float size;
  color col;
  boolean activeBall; // is this the last ball that has been moved?
  PVector vMotion = new PVector(0, 0);
  PVector vPosition = new PVector(0, 0);

  Ball(int pId, float s, PVector vM) {
    playerId = pId;
    size = s;
    vMotion = vM;
    
    activeBall = true;

    if ( pId == 1 ) {
      vPosition = spawnP1.get();
      col = p1Color;
    } 
    else {
      vPosition = spawnP2.get();
      col = p2Color;
    }

    //balls.add(this);
  }

  void display() {
    fill(col);
    
    if(playerId == 1 && isInArea("p2Target")
    || playerId == 2 && isInArea("p1Target")) {
      stroke(255);
      strokeWeight(3);
    } else {
      noStroke();
    }
    
    ellipse(vPosition.x, vPosition.y, size, size);
  }
  
  void update() {
    calcMovement();
    slowBall();
    display();
    calcWallBounce();
    calcBallBounce();
    checkForStop();
  }
  
  void calcMovement() {
    vPosition.add(vMotion);
  }
  
  void calcWallBounce() {
    // Top wall
    if( vPosition.y < size/2 ) {
      vMotion.y = 0 - vMotion.y;
      vPosition.y = size/2;
    }
    
    // Right wall
    else if( vPosition.x > windowWidth - size/2 ) {
      vMotion.x = 0 - vMotion.x;
      vPosition.x = windowWidth - size/2;
    }
    
    // Bottom wall
    else if( vPosition.y > windowHeight - size/2) {
      vMotion.y = 0 - vMotion.y;
      vPosition.y = windowHeight - size/2;
    }
    
    // Left wall
    else if( vPosition.x < size/2) {
      vMotion.x = 0 - vMotion.x;
      vPosition.x = size/2;
    }
  }
  
  void slowBall() {
    vMotion.set(
      vMotion.x * setup_slownewssPerTick,
      vMotion.y * setup_slownewssPerTick
    );
  }
  
  void checkForStop() {
    // Checks if the velocity is low enough to stop it and end the round
    if( abs(vMotion.x) < setup_minVelocity && abs(vMotion.y) < setup_minVelocity) {
      vMotion.set(0, 0); // Stop ball
      
      if(activeBall) {
        activeBall = false;
        game.isCurrentBallRolling = false;
      }
    }
  }
  
  void calcBallBounce() {
    // Stolen from: http://processing.org/examples/circlecollision.html

    for ( Ball otherBall: balls ) { // go through ball list
      if (this != otherBall) { // if not the current ball
        
        // Distance between balls
        PVector vDistance = PVector.sub(otherBall.vPosition, vPosition);
        float distance = vDistance.mag();
        
        if(distance < size/2 + otherBall.size/2) {
          // Collision
          // get angle of bVect
          float theta  = vDistance.heading();
          // precalculate trig values
          float sine = sin(theta);
          float cosine = cos(theta);
    
          /* bTemp will hold rotated ball positions. You 
           just need to worry about bTemp[1] position*/
          PVector[] bTemp = {
            new PVector(), new PVector()
          };
    
           /* this ball's position is relative to the other
           so you can use the vector between them (bVect) as the 
           reference point in the rotation expressions.
           bTemp[0].position.x and bTemp[0].position.y will initialize
           automatically to 0.0, which is what you want
           since b[1] will rotate around b[0] */
          bTemp[1].x  = cosine * vDistance.x + sine * vDistance.y;
          bTemp[1].y  = cosine * vDistance.y - sine * vDistance.x;
    
          // rotate Temporary velocities
          PVector[] vTemp = {
            new PVector(), new PVector()
          };
    
          vTemp[0].x  = cosine * vMotion.x + sine * vMotion.y;
          vTemp[0].y  = cosine * vMotion.y - sine * vMotion.x;
          vTemp[1].x  = cosine * otherBall.vMotion.x + sine * otherBall.vMotion.y;
          vTemp[1].y  = cosine * otherBall.vMotion.y - sine * otherBall.vMotion.x;
      
          /* Now that velocities are rotated, you can use 1D
           conservation of momentum equations to calculate 
           the final velocity along the x-axis. */
          PVector[] vFinal = {  
            new PVector(), new PVector()
          };
    
          // final rotated velocity for b[0]
          vFinal[0].x = ((size - otherBall.size) * vTemp[0].x + 2 * otherBall.size * vTemp[1].x) / (size + otherBall.size);
          vFinal[0].y = vTemp[0].y;
    
          // final rotated velocity for b[0]
          vFinal[1].x = ((otherBall.size - size) * vTemp[1].x + 2 * size * vTemp[0].x) / (size + otherBall.size);
          vFinal[1].y = vTemp[1].y;
    
          // hack to avoid clumping
          bTemp[0].x += vFinal[0].x;
          bTemp[1].x += vFinal[1].x;
    
          /* Rotate ball positions and velocities back
           Reverse signs in trig expressions to rotate 
           in the opposite direction */
          // rotate balls
          PVector[] bFinal = { 
            new PVector(), new PVector()
          };
    
          bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
          bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
          bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
          bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;
    
          // update balls to screen position
          otherBall.vPosition.x = vPosition.x + bFinal[1].x;
          otherBall.vPosition.y = vPosition.y + bFinal[1].y;
    
          vPosition.add(bFinal[0]);
    
          // update velocities
          vMotion.x = cosine * vFinal[0].x - sine * vFinal[0].y;
          vMotion.y = cosine * vFinal[0].y + sine * vFinal[0].x;
          otherBall.vMotion.x = cosine * vFinal[1].x - sine * vFinal[1].y;
          otherBall.vMotion.y = cosine * vFinal[1].y + sine * vFinal[1].x;
        } // End collision
      }
    }
  }

  boolean isInArea(String areaName) {
    int areaId = 0;
    boolean returnVal = false;
         if(areaName == "p1Base") { areaId = 1; }
    else if(areaName == "p1Target") { areaId = 2; }
    else if(areaName == "p2Target") { areaId = 3; }
    else if(areaName == "p2Base") { areaId = 4; }
    
    switch(areaId) {
      case 1: // p1Base
        if (vPosition.x < pf.pfBaseZoneWidth) {
          returnVal = true;
        }
        break;
      case 2: // p1Target
        if (vPosition.x > pf.pfBaseZoneWidth
          && vPosition.x < pf.pfBaseZoneWidth + pf.pfTargetZoneWidth) {
          returnVal = true;
        }
        break;
      case 3: // p2Target
        if (vPosition.x > pf.pfBaseZoneWidth + pf.pfTargetZoneWidth
          && vPosition.x < pf.pfBaseZoneWidth + pf.pfTargetZoneWidth * 2) {
          returnVal = true;
        }
        break;
      case 4: //p2Base
        if (vPosition.x > pf.pfBaseZoneWidth + pf.pfTargetZoneWidth * 2) {
          returnVal = true;
        }
        break;
      default:
        returnVal = false;
        break;
    }
  
    return returnVal;
  }
}
