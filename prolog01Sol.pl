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
descendent(X,Y) :- father(Y,X).
descendent(X,Y) :- father(Y,Z), descendent(X,Z).

commonAncestor(X,Y) :- descendent(X,Z), descendent(Y,Z).

%5 Answer (of which explanation is in attached prologTracing.xlsx diagram) follows the naively implemented versions of above clauses.
/* ?- brother(X,Y).:
	X = b
	Y = c

	X = c
	Y = b

	X = d
	Y = e

	X = e
	Y = d
	
?- cousin(X,Y).:
	X = d
	Y = f

	X = e
	Y = f

	X = f
	Y = d

	X = f
	Y = e

?- grandson(X,Y).:
	X = d
	Y = a

	X = e
	Y = a

	X = f
	Y = a
	
?- descendent(X,Y).:
	X = b
	Y = a

	X = c
	Y = a

	X = d
	Y = b

	X = e
	Y = b

	X = f
	Y = c

	X = d
	Y = a

	X = e
	Y = a

	X = f
	Y = a

*/

%6
myreverse(L,K) :- reverse(L,Lrev), K = Lrev.

%7,8 & 9
ffollows(anne,fred).
follows(fred,julie).
follows(fred,susan).
follows(john,fred).
follows(julie,fred).
follows(susan,john).
follows(susan,julie).


tweeted(anne,[tweet1,tweet5]).
tweeted(fred,[tweet2, tweet7,tweet8]).
tweeted(john,[tweet3,tweet4]).
tweeted(julie,[tweet6]).
tweeted(susan,[tweet9,tweet10]).

tweetsOf(X,Y):- tweeted(X,Y).


%a) Which messages can Fred see (assuming that only direct followers will see a message)?

	%includes cut and base is after recurseive call  
	canReadMsg(X,Y) :- follows(X,Z),tweeted(Z,Y).

	listAllMsgForPerson(X,[X|[AllMsgs]]):- 
	  listAll(X,[],AllMsg),flatten(AllMsg,AllMsgs).
	listAll(X,Acc,Result) :- 
	canReadMsg(X,Res), \+member(Res,Acc), Acc\=Res, listAll(X,[Res|Acc],Result),!.
	listAll(X,Acc,Acc).
	
mutual(X,Y) :- follows(X,Y), follows(Y,X).

%only partial solution
%allTheyCanSee(X,Res) :- findall(Y, canReadMsg(X,Y),List), flatten(List,Res).

%9 d) 
ifEveryoneRetweets(X,Results) :- findall(Res, helperRetweets(X,Res),List), flatten(List,Ls), sort(Ls,Results). 
helperRetweets(X,Res) :- retweets(X,[],Res,Accu).%optionally a list of the people-chain can be retreived.

retweets(X,Acc,[M],Accu) :- \+follows(X,_),tweeted(X,M),Accu = [X|Acc];follows(X,Y),\+follows(Y,_),tweeted(Y,M),Accu = [Y|Acc];follows(X,Y),follows(Y,_),member(Y,Acc),tweeted(X,M),Accu = [X|Acc].