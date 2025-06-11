% axiom(a).
% premise(a).
% contrary(a,x). % asymmetric
% contradictory(x,nx). % symmetric -- do we need that? looks like this is something inherent to aspforaspic
% we can circumvent that by addint the following to the base:
% contrary(x,nx) :- contradictory(x,nx).
% contrary(nx,x) :- contradictory(x,nx).
% head(i,x). 
% body(i,x).
% strict_head(i,x).
% strict_body(i,x).


#program base.
rMT(pb1;pb2;pf1;ob1;ob2;of1). % rule move types
branchMT(pb1;pb2;pf2). % branching (br.) move types
%  any rule head
rH(R,H) :- head(R,H). 
rH(R,H) :- strict_head(R,H). 
% any rule body
rB(R,B) :- body(R,B).
rB(R,B) :- strict_body(R,B).
% any rule's statements
rS(R,S) :- rH(R,S). 
rS(R,S) :- rB(R,S). 
% players
plr(p;o).
% pure premise
purePremise(P) :- premise(P), not strict_head(_,P).
% knowledge base
kb(P) :- premise(P).
kb(A) :- axiom(A).

stS(0,S,P) :- g(S), not contrary(S,S), plr(P). % goal --  initial statement 
stBloR(0,R,H,p) :- rH(R,H), rS(R,S1), rS(R,S2), contrary(S1,S2). % blocked inconsistent rules from the beginning
stBloR(0,R,H,p) :- head(R,H), contrary(R,S), rS(R,S). % blocked inconsistent default rule
stBloR(0,R,H,p) :- head(R,H), body(R,H). % blocked circular rule

#program updateState(t).

stPurePremise(t,P,p) :- stS(_,P,p), premise(P), not stSR(_,_,P,p). % pure premise relative to P 
rejS(t,S,p) :- stS(_,C,p), contrary(S,C). % rejected statements
rejPremise(t,P,p) :- rejS(_,P,p), premise(P). % rejected premise
rejRule(t,R,H,p) :- head(R,H), contrary(R,C), stS(_,C,p). % rejected rules

% auxiliary for blocked rules
auxBloP(t,C,p) :- stS(_,S,p), contrary(S,C).
auxBloP(t,C,p) :- stDR(_,R,_,p), contrary(R,C).
auxBloP(t,S,p) :- rejS(t,S,p).

stBloR(t,R,H,p) :- rejRule(_,R,H,p).
stBloR(t,R,H,p) :- rH(R,H), rS(R,S), auxBloP(_,S,p).
% is it necessary to exclude the rejected rules? If not then we can remove the 2 below
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), rS(R,C), contrary(R,C).  
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), rB(R,B), rH(R,B).  % these should be blocked from the beginning
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), stR(_,_,H,p).  % is already used

% finished pieces of the proponent
stFinS(t,P,p) :- stPurePremise(_,P,p). % here maybe paretheses not so necessary
stFinS(t,A,p) :- stS(_,A,p), axiom(A).
stFinS(t,H,p) :- stR(_,R,H,p), stFinS(_,B,p) : rB(R,B).

% attacked played pieces
stAttS(t,P,o) :- stS(_,P,o), purePremise(P), rejPremise(t,P,p).
stAttR(t,R,H,o) :- rejRule(_,R,H,p).
stAttS(t,S,o) :- stS(_,S,o), not axiom(S), not purePremise(S), rH(_,S), stAttR(_,R,S,o) : rH(R,S).
stAttR(t,R,H,o) :- stR(_,R,H,o), not rejRule(_,R,H,p), rB(R,B), stAttS(_,B,o). % do we need to make this distinction with rejected rules? these are anyways stAttR (two lines above.)

% unattacked finished played pieces
stUnaFinS(t,S,o) :- stS(_,S,o), kb(S), not rejPremise(t,S,p).
stUnaFinR(t,R,H,o) :- stR(_,R,H,o), not stAttR(_,R,H,o), stUnaFinS(t,B,o) : rB(R,B).
stUnaFinS(t,H,o) :- stS(_,H,o), not stAttS(_,H,o), not axiom(H), stUnaFinR(t,_,H,o). % this probably can also be done simpler?

% unattacked pieces supporting statements in S
% TODO: this depends on the advancement type
% TODO: these are just contraries of pure premises of proponent and contraries of defeasible rules of the proponent

% starting with basic S for basic advancement type
stSet(t,C,o) :- stPurePremise(t,S,p), contrary(S,C).
stSet(t,C,o) :- stDR(t,R,_,p), contrary(R,C).

% unattacked pieces supporting statements in S 
unbloSupSS(t,S,o) :- stSet(_,S,o), not stAttS(t,S,o).
unbloSupSS(t,S,o) :- stS(_,S,o), not stAttS(t,S,o), unbloSupSR(t,R,_,o), rB(R,S).
unbloSupSR(t,R,H,o) :- stR(_,R,H,o), not stAttR(t,R,H,o), unbloSupSS(t,H,o).

% candidates to attack
candAttP(t,P,p) :- premise(P), unbloSupSS(t,P,o).
candAttDR(t,R,H,p) :- head(R,H), unbloSupSR(t,R,H,o). % this can be simpliefied, and I can always just collect statements to be attacked - be that rule or a premise - the above i could maybe remove
% TODO:
candAtt(t,P,p) :- premise(P), unbloSupSS(t,P,o).
candAtt(t,R,p) :- head(R,H), unbloSupSR(t,R,H,o).

% premises defended by p
% defP(t,P,p) :- premise(P), not rejPremise(_,P,p),  not stUnaFinS(_,C,o) : contrary(P, C).

% def. rules defended by P
% defDR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), not stUnaFinS(_,C,o) : contrary(R,C).

% possible moves
% definition could be really simplieified, in all PB moves, the second argument is always R_d - I suggest to just add it to the definition rather than have it as parameter, for less confusion.

remR(t,R,H,p) :- rH(R,H), not stBloR(_,R,H,p), not stR(_,R,H,p). % should we not exclude rules with same head? like below
% remR(t,R,H,p) :- rH(R,H), not stBloR(t,R,H,p), not stR(t,_,H,p). % should we not exclude rules with same head? like below
pm(t,p,pb1,R) :- remR(t,R,H,p), stS(_,H,p). % possible move "PB1"
pm(t,p,pb2,R) :- remR(t,R,H,p), not stS(_,H,p), contrary(S,H), candAtt(t,S,p). % possible move "PB2"
%  a big simplification would be to just name the moves, and then if rule move - add head and body, if statement - add statement. No matter if head already exists, P/B are sets and can be added again instead of defining T= {h} u {B -> h} or just T={B->h}.
pm(t,p,pf1,R) :- remR(t,R,H,p), not stPurePremise(_,H,p), stFinS(_,B,p) : rB(R,B). % possible move "PF1" % TODO for now remove forward moves
pm(t,p,pf2,C) :- candAtt(t,S,p), contrary(S,C), kb(C), not stS(_,C,p), not contrary(C,C), not rejS(_,C,p), not contrary(R,C) : stDR(_,R,_,p) ; not contrary(S1,C) : stS(_,S1,p).
% 
pm(t,o,ob1,R) :- rH(R,H), not stR(_,R,H,_), unbloSupSS(t,H,o).
pm(t,o,ob2,R) :- rH(R,H), not stR(_,R,H,_), stSet(t,H,o).
pm(t,o,of1,R) :- rH(R,H), not stR(_,R,H,_), stUnaFinS(t,B,o) : rB(R,B). % TODO for now remove forward moves
pm(t,o,of2,S) :- stSet(_,S,o), kb(S), not stS(_,S,_).
% the condition that all body atoms must be included is sometimes enforced by P* \supseteq B and sometimes b\in P* for every b\in B. Would be good to unify it.

stS(t,S,P) :- m(_,p,T,R), rMT(T), rS(R,S), plr(P). % new state statement
stS(t,A,P) :- m(_,p,T,A), not rMT(T), plr(P).
stS(t,S,o) :- m(_,o,T,R), rMT(T), rS(R,S).
stS(t,A,o) :- m(_,o,T,A), not rMT(T).
stR(t,R,H,P) :- m(_,p,T,R), rH(R,H), rMT(T), plr(P). % new state rule
stR(t,R,H,o) :- m(_,o,T,R), rH(R,H), rMT(T). 

stDR(t,R,H,P) :- stR(t,R,H,P), head(H,R).
stSR(t,R,H,P) :- stR(t,R,H,P), strict_head(H,R).

%  termination criteria - for admissible

rejPremiseAtt(t,P,p) :- rejPremise(_,P,p), contrary(P,C), stFinS(_,C,p). 
rejRuleAtt(t,R,H,p) :- rejRule(_,R,H,p), contrary(R,C), stFinS(_,C,p). 

term(t) :- stFinS(_,G,p) : g(G) ; rejPremiseAtt(_,P,p) : rejPremise(_,P,p) ; rejRuleAtt(_,R,_,p) : rejRule(_,R,_,p); not stUnaFinS(t,S,o) : stSet(_,S,o).

end(t,p) :- term(t), not pm(t,o,_,_). % proponent won
end(t,o) :- not term(t), not pm(t,p,_,_).  % opponent won


#program step(t).
m(t,P,T,X) :- pm(t-1,P,T,X), not branchMT(T), t > 0. % proceed with non-br. move type
{ m(t,P,T,X) : pm(t-1,P,T,X) } = 1 :- t > 0, branchMT(T) : pm(t-1,_,T,_). % choose one br. move

#program pmc(t,player,type,id).
m(t,player,type,id).

#show m/4.


% also: for simplification -- can't we just check if there is NO OTHER MOVE possible for the opposite player, rather than checking specific? 
% in the PW condition, why not do \bar{K^{o-}_p} \cap P^* = \emptyset, rather than use quantifier?

% in the example, 
%   at 1-2 using sd3 can be both ob1 and ob2
% 