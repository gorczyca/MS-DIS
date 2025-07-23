% clingo af2.lp instance.lp -n0 --outf=2  | clingraph --out=render --format=png --type=digraph

attr(graph_nodes, m, shape, circle).
attr(graph_nodes, m, style, filled).

nodeColor(p,"green").
nodeColor(o,"yellow").

graph(m).
graph((A,l),m) :- arg(A).
node(A,(A,l)) :- arg(A).
edge((A,B),m) :- att(A,B).

attr(node,A,fillcolor,C) :- m(_,P,A), nodeColor(P, C).
attr(graph,(A,l),label,T) :- m(T,_,A).

ldefeat(Tm,A) :- defeat(Tm,A) , Tm = #min { T : defeat(T,A) }, not m(_,_,A).
attr(graph,(A,l),label,Tm) :- ldefeat(Tm,A).
attr(node,A,fillcolor,"red") :- ldefeat(_,A).

lpm(Tm,P,A) :- pm(Tm,P,A), Tm = #max { T : pm(T,_,A) }, not m(_,_,A), not defeat(_,A).
attr(graph,(A,l),label,T) :- lpm(T,_,A).
attr(node,A,fillcolor,"lightblue") :- lpm(_,_,A).

