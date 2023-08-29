




% habitat(Animal, Bioma).
% * habitat(jirafa, sabana).
habitat(ciervo,sabana).
habitat(leon,sabana).
habitat(tigre,sabana).
habitat(coyote,desierto).
habitat(foca,mar).
habitat(foca,costa).
habitat(foca,tundra).
habitat(foca,desierto).
habitat(foca,sabana).
% animal(Animal).
animal(jirafa).
animal(foca).
animal(leon).
animal(tigre).
animal(ciervo).
animal(coyote).

acuatico(Animal):-
	habitat(Animal, mar).

terrestre(Animal):- 
    animal(Animal), 
    not(habitat(Animal, mar)). 

% templado(Bioma).
templado(sabana).

friolento(Animal):-
    animal(Animal),
    forall(habitat(Animal,Bioma), templado(Bioma)).

% * come(Depredador, Presa)
come(leon, ciervo).
come(tigre, ciervo).

come(coyote, ciervo).

% * hostil(Animal, Bioma)
% ! Un bioma es hostil para una presa si se la comen todos
hostil(Presa, Bioma):-
    animal(Presa),
    habitat(_ , Bioma),
    forall(habitat(Animal,Bioma), come(Animal, Presa)).

% * terrible(Animal, Bioma)
% ! todos los animales que se comen a la presa viven en el mismo bioma?
% ! no todos los animales q se lo comen viven en el mismo bioma. True
terrible(Presa, Bioma):-
    animal(Presa),
    habitat( _ , Bioma),
    forall(come(Animal,Presa), habitat(Animal,Bioma)).

% * compatibles
compatibles(Animal, Animal2):-
    animal(Animal),
    animal(Animal2),
    not(come(Animal,Animal2)),
    not(come(Animal2, Animal)).
 
% ! un animal es adaptabnle si habita en todos los biomas
adaptable(Animal):-
    animal(Animal),
    forall(habitat(_, Bioma), habitat(Animal, Bioma)).

%! se cumple para los animales que habitan en un solo bioma
%! osea que no tienen OTRO b
% * todos los animales que viven en 1 solo bioma
%  * un animal es raro si no tiene mas de un bioma
raro(Animal):-
    habitat(Animal, Bioma),
    not((habitat(Animal,OtroBioma), Bioma \= OtroBioma)). 
    
%! Se cumple para los animales que se comen a todos 
%! los otros animales que viven
%! en el mismo bioma
%* necesito saber todos los animales que habitan en el bioma en el que vive
% * 1. primero obtengo el bioma del animal
dominante(Animal):-
	habitat(Animal, Bioma),
	forall((habitat(Presa, Bioma), Presa \= Animal), come(Animal,Presa)).
