% run by clingo cln2.lp | clingraph

% instance 
% head(1,s).
% body(1,c).
% body(1,d).
% body(1,f).

% head(2,h).
% body(2,b).
% body(2,a).

% head(3,d).
% body(3,w).

% head(4,f).
% body(4,d).

% head(6,z).
% body(6,w).

% head(7,w).

% assumption(c;e;a;i;b).
% contrary(c,h).
% contrary(a,r).
% contrary(b,i).
% contrary(i,z).

% % dispute
% m(1,p,pb1,1).
% m(2,o,ob2,2).
% m(3,p,pb1,3).
% m(4,p,pb1,4).
% m(5,p,pf2,i).
% m(6,o,ob2,6).
% m(7,o,ob1,7).

% end(7,p).
% end(7,o).

% %%%%%%%%%%%%%%%%%%%%%%%
% visualisation
% 

% nodes / edges

% create graph for each rule move %%%% try simplifying the below code 

% rules with a single body
sinBR(R, H) :- head(R,H), 1 = #count { X : body(R,X) }.


% TODO:
%   empty body rules
%   remove connector if single body atom
%   simplify

graph(main).
nodeColor(p,"green:white").
nodeColor(o,"yellow:white").

gameOverColor(p,"#ccffcc").
gameOverColor(o,"#ffcccc").


attr(graph,main,labeljust,l).


attr(graph,main,rankdir,"BT"). % arrows point up

attr(graph,main,bgcolor,C) :- end(_,P), gameOverColor(P,C).

attr(graph,main,label,"Game over. Proponent won.") :- end(_,p).
attr(graph,main,label,"Game over. Opponent won.") :- end(_,o).


attr(graph_nodes, main, style, filled).
graph((T,P,M,X),main) :- m(T,P,M,X). % create graph for each rule move

attr(graph,(T,P,M,X),bgcolor,"lightgray") :- m(T,P,M,X). % background color for each moce

node((R,H),(T,P,M,R)) :- head(R,H), m(T,P,M,R). % create node for head
node((R,B),(T,P,M,R)) :- body(R,B), m(T,P,M,R). % node for each body
node((connector,(T,P,M,R)),(T,P,M,R)) :- head(R,H), m(T,P,M,R), not sinBR(R,H). % connector - only if not single body
node((A,A),(T,P,M,A)) :- m(T,P,M,A), assumption(A). % node for each assumption used as a move

% edges through connector
edge(((R,B),(connector,(T,P,M,R))),(T,P,M,R)) :- body(R,B), m(T,P,M,R), not sinBR(R,_). % edge from connector to rule body
edge(((connector,(T,P,M,R)),(R,H)),(T,P,M,R)) :- head(R,H), m(T,P,M,R), not sinBR(R,H). % edge from rule head to connector

% edges with no connector
edge(((R,B),(R,H)),(T,P,M,R)) :- head(R,H), body(R,B), m(T,P,M,R), sinBR(R,H). % edge from rule head to connector

% styling afterwards
graphAttr(style,filled).
graphAttr(labeljust,l).
attr(graph,G,K,V) :- graph(G,_), graphAttr(K,V). % graph style 
attr(graph, (T,P,M,R), (label,0), T) :- m(T,P,M,R).      % graph labels
attr(graph, (T,P,M,R), (label,1), ": ") :- m(T,P,M,R).      % graph labels
attr(graph, (T,P,M,R), (label,2), M) :- m(T,P,M,R).      % graph labels
attr(node, (R,H), label, H) :- node((R,H),_), R != connector.  % statement's label
%  style connector
connAttr(label,"").
connAttr(width,"0.15").
connAttr(shape,circle).
attr(node, (connector,(T,P,M,R)), K, V) :- node((connector,(T,P,M,R)),_), connAttr(K,V).  % major simplification
attr(node, (connector,(T,P,M,R)), fillcolor, Col) :- node((connector,(T,P,M,R)),_), nodeColor(P, Col).

attr(node, (N,X), shape, circle) :- node((N,X),_), assumption(X).
attr(node, (N,X), fillcolor, Col) :- node((N,X),(_,P,_,_)), nodeColor(P, Col).
attr(node, (R,B), shape, rectangle) :- node((R,B),_), not assumption(B), R!=connector.

% attacks
% rule->rule attack
edge(((X1,S1),(X2,S2)),main) :- node((X1,S1),_), node((X2,S2),_), contrary(S2,S1).  % change the other, pure assumption nodes to A,A
attr(edge,((X1,S1),(X2,S2)),color,red) :- node((X1,S1),_), node((X2,S2),_), contrary(S2,S1).

% supports 
edge(((X1,S),(X2,S)),main) :- node((X1,S),_), node((X2,S),_), head(X1,S), X1!=X2.
attr(edge,((X1,S),(X2,S)),style,dashed) :- node((X1,S),_), node((X2,S),_), head(X1,S), X1!=X2.