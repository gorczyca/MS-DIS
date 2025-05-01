#program base.
m(0,p,G) :- g(G), not att(G,G). % initiate the dispute
#program updateState(t).
cul(t,C) :- m(_,p,P), att(P,C). % culprits
pm(t,p,P) :- m(_,o,O), att(P,O), not cul(_,P), not m(_,p,P), not att(P,P), not att(P,D1) : m(_,p,D1). % possible prop. move
pm(t,o,O) :- m(_,p,P), att(O,P), not cul(_,O), not m(_,o,O). % possible opp. move
end(t,p) :- g(G), m(0,p,G), not pm(t,o,_), cul(_,O1) : m(_,o,O1). % prop. won
end(t,o) :- not pm(t,p,_), m(_,o,O), not att(P1,O) : m(_,p,P1). % opp. won
#program step(t).
m(t,o,A) :- pm(t-1,o,A), not pm(t-1,p,_). 
{ m(t,p,A) : pm(t-1,p,A) } = 1 :- not pm(t-1,o,_).

#program pmc(t,player,id).
m(t,player,id).