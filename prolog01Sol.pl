% 1,2,3 & 4 
  father(a,b).  % 1                 
  father(a,c).  % 2
  father(b,d).  % 3
  father(b,e).  % 4
  father(c,f).  % 5
%female(b).

%1
brother(X,Y) :- father(Z,X), father(Z,Y), X\=Y.

%version that checks that it's strictly 'brother'.
brother2(X,Y) :- father(Z,X), father(Z,Y), \+female(X), \+female(Y) , X\=Y.

%2
cousin(X,Y) :- father(Z,X), father(S,Y), brother(Z,S).

%version that considers cousins as far removed as possible
cousin2(X,Y) :- descendent(X,Z), descendent(Y,Z), \+ descendent(X,Y), \+ descendent(Y,X), \+brother(X,Y), X \= Y.

% version 2 - only returns unique results
cousin3(X,Y) :- descendent(X,Z), descendent(Y,Z), \+commonAncestor(Z,Y), \+commonAncestor(Z,X) , \+ descendent(X,Y), \+ descendent(Y,X), \+brother2(X,Y), X \= Y.

%3
grandson(X,Y) :- father(Z,X), father(Y,Z).

%version that checks that it's strictly 'grandson'.
grandson2(X,Y) :- father(Y, Z),
father(Z,X), \+female(X).

%4
descendent(X,Y) :- father(Y,X);
father(Y,Z), descendent(X,Z).

commonAncestor(X,Y) :- descendent(X,Z), descendent(Y,Z).

%5 Answer (of which explanation is in attached diagram) follows the naively implemented versions of above clauses.


 
 