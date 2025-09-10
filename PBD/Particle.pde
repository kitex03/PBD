class Particle {

  PVector acceleration;
  PVector force;
  PVector velocity;
  PVector location;
  PVector last_location;
  
  float masa;
  float w;
  
  boolean bloqueada;
  
  float display_size;

  Particle(PVector l, PVector v, float ma) {
    acceleration = new PVector(0.0f,0.0f,0.0f);
    force = new PVector(0.0f,0.0f,0.0f);
    velocity = v.get();
    location = l.get();
    
    masa = ma;
    w = 1.0f/ma;   
    
    display_size = 0.1;
  }

  void set_bloqueada(boolean bl, float m){
    bloqueada = bl;
    w = 1.0f/m;
    masa = m;
  }

  void update_pbd_vel(float dt){
   velocity = PVector.sub(location, last_location).div(dt);
  }

  // Method to update location
  void update(float dt) {

    //--->actualizar la aceleracion de la particula con la fuerza actual
    acceleration.add(force.mult(w));
    
    //--->guardamos posicion anterior, para PBD 
    last_location = location.copy();

    //---> Predicción de PBD
    //---> Utilizar euler semiimplicito para calcular velocidad y posicion
    velocity.add(acceleration.mult(dt));
    location.add(velocity.mult(dt)); 
    
    //---> Limpieza de fuerzas y aceleraciones
    acceleration = new PVector(0.0f,0.0f,0.0f);
    force = new PVector(0.0f,0.0f,0.0f);
  }
  
  PVector getLocation(){
    return location;
  }

  PVector getLastLocation(){
    return last_location;
  }

  void display(float scale_px){
    strokeWeight(1);
    stroke(125);
    pushMatrix();
      fill(220);
      translate(scale_px*location.x,
                  -scale_px*location.y, // OJO!! Se le cambia el signo, porque los px aumentan hacia abajo
                  scale_px*location.z);
      sphereDetail(12);
      sphere(scale_px*display_size);
    popMatrix();
      
  }

  void ComputePlaneCollisions(PVector normal, float d){
    if(location.y > 0)
      return;
    println("posicion: "+location);
    PVector v_normal = PVector.mult(normal, PVector.dot(velocity, normal));
    PVector v_tangencial = PVector.sub(velocity, v_normal);
    velocity = PVector.sub(v_tangencial,v_normal);
    float _s = PVector.dot(location, normal) - d;
    location = PVector.add(location, PVector.mult(normal, _s));
  }

}