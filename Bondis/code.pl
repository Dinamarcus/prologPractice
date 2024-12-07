% Recorridos, recorrido(linea, area, calleQueAtraviesa)
recorrido(17, gba(sur), mitre).
recorrido(24, gba(sur), belgrano).
recorrido(247, gba(sur), onsari).
recorrido(60, gba(norte), maipu).
recorrido(152, gba(norte), olivos).
recorrido(17, caba, santaFe).
recorrido(152, caba, santaFe).
recorrido(10, caba, santaFe).
recorrido(160, caba, medrano).
recorrido(24, caba, corrientes).

%%%%%%%%%
%Punto 1%
%%%%%%%%%
mismaCalleAtravesada(Linea1, Linea2):-
    recorrido(Linea1, _, Calle1),
    recorrido(Linea2, _, Calle2),
    Calle1 = Calle2.

dentroDeMismaZona(Linea1, Linea2):-
    recorrido(Linea1, Zona1, _),
    recorrido(Linea2, Zona2, _),
    Zona1 = Zona2.

puedenCombinarse(Linea1, Linea2):-
    mismaCalleAtravesada(Linea1, Linea2),
    dentroDeMismaZona(Linea1, Linea2).

%%%%%%%%%
%Punto 2%
%%%%%%%%%
pasaPorCalleDeCABA(Linea):-
    recorrido(Linea, Zona, _),
    Zona = caba.

pasaPorCalleDeGBA(Linea):-
    recorrido(Linea, gba(_), _).

esNacional(Linea):-
    pasaPorCalleDeCABA(Linea),
    pasaPorCalleDeGBA(Linea).

esProvincial(Linea):-
    recorrido(Linea, _, _),
    not(esNacional(Linea)).

%%%%%%%%%
%Punto 3%
%%%%%%%%%
cantidadDeLineasPorCalle(Zona, Calle, Cantidad) :-
    recorrido(_, Zona, Calle),
    findall(Linea, recorrido(Linea, Zona, Calle), Lineas),
    length(Lineas, Cantidad).

calleMasTransitada(Calle, Zona):-
    cantidadDeLineasPorCalle(Zona, Calle, Cantidad),
    forall((recorrido(_, Zona, OtraCalle), Calle \= OtraCalle), (cantidadDeLineasPorCalle(Zona, OtraCalle, CantidadMenor), Cantidad > CantidadMenor)).

%%%%%%%%%
%Punto 4%
%%%%%%%%%
cantidadDeLineasNacionalesPorCalle(Zona, Calle, Cantidad) :-
    recorrido(_, Zona, Calle),
    findall(Linea, (recorrido(Linea, Zona, Calle), esNacional(Linea)), Lineas),
    length(Lineas, Cantidad).

esCalleTransbordo(Zona, Calle):-
    cantidadDeLineasNacionalesPorCalle(Zona, Calle, Cantidad),
    Cantidad >= 3.

%%%%%%%%%
%Punto 5%
%%%%%%%%%
cantidadCallesRecorrido(Linea, Cantidad):-
    recorrido(Linea, _, _),
    findall(Calle, recorrido(Linea, _, Calle), Calles),
    length(Calles, Cantidad).

pasaPorDistintasZonas(Linea):-
    recorrido(Linea, gba(Zona), _),
    recorrido(Linea, gba(OtraZona), _),
    Zona \= OtraZona.

valorPlus(Linea, 50):-
    pasaPorDistintasZonas(Linea).
valorPlus(Linea, 0):-
    not(pasaPorDistintasZonas(Linea)).

valorNormal(Linea, 500):-
    esNacional(Linea).
valorNormal(Linea, 350):-
    esProvincial(Linea),
    recorrido(Linea, caba, _).
valorNormal(Linea, ValorNormal):-
    esProvincial(Linea),
    cantidadCallesRecorrido(Linea, CantidadCalles),
    valorPlus(Linea, Plus),
    ValorNormal is (25 * CantidadCalles) + Plus.

beneficiario(pepito, [personalDeCasas(gba(oeste))]).
beneficiario(juanita, [boletoEstudiantil]).
beneficiario(marta,[jubilado, personalDeCasas(gba(sur)), personalDeCasas(caba)]).
beneficiario(tito, []).

beneficio(personalDeCasas(Zona), Linea, 0):-
    recorrido(Linea, Zona, _).
beneficio(boletoEstudiantil, _, 50).
beneficio(jubilado, Linea, ValorConBeneficio):-
    valorNormal(Linea, ValorNormal),
    ValorConBeneficio is ValorNormal / 2.

aplicarBeneficios([], _, ValorNormal, ValorNormal).
aplicarBeneficios([Beneficio|Resto], Linea, ValorNormal, ValorConBeneficio):-
    beneficio(Beneficio, Linea, ValorBeneficio),
    ValorConBeneficioActual is ValorNormal - ValorBeneficio,
    aplicarBeneficios(Resto, Linea, ValorNormal, ValorConBeneficioResto),
    ValorConBeneficio is min(ValorConBeneficioActual, ValorConBeneficioResto).
    

costoViaje(Persona, Linea, ValorFinal):-
    valorNormal(Linea, ValorNormal),
    beneficiario(Persona, Beneficios),
    aplicarBeneficios(Beneficios, Linea, ValorNormal, ValorConBeneficios),
    valorPlus(Linea, Plus),
    ValorFinal is ValorConBeneficios - Plus.