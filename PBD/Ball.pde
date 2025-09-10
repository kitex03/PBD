public class Ball extends Part
{
   float _r;       // Radius (m)
   color _color;   // Color (RGB)


   Ball(PVector s, PVector v, float m, float r, color c)
   {
      super(s, v, m, false, false);

      _r = r;
      _color = c;
   }

   float getRadius()
   {
      return _r;
   }

   void render()
   {
      pushMatrix();
      {
         translate(_s.x*500, _s.y*500, _s.z*500);
         fill(_color);
         stroke(0);
         strokeWeight(0.5);
         sphereDetail(25);
         sphere(500*_r);
      }
      popMatrix();
   }

      void ComputeCollisions(ArrayList<Particle> nodes) {  
       for (Particle p : nodes) {
           float distanciaMinima = _r ;
           
           float distancia = abs(p.getLocation().z - _s.z);
           
           if (distancia < distanciaMinima) {
               println("Colisión");
               PVector normal = new PVector (0.0, 0.0, 1.0);
               normal.normalize();
               float dif_elongacion = distanciaMinima - distancia;
               float fuerza_elastica = 0.008 * dif_elongacion;
               PVector fuerza = PVector.mult(normal, fuerza_elastica);
               println("Fuerza aplicada: " + fuerza);
               
               p.force.add(fuerza);
               
               _F.add(PVector.mult(fuerza, -1));
           }
       }
   }
}