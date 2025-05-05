#program base.
% at % advancement type, currently dabf or ds
% tt % termination type, currently ta or ts
rMT(pb1;pb2;pf1;ob1;ob2;of1). % rule move types
branchMT(pb1;pb2;pf2). % branching (br.) move types
plr(p;o). % players; proponent (p) and opponent (o)
rS(R,S) :- head(R,S). % rule's statements
rS(R,S) :- body(R,S). % rule's statements
stS(0,S,P) :- g(S), not contrary(S,S), plr(P). % goal --  initial statement 
remBloR(0,R,H,p) :- head(R,H), rS(R,S1), rS(R,S2), contrary(S1,S2). % blocked, inconsistent rules
#program updateState(t).
stS(t,S,P) :- stS(_,S,p), plr(P). % allow the opponent to access proponent statements
stR(t,R,H,o) :- stR(_,R,H,p). % allow the opponent to access proponent rules
def(t,D) :- stS(_,D,p), assumption(D). % defence
cul(t,C) :- stS(_,S,p), contrary(C,S). % culprit
culCtr(t,CC) :- cul(_,C), contrary(C,CC). % culprit contrary
defCtr(t,DC) :- def(_,D), contrary(D,DC). % defence contrary
remR(t,R,H,P) :- not stR(_,R,H,P), head(R,H), plr(P). % remaining player's rule 
remBloR(t,R,H,P) :- remR(t,R,H,P), body(R,B), cul(_,B), plr(P). % blocked remaining player P's rule 
remBloR(t,R,H,p) :- remR(t,R,H,p), rS(R,S), defCtr(_,S). % blocked remaining proponent's rule 
unexpS(t,H,p) :- stS(_,H,p), not stR(t,_,H,p). % unexpanded statement
stExpS(t,H,o) :- stS(_,H,o), remBloR(_,R,H,o) : remR(t,R,H,o). % fully expanded statement 
stBloS(t,S,o) :- stS(_,S,o), cul(_,S). % state blocked statement
stBloS(t,S,o) :- stExpS(t,S,o), not assumption(S), stBloR(t,R,S,o) : stR(t,R,S,o).
stBloR(t,R,H,o) :- stR(t,R,H,o), body(R,B), stBloS(t,B,o). % state blocked rule
comS(t,S,p) :- stS(t,S,p), assumption(S). % complete statement
comS(t,H,p) :- stR(t,R,H,p), comS(t,S,p) : body(R, S).
unbloComS(t,S,o) :- stS(t,S,o), assumption(S), not cul(t,S). % unblocked complete (com.) statement
unbloComS(t,H,o) :- stS(t,H,o), not stBloS(t,H,o), unbloComR(t,_,H,o).
unbloComR(t,R,H,o) :- stR(t,R,H,o), not stBloR(t,R,H,o), unbloComS(t,B,o) : body(R, B). % unblocked com. rule
unbloSupSS(t,S,o) :- stS(t,S,o), contrary(D,S), def(t,D), not stBloS(t,S,o). % unblocked statement supporting S 
unbloSupSS(t,S,o) :- stS(t,S,o), not stBloS(t,S,o), unbloSupSR(t,R,_,o), body(R, S).
unbloSupSR(t,R,H,o) :- stR(t,R,H,o), not stBloR(t,R,H,o), unbloSupSS(t,H,o). % unblocked rules supporting S
culCan(t,C) :- assumption(C), unbloSupSS(t,C,o). % culprit candidate
pm(t,p,pb1,R) :- remR(t,R,H,p), not remBloR(_,R,H,p), unexpS(t,H,p). % possible move "PB1"
pm(t,p,pb2,R) :- remR(t,R,H,p), not remBloR(_,R,H,p), culCan(t,C), contrary(C, H), not stS(t,H,p), not contrary(D, H) : def(_,D). % possible move "PB2"
pm(t,p,pf1,R) :- remR(t,R,H,p), not remBloR(_,R,H,p), comS(t,B,p) : body(R, B). % possible move "PF1"
pm(t,p,pf2,A) :- culCan(t,C), contrary(C,A), assumption(A), not stS(t,A,p), not contrary(A,A), not cul(_,A), not contrary(D,A) : def(_,D). % possible move "PF2"
pm(t,p,pf2,A) :- at(ds), assumption(A), not stS(_,A,p), not contrary(A,A), not cul(_,A), not contrary(D,A) : def(_,D). % possible move "PF2" if AD=DS
pm(t,o,ob1,R) :- remR(t,R,H,o), not remBloR(_,R,H,o), unbloSupSS(t,H,o). % possible move "OB1"
pm(t,o,ob2,R) :- remR(t,R,H,o), not remBloR(_,R,H,o), contrary(D, H), def(_,D). % possible move "OB2"
pm(t,o,of1,R) :- remR(t,R,H,o), not remBloR(_,R,H,o), unbloComS(t,B,o) : body(R, B). % possible move "OF1"
pm(t,o,of2,A) :- contrary(D,A), def(_,D), assumption(A), not stS(t,A,o). % possible move "OF2"
stS(t,S,P) :- m(_,p,T,R), rMT(T), rS(R,S), plr(P). % new state statement
stS(t,A,P) :- m(_,p,T,A), not rMT(T), plr(P).
stS(t,S,o) :- m(_,o,T,R), rMT(T), rS(R,S).
stS(t,A,o) :- m(_,o,T,A), not rMT(T).
stR(t,R,H,P) :- m(_,p,T,R), head(R,H), rMT(T), plr(P). % new state rule
stR(t,R,H,o) :- m(_,o,T,R), head(R,H), rMT(T). 
term(t) :- tt(ta), g(G), comS(_,G,p), comS(_,CC,p) : culCtr(_,CC); not unbloComS(t,DC,o) : defCtr(_,DC). % termination condition
remA(t,A) :- tt(ts), assumption(A), not def(_,A), not cul(_,A).
term(t) :- tt(ts), g(G), comS(_,G,p), comS(_,CC,p) : culCtr(_,CC); not unbloComS(t,DC,o) : defCtr(_,DC); not remA(t,A) : assumption(A). % termination condition
end(t,p) :- term(t), not pm(t,o,_,_). % proponent won; termination condition satisfied and opponent cannot move
end(t,o) :- not term(t), not pm(t,p,_,_). % opponent won; term. cond. not satisfied and proponent cannot move

#program step(t).
m(t,P,T,X) :- pm(t-1,P,T,X), not branchMT(T), t > 0. % proceed with non-br. move type
{ m(t,P,T,X) : pm(t-1,P,T,X) } = 1 :- t > 0, branchMT(T) : pm(t-1,_,T,_). % choose one br. move

#program pmc(t,player,type,id).
m(t,player,type,id).
