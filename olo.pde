static color p1Color = #28bae0;
static color p2Color = #ff4848;
static color p1BgColor = #b4e7f5;
static color p2BgColor = #ffbfbf;
static color defeatColor = #eeeeee;

static int setup_pfAreaHeight = 400;
static int setup_pfTargetZoneWidth = 300;
static int setup_pfBaseZoneWidth = 150;

static float setup_slownewssPerTick = .97;
static float setup_minVelocity = 0.2;

static int setup_minBallSize = 15;
static int setup_maxBallSize = 60;

static int setup_amountOfBalls = 5;

// Keycode to the key which resets the current game. By default space (32)
static int setup_resetKey = 32;

// Spawn positions of the balls
static PVector spawnP1 = new PVector(
  setup_pfBaseZoneWidth / 2,
  setup_pfAreaHeight /2
);
static PVector spawnP2 =  new PVector(
  setup_pfTargetZoneWidth * 2 + setup_pfBaseZoneWidth * 1.5,
  setup_pfAreaHeight /2
);

// Amount of balls, the variable above is used to reset this value
int amountOfBalls = setup_amountOfBalls;

// mouseReleasedEvent: Saves if the mouse has been released, is being reset in game.waitForMArrowFinish()
boolean mouseReleasedEvent = false;

// Listtype for balllist, defined in setup()
ArrayList<Ball> balls;

// Calc width and height measurements
int windowWidth = 2 * setup_pfTargetZoneWidth + 2 * setup_pfBaseZoneWidth;
int windowHeight = setup_pfAreaHeight;

// Classes
Playfield pf;
Game game;
Player player1;
Player player2;
Gui gui;

void setup() {
  size(windowWidth, windowHeight);
  
  // Define balllist
  balls = new ArrayList<Ball>(); 
  
  // Create playfield
  pf = new Playfield(setup_pfAreaHeight, setup_pfTargetZoneWidth, setup_pfBaseZoneWidth);
  // Create players
  player1 = new Player(1);
  player2 = new Player(2);
  // Create gui
  gui = new Gui();
  // Create game
  game = new Game();
}

void draw() {
  background(255);
  pf.display();
  
  for ( Ball b: balls ) {
    b.update();
  }
  
  game.tick();
  gui.render();
} 

void mouseReleased() {
  mouseReleasedEvent = true;
}

void keyPressed() {
  if(keyCode == setup_resetKey) {
    game.reset();
  }
}
