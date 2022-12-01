final int SIZE = 10;
final int COST = 50;
final int INITIAL = 50;
final int INTERVAL = 1000;
final int GAIN = 10;
final int PREY_SEE = 500;
final int PREDATOR_SEE = 1000;

ArrayList<Plant> plants = new ArrayList<Plant>();
ArrayList<Prey> preys = new ArrayList<Prey>();
ArrayList<Predator> predators = new ArrayList<Predator>();

ArrayList<Integer> popPlants = new ArrayList<Integer>();
ArrayList<Integer> popPreys = new ArrayList<Integer>();

int lastTick;
int lastTickPredators;
int lastPlantBirth;
int lastRecord;

int maxPlants = 0;


float distance(Cell c1, Cell c2) {
  float x1 = c1.x;
  float y1 = c1.y;
  float x2 = c2.x;
  float y2 = c2.y;
  float distX = x1 - x2;
  float distY = y1 - y2;
  return sqrt(distX*distX + distY*distY);
}

class Predator extends Cell {
  Predator(float x, float y) {
    super(x, y);
    energy *= 1.5;
    col = color(255, 60, 60);
    dx = random(-1, 1);
    dy = random(-1, 1);
  }
  
  Predator birth() {
    this.energy -= COST*20;
    return new Predator(x, y);
  }
}

class Cell {
  color col;
  
  float x;
  float y;
  
  float dx;
  float dy;
  
  float energy;
  
  boolean moving;
  
  Cell(float x, float y) {
    this.x = x;
    this.y = y;
    this.energy = INITIAL;
  }
    
  void display() {
    fill(0);
    stroke(col);
    if (this instanceof Prey) {
      stroke(0, 255*(energy/COST), 0); 
    }
    // line(x, y, x+SIZE, y+SIZE);
    // line(x+SIZE, y, x, y+SIZE);
    ellipse(x, y, SIZE, SIZE);
  }
}

class Prey extends Cell {
  boolean beingChased;
   Prey( float x, float y) {
      super(x, y);
      dx = random(-1, 1);
      dy = random(-1, 1);
      
      col = color(0, 255, 0);
   }
   
   Prey birth() {
     this.energy -= COST*0.5;
     return new Prey(x, y);
   }
}

class Plant extends Cell {
    boolean beingChased;
    int startedMoving;
    int lastTick;
   Plant(float x, float y) {
     super(x, y);
     col = color(0, 0, 255);
     this.lastTick = millis();
   }
   
   Plant birth() {
     this.energy -= COST;
     return new Plant(x, y);
   }
}

int seePrey(Predator p) {
  int imin = -1;
  float distMin = 1000000;
  for (int i = 0; i < preys.size(); i++) {
    float dist = distance(preys.get(i), p);
    if ((dist < PREDATOR_SEE) && (dist < distMin) && (!preys.get(i).beingChased)) {
        imin = i;
        distMin = dist;
    }
  }
  if (imin != -1) {
    //line(p.x, p.y, preys.get(imin).x, preys.get(imin).y); 
    preys.get(imin).beingChased = true;
  }
  return imin;
}

int seePlant(Prey p) {
  int imin = -1;
  float distMin = 100000;
  for (int i = 0; i < plants.size(); i ++) {
    float dist = distance(plants.get(i), p);
    if ((dist < PREY_SEE) && (dist < distMin) && (!plants.get(i).beingChased)) {
      imin = i;
      distMin = dist;
    }
  }
  if (imin != -1) {
      //stroke(0, 0, 255);
      //line(p.x, p.y, plants.get(imin).x, plants.get(imin).y);
      plants.get(imin).beingChased = true;
  }
  return imin;
}

boolean collisionPlant(Cell p) {
  for (int i = 0; i < plants.size(); i++) {
    if (p != plants.get(i)) {
      if (distance(p, plants.get(i)) < SIZE) {
        return true;
      }
    }
  }
  return false;
}

void setup() {
  size(1250, 650);
  plants.add(new Plant(random(50, 1200), random(50,  600)));
  plants.add(new Plant(random(50, 1200), random(50,  600)));
  plants.add(new Plant(random(50, 1200), random(50,  600)));
  
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  preys.add(new Prey(random(50, 1200), random(50,  600)));
  
  //predators.add(new Predator(random(50, 1200), random(50, 600)));
}

void draw() {
  background(0);
  
  
  
  // born new plant
  if (millis() - lastPlantBirth > INTERVAL*7) {
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    plants.add(new Plant(random(50, 1200), random(50,  600)));
    lastPlantBirth = millis();
  }
  
  // decrease energy of preys
  boolean flag  = false;
  for (int i = 0; i < preys.size(); i++) {
    preys.get(i).beingChased = false;
    
    if (millis() - lastTick > INTERVAL*2) {
      preys.get(i).energy -= GAIN;
      flag = true;
    }
  }
  if (flag) {
      lastTick = millis();
  }
  
  // decrease energy of predators
  flag = false;
  for (int i = 0; i < predators.size(); i++) {
    if (millis() - lastTickPredators > INTERVAL) {
      flag = true;
      predators.get(i).energy -= GAIN;
    }
  }
  if (flag) {
      lastTickPredators = millis();  
    }
  
  
  // give energy to plants
  
    for (int i = 0; i < plants.size(); i++) {
      plants.get(i).beingChased = false;
      if (millis() - plants.get(i).lastTick > INTERVAL) {
        plants.get(i).energy += GAIN*15; 
        plants.get(i).lastTick = millis();
      }
    }
    
  
  
  // give a birth to new plants
  int size = plants.size();
  for (int i = 0; i < size; i++) {
    if (plants.get(i).energy - COST > 0) {
      plants.add(plants.get(i).birth());  
    }
  }
  
  // give a birth to new preys
  size = preys.size();
  for (int i = 0; i < size; i++) {
    if (preys.get(i).energy - COST > 0) {
      preys.add(preys.get(i).birth());  
    }
  }
  
  // give a birth to new predators
  size = predators.size();
  for (int i = 0; i < size; i++) {
    if (predators.get(i).energy - COST*10> 0) {
      predators.add(predators.get(i).birth());  
    }
  }
  
  // move plants
  for (int i = 0; i < plants.size(); i++) {
    if (collisionPlant(plants.get(i)) && (!plants.get(i).moving)) {
      plants.get(i).moving = true;
      plants.get(i).dx = random(-1, 1);
      plants.get(i).dy = random(-1, 1);
      plants.get(i).startedMoving = millis();
    }
    if (!collisionPlant(plants.get(i))) {
      plants.get(i).moving = false;
      plants.get(i).dx = 0;
      plants.get(i).dy = 0;
      plants.get(i).startedMoving = millis();
    }
    if ((plants.get(i).x > 10) && (plants.get(i).x < 1240) && (plants.get(i).y > 10) && (plants.get(i).y < 640)) {
      plants.get(i).x += plants.get(i).dx;
      plants.get(i).y += plants.get(i).dy;
    } else {
      plants.remove(i); 
    }
  }
  
  
  
  // predators hunt preys
  for (int i = 0; i < predators.size(); i++) {
    int target = seePrey(predators.get(i));
    if (target != -1) {
      //if (!preys.get(target).beingChased) {
        //preys.get(target).beingChased = true;
        float distX = predators.get(i).x - preys.get(target).x;
        float distY = predators.get(i).y - preys.get(target).y;
        //float step = 1;
        float dist = sqrt(distX*distX + distY*distY);
        //float steps = dist / step;
        predators.get(i).dx = -distX / dist * 1.1;
        predators.get(i).dy = -distY / dist * 1.1;
      //} else {
        
      //}
      
    }
  }
  
  // preys hunt plants
  for (int i = 0; i < preys.size(); i++) {
    int target = seePlant(preys.get(i));
    if (target != -1) {
     // plants.get(target).beingChased = true;
      float distX = preys.get(i).x - plants.get(target).x;
      float distY = preys.get(i).y - plants.get(target).y;
      //float step = 1;
      float dist = sqrt(distX*distX + distY*distY);
      //float steps = dist / step;
      preys.get(i).dx = -distX / dist * 1.15;
      preys.get(i).dy = -distY / dist * 1.15;
    }
  }
  
  // move preys
  for (int i = 0; i < preys.size(); i++) {
    if ((preys.get(i).x > 10) && (preys.get(i).x < 1240) && (preys.get(i).y > 10) && (preys.get(i).y < 640)) {
      preys.get(i).x += 1.5*preys.get(i).dx;
      preys.get(i).y += 1.5*preys.get(i).dy;
    } else {
      preys.remove(i); 
    }
  }
  
  
  // move predators
  for (int i = 0; i < predators.size(); i++) {
    if ((predators.get(i).x > 10) && (predators.get(i).x < 1240) && (predators.get(i).y > 10) && (predators.get(i).y < 640)) {
      predators.get(i).x += predators.get(i).dx;
      predators.get(i).y += predators.get(i).dy;
    } else {
      predators.remove(i); 
    }
  }
  
  
  // preys eat
  for (int i = 0; i < preys.size(); i++) {
    for (int j = 0; j < plants.size(); j++) {
      if ((distance(preys.get(i), plants.get(j)) < SIZE) && (plants.get(j).energy > 0)) {
        plants.get(j).energy -= 10000;
        preys.get(i).energy += GAIN;
        preys.get(i).dx = random(-1, 1);
        preys.get(i).dy = random(-1, 1);
        break;
      }
    }
  }
  
  
  // predators eat
  for (int i = 0; i < predators.size(); i++) {
    for (int j = 0; j < preys.size(); j++) {
      if ((distance(predators.get(i), preys.get(j)) < SIZE) && (preys.get(j).energy > 0)) {
        preys.get(j).energy -= 10000;
        predators.get(i).energy += GAIN*2.5;
        predators.get(i).dx = random(-1, 1);
        predators.get(i).dy = random(-1, 1);
        break;
      }
    }
  }
  
  // kill predators
  for (int i = 0; i < predators.size(); i++) {
    if (predators.get(i).energy < 1) {
      predators.remove(i);
    }
  }
   
  // kill preys
  for (int i = 0; i < preys.size(); i++) {
    if (preys.get(i).energy < 1) {
      preys.remove(i);  
    }
  }
  
  // kill plants
  int i = 0;
  while ( i < plants.size() ) {
    if (plants.get(i).energy < 1) {
      plants.remove(i);  
      continue;
    }
    
    if (millis() - plants.get(i).startedMoving > 1000) {
      plants.remove(i);  
      continue;
    }
    i += 1;
  }
  
  // display plants
  for (Plant plant : plants) {
    plant.display(); 
  }
  
  // display preys
  for (Prey prey : preys) {
    prey.display(); 
    
  }
 
  // display predators
  for (Predator pred : predators) {
    pred.display();  
    //fill(255);
    //text(pred.energy, pred.x, pred.y);
  }
  
  if (millis() - lastRecord > INTERVAL*0.1) {
    popPlants.add(plants.size());
    popPreys.add(preys.size());
    lastRecord = millis();
  }
  
  if (true) {
    if (plants.size() > maxPlants) {
      maxPlants = plants.size();  
    }
    float maxY = maxPlants;
    float maxX = 1250;
    float x0 = 50;
    float y0 = 600;
    float count = popPlants.size();
    fill(255, 255, 255, 100);
    stroke(0);
    //rect(50, 100, 1150, 400);
    float dist = maxX / count;
    for (i = 1; i < count; i++) {
        stroke(0, 255, 0, 100);
        line(dist*(i-1), y0 - 300*(popPlants.get(i-1)/maxY), dist*i, y0 - 300*(popPlants.get(i)/maxY));
        stroke(0, 0, 255, 100);
        line(dist*(i-1), y0 - 300*(popPreys.get(i-1)/maxY), dist*i, y0 - 300*(popPreys.get(i)/maxY));
    }
  }
  
}
