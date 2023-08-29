%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%? -------------------- 1 ---------------------------
%* Acciones como predicados.
%* hacemos primero el punto y despues completamos la base de conocimiento
%! no tenemos en cuenta los puntos sino las acciones y sus relaciones primero

esDe(hermione, gryffindor). 
esDe(ron, gryffindor). 
esDe(harry, gryffindor). 
esDe(draco, slytherin). 
esDe(luna, ravenclaw).

%* denotamos las acciones como hechos

fueraDeCama(harry).

fueA(draco, mazmorras).

%* buenaAccion(persona, puntos, accion).
buenaAccion(ron, 50, ganoAjedrez).
buenaAccion(harry, 60, ganoAVoldemort).
buenaAccion(hermione,50, salvarASusAmigos).

lugarProhibido(bosque, 50).
lugarProhibido(seccionRestringida, 10).
lugarProhibido(tercerPiso, 75).

%* representamos las acciones como individuos, osea hacemos un predicado
%* hizo (persona, quehizo(como/donde)).

hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, irA(seccionProhibida)).
hizo(harry, irA(tercerPiso)).
hizo(harry, irA(bosque)).
hizo(draco, irA(mazmorras)).
hizo(ron, buenaAccion(50, ganarAjedrez)).
hizo(hermione, buenaAccion(50,salvarASusAmigos)).
hizo(harry, buenaAccion(60, ganarleAVoldemort)).

hizoAlgunaAccion(Mago):-
    hizo(Mago, _).

%* hizo algo malo si lo que hizo genera un puntaje negativo
hizoAlgoMalo(Mago):-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntaje),
    Puntaje < 0.

puntajeQueGenera(buenaAccion(PuntosQueSuma,_), PuntosQueSuma).

puntajeQueGenera(fueraDeCama, -50).

puntajeQueGenera(irA(Lugar), PuntosQueResta):-
    lugarEsProhibido(Lugar,Puntos),
    PuntosQueResta is Puntos * -1.

lugarEsProhibido(seccionProhibida, 10).
lugarEsProhibido(bosque, 50).
lugarEsProhibido(tercerPiso, 75).

%* true or false? verifica la condicion de que sea buen alumno, no quiero que me 
%* devuelva puntajes, sino que vea si tiene o no puntajes negativos.
esBuenAlumno(Mago):-
    hizoAlgunaAccion(Mago),
    not(hizoAlgoMalo(Mago)).

%* 1b)Saber si una acción es recurrente, que se cumple si más de un mago 
%* hizo esa misma acción.

esRecurrente(Accion):-
    hizo(Mago, Accion),
    hizo(Mago2, Accion),
    Mago \= Mago2.
   
%? --------------------------- 2 -------------------------
%* Saber cuál es el puntaje total de una casa, que es la suma de los 
%* puntos obtenidos por sus miembros.

%? los puntos se obtienen a traves de una accion
puntosObtenidos(Mago, Accion, Puntos):-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntos).

puntajeTotalCasa(Casa,PuntajeTotal):-
    esDe(_, Casa),
    findall( Puntos, puntosObtenidos(Mago, _, Puntos), ListaDePuntos),
    sumlist(ListaDePuntos, PuntajeTotal).

%? --------------------------- 3 -------------------------
%* Saber cuál es la casa ganadora de la copa, que se verifica para aquella 
%* casa que haya obtenido una cantidad mayor de puntos que todas las otras. 

%? Para todas las otras casas el puntaje debe ser menor
ganoLaCopa(Casa):-
    puntajeTotalCasa(Casa, PuntajeMayor),
    forall((puntajeTotalCasa(OtraCasa, PuntajeMenor), Casa \= OtraCasa), PuntajeMayor > PuntajeMenor).

%? --------------------------- 4 -------------------------
hizo(hermione, responderPregunta(dondeBezoar, 20, snape)).
hizo(hermione, responderPregunta(levitarPluma, 25, flitwick)).

puntajeQueGenera(responderPregunta(_, PuntosQueSuma, Profesor), PuntosQueSuma):- Profesor \= snape.

puntajeQueGenera(responderPregunta(_, PuntosQueSuma, snape), PuntosQueDa):-
    PuntosQueDa is PuntosQueSuma // 2.