assumption(a;b;c;d;e;f;xe).

contrary(a,xa).
contrary(b,xb).
contrary(c,xc).
contrary(d,xd).
contrary(e,xe).
contrary(f,xf).

% s←p,a
head(1,s).
body(1,p).
body(1,a).
body(1,d).


% xc←r
head(2,p).
body(2,xc).

% t←c
head(3,t).
body(3,c).

% xa←b,t
head(4,xa).
body(4,b).
body(4,t).

% r←d,v
head(5,xc).
body(5,f).
% body(5,v).

% xd←e
head(6,xd).
body(6,e).

g(s).

