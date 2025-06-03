% axiom(a).
% premise(a).
% contrary(a,x). % asymmetric
% contradictory(x,nx). % symmetric 
% head(i,x). 
% body(i,x).
% strict_head(i,x).
% strict_body(i,x).

% we could say label(i,x). rather than rely on i to be the label

%  with preferences
% preferred(a,b).

#program base.
%  any rule
rH(R,H) :- head(R,H).
rH(R,H) :- strict_head(R,H). 
rB(R,B) :- body(R,B).
rB(R,B) :- strict_body(R,B).


rS(R,S) :- rH(R,S). % any rule's statements
rS(R,S) :- rB(R,S). 

purePremise(P) :- premise(P), not strict_head(_,P).

% knowledge base
kb(P) :- premise(P).
kb(A) :- axiom(A).

#program updateState(t).

stS(t,S,Pl). % state statement

stSR(t,R,H,Pl). % strict rule 
stDR(t,R,H,Pl). % defeasible rule 
stR(t,R,H,Pl).

stPurePremise(t,P,p) :- stS(_,P,p), premise(P), not stSR(_,_,P,p). % pure premise relative to P - possible that it is not pure actually?
rejS(t,S,p) :- stS(_,C,p), contrary(S,C). % rejected statements
rejPremise(t,P,p) :- rejS(_,P,p), premise(P). % rejected premise
rejRule(t,R,H,p) :- head(R,H), contrary(R,C), stS(_,C,p). % rejected rules
stBloR(t,R,H,p) :- rejRule(_,R,H,p).
stBloR(t,R,H,p) :- rH(R,H), rS(R,S1), rS(R,S2), contrary(S1,S2). 

auxBloP(t,C,p) :- stS(_,S,p), contrary(S,C).
auxBloP(t,C,p) :- stDR(_,R,_,p), contrary(R,C).
auxBloP(t,S,p) :- rejS(t,S,p).

stBloR(t,R,H,p) :- rH(R,H), rS(R,S), auxBloP(_,S,p).
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), rS(R,C), contrary(R,C).  % is it necessary to exclude the rejected rules
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), rB(R,B), rH(R,B).  % these should be blocked from the beginning
stBloR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), stR(_,_,H,p).  % is already used

% finished pieces of the proponent
stFinS(t,P,p) :- stPurePremise(_,P,p).
stFinS(t,A,p) :- stS(_,A,p), axiom(A).
stFinS(t,H,p) :- stR(_,R,H,p), stFinS(_,B,p) : rB(R,B).

% attacked played pieces
stAttS(t,P,o) :- stS(_,P,o), purePremise(P), rejPremise(t,P,p).
stAttR(t,R,H,o) :- rejRule(_,R,H,p).
stAttS(t,S,o) :- stS(_,S,o), not axiom(S), not purePremise(S), rH(_,S), stAttR(_,R,S,o) : rH(R,S).
stAttR(t,R,H,o) :- stR(_,R,H,o), not rejRule(_,R,H,p), rS(R,B), stAttS(_,B,o). % do we need to make this distinction with rejected rules? these are anyways stAttR (two lines above.)

% unattacked finished played pieces
stUnaFinS(t,S,o) :- stS(_,S,o), kb(S), not rejPremise(t,S,p).
stUnaFinR(t,R,H,o) :- stR(_,R,H,o), not stAttR(_,R,H,o), stUnaFinS(_,B,o) : rB(R,B).
stUnaFinS(t,H,o) :- stS(_,H,o), not stAttS(_,H,o), not axiom(H), stUnaFinR(_,_,H,o). % this probably can also be done simpler?

% unattacked pieces supporting statements in S
% TODO: this depends on the advancement type

% starting with basic S for basic advancement type
stSet(t,C,o) :- stPurePremise(t,S,p), contrary(S,C).
stSet(t,C,o) :- stDR(t,R,_,p), contrary(R,C).

% unattacked pieces supporting statements in S 
unbloSupSS(t,S,o) :- stSet(_,S,o), not stAttS(_,S,o).
unbloSupSS(t,S,o) :- stS(_,S,o), not stAttS(_,S,o), unbloSupSR(_,R,_,o), rB(R,S).
unbloSupSR(t,R,H,o) :- stR(_,R,H,o), not stAttR(_,R,H,o), unbloSupSS(_,H,o).

% candidates to attack
candAttP(t,P,p) :- premise(P), unbloSupSS(_,P,o).
candAttDR(t,R,H,p) :- head(R,H), unbloSupSR(_,R,H,o).

% premises defended by p
defP(t,P,p) :- premise(P), not rejPremise(_,P,p),  not stUnaFinS(_,C,o) : contrary(P, C).

% def. rules defended by P
defDR(t,R,H,p) :- head(R,H), not rejRule(_,R,H,p), not stUnaFinS(_,C,o) : contrary(R,C).

%  question: rule labels also proponent statements? 
%  question: aspforaspic allows for (undercut?) attacking rules by their labels?
% can rules / statements have more than one contrary? I guess so.