

PBDSystem crea_tela(float alto,
    float ancho,
    float dens,
    int n_alto,
    int n_ancho,
    float stiffness,
    float display_size,
    PVector posicion_inicial){
   
  int N = n_alto*n_ancho;
  float masa = dens*alto*ancho;
  PBDSystem tela = new PBDSystem(N,masa/N);
  
  float dx = ancho/(n_ancho-1.0);
  float dy = alto/(n_alto-1.0);
  
  int id = 0;
  for (int i = 0; i< n_ancho;i++){
    for(int j = 0; j< n_alto;j++){
      Particle p = tela.particles.get(id);
      p.location.set(PVector.add(posicion_inicial,new PVector(dx*i,dy*j,0)));
      p.display_size = display_size;

      id++;
    }
  }
  
  /**
   * Creo restricciones de distancia. Aquí sólo se crean restricciones de estructura.
   * Faltarían las de shear y las de bending.
   */
  id = 0;
  for (int i = 0; i< n_ancho;i++){
    for(int j = 0; j< n_alto;j++){
      println("id: "+id+" (i,j) = ("+i+","+j+")");
      Particle p = tela.particles.get(id);
      if(i>0){
        int idx = id - n_alto;
        Particle px = tela.particles.get(idx);
        Constraint c = new DistanceConstraint(p,px,dx,stiffness);
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idx);
      }

      if(j>0){
        int idy = id - 1;
        Particle py = tela.particles.get(idy);
        Constraint c = new DistanceConstraint(p,py,dy,stiffness);
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idy);
      }


      id++;
    }
  }
  
  println("Restricciones de Triangulo");
  id = 0;
  for (int i = 0; i< n_ancho;i++){
    for(int j = 0; j< n_alto;j++){
      println("id: "+id+" (i,j) = ("+i+","+j+")");
      Particle v = tela.particles.get(id);
      if( j>0 && i<n_ancho && i >0 ){
        int idx1 = id - n_alto;
        int idy = id - 1;
        Particle b0 = tela.particles.get(idx1);
        Particle b1 = tela.particles.get(idy);
        Constraint c = new TriangleConstrain(v,b0,b1,stiffness);
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idx1+"->"+idy);
      }
      if(i<n_ancho -1 && j>0)
      {
        int idx2 = id + n_alto;
        int idy = id - 1;
        Particle b0 = tela.particles.get(idy);
        Particle b1 = tela.particles.get(idx2);
        Constraint c2 = new TriangleConstrain(v,b0,b1,stiffness);
        println("Restricción creada: "+ id+"->"+idx2+"->"+idy);
        tela.add_constraint(c2);
      }
      if( j>0 && i<n_ancho && i >0&& j<n_alto-1){
        int idx1 = id - n_alto;
        int idy = id + 1;
        Particle b0 = tela.particles.get(idx1);
        Particle b1 = tela.particles.get(idy);
        Constraint c = new TriangleConstrain(v,b0,b1,stiffness);
        tela.add_constraint(c);
        println("Restricción creada: "+ id+"->"+idx1+"->"+idy);
      }
      if(i<n_ancho -1 && j>0 && j<n_alto-1)
      {
        int idx2 = id + n_alto;
        int idy = id + 1;
        Particle b0 = tela.particles.get(idy);
        Particle b1 = tela.particles.get(idx2);
        Constraint c2 = new TriangleConstrain(v,b0,b1,stiffness);
        println("Restricción creada: "+ id+"->"+idx2+"->"+idy);
        tela.add_constraint(c2);
      }


      id++;
    }
  }


    println("Restricciones de bending");

    id = 0;
    for (int i = 0; i< n_ancho;i++){
      for(int j = 0; j< n_alto;j++){
        if( j > 1 && i<n_ancho-2)
        {
          println("primero");
          int idx1 = id + n_alto - 2;
          int idx2 = id;
          int idx3 = id + 2 * n_alto;

          Particle x1 = tela.particles.get(idx1);
          Particle x2 = tela.particles.get(idx2);
          Particle x3 = tela.particles.get(idx3);

          Constraint c = new TriangleConstrain(x1,x2,x3,stiffness);
          tela.add_constraint(c);
          println("Restricción creada primero: "+ idx1+"->"+idx2+"->"+idx3);

        }
        if( i >1 && j<n_alto-2)
        {
          println("segundo");
          int idx1 = id - 2*n_alto + 1;
          int idx2 = id;
          int idx3 = id + 2 ;

          Particle x1 = tela.particles.get(idx1);
          Particle x2 = tela.particles.get(idx2);
          Particle x3 = tela.particles.get(idx3);

          Constraint c = new TriangleConstrain(x1,x2,x3,stiffness);
          tela.add_constraint(c);
          println("Restricción creada segundo: "+ idx1+"->"+idx2+"->"+idx3);

        }
        if(i> 1 && j>1 )
        {
          println("tercero");
          int idx1 = id -n_alto - 2;
          int idx2 = id;
          int idx3 = id - 2 * n_alto;

          Particle x1 = tela.particles.get(idx1);
          Particle x2 = tela.particles.get(idx2);
          Particle x3 = tela.particles.get(idx3);

          Constraint c = new TriangleConstrain(x1,x2,x3,stiffness);
          tela.add_constraint(c);
          println("Restricción creada tercera: "+ idx1+"->"+idx2+"->"+idx3);

        }
        if(j> 1 &&  i<n_alto-2)
        {
          println("cuarto");
          int idx1 = id + 2*n_alto - 1;
          int idx2 = id;
          int idx3 = id - 2;

          Particle x1 = tela.particles.get(idx1);
          Particle x2 = tela.particles.get(idx2);
          Particle x3 = tela.particles.get(idx3);

          Constraint c = new TriangleConstrain(x1,x2,x3,stiffness);
          tela.add_constraint(c);
          println("Restricción creada cuarto: "+ idx1+"->"+idx2+"->"+idx3);

        }

        id++;
      }
    }
  



  // if(posicion_inicial.x == 0.0){
  //     println("Restricciones de bending");

  //   id = 0;
  //   for (int i = 0; i< n_ancho;i++){
  //     for(int j = 0; j< n_alto;j++){
  //       if(i> 0 && j > 0 && i<n_ancho-1)
  //       {
  //         int idx3 = id - n_alto;
  //         int idx2 = id -1;
  //         int idx1 = id;
  //         int idx4 = id + n_alto;

  //         Particle x1 = tela.particles.get(idx1);
  //         Particle x2 = tela.particles.get(idx2);
  //         Particle x3 = tela.particles.get(idx3);
  //         Particle x4 = tela.particles.get(idx4);

  //         Constraint c = new BendingConstraint(x1,x2,x3,x4,stiffness);
  //         tela.add_constraint(c);
  //         println("Restricción creada: "+ idx1+"->"+idx2+"->"+id+"->"+idx4);

  //       }
  //       if(j> 0 && i < n_ancho -1 && j<n_alto-1)
  //       {
  //         int idx3 = id - 1;
  //         int idx2 = id + n_alto;
  //         int idx1 = id;
  //         int idx4 = id + 1;

  //         Particle x1 = tela.particles.get(idx1);
  //         Particle x2 = tela.particles.get(idx2);
  //         Particle x3 = tela.particles.get(idx3);
  //         Particle x4 = tela.particles.get(idx4);

  //         Constraint c = new BendingConstraint(x1,x2,x3,x4,stiffness);
  //         tela.add_constraint(c);
  //         println("Restricción creada: "+ idx1+"->"+idx2+"->"+id+"->"+idx4);

  //       }
  //       if(i> 0 && j>0 &&j < n_alto -1 && i<n_ancho-1)
  //       {
  //         int idx3 = id + n_alto;
  //         int idx2 = id -1;
  //         int idx1 = id;
  //         int idx4 = id - n_alto;

  //         Particle x1 = tela.particles.get(idx1);
  //         Particle x2 = tela.particles.get(idx2);
  //         Particle x3 = tela.particles.get(idx3);
  //         Particle x4 = tela.particles.get(idx4);

  //         Constraint c = new BendingConstraint(x1,x2,x3,x4,stiffness);
  //         tela.add_constraint(c);
  //         println("Restricción creada: "+ idx1+"->"+idx2+"->"+id+"->"+idx4);

  //       }
  //       if(j> 0 && i > 0 && j<n_alto-1)
  //       {
  //         int idx3 = id + 1;
  //         int idx2 = id - n_alto;
  //         int idx1 = id;
  //         int idx4 = id - 1;

  //         Particle x1 = tela.particles.get(idx1);
  //         Particle x2 = tela.particles.get(idx2);
  //         Particle x3 = tela.particles.get(idx3);
  //         Particle x4 = tela.particles.get(idx4);

  //         Constraint c = new BendingConstraint(x1,x2,x3,x4,stiffness);
  //         tela.add_constraint(c);
  //         println("Restricción creada: "+ idx1+"->"+idx2+"->"+id+"->"+idx4);

  //       }

  //       id++;
  //     }
  //   }
  
  // }
  

  // Fijamos dos esquinas
  id = n_alto-1;
  tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY); 
  
  id = N-1;
  tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY); 

  id = N-n_alto;
  tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY);

  id = 0;
  tela.particles.get(id).set_bloqueada(true,Float.POSITIVE_INFINITY);
  
  print("Tela creada con " + tela.particles.size() + " partículas y " + tela.constraints.size() + " restricciones.\n"); 
  
  return tela;
}
