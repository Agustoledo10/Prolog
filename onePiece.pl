
% tripulante(Pirata, Tripulacion)
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% impactoEnRecompensa(Pirata, Evento , Monto)
impactoEnRecompensa(luffy,arlongPark, 30000000).
impactoEnRecompensa(luffy,baroqueWorks, 70000000).
impactoEnRecompensa(luffy,eniesLobby, 200000000).
impactoEnRecompensa(luffy,marineford, 100000000).
impactoEnRecompensa(luffy,dressrosa, 100000000).

impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).

impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).

impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).

impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).

impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).


%? --------------------- 1 -----------------------

% participaronDelMismoEventoAgus(Trip1, Trip2, Evento):-
%     tripulante(P1, Trip1),
%     tripulante(P2, Trip2),
%     Trip1 \= Trip2,
%     impactoEnRecompensa(P1, Evento , _),
%     impactoEnRecompensa(P2, Evento, _).

%* es mejor verificar si se cumple la condicion para uno y desp preguntarlo para los dos
participaronDelMismoEvento(Trip1, Trip2, Evento):-
    participoDelEvento(Trip1, Evento),
    participoDelEvento(Trip2, Evento),
    Trip1 \= Trip2.
 
participoDeEvento(Tripulacion, Evento):-
    impactoEnRecompensa(Pirata, Evento, _),
    tripulante(Pirata, Tripulacion).

%? --------------------- 2 -----------------------

elMasDestacadoDelEvento(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento , MontoPirata),
    forall((impactoEnRecompensa(OtroPirata, Evento , MontoOtro), OtroPirata \= Pirata), MontoPirata > MontoOtro).

pirataMasDestacado(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    not((impactoEnRecompensa(_, Evento, OtraRecompensa),OtraRecompensa > Recompensa)).
%? --------------------- 3 -----------------------
%* si su recompensa no se vio impactada por dicho evento 
%* a pesar de que la trip participo
%? seria cierto para bepo, dressrosa

pasoDesapercibidoAgus(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    tripulante(OtroPirata, Tripulacion),
    Pirata \= OtroPirata,
    impactoEnRecompensa(Pirata, _, Recompensa),
    impactoEnRecompensa(OtroPirata, Evento, _),
    not(impactoEnRecompensa(Pirata, Evento, Recompensa)).

pasoDesapercibido(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    participoDeEvento(Tripulacion, Evento),
    not(impactoEnRecompensa(Pirata, Evento, _)).
    
%? --------------------- 4 -----------------------
%* recompensa total de una tripulacion, suma de las recompensas actuales de sus miembros

recompensaTripulacion(Tripulacion , RecompensaTotal):-
    tripulante(_, Tripulacion),
    findall(Recompensa, (tripulante(Pirata, Tripulacion), impactoEnRecompensa(Pirata, _, Recompensa)), Recompensas),
    sumlist(Recompensas, RecompensaTotal).


%? --------------------- 5 -----------------------

recompensaPorElPirata(Pirata, RecompensaActual):-
    tripulante(Pirata, _),
    findall(Recompensa, impactoEnRecompensa(Pirata, _ ,Recompensa), ListaDeRecompensas),
    sumlist(ListaDeRecompensas, RecompensaActual).



temible(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), peligroso(Pirata)).

temible(Tripulacion):-
    recompensaTripulacion(Tripulacion , RecompensaTotal),
    RecompensaTotal > 500000000.

peligroso(Pirata):-
    recompensaPorElPirata(Pirata, RecompensaActual),
    RecompensaActual > 100000000.
%? --------------------- modelado polimorfico + (PRIMERO EL PUNTO 6) -----------------------
%* comio(Pirata,(tipo(fruta)).
%! INFO QUE NO INTERVIENE EN EL PREDICADO ES TOTALMENTE DESCARTADA

peligroso(Pirata):-
    comio(Pirata, Fruta),
    esPeligrosa(Fruta).

comio(luffy, paramecia(gomugomu)).
comio(buggy, paramecia(barabara)).
comio(law, paramecia(opeope)).
comio(bepo, paramecia(opeope)).
comio(chopper, zoan(hitohito, humano)).
comio(lucci, zoan(nekoneko, leopardo)).
comio(smoker, logia(mokumoku, humo)).

esPeligrosa(paramecia(opeope)).
esPeligrosa(zoan(_, Especie)):-
    feroz(Especie).
esPeligrosa(logia(_,_)).

feroz(lobo).
feroz(leopardo).
feroz(zanahoria).


%? 6b.Justificar las decisiones de modelado
%* Decidi modelar de esta forma ya que al crear una sola forma para referirme a las
%* frutas que comieron distintas personas, puedo hacer un unico uso del predicado
%* comio(Pirata, Fruta) y si necesitase agregar alguien que haya comido otra fruta
%* es tan facil como agregarla en mi base de conocomientos como un hecho, a esto le 
%* llamaria crear acciones como individuos.

%* luego al definir a una fruta como peligrosa aparte, me salvo de tener que modificar
%* un functor que tenga muchas caracteristicas para una fruta. 
%* Ej: carac([rica, peligrosa], Fruta). si lo tuviese asi seria mas dificil crear predicados

%? --------------------- 7 -----------------------
%* Saber si una tripulación es de piratas de asfalto, 
%* que se cumple si ninguno de sus miembros puede nadar.

piratasDeAsfalto(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), comio(Pirata, _)).

puedeNadar(Persona):-
    not(comio(Persona, _)).
      
piratasDeAsfaltoV2(Tripulacion):-
    tripulante(_,Tripulacion),
    forall(tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata))).