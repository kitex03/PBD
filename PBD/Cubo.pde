PBDSystem crea_cubo(float alto,
    float ancho,
    float prof,
    float dens,
    int n_alto,
    int n_ancho,
    float stiffness,
    float display_size,
    PVector posicion_inicial){
   
  int N = n_alto*n_ancho * n_ancho;
  float masa = dens*alto*ancho;
  PBDSystem tela = new PBDSystem(N,masa/N);
  
  float dx = ancho/(n_ancho-1.0);
  float dy = alto/(n_alto-1.0);
  float dz = prof/(n_ancho-1.0);
  
  int id = 0;
  for(int k = 0; k< n_ancho;k++){
    for (int i = 0; i< n_ancho;i++){
        for(int j = 0; j< n_alto;j++){
        Particle p = tela.particles.get(id);
        p.location.set(PVector.add(posicion_inicial,new PVector(dx*i,dy*j,dz*k)));
        p.display_size = display_size;

        id++;
        }
    }
  }
  
  /**
   * Creo restricciones de distancia. Aquí sólo se crean restricciones de estructura.
   * Faltarían las de shear y las de bending.
   */
  id = 0;
  for(int k = 0; k< n_alto;k++){
    for (int i = 0; i< n_ancho;i++){
        for(int j = 0; j< n_alto;j++){
            Particle p = tela.particles.get(id);
            if(i>0){
                int idx = id - n_alto;
                Particle px = tela.particles.get(idx);
                Constraint c = new DistanceConstraint(p,px,dx,stiffness);
                tela.add_constraint(c);
            }

            if(j>0){
                int idy = id - 1;
                Particle py = tela.particles.get(idy);
                Constraint c = new DistanceConstraint(p,py,dy,stiffness);
                tela.add_constraint(c);
            }
            if(k>0){
                int idz = id - n_alto*n_ancho;
                Particle pz = tela.particles.get(idz);
                Constraint c = new DistanceConstraint(p,pz,dz,stiffness);
                tela.add_constraint(c);
            }
            if(i < n_ancho -2 && k < n_alto-1  && j < n_alto-1 ){
                int idx = id + n_alto*n_ancho+n_alto+1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if(i < n_ancho -2 && k < n_alto-1  && j >0 ){
                int idx = id + n_alto*n_ancho+n_alto-1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if( k >1 && j < n_alto-1 && i < n_ancho -1 ){
                int idx = id - n_alto*n_ancho+n_alto+1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if( k>0 && i < n_ancho -1&& j>0){
                int idx = id - n_alto*n_ancho+n_alto-1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if(i < n_ancho-1  && k < n_alto-1  && j < n_alto ){
                int idx = id + n_alto*n_ancho+n_alto;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if(i >0  && k < n_alto-1  && j < n_alto ){
                int idx = id + n_alto*n_ancho-n_alto;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if(i < n_ancho && k < n_alto-1  && j < n_alto-1 ){
                int idx = id + n_alto*n_ancho+1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if(i < n_ancho && k < n_alto-1  && j >0){
                int idx = id + n_alto*n_ancho-1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if( i>0&& k >0 && i < n_ancho && j > 0){
                int idx = id - n_ancho -1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }
            if( i>0&& k >0 && i < n_ancho && j < n_alto-1){
                int idx = id - n_ancho +1;
                Particle px = tela.particles.get(idx);
                float dist = PVector.dist(p.location,px.location);
                Constraint c = new DistanceConstraint(p,px,dist,stiffness);
                tela.add_constraint(c);
                
            }



            id++;
            }
        }
    }

    
  

  // Fijamos dos esquinas
    id = n_alto-1;
    tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY);
    print("Fijamos partícula "+id+" como bloqueada.\n");

    id=N - n_alto*(n_ancho-1)-1;
    tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY);
    print("Fijamos partícula "+id+" como bloqueada.\n");

    id = n_ancho*n_alto - 1;
    tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY);
    print("Fijamos partícula "+id+" como bloqueada.\n");
  
    id = N-1;
    tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY); 
    print("Fijamos partícula "+id+" como bloqueada.\n");
  
    print("Tela creada con " + tela.particles.size() + " partículas y " + tela.constraints.size() + " restricciones.\n"); 
  
  return tela;
}
