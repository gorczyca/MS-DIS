% clingo af2.lp instance.lp -n0 --outf=2  | clingraph --out=render --format=png --type=digraph

% goal
% m(0,p,d).
% m(1,o,c).
% m(2,p,b).
% end(2,p).

% arg(a).
% arg(b).
% arg(c).
% arg(d).
% arg(e).
% att(a,b).
% att(b,a).
% att(b,c).
% att(c,d).
% att(d,e).
% att(e,c).


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

attr(graph,m,rankdir,"LR"). % arrows point up
attr(graph,m,labeljust,l).
attr(graph,m,labelloc,c).
attr(graph,main,pad,0).
attr(graph_nodes, m, shape, circle).
attr(graph_nodes, m, style, filled).
attr(graph,main,fontname,"Monaco, Consolas, Courier New, monospace").
attr(graph,X,margin,0) :- graph(X,m), X!=m.
attr(graph,X,pad,0) :- graph(X,m), X!=m.
attr(graph,X,color,white) :- graph(X,m), X!=m.
% attr(graph,X,pad,10) :- graph(X,main), X!=main.


nodeColor(p,C) :- greenGradient(C).
nodeColor(o,C) :- yellowGradient(C).

% initiate
% graph for each argument
graph(m).
graph((A,l),m) :- arg(A).
node(A,(A,l)) :- arg(A).
edge((A,B),m) :- att(A,B).

attr(node,A,fillcolor,C) :- m(_,P,A), nodeColor(P, C).

attr(graph,(A,l),label,T) :- m(T,_,A).

ldefeat(Tm,A) :- defeat(Tm,A) , Tm = #min { T : defeat(T,A) }, not m(_,_,A).
attr(graph,(A,l),label,Tm) :- ldefeat(Tm,A).
attr(node,A,fillcolor,C) :- ldefeat(_,A), redGradient(C).

lpm(Tm,P,A) :- pm(Tm,P,A), Tm = #max { T : pm(T,_,A) }, not m(_,_,A), not defeat(_,A).
attr(graph,(A,l),label,T) :- lpm(T,_,A).
attr(node,A,fillcolor,C) :- lpm(_,_,A),blueGradient(C).






