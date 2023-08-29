viveEnDreadbury(tiaAgatha).
viveEnDreadbury(mayordomo).
viveEnDreadbury(charles).

odia(tiaAgatha, Persona):-
    viveEnDreadbury(Persona),
    Persona \= mayordomo.

odia(mayordomo,Persona):- odia(tiaAgatha, Persona).

odia(charles, Persona):- 
    viveEnDreadbury(Persona),
    not(odia(tiaAgatha, Persona)).


esMasRico(Persona, tiaAgatha):-
    viveEnDreadbury(Persona),
    not(odia(mayordomo, Persona)).

mata(Persona, Victima):-
    odia(Persona, Victima),
    not(esMasRico(Persona,Victima)),
    viveEnDreadbury(Persona).


