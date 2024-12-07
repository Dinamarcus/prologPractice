% Integrantes, Integrante(grupo, persona, Instrumento)
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(sophieTrio, pablo, bateria).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi,guitarra).
integrante(jazzmin, santi, bateria).

% Niveles, nivelQueTiene(persona, instrumento, nivelImprovisacion).
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(pablo, bateria, 1).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% Intrumentos, instrumento(instrumento, rolAltocar).
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

% Grupos, grupo(grupo, tipo).
grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

%%%%%%%%%
%Punto 1%
%%%%%%%%%
tocaIntrumentoRitmico(Persona, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, ritmico).

tocaIntrumentoArmonico(Persona, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, armonico).

tieneBuenaBase(Grupo):-
    tocaIntrumentoRitmico(Persona, Grupo),
    tocaIntrumentoArmonico(Persona2, Grupo),
    Persona \= Persona2.

%%%%%%%%%
%Punto 2%
%%%%%%%%%
alMenos2PuntosMas(Nivel1, Nivel2):-
    Diferencia is Nivel1 - Nivel2,
    Diferencia >= 2.

tieneMayorNivel(Persona, Persona2, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    integrante(Grupo, Persona2, Instrumento2),
    nivelQueTiene(Persona, Instrumento, NivelPersona1),
    nivelQueTiene(Persona2, Instrumento2, NivelPersona2),
    alMenos2PuntosMas(NivelPersona1, NivelPersona2).

mayorNivelQueElResto(Persona, Grupo):-
    integrante(Grupo, Persona, _),
    forall((integrante(Grupo, Persona2, _), Persona \= Persona2), tieneMayorNivel(Persona, Persona2, Grupo)).

seDestaca(Persona, Grupo):-
    mayorNivelQueElResto(Persona, Grupo).

%%%%%%%%%
%Punto 3%
%%%%%%%%%
%Ya agregado

%%%%%%%%%
%Punto 4%
%%%%%%%%%
bateriaBajoOPiano(bateria).
bateriaBajoOPiano(bajo).
bateriaBajoOPiano(piano).

esDeViento(Instrumento):-
    instrumento(Instrumento, melodico(viento)).

estaEnFormacion(Instrumento, formacion(Formacion)):-
    member(Instrumento, Formacion).

nadieLoToca(Grupo, Persona, Instrumento):-
    not(integrante(Grupo, Persona, Instrumento)).

hayCupo(Instrumento, Grupo):-
    grupo(Grupo,bigBand),
    esDeViento(Instrumento).

hayCupo(Instrumento, Grupo):-
    grupo(Grupo,bigBand),
    bateriaBajoOPiano(Instrumento).

hayCupo(Instrumento, Grupo):-
    instrumento(Instrumento, _),
    grupo(Grupo, formacion(Formacion)),
    forall(integrante(Grupo, Persona, _), (nadieLoToca(Grupo, Persona, Instrumento), estaEnFormacion(Instrumento, Formacion))).

%%%%%%%%%
%Punto 5%
%%%%%%%%%
noEsIntegrante(Persona, Grupo):-
    integrante(Grupo, _, _),
    not(integrante(Grupo, Persona, _)).

nivelMinimoRequerido(bigBand, 1).
nivelMinimoRequerido(formacion(Formacion), NivelMinimo):-
    length(Formacion, CantidadInstrumentos),
    NivelMinimo is 7 - CantidadInstrumentos.

puedeIncorporarse(Grupo, Persona, Instrumento):-
    noEsIntegrante(Persona, Grupo),
    hayCupo(Instrumento, Grupo),
    nivelQueTiene(Persona, Instrumento, Nivel),
    grupo(Grupo, TipoGrupo),
    nivelMinimoRequerido(TipoGrupo, NivelMinimo),
    Nivel >= NivelMinimo.

%%%%%%%%%
%Punto 6%
%%%%%%%%%
seQuedoEnBanda(Persona):-
    nivelQueTiene(Persona, _, _),
    not(integrante(_, Persona, _)),
    not(puedeIncorporarse(_, Persona, _)).

%%%%%%%%%
%Punto 6%
%%%%%%%%%
tocaIntrumentoDeViento(Persona, Grupo):-
    integrante(Grupo, Persona, Instrumento),
    instrumento(Instrumento, melodico(viento)).

puedeTocar(Grupo):-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    findall(Integrante, (integrante(Grupo, Integrante,Instrumento), tocaIntrumentoDeViento(Integrante, Grupo)), Integrantes),
    length(Integrantes, Cantidad),
    Cantidad >= 5.

puedeTocar(Grupo):-
    grupo(bigband, formacion(Formacion)),
    forall(member(Instrumento, Formacion), integrante(Grupo, _, Instrumento)).