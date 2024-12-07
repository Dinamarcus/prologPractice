%%%%%%%%%
%Punto 1%
%%%%%%%%%

% Jockeys, jockey(Nombre, Peso, Edad, caballeria).
jockey(valdivieso, 155, 52, eltute).
jockey(leguisamo, 161, 49, elcharabon).
jockey(lezcano, 149, 50, lashormigas).
jockey(baratucci, 153, 55, elcharabon).
jockey(falero, 157, 52, eltute).

% Studs, stud(Nombre, Jockeys).
stud(eltute, [valdivieso, falero]).
stud(lashormigas, [lezcano]).
stud(elcharabon, [baratucci, leguisamo]).

% Caballos, caballo(Nombre, crin).
caballo(botofago, tordo).
caballo(oldman, alazan).
caballo(energica, ratonero).
caballo(matboy, palomino).
caballo(yatasto, pinto).

crin(tordo, [negro]).
crin(alazan, [marron]).
crin(ratonero, [gris, negro]).
crin(palomino, [marron, blanco]).
crin(pinto, [blanco, marron]).

% Premios, premio(caballo, premios)
premio(botofago, [granPremioNacional, granPremioRepublica]).
premio(oldman, [granPremioRepublica, campeonatoPalermoDeOro]).
premio(energica, []).
premio(yatasto, []).
premio(matboy, [granPremioCriadores]).

% Preferencias, prefiere(caballo, Jockey).
prefiere(botofago, Jockey):-
    pesoJockeyMenorA(Jockey, 52).
prefiere(botofago, baratucci).

prefiere(oldman, Jockey):-
    personaDeMuchasLetras(Jockey).

prefiere(energica, Jockey):-
    jockey(Jockey, _, _, _),
    not(prefiere(botofago, Jockey)).

prefiere(matboy, Jockey):-
    alturaJockeyMayorA(Jockey, 170).

alturaJockeyMayorA(Nombre, AlturaMinima):-
    jockey(Nombre, Altura, _, _),
    Altura > AlturaMinima.

personaDeMuchasLetras(Nombre):-
    jockey(Nombre, _, _, _),
    atom_length(Nombre, Length),
    Length > 7.
    

pesoJockeyMenorA(Nombre, PesoEsperado):-
    jockey(Nombre, _, Peso, _),
    Peso < PesoEsperado.

%%%%%%%%%
%Punto 2%
%%%%%%%%%
prefiereMasDeUnJockey(Caballo):-
    caballo(Caballo, _),
    findall(Jockey, prefiere(Caballo, Jockey), Jockeys),
    length(Jockeys, Cantidad),
    Cantidad > 1.

%%%%%%%%%
%Punto 3%
%%%%%%%%%
aborreceA(Caballo, Caballeria):-
    caballo(Caballo, _),
    stud(Caballeria, _),
    forall(stud(Caballeria, Integrantes), noPrefiereTodosLosIntegrantes(Caballo, Integrantes)).

noPrefiereTodosLosIntegrantes(Caballo, [Jockey|Resto]):-
    not(prefiere(Caballo, Jockey)),
    noPrefiereTodosLosIntegrantes(Caballo, Resto).
noPrefiereTodosLosIntegrantes(_, []).

%%%%%%%%%
%Punto 4%
%%%%%%%%%
ganoGranPremioNacional(Caballo):-
    premio(Caballo, Premios),
    member(granPremioNacional, Premios).

ganoGranPremioRepublica(Caballo):-
    premio(Caballo, Premios),
    member(granPremioRepublica, Premios).

ganoPremioImportante(Caballo):-
    ganoGranPremioNacional(Caballo).
ganoPremioImportante(Caballo):-
    ganoGranPremioRepublica(Caballo).

esPiolin(Jockey):-
    jockey(Jockey, _, _, _),
    forall(ganoPremioImportante(Caballo), prefiere(Caballo, Jockey)).

%%%%%%%%%
%Punto 5%
%%%%%%%%%
ganadora(ganador(Caballo),Resultado):-
    resultaGanador(Caballo, Resultado).

ganadora(segundo(Caballo), Resultado):-
    resultaGanador(Caballo, Resultado).
ganadora(segundo(Caballo), Resultado):-
    resultaSegundo(Caballo, Resultado).

ganadora(exacta(Caballo1, Caballo2), Resultado):-
    resultaGanador(Caballo1, Resultado),
    resultaSegundo(Caballo2, Resultado).

ganadora(imperfecta(Caballo1, Caballo2), Resultado):-
    resultaGanador(Caballo1, Resultado),
    resultaSegundo(Caballo2, Resultado).
ganadora(imperfecta(Caballo1, Caballo2), Resultado):-
    resultaGanador(Caballo2, Resultado),
    resultaSegundo(Caballo1, Resultado).

resultaGanador(Caballo, [Caballo|_]).
resultaSegundo(Caballo, [_|[Caballo|_]]).

%%%%%%%%%
%Punto 6%
%%%%%%%%%
realizarCompra(ColorPreferido, CaballosComprados):-
    findall(Caballo, 
        (caballo(Caballo, Crin), 
         crin(Crin, Colores), 
         member(ColorPreferido, Colores)), 
        Caballos),
    Caballos \= [],  % Asegura que hay al menos un caballo
    subconjunto(Caballos, CaballosComprados).

% Predicado auxiliar para generar subconjuntos
subconjunto([], []).
subconjunto([Caballo|Resto], [Caballo|SubResto]):-
    subconjunto(Resto, SubResto).
subconjunto([_|Resto], SubResto):-
    subconjunto(Resto, SubResto).


