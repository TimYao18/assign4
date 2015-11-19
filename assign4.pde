/* please implement your assign4 code in this file. */

// constant variables
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_LOSE = 2;

final int SOURCE_NONE = 0;
final int SOURCE_FIGHTER = 1;
final int SOURCE_BULLET = 2;

final int HIT_NONE = 0;
final int HIT_ENEMY = 1;
final int HIT_TREASURE = 2;

final int HP_POINT_DEFAULT = 50;
final int HP_POINT_MAX = 100;
final int HP_POINT_HIT = 20;
final int HP_POINT_ENERGY = 10;

// Fixed Position
final int HP_X = 10;
final int HP_Y = 10;
final int HP_RED_X = HP_X + 5;
final int HP_RED_Y = HP_Y + 2;
final int BUTTON_X = 202;
final int BUTTON_Y = 280;
final int BUTTON_WIDTH = 255;
final int BUTTON_HEIGHT = 123;
final int DEFAULT_FIGHTER_X = 500;
final int DEFAULT_FIGHTER_Y = 240;

// image size
final int FIGHTER_SIZE = 50;
final int ENEMY_SIZE = 60;
final int ENEMY_GAP = (ENEMY_SIZE / 2);
final int TREASURE_SIZE = 40;
final int HP_WIDTH = 202;
final int HP_HEIGHT = 20;
final int BULLET_WIDTH = 32;
final int BULLET_HEIGHT = 27;

// speed
final int BACKGROUND_SPEED = 2;
final int ENEMY_SPEED = 5;
final int FIGHTER_SPEED = 5;
final int BULLET_SPEED = 5;

// level_enemy_num
final int ENEMY_NUM_1 = 5;
final int ENEMY_NUM_2 = 5;
final int ENEMY_NUM_3 = 8;
final int MAX_ENEMY_NUM = 8;

final int BOOM_IMAGE_NONE = -1;
final int MAX_BOOM_IMAGE_NUM = 5;

final int MAX_BULLET_NUM = 5;

int[] arrayEnemyX = new int[MAX_ENEMY_NUM];
int[] arrayEnemyY = new int[MAX_ENEMY_NUM];
boolean[] arrayEnemyEnable = new boolean[MAX_ENEMY_NUM];
int[] arrayBoomX = new int[MAX_ENEMY_NUM];
int[] arrayBoomY = new int[MAX_ENEMY_NUM];
int[] arrayBoomShow = new int[MAX_ENEMY_NUM];
int[] arrayBulletX = new int[MAX_BULLET_NUM];
int[] arrayBulletY = new int[MAX_BULLET_NUM];
boolean[] arrayBulletEnable = new boolean[MAX_BULLET_NUM];

// variables
int gameState;
int enemyTeamType = -1;
boolean changeEnemyTeamType = false;
int slantDirection;
int currentMaxEnemyNum = ENEMY_NUM_1;
// positions
int bg1RX;
int bg2RX;
int fighterX;
int fighterY;
int hpPoint;
int treasureX;
int treasureY;
// keypressed
boolean isLeftPressed;
boolean isRightPressed;
boolean isUpPressed;
boolean isDownPressed;

// images
PImage gameStart1;
PImage gameStart2;
PImage bg1;
PImage bg2;
PImage imageEnemy;
PImage fighter;
PImage hp;
PImage treasure;
PImage gameLose1;
PImage gameLose2;
PImage bullet;
PImage[] boom = new PImage[5];


void setup () {
  size(640, 480) ;  // must use this size.

  // your code
  bg1RX = width; // bg1 right side position
  bg2RX = width * 2; // bg2 right side position

  // load images
  gameStart1 = loadImage("img/start2.png");
  gameStart2 = loadImage("img/start1.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  imageEnemy = loadImage("img/enemy.png");
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  treasure = loadImage("img/treasure.png");
  gameLose1 = loadImage("img/end2.png");
  gameLose2 = loadImage("img/end1.png");
  for (int i = 0; i < MAX_BOOM_IMAGE_NUM; i++) {
    boom[i] = loadImage("img/flame" + (i+1) + ".png");
  }
  for (int i = 0; i < MAX_ENEMY_NUM; i++) {
    arrayBoomShow[i] = BOOM_IMAGE_NONE; // not show
  }
  bullet = loadImage("img/shoot.png");

  // default
  gameState = GAME_START;
  isLeftPressed = false;
  isRightPressed = false;
  isUpPressed = false;
  isDownPressed = false;

  // Begin from type 0
  enemyTeamType = 0;

  // get random start position
  // hp
  hpPoint = HP_POINT_DEFAULT;

  // enemy
  changeEnemyTeamType = true;

  // fighter
  //fighterX = floor(random(width-FIGHTER_SIZE));
  //fighterY = floor(random(height-FIGHTER_SIZE));
  fighterX = DEFAULT_FIGHTER_X;
  fighterY = DEFAULT_FIGHTER_Y;

  // treasure
  treasureX = floor(random(width-TREASURE_SIZE));
  treasureY = floor(random(height-TREASURE_SIZE));

  frameRate(60);
}

void draw() {
  // your code
  switch (gameState)
  {
  case GAME_START:
    // Mouse in the button rectangle
    if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
      BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
      image(gameStart2, 0, 0);

      // Click
      if (mousePressed) {
        gameState = GAME_RUN;
      }
    } else {
      image(gameStart1, 0, 0);
    }
    break;

  case GAME_RUN:

    // draw background
    bg1RX = (bg1RX + BACKGROUND_SPEED);
    if (bg1RX >= width * 2)
      bg1RX = 0;
    bg2RX = (bg2RX + BACKGROUND_SPEED);
    if (bg2RX >= width * 2)
      bg2RX = 0;
    image(bg1, bg1RX-width, 0);
    image(bg2, bg2RX-width, 0);

    // draw treasure
    image(treasure, treasureX, treasureY);
    
    // draw boom
    //// 1frame = 100ms = 0.1s 
    int switchNextFlame = (frameCount % (60/6) == 0) ? 1 : 0; 
    for (int i = 0; i < MAX_ENEMY_NUM; i++) {
      if (arrayBoomShow[i] != BOOM_IMAGE_NONE) {
        image(boom[arrayBoomShow[i]], arrayBoomX[i], arrayBoomY[i]);
        arrayBoomShow[i]+=switchNextFlame;
        if (arrayBoomShow[i] >= MAX_BOOM_IMAGE_NUM)
          arrayBoomShow[i] = BOOM_IMAGE_NONE;
      }
    }

    // Fighter Position
    if (isUpPressed) {
      fighterY -= FIGHTER_SPEED;
    }
    if (isDownPressed) {
      fighterY += FIGHTER_SPEED;
    }
    if (isLeftPressed) {
      fighterX -= FIGHTER_SPEED;
    }
    if (isRightPressed) {
      fighterX += FIGHTER_SPEED;
    }
    // Fighter - Screen Edge Boundery Detection
    if (fighterX <= 0) {
      fighterX = 0;
    } else if (fighterX > width - FIGHTER_SIZE) {
      fighterX = width - FIGHTER_SIZE;
    }

    if (fighterY <= 0) {
      fighterY = 0;
    } else if (fighterY > height - FIGHTER_SIZE) {
      fighterY = height - FIGHTER_SIZE;
    }
    // draw fighter
    image(fighter, fighterX, fighterY);

    // draw enemy team
    if (changeEnemyTeamType == true) {
      if (enemyTeamType == 1) {
        int startY = 0;

        // Dive a slant direction
        if (random(-1, 1) >= 0) {
          // slant /
          slantDirection = 1;
          startY = floor(random(height-ENEMY_SIZE*5));
        } else {
          // slant \
          slantDirection = -1;
          startY = floor(random(ENEMY_SIZE*4, height-ENEMY_SIZE));
        }

        // set start position
        for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
          if (enemyNo < ENEMY_NUM_2) {
            arrayEnemyX[enemyNo] = 0 - enemyNo * (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = startY + slantDirection * enemyNo * ENEMY_SIZE;
            arrayEnemyEnable[enemyNo] = true;
          } else {
            arrayEnemyEnable[enemyNo] = false;
          }
        }
      } else if (enemyTeamType == 2) {
        int startY = floor(random(2*(ENEMY_SIZE + ENEMY_GAP), height - 3*(ENEMY_SIZE + ENEMY_GAP)));

        for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
          if (enemyNo == 0) {
            arrayEnemyX[enemyNo] = 0 - enemyNo * (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = startY - enemyNo * (ENEMY_SIZE + ENEMY_GAP);
          } else if (enemyNo <= 2) {
            arrayEnemyX[enemyNo] = arrayEnemyX[enemyNo-1] - (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = arrayEnemyY[enemyNo-1] - (ENEMY_SIZE + ENEMY_GAP);            
          } else if (enemyNo <= 4) {
            arrayEnemyX[enemyNo] = arrayEnemyX[enemyNo-1] - (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = arrayEnemyY[enemyNo-1] + (ENEMY_SIZE + ENEMY_GAP);            
          } else if (enemyNo <= 6) {
            arrayEnemyX[enemyNo] = arrayEnemyX[enemyNo-1] + (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = arrayEnemyY[enemyNo-1] + (ENEMY_SIZE + ENEMY_GAP);            
          } else {
            arrayEnemyX[enemyNo] = arrayEnemyX[enemyNo-1] + (ENEMY_SIZE + ENEMY_GAP);
            arrayEnemyY[enemyNo] = arrayEnemyY[enemyNo-1] - (ENEMY_SIZE + ENEMY_GAP);
          }
          arrayEnemyEnable[enemyNo] = true;
        }
      } else { //if (enemyTeamType == 0) {
        enemyTeamType = 0;
        int startY = floor(random(height-ENEMY_SIZE));
        for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++)
        {
          if (enemyNo < ENEMY_NUM_1) {
            arrayEnemyX[enemyNo] = 0-enemyNo*(ENEMY_SIZE+ENEMY_GAP);
            arrayEnemyY[enemyNo] = startY;
            arrayEnemyEnable[enemyNo] = true;
          } else {
            arrayEnemyEnable[enemyNo] = false;
          }
        }
      }

      changeEnemyTeamType = false;
    }

    // draw enemy images
    // all enemies fly from left to right
    for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
      if (arrayEnemyEnable[enemyNo] == true)
      {
        image(imageEnemy, arrayEnemyX[enemyNo], arrayEnemyY[enemyNo]);
        // set new position
        arrayEnemyX[enemyNo]+=ENEMY_SPEED;
      }
    }
    
    // draw bullet
    for (int i = 0; i < MAX_BULLET_NUM; i++) {
      if (arrayBulletEnable[i] == false) {
        continue;
      }
      image(bullet, arrayBulletX[i], arrayBulletY[i]);
      arrayBulletX[i]-=BULLET_SPEED;

      // out of screen, disable bullet 
      if (arrayBulletX[i] < -BULLET_WIDTH)
        arrayBulletEnable[i] = false;
    }

    // ENABLE_COLLISION
    // Enemy hit Detection
    int detectSource = SOURCE_NONE;
    int detectHit = HIT_NONE;
    for (int enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
      if (arrayEnemyEnable[enemyNo] == false) {
        continue;
      }

      // fighter hit detect
      if (arrayEnemyX[enemyNo] <= fighterX && fighterX <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
         arrayEnemyY[enemyNo] <= fighterY && fighterY <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
         // Fighter Left-Up corner is in enemy's rect
         detectSource = SOURCE_FIGHTER;
         detectHit = HIT_ENEMY;
      } else if (arrayEnemyX[enemyNo] <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
         arrayEnemyY[enemyNo] <= fighterY && fighterY <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
         // Fighter Right-Up corner is in enemy's rect
         detectSource = SOURCE_FIGHTER;
         detectHit = HIT_ENEMY;
      } else if (arrayEnemyX[enemyNo] <= fighterX && fighterX <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
         arrayEnemyY[enemyNo] <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
         // Fighter Left-Down corner is in enemy's rect
         detectSource = SOURCE_FIGHTER;
         detectHit = HIT_ENEMY;
      } else if (arrayEnemyX[enemyNo] <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
         arrayEnemyY[enemyNo] <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
         // Fighter Right-Down corner is in enemy's rect
         detectSource = SOURCE_FIGHTER;
         detectHit = HIT_ENEMY;
      } 

      // not hit fighter, then check bullet
      if (detectHit == HIT_NONE)
      {
        // bullet hit detect
        for (int j = 0; j < MAX_BULLET_NUM; j++) {
          if (arrayBulletEnable[j] == false)
            continue;
  
          if (arrayEnemyX[enemyNo] <= arrayBulletX[j] && arrayBulletX[j] <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
             arrayEnemyY[enemyNo] <= arrayBulletY[j] && arrayBulletY[j] <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
             // Bullet Left-Up corner is in enemy's rect
             detectSource = SOURCE_BULLET;
             detectHit = HIT_ENEMY;
          } else if (arrayEnemyX[enemyNo] <= arrayBulletX[j]+FIGHTER_SIZE && arrayBulletX[j]+FIGHTER_SIZE <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
             arrayEnemyY[enemyNo] <= arrayBulletY[j] && arrayBulletY[j] <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
             // Bullet Right-Up corner is in enemy's rect
             detectSource = SOURCE_BULLET;
             detectHit = HIT_ENEMY;
          } else if (arrayEnemyX[enemyNo] <= arrayBulletX[j] && arrayBulletX[j] <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
             arrayEnemyY[enemyNo] <= arrayBulletY[j]+FIGHTER_SIZE && arrayBulletY[j]+FIGHTER_SIZE <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
             // Bullet Left-Down corner is in enemy's rect
             detectSource = SOURCE_BULLET;
             detectHit = HIT_ENEMY;
          } else if (arrayEnemyX[enemyNo] <= arrayBulletX[j]+FIGHTER_SIZE && arrayBulletX[j]+FIGHTER_SIZE <= arrayEnemyX[enemyNo] + ENEMY_SIZE &&
             arrayEnemyY[enemyNo] <= arrayBulletY[j]+FIGHTER_SIZE && arrayBulletY[j]+FIGHTER_SIZE <= arrayEnemyY[enemyNo] + ENEMY_SIZE) {
             // Bullet Right-Down corner is in enemy's rect
             detectSource = SOURCE_BULLET;
             detectHit = HIT_ENEMY;
          }
          
          if (detectHit == HIT_ENEMY)
          {
            arrayBulletEnable[j] = false;
            break;
          }
        }
      }
      
      // hit enemy => disable enemy
      if (detectHit == HIT_ENEMY) {
        arrayEnemyEnable[enemyNo] = false;

        // Get enemy position as boom position
        for (int j = 0; j < MAX_ENEMY_NUM; j++) {
          // Find space to show boom
          if (arrayBoomShow[j] == BOOM_IMAGE_NONE) {
            arrayBoomX[j] = arrayEnemyX[enemyNo];
            arrayBoomY[j] = arrayEnemyY[enemyNo];
            arrayBoomShow[j] = 0;
            break;
          }
        }
        break;
      }
    }

    // Treasure hit Detection
    if (treasureX <= fighterX && fighterX <= treasureX + ENEMY_SIZE &&
      treasureY <= fighterY && fighterY <= treasureY + ENEMY_SIZE) {
      // Fighter Left-Up corner is in treasure's rect
      detectHit = HIT_TREASURE;
    } else if (treasureX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= treasureX + ENEMY_SIZE &&
      treasureY <= fighterY && fighterY <= treasureY + ENEMY_SIZE) {
      // Fighter Right-Up corner is in treasure's rect
      detectHit = HIT_TREASURE;
    } else if (treasureX <= fighterX && fighterX <= treasureX + ENEMY_SIZE &&
      treasureY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= treasureY + ENEMY_SIZE) {
      // Fighter Left-Down corner is in treasure's rect
      detectHit = HIT_TREASURE;
    } else if (treasureX <= fighterX+FIGHTER_SIZE && fighterX+FIGHTER_SIZE <= treasureX + ENEMY_SIZE &&
      treasureY <= fighterY+FIGHTER_SIZE && fighterY+FIGHTER_SIZE <= treasureY + ENEMY_SIZE) {
      // Fighter Right-Down corner is in treasure's rect
      detectHit = HIT_TREASURE;
    }

    // Check fighter hit enemy
    if (detectHit == HIT_ENEMY && detectSource == SOURCE_FIGHTER) {
      hpPoint -= HP_POINT_HIT;
      if (hpPoint <= 0) {
        hpPoint = 0;
        gameState = GAME_LOSE;
      }
    } else if (detectHit == HIT_TREASURE) {
      hpPoint += HP_POINT_ENERGY;
      if (hpPoint >= HP_POINT_MAX) {
        hpPoint = HP_POINT_MAX;
      }

      // reset treasure position
      treasureX = floor(random(width-TREASURE_SIZE));
      treasureY = floor(random(height-TREASURE_SIZE));
    }
    
    // check if changeEnemyTeamType
    boolean allDisabled = true;
    int enemyNo;
    for (enemyNo = 0; enemyNo < MAX_ENEMY_NUM; enemyNo++) {
      if (arrayEnemyEnable[enemyNo] == false)
        continue;

      // out of screen
      if (arrayEnemyX[enemyNo] > 640 + ENEMY_SIZE) {
        arrayEnemyEnable[enemyNo] = false;
      } else {
        allDisabled = false;
      }
    }

    if (allDisabled == true) {
      changeEnemyTeamType = true;
      enemyTeamType++;
      if (enemyTeamType > 2) {
        enemyTeamType = 0;
      }
    }

    // draw hpRed - show on the top
    fill(#FF0000);
    rect(HP_RED_X, HP_RED_Y, hpPoint*HP_WIDTH/HP_POINT_MAX, HP_HEIGHT, 0, 3, 0, 0);
    image(hp, HP_X, HP_Y);

    break;

  case GAME_LOSE:
    // Mouse in the button rectangle
    if (BUTTON_X < mouseX && mouseX < BUTTON_X + BUTTON_WIDTH &&
      BUTTON_Y < mouseY && mouseY < BUTTON_Y + BUTTON_HEIGHT) {
      image(gameLose2, 0, 0);

      // Click
      if (mousePressed) {
        gameState = GAME_RUN;
        
        // reset hpPoint
        hpPoint = HP_POINT_DEFAULT;
        // reset fighter
        //fighterX = floor(random(width-FIGHTER_SIZE));
        //fighterY = floor(random(height-FIGHTER_SIZE));
        fighterX = DEFAULT_FIGHTER_X;
        fighterY = DEFAULT_FIGHTER_Y;
        
        enemyTeamType = -1;
        changeEnemyTeamType = true;
        for (int i = 0; i < MAX_ENEMY_NUM; i++) {
          arrayBoomShow[i] = BOOM_IMAGE_NONE;
        }
      }
    } else {
      image(gameLose1, 0, 0);
    }
    break;
  }
}


void keyPressed() {
  if (key == CODED) {
    switch(keyCode)
    {
    case UP:
      isUpPressed = true;
      break;
    case DOWN:
      isDownPressed = true;
      break;
    case LEFT:
      isLeftPressed = true;
      break;
    case RIGHT:
      isRightPressed = true;
      break;
    }
  } else if (key == ' ') {
    // space to shoot bullet
    for (int i = 0; i < MAX_BULLET_NUM; i++) {
      if (arrayBulletEnable[i] == false) {
        arrayBulletEnable[i] = true;
        arrayBulletX[i] = fighterX;
        arrayBulletY[i] = fighterY + (FIGHTER_SIZE / 2) - (BULLET_HEIGHT/2);
        break;
      }
    }
  }
}

void keyReleased() {

  if (key == CODED) {
    switch(keyCode)
    {
    case UP:
      isUpPressed = false;
      break;
    case DOWN:
      isDownPressed = false;
      break;
    case LEFT:
      isLeftPressed = false;
      break;
    case RIGHT:
      isRightPressed = false;
      break;
    }
  }
}
