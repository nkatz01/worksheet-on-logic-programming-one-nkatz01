% 1,2,3 & 4 

father(albert, bob).
father(albert, bill).

father(bob, carl).
father(bill, rupart).
father(rupart, jack).
father(jack, jim).

father(carl, benny).
father(carl, lizzy).
father(lizzy, frank).
father(benny, gabe).
father(gabe, gideon).

female(lizzy).

brother(X,Y) :- father(Z,X), father(Z,Y), \+female(X), \+female(Y).

cousin(X,Y) :- descendent(X,Z), descendent(Y,Z), \+ descendent(X,Y), \+ descendent(Y,X), \+brother(X,Y), X \= Y.

% version 2 - only returns unique results
cousin(X,Y) :- descendent(X,Z), descendent(Y,Z), \+commonAncestor(Z,Y), \+commonAncestor(Z,X) , \+ descendent(X,Y), \+ descendent(Y,X), \+brother(X,Y), X \= Y.

grandson(X,Y) :- father(Y, Z),
father(Z,X), \+female(X).

descendent(X,Y) :- father(Y,X);
father(Y,Z), descendent(X,Z).

commonAncestor(X,Y) :- descendent(X,Z), descendent(Y,Z).
