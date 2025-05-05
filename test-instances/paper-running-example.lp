assumption("a";"b";"c";"d").

contrary("b","b̄").
contrary("c","c̄").

% s←q,r
head("s←q,r","s").
body("s←q,r","q").
body("s←q,r","r").

% q←a
head("q←a","q").
body("q←a","a").

% r←b
head("r←b","r").
body("r←b","b").

% b̄←q,t
head("b̄←q,t","b̄").
body("b̄←q,t","q").
body("b̄←q,t","t").

% t←c
head("t←c","t").
body("t←c","c").

% c̄←q,t
head("c̄←q,d","c̄").
body("c̄←q,d","q").
body("c̄←q,d","d").
