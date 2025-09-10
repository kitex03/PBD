
abstract class Constraint{

  ArrayList<Particle> particles;
  float stiffness;    // k en el paper de Muller
  float k_coef;       // k' en el paper de Muller
  float C;
  
  Constraint(){
    particles = new ArrayList<Particle>();
  }
  
  void  compute_k_coef(int n){
    k_coef = 1.0 - pow((1.0-stiffness),1.0/float(n));
    // println("Fijamos "+n+" iteraciones   -->  k = "+stiffness+"    k' = "+k_coef+".");
  }

  abstract void proyecta_restriccion();
  abstract void display(float scale_px);
}

class DistanceConstraint extends Constraint{

  float d;
  
  DistanceConstraint(Particle p1,Particle p2,float dist,float k){
    super();
    d = dist;
    particles.add(p1);
    particles.add(p2);
    stiffness = k;
    k_coef = stiffness;
    C=0;

  }
  
  void proyecta_restriccion(){
    Particle part1 = particles.get(0); 
    Particle part2 = particles.get(1);
    
    PVector vd = PVector.sub(part1.location,part2.location);

    if(debug){
      println("PROYECTA: p1="+part1.location);
      println("PROYECTA: p2="+part2.location);
      println("PROYECTA: p1-p2="+vd);
    }
    
    float W = part1.w + part2.w;
    float dist = vd.mag();
    if(W < 1e-6 || dist < 1e-6)
      return;

    
    C = dist - d; // distancia actual - distancia deseada
    PVector n = PVector.mult( vd , 1.0 / dist);

    PVector delta_pi = PVector.mult(n, -k_coef * part1.w / W * C);
    PVector delta_pj = PVector.mult(n, k_coef * part2.w / W * C);

    part1.location.add(delta_pi);
    part2.location.add(delta_pj);
    
    
  }
  
  void display(float scale_px){
    PVector p1 = particles.get(0).location; 
    PVector p2 = particles.get(1).location; 
    strokeWeight(3);
    stroke(255,255*(1-abs(4*C/d)),255*(1-abs(4*C/d)));
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p2.x, -scale_px*p2.y, scale_px*p2.z);
  };
  
}

class TriangleConstrain extends Constraint{

  float h0;
  PVector c;
  
  TriangleConstrain(Particle v,Particle b0, Particle b1,float k){
    super();
    c = PVector.add(v.location,PVector.add(b0.location,b1.location)).mult(1./3.);
    h0 = PVector.sub(v.location,c).mag();
    particles.add(v);
    particles.add(b0);
    particles.add(b1);
    stiffness = k;
    k_coef = stiffness;
    C=0;
  }

  void proyecta_restriccion(){
    Particle v = particles.get(0);
    Particle b0 = particles.get(1);
    Particle b1 = particles.get(2);
    
    c = PVector.add(v.location,PVector.add(b0.location,b1.location)).mult(1./3.);
    float W = b0.w + b1.w + 2*v.w;
    float h = PVector.sub(v.location,c).mag();

    if(W < 1e-6 || h < 1e-6)
      return;

    C = 1 - (h0 / h);

    PVector delta_b0 = PVector.mult(PVector.sub(v.location,c), k_coef * ( (2 * b0.w )/ W) * C);
    PVector delta_b1 = PVector.mult(PVector.sub(v.location,c), k_coef * ( (2 * b1.w )/ W) * C);
    PVector delta_v = PVector.mult(PVector.sub(v.location,c), k_coef * ( (-4 * v.w )/ W) * C);

    b0.location.add(delta_b0);
    b1.location.add(delta_b1);
    v.location.add(delta_v);

  }

  void display(float scale_px){
    PVector v = particles.get(0).location; 
    PVector b0 = particles.get(1).location; 
    PVector b1 = particles.get(2).location; 
    strokeWeight(3);
    stroke(255,255*(1-abs(4*C)),255*(1-abs(4*C)));
    line(scale_px*v.x, -scale_px*v.y, scale_px*v.z,  scale_px*b0.x, -scale_px*b0.y, scale_px*b0.z);
    line(scale_px*v.x, -scale_px*v.y, scale_px*v.z,  scale_px*b1.x, -scale_px*b1.y, scale_px*b1.z);
    line(scale_px*b0.x, -scale_px*b0.y, scale_px*b0.z,  scale_px*b1.x, -scale_px*b1.y, scale_px*b1.z);
  };

}

class BendingConstraint extends Constraint{
  
  float phi0;

  BendingConstraint(Particle x1,Particle x2, Particle x3, Particle x4,float k){
    super();
    particles.add(x1);
    particles.add(x2);
    particles.add(x3);
    particles.add(x4);
    PVector n1 = PVector.sub(x2.location,x1.location).cross(PVector.sub(x3.location,x1.location)).normalize();
    PVector n2 = PVector.sub(x2.location,x1.location).cross(PVector.sub(x4.location,x1.location)).normalize();
    phi0 = PVector.angleBetween(n1,n2);
    stiffness = k;
    k_coef = stiffness;
    C=0;
  }

  void proyecta_restriccion(){
    Particle x1 = particles.get(0);
    Particle x2 = particles.get(1);
    Particle x3 = particles.get(2);
    Particle x4 = particles.get(3);

    PVector n1 = PVector.sub(x2.location,x1.location).cross(PVector.sub(x3.location,x1.location));
    PVector n2 = PVector.sub(x2.location,x1.location).cross(PVector.sub(x4.location,x1.location));
    n1.normalize();
    n2.normalize();

    float d = constrain(n1.dot(n2), -1.0, 1.0);


    float W = x1.w + x2.w + x3.w + x4.w;
    C = acos(d) - phi0;

    if(C < 1e-6 || d<1e-6 || W < 1e-6)
      return;

    

    PVector q3 =PVector.div(PVector.add(x2.location.cross(n2),n1.cross(x2.location).mult(d)),x2.location.cross(x3.location).mag());
    PVector q4 =PVector.div(PVector.add(x2.location.cross(n1),n2.cross(x2.location).mult(d)),x2.location.cross(x4.location).mag());

    PVector q2_1 =PVector.div(PVector.add(x3.location.cross(n2),n1.cross(x3.location).mult(d)),x2.location.cross(x3.location).mag()).mult(-1);
    PVector q2_2 =PVector.div(PVector.add(x4.location.cross(n1),n2.cross(x4.location).mult(d)),x2.location.cross(x4.location).mag()).mult(-1);
    PVector q2 = PVector.add(q2_1,q2_2);

    PVector q1 = PVector.add(q2.mult(-1), PVector.add(q3.mult(-1),q4.mult(-1)));

    float sumq = q1.magSq() + q2.magSq() + q3.magSq() + q4.magSq();
    float numerador = sqrt(1-sq(d)) * (C);
    float division = numerador / sumq;




    PVector delta_p1 = PVector.mult(q1, ((-4 * x1.w) / W ) * division);
    PVector delta_p2 = PVector.mult(q2, ((-4 * x2.w) / W ) * division);
    PVector delta_p3 = PVector.mult(q3, ((-4 * x3.w) / W ) * division);
    PVector delta_p4 = PVector.mult(q4, ((-4 * x4.w) / W ) * division);

    x1.location.add(delta_p1);
    x2.location.add(delta_p2);
    x3.location.add(delta_p3);
    x4.location.add(delta_p4); //<>//
    
    
  }

  void display(float scale_px){
    PVector p1 = particles.get(0).location; 
    PVector p2 = particles.get(1).location; 
    PVector p3 = particles.get(2).location; 
    PVector p4 = particles.get(3).location; 
    strokeWeight(3);
    stroke(0,255*(1-abs(4*C/phi0)),255*(1-abs(4*C/phi0)));
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p2.x, -scale_px*p2.y, scale_px*p2.z);
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p3.x, -scale_px*p3.y, scale_px*p3.z);
    line(scale_px*p1.x, -scale_px*p1.y, scale_px*p1.z,  scale_px*p4.x, -scale_px*p4.y, scale_px*p4.z);
  };
  
}
