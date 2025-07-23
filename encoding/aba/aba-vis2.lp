% run by clingo cln2.lp | clingraph

% g(s).

% nodes / edges

% create graph for each rule move %%%% try simplifying the below code 

% rules with a single body
sinBR(R, H) :- head(R,H), 1 = #count { X : body(R,X) }.


% TODO:
%   empty body rules
%   remove connector if single body atom
%   simplify

graph(main).
% nodeColor(p,"green:white").
% nodeColor(o,"yellow:white").
nodeColor(p,"green").
nodeColor(o,"yellow").

gameOverColor(p,"#ccffcc").
gameOverColor(o,"#ffcccc").

boldFont("Impact, Arial Black, Helvetica Bold, Franklin Gothic Heavy").
% boldFont("Monaco, Consolas, Courier New, monospace").
normalFont("Monaco, Consolas, Courier New, monospace").
% boldFont("Lucida Handwriting, Brush Script MT, Comic Sans MS, cursive").
% normalFont("Arial Narrow, Helvetica, sans-serif").
% normalFont2("Monaco, Consolas, Courier New, monospace").
% boldFont("Georgia, Times New Roman, Times, serif").
%
attr(graph,main,labeljust,l).
attr(graph,main,shape,box).
% attr(graph,main,margin,2).
attr(graph,main,fontname,F) :- normalFont(F).
% attr(graph,main,pencolor,red).

attr(graph,main,rankdir,"LR"). % arrows point up
% attr(graph,main,bgcolor,C) :- end(_,P), gameOverColor(P,C).
% attr(graph,main,label,"Game over. Proponent won.") :- end(_,p).
% attr(graph,main,label,"Game over. Opponent won.") :- end(_,o).

% attr(graph_nodes, main, fontname, F) :- normalFont2(F).
% attr(graph_nodes, main, style, filled).

% maybe useful:

% attr(graph,(T,P,M,X),bgcolor,"lightgray") :- m(T,P,M,X). % background color for each moce
% % styling afterwards
% graphAttr(style,filled).
% graphAttr(labeljust,l).

% we will create a graph for each rule / assumption
%% Rules
graph((R,mv),main) :- head(R,_).
attr(graph,(R,mv),margin,5) :- graph((R,mv),main).

% put them in additional boxes for annotation 

graph((R,H,box),(R,mv)) :- head(R,H). % create node for head
graph((R,B,box),(R,mv)) :- body(R,B). % node for each body
% attr(graph,(R,B,box),padding,2) :- graph((R,B,box),(R,mv)).

node((R,H,r),(R,H,box)) :- head(R,H). % create node for head
node((R,B,r),(R,B,box)) :- body(R,B). % node for each body

% attr(node,(R,B,r),margin,0) :- node((R,B,r),(R,B,box)).

node((R,connector),(R,mv)) :- head(R,H), not sinBR(R,H). % connector - only if not single body
% edges through connector
% edge from connector to rule body
edge(((R,B,r),(R,connector)),(R,mv)) :- body(R,B), not sinBR(R,_). 
% edge from rule head to connector
edge(((R,connector),(R,H,r)),(R,mv)) :- head(R,H), not sinBR(R,H). 
% edges with no connector
edge(((R,B,r),(R,H,r)),(R,mv)) :- head(R,H), body(R,B), sinBR(R,H). % edge from rule head to connector

%% Assumptions
graph((A,mv),main) :- assumption(A).
% for now, do not put assumptions into separate boxes

% graph((A,A,box),(A,mv)) :- assumption(A). % node for each assumption, in the node graph
node((A,A,a),(A,mv)) :- assumption(A). % node for each assumption, in the node graph

% add label to each statement
attr(node, (R,X,r), label, X) :- node((R,X,r),_).  % statement's label
% and to each assumption
attr(node, (A,A,a), label, A) :- node((A,A,a),_).  % statement's label

% attr(graph,G,K,V) :- graph(G,_), graphAttr(K,V). % graph style 
% attr(graph, (T,P,M,R), (label,0), T) :- m(T,P,M,R).      % graph labels
% attr(graph, (T,P,M,R), (label,1), ": ") :- m(T,P,M,R).      % graph labels
% attr(graph, (T,P,M,R), (label,2), M) :- m(T,P,M,R).      % graph labels

%  style connector
connAttr(label,"").
connAttr(width,"0.15").
connAttr(shape,circle).
attr(node, (R,connector), K, V) :- node((R,connector),_), connAttr(K,V).  % major simplification

% attr(node, (R,connector), fillcolor, Col) :- node((R,connector),_), nodeColor(P, Col).

% attr(node, (N,X), shape, circle) :- node((N,X),_), assumption(X).
% attr(node, (N,X), fillcolor, Col) :- node((N,X),(_,P,_,_)), nodeColor(P, Col).
% attr(node, (R,B), shape, rectangle) :- node((R,B),_), not assumption(B), R!=connector.

% % attacks
% % anything->assumption attack
edge(((X1,S1,X),(X2,S2,a)),main) :- node((X1,S1,X),_), node((X2,S2,a),_), contrary(S2,S1).  % change the other, pure assumption nodes to A,A
attr(edge,((X1,S1,X),(X2,S2,a)),color,"blue") :- node((X1,S1,X),_), node((X2,S2,a),_), contrary(S2,S1).
% attr(edge,((X1,S1,X),(X2,S2,a)),style,2) :- node((X1,S1,X),_), node((X2,S2,a),_), contrary(S2,S1).

% % supports 
% head -> (non head) statement
edge(((X1,S,r),(X2,S,r)),main) :- node((X1,S,r),_), node((X2,S,r),_), head(X1,S), not head(X2,S), X1!=X2.
attr(edge,((X1,S,r),(X2,S,r)),style,dashed) :- node((X1,S,r),_), node((X2,S,r),_), head(X1,S), X1!=X2.
% assumption -> statement
% TODO:
edge(((A,A,a),(X,A,r)),main) :- node((A,A,a),_), node((X,A,r),_), X!=A.
attr(edge,((A,A,a),(X,A,r)),style,dashed) :- node((A,A,a),_), node((X,A,r),_), X != A.


% styling
% attr(node, (R,X), shape, circle) :- node((R,X),_), g(X).
attr(node, (X1,A,X2), shape, plain) :- node((X1,A,X2),_).
% attr(node, (X1,A,X2), fontname, F) :- node((X1,A,X2),_), assumption(A), boldFont(F).
% attr(node, (X1,A,X2), fontname, F) :- assumption(A), normalfont(F), node((X1,A,X2),_).
% attr(graph, (A,B,C), fontname, F) :- assumption(A), normalfont(F), graph((A,B,C),_).
% attr(graph_nodes, main, fontname, F) :- boldFont(F).
attr(node, (X1,A,X2), fontname, F) :- assumption(A), boldFont(F), node((X1,A,X2),_).
attr(node, (X1,S,X2), fontname, F) :- not assumption(S), normalFont(F), node((X1,S,X2),_).
% attr(graph_nodes, (A,mv), fontname, F) :- assumption(A), boldFont(F), graph((A,mv),main).

% attr(node, (R,X1,X2), shape, square) :- node((R,X1,X2),_), not assumption(X1).
% attr(node, (R,X1,X2), peripheries, 2) :- node((R,X1,X2),_), g(X1).
% attr(node, (R,X1,X2), pad, 100) :- node((R,X1,X2),_), g(X1).

%  %
% styling hierarchy
% proponent used rule
% proponent statements
% defences

% Decorating

%%%%%%%%%%%%%%%%%%%% Rules
%%%%%%%%%%%%%%%%%%%%

white("white").
green("#90EE90").
yellow("#FFFF99").
blue("#87CEFA").
red("#FFA0A0").
vividRed("#FF6961").
orange("#FFB266").
greenGradient("#90EE90:white").
yellowGradient("#FFFF99:white").
blueGradient("#87CEFA:white").
redGradient("#FFA0A0:white").

% 1. MOVES
% labels
attr(graph, (X,mv), (label,0), Tm) :- m(Tm,_,_,X), Tm = #max { T : m(T,_,_,X) }.     
attr(graph, (X,mv), (label,1), ": ") :- m(T,_,_,X).   
attr(graph, (X,mv), (label,2), M) :- m(Tm,_,M,X), Tm = #max { T : m(T,_,_,X) }.      
% colors
attr(graph, (X,mv), bgcolor, C) :- m(T,p,M,X), greenGradient(C).
attr(graph, (X,mv), bgcolor, C) :- m(T,o,M,X), not m(_,p,_,X), yellowGradient(C).
%%%%

% possible moves: only take maximal ones and if its not over
attr(graph, (X,mv), (label,0), Tm) :- pm(Tm,P,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X).
attr(graph, (X,mv), (label,1), "-PM: ") :- pm(Tm,P,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X).
attr(graph, (X,mv), (label,2), M) :- pm(Tm,p,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X).
attr(graph, (X,mv), (label,2), M) :- pm(Tm,o,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not pm(Tm,p,_,X), not m(_,_,_,X).
% 

%%%
% attr(graph, (X,mv), pencolor, "darkgreen") :- pm(Tm,p,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), nodeColor(p, Col), not m(_,_,_,X).
% attr(graph, (X,mv), penwidth, 3) :- pm(Tm,_,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X).
% attr(graph, (X,mv), style, dotted) :- pm(Tm,_,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X).
% attr(graph, (X,mv), pencolor, "darkorange") :- pm(Tm,o,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), nodeColor(o, Col), not pm(Tm,p,_,X), not m(_,_,_,X).

attr(graph, (X,mv), bgcolor, C) :- pm(Tm,_,M,X), Tm = #max { T : pm(T,_,_,_) }, not end(_,_), not m(_,_,_,X), blueGradient(C).


% 2. Remaining blocked rules
%  exceptions - if used by the opponent
%             - if possible moves
attr(graph, (R,mv), label, Tm) :- remBloR(Tm,R,_,_), Tm = #min { T : remBloR(T,R,_,_) }, not m(_,o,_,R),  not pm(Tm,_,_,R).
attr(graph, (R,mv), bgcolor, C) :- remBloR(Tm,R,_,_), Tm = #min { T : remBloR(T,R,_,_) }, not m(_,o,_,R), not pm(Tm,_,_,R), redGradient(C).


%%%%%%%%%%%%%%%%%%%% Assumptions
%%%%%%%%%%%%%%%%%%%%

attr(graph, (A,mv), label, Tm) :- def(Tm,A), Tm = #min { T : def(T,A) }. %, graph((A,A),(A,mv)).   
attr(graph, (X,mv), bgcolor, C) :- def(_,X), green(C).

% same if those are parts of rules 
attr(graph, (R,A,box), label, Tm) :- def(Tm,A), Tm = #min { T : def(T,A) }, graph((R,A,box),(R,mv)). %, graph((A,A),(A,mv)).   
attr(graph, (R,A,box), bgcolor, C) :- def(_,A), graph((R,A,box),(R,mv)), green(C).


%% Culprits
attr(graph, (A,mv), label, Tm) :- cul(Tm,A), Tm = #min { T : cul(T,A) }. %, graph((A,A),(A,mv)).   
attr(graph, (X,mv), bgcolor, C) :- cul(_,X), vividRed(C).
% same if those are parts of rules 
attr(graph, (R,A,box), label, Tm) :- cul(Tm,A), Tm = #min { T : cul(T,A) }, graph((R,A,box),(R,mv)).   
attr(graph, (R,A,box), bgcolor, C) :- cul(_,A), graph((R,A,box),(R,mv)), vividRed(C).

%% Culprit candidates
attr(graph, (A,mv), label, Tm) :- culCan(Tm,A), Tm = #min { T : culCan(T,A) }, not cul(_,A), not def(_,A). %, graph((A,A),(A,mv)).   
attr(graph, (A,mv), bgcolor, C) :- culCan(_,A), not cul(_,A), not def(_,A), orange(C).
% same if those are parts of rules 
attr(graph, (R,A,box), label, Tm) :- culCan(Tm,A), Tm = #min { T : culCan(T,A) }, graph((R,A,box),(R,mv)), not cul(_,A), not def(_,A).
attr(graph, (R,A,box), bgcolor, C) :- culCan(_,A), graph((R,A,box),(R,mv)), not cul(_,A), not def(_,A), orange(C).

%%%%%%%%%%%%%%%%%%%% Statements
%%%%%%%%%%%%%%%%%%%%
% complete statements of proponent
% same if those are parts of rules 
attr(graph, (R,S,box), label, Tm) :- comS(Tm,S,p), Tm = #min { T : comS(T,S,p) }, graph((R,S,box),(R,mv)). %, graph((A,A),(A,mv)).   
attr(graph, (R,S,box), bgcolor, C) :- comS(Tm,S,p), Tm = #min { T : comS(T,S,p) }, graph((R,A,box),(R,mv)), green(C).

% state blocked statements of the opponent
attr(graph, (R,S,box), label, Tm) :- stBloS(Tm,S,o), Tm = #min { T : stBloS(T,S,o) }, graph((R,S,box),(R,mv)), not cul(_,S). %, graph((A,A),(A,mv)).   
attr(graph, (R,S,box), bgcolor, C) :- stBloS(Tm,S,o), Tm = #min { T : stBloS(T,S,o) }, graph((R,A,box),(R,mv)), not cul(_,S), red(C).


% goal


% attr(graph, (T,P,M,R), (label,1), ": ") :- m(T,P,M,R).      % graph labels
% attr(graph, (T,P,M,R), (label,2), M) :- m(T,P,M,R).      % graph labels




% reset the inner graph labels, because it inherits

attr(graph, (X,mv), label, "") :- graph((X,mv),main), not m(_,_,_,X), not pm(_,_,_,X).
attr(graph, (X1,X2,box), label, "") :- graph((X1,X2,box),(X1,mv)), not def(_,X2), not cul(_,X2), not culCan(_,X2), not comS(_,X2,p), not stBloS(_,X2,o).     % graph labels

% reset border width and colors
attr(graph, (X1,X2,box), pencolor, black) :- graph((X1,X2,box),(X1,mv)).
attr(graph, (X1,X2,box), penwidth, 1) :- graph((X1,X2,box),(X1,mv)).
attr(graph, (X1,X2,box), style, solid) :- graph((X1,X2,box),(X1,mv)).

attr(graph, (X1,X2,box), bgcolor, C) :- graph((X1,X2,box),(X1,mv)), not def(_,X2), not cul(_,X2), not comS(_,X2,p), not culCan(_,X2), not stBloS(_,X2,o), white(C).    % graph labels





%  possible move