head(1,s).
body(1,c).
body(1,d).
body(1,f).

head(2,h).
body(2,b).
body(2,a).

head(3,d).
body(3,w).

head(4,f).
body(4,d).

head(6,z).
body(6,w).

head(7,w).

assumption(c;e;a;i;b).
contrary(c,h).
contrary(a,r).
contrary(b,i).
contrary(i,z).


% moves
m(1,p,pb1,1).
m(2,o,ob2,2).
m(3,p,pb1,3).
m(4,p,pb1,4).
m(5,p,pf2,5).
m(6,o,ob2,6).
m(7,o,ob1,7).

% auxiliary

