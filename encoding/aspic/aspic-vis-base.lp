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
