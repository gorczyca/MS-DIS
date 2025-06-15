% clingo af1.lp instance.lp -n0 --outf=2  | clingraph --out=render --format=png --type=digraph


% goal
% m(0,p,d).
% m(1,o,c).
% m(2,p,b).
% end(2,p).

graph(main).
attr(graph,main,labeljust,l).
attr(graph,main,rankdir,"BT"). % arrows point up
attr(graph,main,bgcolor,C) :- end(_,P), gameOverColor(P,C).
% attr(graph,main,label,"Game over. Proponent won.") :- end(_,p).
% attr(graph,main,label,"Game over. Opponent won.") :- end(_,o).

attr(graph,T,bgcolor,"lightgray") :- m(T,_,_). % background color for each move
attr(graph,T,(label,0),T) :- m(T,_,_). % background color for each move
attr(graph,T,(label,1),": ") :- m(T,_,_). % background color for each move
attr(graph,T,(label,2),P) :- m(T,P,_). % background color for each move


graph(T,main) :- m(T,_,_).

nodeColor(p,"green:white").
nodeColor(o,"yellow:white").

gameOverColor(p,"#ccffcc").
gameOverColor(o,"#ffcccc").

node(A,T) :- m(T,_,A).
edge((A,B),T) :- m(T,_,A), m(_,_,B), att(A,B).


nodeAttr(style,filled).
nodeAttr(shape,circle).
% nodeAttr(fillcolor,white).

attr(node,A,K,V) :- node(A,_), nodeAttr(K,V).
attr(node,A,fillcolor,C) :- node(A,_), m(_,P,A), nodeColor(P,C).
attr(graph_edges,main,color,red).
% attr(node,A,shape,circle) :- node(A).
% node(X)