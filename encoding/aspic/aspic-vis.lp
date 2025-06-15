% clingo aspic.lp instance.lp base.lp -n0 --outf=2  | clingraph --out=render --format=png --type=digraph

% m(1,p,pb1,sr2).
% m(2,p,pb1,sr1).
% m(3,o,ob1,sd3).
% m(4,o,ob1,sd1).
% m(5,p,pb2,sd4).

% end(5,p).
% end(7,o).

% %%%%%%%%%%%%%%%%%%%%%%%
% visualisation
% 

% nodes / edges

% create graph for each rule move %%%% try simplifying the below code 

% any rule head hR


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
attr(graph,(T,P,M,X),bgcolor,"lightgray") :- m(T,P,M,X). % background color for each move

node((R,H),(T,P,M,R)) :- rH(R,H), m(T,P,M,R). % create node for head
node((R,B),(T,P,M,R)) :- rB(R,B), m(T,P,M,R). % node for each body
node((connector,(T,P,M,R)),(T,P,M,R)) :- rH(R,H), m(T,P,M,R). % connector - only if not single body
node((A,A),(T,P,M,A)) :- m(T,P,M,A), kb(A). % node for each assumption used as a move

% edges through connector
edge(((R,B),(connector,(T,P,M,R))),(T,P,M,R)) :- rB(R,B), m(T,P,M,R). % edge from connector to rule body
edge(((connector,(T,P,M,R)),(R,H)),(T,P,M,R)) :- rH(R,H), m(T,P,M,R). % edge from rule head to connector

% style the defeasible rules
attr(edge, ((connector,(T,P,M,R)),(R,H)), penwidth, "0.75") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,H),(T,P,M,R)), head(R,H).
attr(edge, ((connector,(T,P,M,R)),(R,H)), arrowsize, "1.5") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,H),(T,P,M,R)), head(R,H).
attr(edge, ((connector,(T,P,M,R)),(R,H)), color, "black:black") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,H),(T,P,M,R)), head(R,H).
attr(edge, ((connector,(T,P,M,R)),(R,H)), arrowhead, empty) :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,H),(T,P,M,R)), head(R,H). % simplify as: default rule attr.

attr(edge, ((R,B),(connector,(T,P,M,R))), penwidth, "0.75") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,B),(T,P,M,R)), body(R,B).
attr(edge, ((R,B),(connector,(T,P,M,R))), arrowsize, "1.5") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,B),(T,P,M,R)), body(R,B).
attr(edge, ((R,B),(connector,(T,P,M,R))), color, "black:black") :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,B),(T,P,M,R)), body(R,B).
attr(edge, ((R,B),(connector,(T,P,M,R))), arrowhead, empty) :- node((connector,(T,P,M,R)),(T,P,M,R)), node((R,B),(T,P,M,R)), body(R,B). % simplify as: default rule attr.

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

attr(node, (N,X), shape, circle) :- node((N,X),_), premise(X).
attr(node, (N,X), shape, diamond) :- node((N,X),_), axiom(X).

attr(node, (N,X), fillcolor, Col) :- node((N,X),(_,P,_,_)), nodeColor(P, Col).
attr(node, (R,B), shape, rectangle) :- node((R,B),_), not kb(B), R!=connector.

% attacks
edge(((X1,S1),(X2,S2)),main) :- node((X1,S1),_), node((X2,S2),_), contrary(S2,S1).  % change the other, pure assumption nodes to A,A
attr(edge,((X1,S1),(X2,S2)),color,red) :- node((X1,S1),_), node((X2,S2),_), contrary(S2,S1).

% attacks on rules 
edge(((X1,S1),(connector,(T,P,M,R))),main) :- head(R,_), node((X1,S1),_), node((connector,(T,P,M,R)),(T,P,M,R)), contrary(R,S1).  % change the other, pure assumption nodes to A,A
attr(edge,((X1,S1),(connector,(T,P,M,R))),color,red) :- head(R,_), node((X1,S1),_), node((connector,(T,P,M,R)),(T,P,M,R)), contrary(R,S1).

% supports 
edge(((X1,S),(X2,S)),main) :- node((X1,S),_), node((X2,S),_), rH(X1,S), X1!=X2.
attr(edge,((X1,S),(X2,S)),style,dashed) :- node((X1,S),_), node((X2,S),_), rH(X1,S), X1!=X2.