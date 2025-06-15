% clingo af2.lp instance.lp -n0 --outf=2  | clingraph --out=render --format=png --type=digraph

% goal
% m(0,p,d).
% m(1,o,c).
% m(2,p,b).
% end(2,p).

nodeColor(p,"green:white").
nodeColor(o,"yellow:white").

gameOverColor(p,"#ccffcc").
gameOverColor(o,"#ffcccc").

% initiate

graph(T) :- m(T,_,_).
node((A,T),T) :- arg(A), m(T,_,_).
edge(((A,T),(B,T)),T) :- att(A,B), m(T,_,_).

attr(graph_nodes, G, shape, circle) :- graph(G).
attr(graph_nodes, G, style, filled) :- graph(G).
attr(graph_nodes, G, fillcolor, white) :- graph(G).
attr(node, (A,G), label, A) :- node((A,G),G).      % graph labels

attr(graph,G,labeljust,l) :- graph(G).
attr(graph,G,(label,0),G) :- graph(G).
attr(graph,G,(label,1),": ") :- graph(G). 
plrLabel(p,"P").
plrLabel(o,"O").
attr(graph,G,(label,2),L) :-  m(G,P,_), plrLabel(P,L).
attr(graph,G,bgcolor,C) :- end(G,P), gameOverColor(P,C).



attr(node, (A,T1), fillcolor, C) :-m(T1,_,_), T1 >= T, m(T,P,A), nodeColor(P, C).
% blocked pieces
attr(node, (B,T1), style, dashed) :- m(T1,_,_), T1 >= T, m(T,p,A), att(A,B), not m(T2,o,B), T2 <= T1, m(T2,_,_), not m(_,o,B).
attr(edge, ((B,T1),(C,T1)), style, dashed) :- m(T1,_,_), T1 >= T, m(T,p,A), att(A,B), att(B,C), not m(T2,o,B), T2 <= T1, m(T2,_,_), not m(_,o,B).

% #show graph/1.
% #show attr/4.
% #show node/2.
% #show edge/2.


