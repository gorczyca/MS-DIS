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


attr(graph,main,rankdir,"LR"). % arrows point up
attr(graph,main,labeljust,r).
attr(graph,main,labelloc,t).
% attr(graph,main,margin,"0.1").
attr(graph,main,pad,0).
attr(graph_nodes, main, shape, plain).
% attr(graph_nodes, main, style, filled).
attr(graph,main,fontname,"Monaco, Consolas, Courier New, monospace").
attr(graph,X,margin,5) :- graph(X,main), X!=main.
attr(graph,X,color,white) :- graph(X,main), X!=main.
% attr(graph,X,pad,10) :- graph(X,main), X!=main.


nodeColor(p,C) :- greenGradient(C).
nodeColor(o,C) :- yellowGradient(C).

% initiate
% graph for each argument
graph(main).
graph((A,box),main) :- arg(A).
node(A,(A,box)) :- arg(A).
edge((A,B),main) :- att(A,B).

attr(graph,(A,box),bgcolor,C) :- m(_,P,A), nodeColor(P, C).

attr(graph,(A,box),label,T) :- m(T,_,A).

ldefeat(Tm,A) :- defeat(Tm,A) , Tm = #min { T : defeat(T,A) }, not m(_,_,A).
attr(graph,(A,box),label,Tm) :- ldefeat(Tm,A).
attr(graph,(A,box),bgcolor,C) :- ldefeat(_,A), redGradient(C).

lpm(Tm,P,A) :- pm(Tm,P,A), Tm = #max { T : pm(T,_,A) }, not m(_,_,A), not defeat(_,A).
% attr(graph,(A,box),label,T) :- lpm(T,_,A).
attr(graph,(A,box),(label,0),T) :- lpm(T,_,A).
attr(graph,(A,box),(label,1),": ") :- lpm(T,_,A).
attr(graph,(A,box),(label,2),P) :- lpm(T,P,A).
attr(graph,(A,box),bgcolor,C) :- lpm(_,_,A),blueGradient(C).






