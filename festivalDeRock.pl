%? festival(NombreDelFestival, Bandas, Lugar).
%* Relaciona el nombre de un festival con la lista de los nombres de
%* bandas que tocan en el y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, littoNebbia],hipodromoSanIsidro).
festival(agusFest, [losPiojos, losRegorditosDeRigorda ], recoleta).
%? lugar(nombre, capacidad, precioBase).
%* Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

%? banda(Nombre, Nacionalidad, Popularidad).
%* Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).
banda(losPiojos, argentina, 1001).
banda(losRegorditosDeRigorda, argentina, 1002).
%? entradaVendida(NombreDelFestival, TipoDeEntrada).
%* Indica la venta de una entrada de cierto tipo para el festival indicado.
%* Los tipos de entrada pueden ser alguno de los siguientes:
%* - campo
%* - plateaNumerada(Fila)
%* - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

entradaVendida(primaveraSound, popular).
%? plusZona(Lugar, Zona, Recargo)
%* Relacion una zona de un lugar con el recargo que le aplica al precio 
%* de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).

%? ------------------- 1 --------------------
%* 1) Itinerante/1: Se cumple para los festivales que ocurren en más de un lugar, pero con
%* el mismo nombre y las mismas bandas en el mismo orden
%! solo hay que decir que 2 caracteristicas de un functor son distintas
itinerante(Festival):-
    festival(Festival, Bandas, Lugar),
    festival(Festival, Bandas, OtroLugar), 
    Lugar \= OtroLugar.
%? ------------------- 2 --------------------
careta(Festival):- 
    entradaVendida(Festival,_),
    forall(entradaVendida(Festival,TipoDeEntrada), TipoDeEntrada \= campo).
careta(personalFest).

%? ------------------- 3 --------------------

nacAndPop(Festival):-
    festival(Festival, Bandas, _),
    not(careta(Festival)),
    forall(member(Banda,Bandas), (banda(Banda, argentina, Popularidad), Popularidad >1000)).

%? ------------------- 4 --------------------
%* sobrevendido/1: Se cumple para los festivales que vendieron más entradas que la
%* capacidad del lugar donde se realizan.
%? la cantidad de entradas que vendieron tiene que se mayor a la capacidad

sobrevendido(Festival):-
    festival(Festival, _, Lugar),
    lugar(Lugar, Capacidad, _),
    findall(Entrada, entradaVendida(Festival, Entrada), Entradas),
    length(Entradas, Cantidad),
    Cantidad > Capacidad.

%? ------------------- 5 --------------------
/* Relaciona un festival con el total recaudado con la venta de entradas. 
    Cada tipo de entrada se vende a un precio diferente:
- El precio del campo es el precio base del lugar donde se realiza el festival.
- La platea general es el precio base del lugar más el plus que se p aplica a la
zona.
- Las plateas numeradas salen el triple del precio base para las filas de atrás
(>10) y 6 veces el precio base para las 10 primeras filas. */

precio(campo,Lugar, Precio):- lugar(Lugar, _, Precio).

precio(plateaGeneral(Zona), Lugar, Precio):-
    lugar(Lugar, _, PrecioBase),
    plusZona(Lugar, Zona, Plus),
    Precio is PrecioBase + Plus.
%* Si quiero plantear que las filas son distintas, planteo 2 casos distintos, 
%* ya que seria un Fila <10 o Fila > 10
precio(plateaNumerada(Fila), Lugar, Precio):-
    Fila =< 10,
    lugar(Lugar, _,PrecioBase),
    Precio is PrecioBase * 6.

precio(plateaNumerada(Fila), Lugar, Precio):-
    Fila > 10,
    lugar(Lugar, _,PrecioBase),
    Precio is PrecioBase * 6.

%* necesito festival -> Entrada -> Lugar -> Precio
recaudacionTotal(Festival, TotalRecaudado):-
    festival(NombreDelFestival, _, Lugar),
    findall(Precio,(entradaVendida(Festival, Entrada),precio(Entrada, Lugar, Precio)), Precios),
    sumlist(Precios, TotalRecaudado).

%? ------------------- 6 --------------------
%* Relaciona dos bandas si tocaron juntas en algún recital o 
%* si una de ellas tocó con una banda del mismo palo que la otra, pero más popular.

tocoCon(Banda1, Banda2):-
    festival(_, Bandas, _),
    member(Banda1, Bandas),
    member(Banda2, Bandas),
    Banda1 \= Banda2.

delMismoPalo(Banda1, Banda2):- tocoCon(Banda1, Banda2).

delMismoPalo(Banda1, Banda2):-
    tocoCon(Banda1,Banda3),
    banda(Banda3, _, Popularidad3),
    banda(Banda1, _, Popularidad1),
    Popularidad3 > Popularidad1.   
    delMismoPalo(Banda3, Banda2).
