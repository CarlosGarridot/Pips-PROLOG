% Practica final de Llenguatges de Programacio (Prolog)
% Llenguatges de Programacio (Curs 2025-26)
% Nom:              Carlos Garrido del Toro
% Grup:             PFX301-25
% Data:             Maig 2026
% Professors:       Aina Tur
% Convocatòria:     Ordinària
%
% El predicat principal és solucio_pips:
%
%   solucio_pips(Regions, Peces, Solucio)
%
%   1) COMPROVAR una solució ja coneguda:
%      ?- puzzle(20250818, easy, Regions, Peces, Solucio),
%         solucio_pips(Regions, Peces, Solucio).
%
%   2) CALCULAR la solució:
%      ?- puzzle(20250818, easy, Regions, Peces, SolucioEsperada),
%         solucio_pips(Regions, Peces, SolucioCalculada),
%         SolucioEsperada = SolucioCalculada.
%
%   També es pot cridar directament sense fer servir puzzle:
%      ?- solucio_pips([region(empty, nil, [[0,0]]), ...], [[2,2], ...], Solucio).
%
% La solució genera una solució candidata i comprova si és correcta.
%
% FASE 1 - GENERAR (generar_solucio):
%   Per a cada peça de la llista, cercam dues caselles adjacents
%   i lliures del tauler on col·locar-la. De manera recursiva: 
%   col·locam la primera peça, marcam les seves dues
%   caselles com a ocupades, i repetim amb la resta de peces.
%
% FASE 2 - COMPROVAR (comprovar_regions):
%   Un cop tenim una solució candidata, comprovam que cada
%   región compleixi la seva condició (empty, equals, unequal, sum,
%   less, greater). Per a cada casella d'una regió, cercam
%   quin valor li correspon recorrent simultàniament la llista
%   de peces i la llista de posicions de la solució.
%
%   Si alguna regió falla, el backtracking descarta la solució
%   candidata i en genera una de nova a la Fase 1.

% BASE DE CONEIXEMENT
puzzle(20250818, easy,
[region(empty, nil, [[0,0]]),
region(equals, nil, [[0,1],[0,2],[1,1],[1,2]]),
region(sum, 5, [[0,3]]),
region(sum, 12, [[2,1],[2,2]])],
[[2,2],
[2,3],
[5,2],
[6,6]],
[[[1,1],[1,2]],
[[0,1],[0,0]],
[[0,3],[0,2]],
[[2,1],[2,2]]]).

puzzle(20250819, easy,
  [region(sum, 6, [[0,1]]),
   region(empty, nil, [[1,0]]),
   region(empty, nil, [[1,1]]),
   region(sum, 5, [[1,2]]),
   region(equals, nil, [[2,0],[2,1]]),
   region(empty, nil, [[2,2]]),
   region(sum, 0, [[3,1]])],
  [[6,1],
   [2,4],
   [5,3],
   [2,0]],
  [[[0,1],[1,1]],
   [[2,0],[1,0]],
   [[1,2],[2,2]],
   [[2,1],[3,1]]]).

puzzle(20250820, easy,
  [region(empty, nil, [[0,0]]),
   region(sum, 0, [[0,1],[0,2],[0,3]]),
   region(sum, 4, [[1,0]]),
   region(empty, nil, [[1,1]]),
   region(sum, 2, [[1,2],[1,3]])],
  [[0,0],
   [4,6],
   [1,0],
   [5,1]],
  [[[0,1],[0,2]],
   [[1,0],[0,0]],
   [[1,3],[0,3]],
   [[1,1],[1,2]]]).

puzzle(20250821, easy,
  [region(sum, 2, [[0,0]]),
   region(sum, 7, [[0,1],[1,1]]),
   region(sum, 7, [[2,1],[3,1]]),
   region(sum, 9, [[4,1],[5,1]]),
   region(sum, 2, [[5,2]])],
  [[2,3],
   [4,5],
   [4,3],
   [4,2]],
  [[[0,0],[0,1]],
   [[3,1],[4,1]],
   [[1,1],[2,1]],
   [[5,1],[5,2]]]).
puzzle(20250822, easy,
  [region(sum, 1, [[0,0]]),
   region(empty, nil, [[0,1]]),
   region(sum, 0, [[0,2]]),
   region(empty, nil, [[1,0]]),
   region(sum, 1, [[2,0]]),
   region(sum, 8, [[2,1],[2,2]]),
   region(empty, nil, [[3,2]]),
   region(equals, nil, [[4,0],[4,1]])],
  [[5,1],
   [6,0],
   [1,1],
   [1,6],
   [4,3]],
  [[[2,1],[2,0]],
   [[0,1],[0,2]],
   [[4,0],[4,1]],
   [[0,0],[1,0]],
   [[3,2],[2,2]]]).

puzzle(20250823, easy,
  [region(empty, nil, [[0,0]]),
   region(sum, 1, [[0,1],[0,2]]),
   region(equals, nil, [[1,0],[1,1],[1,2]]),
   region(sum, 4, [[2,0],[2,1]])],
  [[0,0],
   [3,1],
   [3,3],
   [4,0]],
  [[[0,0],[0,1]],
   [[1,2],[0,2]],
   [[1,0],[1,1]],
   [[2,0],[2,1]]]).

puzzle(20250824, easy,
  [region(empty, nil, [[0,0]]),
   region(sum, 6, [[1,0]]),
   region(equals, nil, [[1,1],[1,2]]),
   region(empty, nil, [[2,1]]),
   region(equals, nil, [[2,2],[2,3],[3,3]])],
  [[0,4],
   [6,5],
   [4,4],
   [1,1]],
  [[[2,1],[2,2]],
   [[1,0],[0,0]],
   [[2,3],[3,3]],
   [[1,1],[1,2]]]).

% solucio_pips(Regions, Peces, Solucio)
solucio_pips(Regions, Peces, Solucio) :-
    generar_solucio(Regions, Peces, Solucio),       % posem les peces.
    comprovar_regions(Regions, Peces, Solucio).     % comprovem que es compleixin les normes.


%-----------------------------------------------------------------------------------------------------------
%   GENERAR_SOLUCIO(Regions, Peces, Solucio)
%-----------------------------------------------------------------------------------------------------------

generar_solucio(Regions, Peces, Solucio) :-
    generar(Regions, Peces, Solucio, []).

% ---- GENERAR (Regions, peces, solucio, ocupades) ----
% Cas Base -> Quan la llista de peces és buida, la solució generada també ho és.
generar(_, [], [], _).

% Cas Recursiu ->  Col·loquem una peça a dues caselles adjacents i lliures
generar(Regions, [_Peca | RestPeces], [Posicio | RestSolucio], Ocupades) :-

    % Cercam la posició  de 2 caselles que siguin adjacents.
    trobar_posicio(Regions, Ocupades, Posicio),
    
    %Afegim aquesta nova posició a les ocupades
    afegir(Posicio, Ocupades, NovesOcupades),

    % Cercam la resta de peces
    generar(Regions, RestPeces, RestSolucio, NovesOcupades).

% ---- TROBAR_POSICIO(Regions, Ocupades, Posicio) ----
%
%   Respecte a les peces rotades:
%
%   Sabent que el 1r valor de la peça (per exemple: 3) sempre s'associa a C1 
%   i el 2n valor (per exemple: 4) sempre s'associa a C2
% 
%   En extreure C1 i C2 amb 'pertany' diferents, tenim totes les permutaciones (Backtracking) :
%   - Orientació Normal:     C1=[0,0] i C2=[0,1] -> El 3 cau a [0,0] i el 4 a [0,1].
%   - Orientació Invertida:  Si falla, C1=[0,1] i C2=[0,0] -> El 3 cau a [0,1] i el 4 a [0,0].
%
%   A més, al cercar amb crides diferentes de pertany es permet aixi que una peça estigui 
%   entre dues regions diferentes.
%
%   Aconseguint així l'efecte de 'girar' una peça.

trobar_posicio(Regions, Ocupades, [C1, C2]) :-
    % Trobam una coordenada per C1
    pertany(region(_, _, Caselles1), Regions),
    pertany(C1, Caselles1),
    
    % Trobam una coordenada per C2
    pertany(region(_, _, Caselles2), Regions),
    pertany(C2, Caselles2),
    
    % Han de ser adjacents i no poden estar ja ocupades
    adjacents(C1, C2),
    not(pertany(C1, Ocupades)),
    not(pertany(C2, Ocupades)).

%-----------------------------------------------------------------------------------------------------------
%   COMPROVAR_REGIONS(Regio, Peces, Solucio)
%-----------------------------------------------------------------------------------------------------------
% Cas Base -> No queden regions.
comprovar_regions([], _, _).
% Cas Recursiu -> Comprovam la primera regió i després comprovam la resta.
comprovar_regions([Regio | RestoRegio], Peces, Solucio) :-
    comprovar_una_regio(Regio, Peces, Solucio),      % Comprovem la primera regió
    comprovar_regions(RestoRegio, Peces, Solucio).   % Comprovem la resta de regions

% ------ COMPROVAR_UNA_REGIO (region, peces, soluci) ------
% regio(condició, objectiu, caselles)
%
% S'encarrega de mirar les diferents normes que pot tenir una regió

% empty -> No s'imposa cap condició a les caselles de la regió.
comprovar_una_regio(region(empty, _, _), _, _).

% equals -> Totes les caselles de la regió han de tenir el mateix valor.
comprovar_una_regio(region(equals, _, Caselles), Peces, Solucio) :-
    valors_regio(Caselles, Peces, Solucio, Valors),     % Agafam els nombres
    tots_iguals(Valors).                                % Mirem si els valors extrets son iguals

% unequal -> Totes les caselles de la regió han de tenir valors diferents.
comprovar_una_regio(region(unequal, _, Caselles), Peces, Solucio) :-
    valors_regio(Caselles, Peces, Solucio, Valors),     % Agafam els nombres de la regió
    tots_diferents(Valors).                             % Mirem si tots son diferents

% sum -> La suma dels valors de les caselles de la regió ha de ser igual a OBJECTIU
comprovar_una_regio(region(sum, Objectiu, Caselles), Peces, Solucio) :-
    valors_regio(Caselles, Peces, Solucio, Valors),      % Agafam els nombres
    sumar(Valors, Total),                                % Sumem els valors extrets
    Total =:= Objectiu.                                  % Comprovem que la suma dels valors de les caselles siguin igual a l'objectiu

% less -> La suma dels valors de les caselles de la regió ha de ser inferior a OBJECTIU
comprovar_una_regio(region(less, Objectiu, Caselles), Peces, Solucio) :-
    valors_regio(Caselles, Peces, Solucio, Valors),
    sumar(Valors, Total),
    Total < Objectiu.

% greater -> La suma dels valors de les caselles de la regió ha de ser superior a OBJECTIU
comprovar_una_regio(region(greater, Objectiu, Caselles), Peces, Solucio) :-
    valors_regio(Caselles, Peces, Solucio, Valors),
    sumar(Valors, Total),
    Total > Objectiu.

%-----------------------------------------------------------------------------------------------------------
% FUNCIONS AUXILIARS
%-----------------------------------------------------------------------------------------------------------

% Una regió es una llista de coordenades. Hem de cercar el valor de la peça que hi ha a cada coordenada de la regió.
% valors_regio(LlistaCoordenades, Peces, Solucio, LlistaValors)
valors_regio([], _, _, []).
valors_regio([C|RestoCoord], Peces, Solucio, [V|RestoVals]) :-
    obtenir_valor(C, Peces, Solucio, V),                            % Cercam quin valor V hi ha a la casella C 
    valors_regio(RestoCoord, Peces, Solucio, RestoVals).           % Feim el mateix amb la resta de coordenades de la regió
    % Al final tenim una llista de valors que corresponen a les caselles de la regió
%---------------------

% obtenir_valor(Coord, Peces, Solucio, Valor)
% Busquem recursivament el valor d'una casella recorrent la llista de peces i la llista de la solució.
% Cas base -> Si la coordenada cercada es troba dins la posició de la primera 
obtenir_valor(Coord, [P1|_RestoP], [S1|_RestoS], V) :-  
    valor_peca(Coord, P1, S1, V).
% Cas recursiu -> Si la coordenada no és a la primera peça, continuam la cerca en la resta 
obtenir_valor(Coord, [_|RestoP], [_|RestoS], V) :- 
    obtenir_valor(Coord, RestoP, RestoS, V).
%---------------------

% Aconseguir el valor de la peça a una casilla concreta
% valor_peca(Coordenada, Peça, PosicionsPeça, valor)
% Si la coordenadada la casella coincideix amb la primera meitata de la coordenada de la peça.
valor_peca(Coord, [V1, _V2], [Coord, _Pos2], V1).
% Si la coordenadada la casella coincideix amb la segona meitata de la coordenada de la peça.
valor_peca(Coord, [_V1, V2], [_Pos1, Coord], V2).
%---------------------

% Indica si X perteneix a una llista
pertany(X,[X|_]).
pertany(X,[_|L]):-
    pertany(X,L).
%--------------------


% Sumar els elemetns d'una llista
sumar([],0).
sumar([X|L],N):-
    sumar(L,N1),N is N1+X.
%---------------------

% Indica si els valors son iguals
tots_iguals([]).                % Llista buida
tots_iguals([_]).               % Llista només amb un element
tots_iguals([X,Y | Resto]) :-
    X =:= Y,                    % Els dos primers son iguals?
    tots_iguals([Y | Resto]).   % Comprovam si el segon i la resta son iguals
%---------------------    

% Indica si els valors d'una llista són tots diferents entre si
tots_diferents([]).               % Una llista buida té tots els elements diferents
tots_diferents([_]).              % Una llista amb un sol element també
tots_diferents([X | Resto]) :-
    not(pertany_valor(X, Resto)), % Comprovam que X no estigui repetit a la resta
    tots_diferents(Resto).        % Feim el mateix per a la resta de la llista

% Predicat auxiliar per comparar valors numèrics de manera segura amb =:=
pertany_valor(X, [Y|_]) :- 
    X =:= Y.
pertany_valor(X, [_|L]) :- 
    pertany_valor(X, L).
%---------------------    

% Afegir dues llistes
afegir([],L,L).
afegir([X|L1],L2,[X|L3]):-
    afegir(L1,L2,L3).
%---------------------

% Dos caselles son adjacents si la diferència de files és 1 o -1 i la columna és la mateixa,
% o si la diferència de columnes és 1 o -1 i la fila és la mateixa.
adjacents([F, C1], [F, C2]) :- 
    Diferencia is C1 - C2, 
    (Diferencia =:= 1 ; Diferencia =:= -1).

adjacents([F1, C], [F2, C]) :- 
    Diferencia is F1 - F2, 
    (Diferencia =:= 1 ; Diferencia =:= -1).
