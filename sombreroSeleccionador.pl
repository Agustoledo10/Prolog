%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 1 - Sombrero Seleccionador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mago(harry).
mago(hermione).
mago(draco).
mago(ron).
mago(fred).
mago(george).

caracteristicas(harry,[coraje, amistoso, orgullo, inteligencia]).
caracteristicas(draco, [inteligente, orgullo]).
caracteristicas(hermione, [inteligencia, orgullo, responsabilidad]).
caracteristicas(ron,[amistad]).
caracteristicas(fred,[amistad]).
caracteristicas(george,[amistad]).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).
sangre(fred, pura).
sangre(george, pura).
sangre(ron, pura).

casa(slytherin).
casa(ravenclaw).
casa(gryffindor).
casa(hufflepuff).

caracteristicaBuscada(gryffindor, coraje).
caracteristicaBuscada(slytherin, orgullo).
caracteristicaBuscada(slytherin, inteligencia).
caracteristicaBuscada(ravenclaw, inteligencia).
caracteristicaBuscada(ravenclaw, responsabilidad).
caracteristicaBuscada(hufflepuff, amistad).

permiteEntrar(Casa, Mago):-
    mago(Mago),
    casa(Casa),
    Casa \= slytherin.

permiteEntrar(slytherin, Mago):-
    mago(Mago),
    sangre(Mago, Sangre),
    Sangre \= impura.

tieneCaracteristica(Mago, Caracteristica):-
    caracteristicas(Mago, Caracteristicas),
    member(Caracteristica, Caracteristicas).

tieneCaracterApropiado(Mago,Casa):-
    mago(Mago),
    casa(Casa),
    forall(caracteristicaBuscada(Casa,Caracteristica),tieneCaracteristica(Mago, Caracteristica)).


%? -------------------------------- 3 ---------------------


odiaria(harry, slytherin).
odiaria(draco, hufflepuff).


%! hacerlo como  hecho tmb funciona
puedeQuedarEn(hermione,gryffindor).

puedeQuedarEn(Casa, Mago):-
    tieneCaracterApropiado(Mago,Casa),
    permiteEntrar(Casa, Mago),
    not(odiaria(Mago,Casa)).

%? --------------------- 4 --------------------------

%*  Pone Magos en vez de [Mago]
%*  Definen el mago amistoso con un predicado si tiene esa caracteristica

cadenaDeAmistades(Magos):-
    todosAmistosos(Magos),
    cadenaDeCasas(Magos).
      
todosAmistosos(Magos):-
    forall(member(Mago, Magos), amistoso(Mago)).
      
amistoso(Mago):-
    tieneCaracteristica(Mago, amistad).

%* caso recursivo en el que se evalua para los 2 primeros magos de la lista y desp para 
%* el 2do mago como cabeza  y los demas como cola, xq sino no es una cadena y nos saltearimos
%* la relacion con el mago2
cadenaDeCasas([Mago1, Mago2 | MagosSiguientes]):-
    puedeQuedarEn(Mago1, Casa),
    puedeQuedarEn(Mago2, Casa),
    cadenaDeCasas([Mago2 | MagosSiguientes]).
cadenaDeCasas([_]).
cadenaDeCasas([]).



