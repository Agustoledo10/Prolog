%* Se cumple para los jugadores.
% jugador(Jugador).
% Ejemplo:
jugador(rojo).
jugador(amarillo).
jugador(azul).
jugador(verde). %!el q perdio
jugador(violeta). %! el que esta en todos los paises de amerDS
%* Relaciona un país con el continente en el que está ubicado,
% ubicadoEn(Pais, Continente).
% Ejemplo:
ubicadoEn(argentina, americaDelSur).

ubicadoEn(usa, americaDelNorte).
%* Relaciona dos jugadores si son aliados.
% aliados(UnJugador, OtroJugador).
% Ejemplo:
aliados(rojo, amarillo).
%* Relaciona un jugador con un país en el que tiene ejércitos.
% ocupa(Jugador, Pais).
% Ejemplo:
ocupa(rojo, argentina).
ocupa(azul, brasil).

ocupa(violeta, argentina).
ocupa(violeta, brasil).
ocupa(violeta, usa).
%* Relaciona dos países si son limítrofes.
% limitrofes(UnPais, OtroPais).
% Ejemplo:
limitrofes(argentina, brasil).

tienePresenciaEn(Jugador, Continente):-
    ocupa(Jugador, Pais),
    ubicadoEn(Pais, Continente).

puedenAtacarse(J1,J2):-
    ocupa(J1, Pais),
    ocupa(J2, OtroPais),
    Pais \= OtroPais,
    limitrofes(Pais, OtroPais).

sinTensiones(J1,J2):-
    jugador(J1),
    jugador(J2),
    not(puedenAtacarse(J1,J2)),

sinTensiones(J1,J2):- aliados(J1,J2).

%* perdió/1: Se cumple para un jugador que no ocupa ningún país.
perdio(J1):-
    jugador(J1),
    not(ocupa(J1, _)).

%* controla/2: Relaciona un jugador con un continente si ocupa todos los países del mismo.
controla(J1, Continente):-
    jugador(J1),ubicadoEn(_, Continente),
    forall(ubicadoEn(Pais, Continente), ocupa(J1, Pais)).
% ocupa(Jugador, Pais).
% ubicadoEn(Pais, Continente).

%* reñido/1: Se cumple para los continentes donde todos los jugadores ocupan algún país.
renido(Continente):-
    ubicadoEn(_, Continente),
    forall(jugador(J1), (ocupa(J1,Pais), ubicadoEn(Pais, Continente))).

renido(Continente):-
    ubicadoEn(_, Continente),
    not(jugador(J1), not(ocupa(J1,Pais), ubicadoEn(Pais, Continente))).

%* atrincherado/1: Se cumple para los jugadores que ocupan países en un único continente.
%* que no ocupe en otroContinente que no sea Continente
atrincherado(J1):-
    ocupa(J1, Pais),
    ubicadoEn(_,Continente),
    forall(ocupa(J1,Pais), ubicadoEn(Pais, Continente)).
% ocupa(Jugador, Pais).

    
puedeConquistar(J1, Continente):-
    jugador(J1), ubicadoEn(_,Continente),
    not(controla(J1, Continente)),
    forall(ubicadoEn(PaisQueFalta, Continente),puedeAtacar(J1, PaisQueFalta)).

puedeAtacar(J1, PaisQueFalta):-
    ocupa(J1, Pais),
    limitrofes(PaisQueFalta,Pais),
    not(aliados(J1,J2),ocupa(J2, PaisQueFalta)).