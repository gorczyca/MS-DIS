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

axiom(h).
premise(b;c;d;e;f).
strict_head(sr1,z).
strict_body(sr1,h).
strict_head(sr2,t).
strict_body(sr2,z).
strict_body(sr2,b).
head(sd1,v).
body(sd1,c).
head(sd2,v).
body(sd2,d).
head(sd3,w).
body(sd3,z).
body(sd3,v).
head(sd4,r).
body(sd4,z).
head(sd5,y).
body(sd5,d).
body(sd5,f).
contrary(b,w).
contrary(r,w).
contrary(y,w).
contrary(sd1,r).
contrary(sd2,r).
contrary(w,r).
contrary(w,y).
contrary(z,c).
contrary(z,d).
contrary(z,f).