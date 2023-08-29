%* cancion(Cancion, Compositores, Reproducciones).
cancion(bailanSinCesar, [pabloIlabaca, rodrigoSalinas], 10600177).
cancion(yoOpino, [alvaroDiaz, carlosEspinoza, rodrigoSalinas], 5209110).
cancion(equilibrioEspiritual, [danielCastro, alvaroDiaz, pabloIlabaca, pedroPeirano, rodrigoSalinas], 12052254).
cancion(tangananicaTanganana, [danielCastro, pabloIlabaca, pedroPeirano], 5516191).
cancion(dienteBlanco, [danielCastro, pabloIlabaca, pedroPeirano], 5872927).
cancion(lala, [pabloIlabaca, pedroPeirano], 5100530).
cancion(meCortaronMalElPelo, [danielCastro, alvaroDiaz, pabloIlabaca, rodrigoSalinas], 3428854).

cancion(agus, [agustincito, agustincito1, agustincito2], 7000001).

%* rankingTop3(Mes, Puesto, Cancion).
rankingTop3(febrero, 1, lala).
rankingTop3(febrero, 2, tangananicaTanganana).
rankingTop3(febrero, 3, meCortaronMalElPelo).
rankingTop3(marzo, 1, meCortaronMalElPelo).
rankingTop3(marzo, 2, tangananicaTanganana).
rankingTop3(marzo, 3, lala).
rankingTop3(abril, 1, tangananicaTanganana).
rankingTop3(abril, 2, dienteBlanco).
rankingTop3(abril, 3, equilibrioEspiritual).
rankingTop3(mayo, 1, meCortaronMalElPelo).
rankingTop3(mayo, 2, dienteBlanco).
rankingTop3(mayo, 3, equilibrioEspiritual).
rankingTop3(junio, 1, dienteBlanco).
rankingTop3(junio, 2, tangananicaTanganana).
rankingTop3(junio, 3, lala).

%? ------------------ 1 -----------------------------
%* saber si una cancion es un hit, lo cual ocurre si aparece en el ranking top 3 de todos los meses
%! para todos mis otros meses la cancion aparece
%* forall( canciones, apareceEnElTop3 cancion)
%* no hay un  mes en el que no aparezca
esUnHit(Cancion):-
    rankingTop3(Mes,_,_),
    forall((cancion(Cancion,_,_), rankingTop3(OtroMes,_, Cancion)), Mes \= OtroMes).

%? ------------------ 2 -----------------------------
noEsReconocidaPorLosCriticos(Cancion):-
    %* tiene mas de 7.000.000 de reproducciones y nunca estuvo en el ranking
    cancion(Cancion,_, Reproducciones),
    Reproducciones > 7000000,
    forall(rankingTop3(Mes,_,Cancion), not(rankingTop3(Mes,_,Cancion))).

%? ------------------ 3 -----------------------------
colaboraron(Compositor1, Compositor2):-
        cancion(_, Compositores, _),
        member(Compositor1, Compositores),
        member(Compositor2, Compositores),
        Compositor1 \= Compositor2.

%? ------------------ 4 modelado con polimorfismo-----------------------------
%* trabajo(Trabajador, Cual([info])), represento acciones como individuos

trabajo(tulio, conductor(5)).
trabajo(bodoque, periodista(2, licenciatura)).
trabajo(bodoque, reportero(5, 300)).
trabajo(marioHugo, periodista(10, posgrado)).
trabajo(juanin, conductor(0)).

%? ------------------ 5 -----------------------------
%* Conocer el sueldo total de una persona, -> Es la suma de todos los sueldos de sus trabajos
%* el cual está dado por la suma de los sueldos
%* de cada uno de sus trabajos. El sueldo de cada trabajo se calcula de la siguiente forma

%* Trabajador -> Trabajo -> Sueldo
%* doble consulta

sueldoTotal(Trabajador, SueldoTotal):-
    trabajo(Trabajador,_),
    findall(Sueldo,(trabajo(Trabajador, Trabajo), sueldo(Trabajo, Sueldo)) , ListaDeSueldos),
    sumlist(ListaDeSueldos, SueldoTotal).


%* El sueldo de un conductor es de 10000 por cada año de experiencia

sueldo(conductor(Anios) , Sueldo):-
    Sueldo is 10000 * Anios.

sueldo(reportero(Anios, Notas), Sueldo):-
    Sueldo is 10000 * Anios + 100 * Notas.

sueldo(periodista(Anios, Titulo), Sueldo):-
    factorAumento(Titulo, Factor),
    Sueldo is Anios * 5000 * Factor.

factorAumento(licenciatura, 1.20).
factorAumento(posgrado, 1.35).

%? ------------------ 6 -----------------------------
% trabajo(agus, rol(Anios, Seguidores)).

%*  El concepto de la materia que se relaciona a esto es el polimorfismo, que siginifica que apartir de una
%* forma de modelar informacion en mi base de conocimientos, si quiero agregar otro es tan facil como poner sus caracteristicas,
%* sin tener que modificar mis predicados existentes, osea la logica de mi programa.
% trabajo(agus, communityManager(2, 300)).

trabajo(agus, communityManager(2, 300)).

calcularSueldo(Trabajador,Anios, Seguidores, Sueldo):-
    trabajo(Trabajador, communityManager(Anios, Seguidores)),
    Sueldo is Anios * Seguidores.