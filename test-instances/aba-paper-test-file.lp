assumption(a;b;c;d).

contrary(b,xb).
contrary(c,xc).

% s←q,r
head(1,s).
body(1,q).
body(1,r).

% q←a
head(2,q).
body(2,a).

% r←b
head(3,r).
body(3,b).

head(7,r).
body(7,c).

% b̄←q,t
head(4,xb).
body(4,q).
body(4,t).

% t←c
head(5,t).
body(5,c).

% c̄←q,t
head(6,xc).
body(6,q).
body(6,d).
