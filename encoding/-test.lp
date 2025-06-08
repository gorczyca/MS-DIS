% --- Reified rule representation (instance) ---
head(1,a).
body(1,b).
body(1,c).
body(1,d).

% head(2,x).
% body(2,y).

% head(3,k).  % rule with no body

% --- Compute order of body atoms ---
body_order(R, B, N) :-
    body(R,B),
    N1 = #count { B1 : body(R,B1), B1 < B }, 
    N = N1 + 1.

% Count how many body atoms there are
body_count(R, N) :-
    N = #count { B : body(R,B) },
    head(R,_).

% --- Generate print tokens ---

% Print head
print(R, 1, H) :- head(R, H).

% Print ' <- ' if there is a body
print(R, 2, " <- ") :- head(R,_), body(R,_).

% Print body atoms in order
print(R, N+2, B) :- body_order(R, B, N).

% Print commas between body atoms
% print(R, N+2, ",") :- body_order(R, _, N), body_order(R, _, N+1).

% Print final dot after body
% print(R, N+3, ".") :- body_count(R, N), head(R,_), body(R,_).

% Print final dot for rules without a body
% print(R, 2, ".") :- head(R,_), not body(R,_).

% --- Output directive ---
#show print/3.
