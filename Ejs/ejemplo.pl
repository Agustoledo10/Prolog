humano(platon).
humano(aristoteles).
humano(socrates).

mortal(Alguien):- humano(Alguien).
mortal(elGalloDeAsclepio).

maestro(socrates, platon).
maestro(platon, aristoteles).

groso(Alguien):-
    maestro(Alguien, Uno),
    maestro(Alguien, Otro),
    Uno \= Otro.

