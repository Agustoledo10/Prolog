ganador(1997,peterhansel,moto(1995, 1)).
ganador(1998,peterhansel,moto(1998, 1)).

pais(peterhansel,francia).

etapa(marDelPlata,santaRosa,60).


% Punto 1
%marcaDelModelo(marca, modelo)
marcaDelModelo(peugot, 2008).
marcaDelModelo(peugot, 3008).
marcaDelModelo(mini, countryman).
marcaDelModelo(volkswagen, touareg).
marcaDelModelo(toyota, hilux).
/* b. Si quisiera agregar que el modelo buggy es de la marca mini, puedo agregar un hecho a mi base de conocimientos:
marcaDelModelo(mini, buggy).
En el caso del modelo dkr, no es necesario agregar nada, ya que gracias al principio de universo cerrado aquello
que no está definido en mi base de conocimientos, es falso, por lo que consultar:
marcaDelModelo(mini, dkr). 
Daría falso.
*/
% Punto 2

%ganadorReincidente(Competidor) -> aquel que ganó más de un año. Es decir que existen dos años en los que gano, y esos años son diferentes.
ganadorReincidente(Competidor):-
    ganoEn(UnAnio, Competidor),
    ganoEn(OtroAnio, Competidor),
    UnAnio \= OtroAnio.

ganoEn(Anio, Ganador):-
    ganador(Anio, Ganador, _).
%Punto 3
%insipiraA(Inspirador, Inspirado) -> Un conductor resulta inspirador para otro cuando ganó y el otro no, y también resulta inspirador cuando ganó algún año anterior al otro. 
% En cualquier caso, el inspirador debe ser del mismo país que el inspirado.
/*
Es decir que se cumple cuando:
- Son del mismo pais y
- Puede insipirarlo
Podrá inspirarlo cuando:
- El inspirador ganó y el inspirado no
O bien:
- El inspirador ganó un año anterior al inspirado
*/
inspiraA(Inspirador, Inspirado):-
    sonDelMismoPais(Inspirador, Inspirado),
    puedeInspirarlo(Inspirador, Inspirado).

%sonDelMismoPais(UnCompetidor, OtroCompetidor)
sonDelMismoPais(UnCompetidor, OtroCompetidor):-
    pais(UnCompetidor, Pais),
    pais(OtroCompetidor, Pais),
    UnCompetidor \= OtroCompetidor.

%puedeInspirarlo(Inspirador, Inspirado) -> caso en el que ganó el inspirador y el inspirado no
puedeInspirarlo(Inspirador, Inspirado):-
    ganoEn(Anio, Inspirador),
    not(ganoEn(Anio, Inspirado)).

%caso que el inspirador ganó un año anterior
puedeInspirarlo(Inspirador, Inspirado):-
    ganoEn(UnAnio, Inspirador),
    ganoEn(OtroAnio, Inspirado),
    UnAnio < OtroAnio.

% Punto 4
/*
marcaDeLaFortuna(Conductor, Marca) -> se cumple si el conductor gano solo con vehiculos de esa marca. 
Es decir que no existe una marca diferente a la que usa.
*/
marcaDeLaFortuna(Conductor, Marca):-
    ganoEn(_, Conductor), %tienen que haber ganado
    usoMarca(Conductor, Marca),
    not(ganoConOtraMarca(Conductor, Marca)).

%ganoConOtraMarca(Conductor, Marca)
ganoConOtraMarca(Conductor, Marca):-
    usoMarca(Conductor, Marca),
    usoMarca(Conductor, OtraMarca),
    OtraMarca \= Marca.

%usoMarca(Anio, Conductor, Marca)
usoMarca(Conductor, Marca):-
    ganador(_, Conductor, Vehiculo),
    marca(Vehiculo, Marca).

%marca(Vehiculo, Marca), sabiendo que los vehiculos son de la forma:
/*
auto(modelo)
moto(anioDeFabricacion, suspensionesExtras)
camion(items)
cuatri(marca)
*/
%del auto depende del modelo
marca(auto(Modelo), Marca):-
    marcaDelModelo(Marca, Modelo).

%del cuatri se indica en el functor
marca(cuatri(Marca), Marca).

%la moto se resuelve segun si fue antes o despues del año 2000
marca(Moto, ktm):-
    fabricadaDesdeAnio(2000, Moto).

marca(Moto, yamaha):-
    esMoto(Moto),
    not(fabricadaDesdeAnio(2000, Moto)).

%el camion depende de si lleva o no vodka en los items

marca(Camion, kamaz):-
    lleva(vodka, Camion).
marca(Camion, iveco):-
    esCamion(Camion),
    not(lleva(vodka, Camion)).
fabricadaDesdeAnio(Anio, moto(AnioFabricacion, _)):-
    AnioFabricacion >= Anio.
lleva(Item, camion(Items)):-
    member(Item, Items).

%esMoto(Vehiculo)
esMoto(moto(_,_)).
%esCamion(Vehiculo)
esCamion(camion(_)).

% Punto 5
/*
heroePopular(Conductor) -> se cumple cuando

- Sirvio de inspiracion a alguien y
- Fue el unico en no usar un vehiculo caro cuando gano
*/
heroePopular(Conductor):-
    inspiraA(Conductor, _),
    unicoSinVehiculoCaro(Conductor).

%unicoSinVehiculoCaro(Conductor) -> 
/*
Se cumple si:
- No uso uno vehiculo caro el año que gano
- Se cumple que para todo otro ganador ese mismo año, uso un vehiculo caro
*/
unicoSinVehiculoCaro(Conductor):-
    ganoEn(Anio, Conductor),
    not(usoVehiculoCaro(Conductor, Anio)),
    forall(ganadorDiferente(Anio, Conductor, OtroConductor), usoVehiculoCaro(OtroConductor, Anio)).

ganadorDiferente(Anio, Conductor, OtroConductor):-
    ganoEn(Anio, Conductor),
    ganoEn(Anio, OtroConductor),
    OtroConductor \= Conductor.

usoVehiculoCaro(Conductor, Anio):-
    ganador(Anio, Conductor, Vehiculo),
    esCaro(Vehiculo).

%esCara(Marca)
marcaCara(mini).
marcaCara(toyota).
marcaCara(iveco).

%esCaro(Vehiculo) -> marca cara o bien tiene al menos 3 suspensiones extras
esCaro(Vehiculo):-
    marca(Vehiculo, Marca),
    marcaCara(Marca).

esCaro(Vehiculo):-
    suspensionesExtra(Vehiculo, Suspensiones),
    Suspensiones >= 3.

suspensionesExtra(moto(_, Suspensiones), Suspensiones).
suspensionesExtra(cuatri(_),4).

%Punto 6.a

%distancia(Partida, Destino) 
distancia(Partida, Destino, Kilometros):-
    etapa(Partida, Destino, Kilometros).

distancia(Partida, Destino, Kilometros):-
    etapa(Partida, SiguienteLocacion, KilometrajeParcial),
    distancia(SiguienteLocacion, Destino, KilometrajeFaltante),
    Kilometros is KilometrajeParcial + KilometrajeFaltante.

%Punto 6.b
%puedeRecorrerSinParar(Vehiculo, Distancia) -> puede recorrer cualquier distancia menor a su limite
puedeRecorrerSinParar(Vehiculo, Distancia):-
    limiteDistancia(Vehiculo, Limite),
    Distancia =< Limite.

limiteDistancia(Vehiculo, 2000):-
    esCaro(Vehiculo).

limiteDistancia(Vehiculo, 1800):-
    vehiculo(Vehiculo),
    not(esCaro(Vehiculo)).

limiteDistancia(camion(Items), Limite):-
    length(Items, Cantidad),
    Limite is Cantidad * 1000.
    

vehiculo(Vehiculo):-
    marca(Vehiculo, _).

%Punto 6.c

%destinoMasLejano(Vehiculo, Origen, Destino) -> se cumple para el destino que quede más lejos, es decir para todo otro destino posible, está más cerca del origen (distancia menor desde origen). Otra forma de pensarlo es que no existe un destino que esté más lejos (distancia mayor desde origen)
destinoMasLejano(Vehiculo, Origen, Destino):-
    puedeLlegarSinParar(Vehiculo, Origen, Destino),
    forall(otroDestinoPosible(Vehiculo, Origen, Destino, OtroDestino), estaMasCerca(OtroDestino, Origen, Destino)).

%puedeLlegarSinParar(Vehiculo, Origen, Destino) -> puede llegar sin parar sis puede recorrer la distancia que hay entre el origen y el destino
puedeLlegarSinParar(Vehiculo, Origen, Destino):-
    distancia(Origen, Destino, Distancia),
    puedeRecorrerSinParar(Vehiculo, Distancia).

estaMasCerca(DestinoCercano, Origen, Destino):-
    distancia(Origen, Destino, Distancia),
    distancia(Origen, DestinoCercano, DistanciaCercana),
    DistanciaCercana < Distancia.

otroDestinoPosible(Vehiculo, Origen, Destino, OtroDestino):-
    puedeLlegarSinParar(Vehiculo, Origen, Destino),
    puedeLlegarSinParar(Vehiculo, Origen, OtroDestino),
    Destino \= OtroDestino.