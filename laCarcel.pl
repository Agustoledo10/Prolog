% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotrafico([heroina, opio])).
prisionero(dayanara, narcotrafico([metanfetaminas])).

persona(Persona):- guardia(Persona).
persona(Persona):- prisionero(Persona,_).

% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).
controlaNotInv(Guardia, Otro):- 
    prisionero(Otro,_), 
    not(controla(Otro, Guardia)).

%* El predicado controla no es completamente inversible ya que cuando
%* consulto ?- controla(Alguien, Otro) Prolog busca infinitamente
%* si hay algun Alguien que controle a Otro y como tiene ligado Otro en prisionero
%* pero no Guardia entonces busca infinitamente a quien no controla el Otro ya que
%* lo ligue pero no ligue a guardia

/* 
El predicado es inversible solo para su seg parametro, mientras que para Guardia
que es usado recien en el not, no lo es. Se debe ligar dicha variable antes de usarla
*/
%! para que sea completamente inversible

controla(Guardia, Otro):- 
    guardia(Guardia),
    prisionero(Otro,_), 
    not(controla(Otro, Guardia)).

%* 2. conflictoDeIntereses/2: relaciona a dos personas distintas 
%* (ya sean guardias o prisioneros)
%* si no se controlan mutuamente y existe algún tercero al cual ambos controlan.

conflictoDeIntereses(Alguien, Otro):-
    controla(Alguien, Tercero),
    controla(Otro, Tercero),
    not(controla(Alguien,Otro)),
    not(controla(Otro,Alguien)),
    Alguien \= Otro.

peligroso(Preso):-
    prisionero(Preso, _),
    %! SI LIGO CRIMEN PASA A SER UNA CONSULTA INDIVIDUAL, NO EXISTENCIAL
    forall(prisionero(Preso, Crimen), esGrave(Crimen)).


esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)):- member(metanfetaminas, Drogas).
esGrave(narcotrafico(Drogas)):- length(Drogas, Cantidad), Cantidad >= 5.

esGrave(Crimen):-
    prisionero(_, Crimen),
    not((prisionero(_, narcotrafico([_])), prisionero(_,robo(_)))).

%* Descompongo el robo para sacar su monto
monto(robo(Monto), Monto).

ladronDeGuanteBlanco(Preso):-
    prisionero(Preso, _),
    %* genero el universo de todos los crimenes, y al no contar con un monto entonces se descarta
    forall(prisionero(Preso, Crimen), (monto(Crimen, Monto), Monto>100000)).


%* anios(Crimen,Anios)
anios(robo(Monto), Anios):- Anios is Monto / 10000.
%* 7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
anios(homicidio(Persona), 9):- guardia(Persona).
anios(homicidio(Persona), 7):- not(guardia(Persona)).
anios(narcotrafico(Drogas), Anios):- length(Drogas,Tamanio),Anios is Tamanio * 2. 

condenaMAL(Preso, Condena):-
    prisionero(Preso, _),
    findall(anios(Crimen,Anios),prisionero(Preso, Crimen), ListaDeAnios),
    sumlist(ListaDeAnios, anios(Crimen, Anios)).

condena(Preso, Condena):-
    prisionero(Preso, _),
    findall(Anios, (prisionero(Preso, Crimen), anios(Crimen, Anios)), ListaDeAnios),
    sumlist(ListaDeAnios, Condena).
%* en vez de hacer la consulta de los crimenes, hago la consulta de ellos + anios asociados y 
%* pido los ANIOS
  
controlaATodos(Prisionero, Controlado):-
    prisionero(Prisionero, _),
    controla(Prisionero, Contolado).
    
controlaAtodos(Prisionero, Controlado):-
    prisionero(Prisionero, _),
    persona(Tercero),
    controla(Prisionero, Tercero),
    controla(Tercero, Controlado).

capoDiTutiLiCapi(Preso):-
    prisionero(Preso, _),
    %* nadie lo controla     
    not((Controla(Guardia, Preso))),
    controlaATodos(Prisionero, Controlado).

controlaDirec0Indirec(Uno, Persona):- controla(Uno, Persona).

%! o por alguien a quien él controla (directa o indirectamente).
%! EXPRESION RECURSIVA DE UN  TERCERO QUE PUEDE LLEGAR A CONTROLAR O QUE ALGUIEN QUIEN EL CONTROLE,
%! CONTROLE A ESE MISMO
controlaDirec0Indirec(Uno, Persona):- 
    persona(Tercero), 
    controla(Uno, Tercero),
    controlaDirec0Indirec(Tercero, Persona).

capo(Capo):-
    prisionero(Capo, _),
    persona(Persona),
    %* nadie lo controla (_)
    not(Controla(_, Preso)),
    %! debemos excluir al capo
    forall((persona(Persona), Capo \= Persona), controlaDirec0Indirec(Capo, Persona)).

