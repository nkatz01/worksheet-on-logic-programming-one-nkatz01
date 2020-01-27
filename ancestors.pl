:- use_module(library(assoc)).
:- use_module(library(pairs)).
parent(bruce, clarissa).
parent(fred, greta).
parent(doris,bobby).
parent(richard,bobby).
parent(chirs,richard).
parent(greg, henry).
parent(henry, bessy).
parent(clive, dave).
parent(clarissa, dave).
parent(betty, clarissa).
parent(eddie, greg).
parent(gene,betty).
parent(alan, clive).
parent(jake,alan).
parent(greta, henry).
parent(elsie, greg).
parent(roger,richard).
parent(andrea, clive).
parent(clive, doris).
parent(freda, greta).
parent(clarissa, doris).


ancestor(A, B):-	% A is B's ancestor if
    parent(A, B).% A is B's parent	

ancestor(A, B):-
	 
	%write(' in second ancestor'),nl,
    parent(P, B),	 
    ancestor(A, P).
	
ancestor1(A, B):-
    parent(P, B),
    ancestor1(A, P).
	
ancestor1(A, B):-
    parent(A, B).

ancestor2(A, B):-
    parent(A, B).
ancestor2(A, B):-
    ancestor2(A, P),
    parent(P, B).

ancestor3(A, B):-
    ancestor3(A, P),
    parent(P, B).
ancestor3(A, B):-
    parent(A, B).
	
 
descendant(A, B):-	% A is B's descendant if
    parent(B, A).	% B is A's parent.

descendant(A, B):-	% A is B's descendant if
    parent(B, P),	% B is a parent of some person P and
    descendant(A, P).	% A is P's descendant.


%   PROBLEM 3
%   How do you know if someone is related to someone else ?

related(A, B):-		% A is related to B if
    ancestor(A, B).    	% A is B's ancestor.

related(A, B):-		% A is related to B if
    descendant(A, B).	% A is B's descendant.

related(A, B):-		% A is related to B if
    ancestor(X, A),    	% some person X is A's ancestor and
    ancestor(X, B),    	% X is also B's ancestor and
    A \== B.		% A is not the same as B.

 

follows(anne,fred).
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
 

canReadMsg(X,Y) :- follows(X,Z),tweeted(Z,Y).
	listEveryones(Results):- findall(Tweets, listAllMsgForPerson(X,Tweets),Results).
	
	listAllMsgForPerson(X,[X|[AllMsgs]]):- tweeted(X,M),
	  listAll(X,[M],AllMsg),flatten(AllMsg,AllMsgs).
	  
 	listAll(X,Acc,Result) :- 
	canReadMsg(X,Res), \+member(Res,Acc), Acc\=Res, listAll(X,[Res|Acc],Result),!.
	listAll(X,Acc,Acc).

mutual(Results) :- follows(X,Y), follows(Y,X),sort([X,Y],Results).

listAllMutuals(List) :- setof(Pair, mutual(Pair),List).

ifEveryoneRetweets(X,Results) :- findall(Res, helperRetweets(X,Res),List), flatten(List,Ls), sort(Ls,Results). 
helperRetweets(X,Res) :- retweets(X,[],Res,Accu).%optionally a list of the people-chain can be retreived.


retweets(X,Acc,[M],Accu) :- \+follows(X,_),tweeted(X,M),Accu = [X|Acc];follows(X,Y),\+follows(Y,_),tweeted(Y,M),Accu = [Y|Acc];follows(X,Y),follows(Y,_),member(Y,Acc),tweeted(X,M),Accu = [X|Acc].


retweets(X,Acc,[M|T],Accu) :-  follows(X,Y), \+member(Y,Acc),retweets(Y,[X|Acc],T,Accu),tweeted(X,M).



add_up_list(L,K):- reverse(L,Ls), add_up_list_h(Ls, Res), reverse(Res,K).  

add_up_list_h([],[]). 
add_up_list_h([H|T],[Ttl|Newtail]) :-  sum_list(T,Sumrest), Ttl is H+Sumrest, add_up_list_h(T,Newtail).

merge(L,K,Results) :- append(L,K,Res), sort(Res,Results).

mygcd(A,0,A).
mygcd(A,B,Y) :- A > B, Newb is A mod B , mygcd(B,Newb,Y),!.
mygcd(A,B,Y) :- Newb is B mod A , mygcd(A,Newb,Y).


 
/*
 If A≤B, then gcd(A,B) = gcd(A,B−A).
gcd(A,0) is equal to A.
*/




door(a,b).
door(b,e).
door(b,c).
door(d,e).
door(c,d).
door(e,f).
door(g,e).

go(X,Y,ActualPath) :-
	go(X,Y,[],Path),
	reverse(Path,[],ActualPath).

go(X,X,Route,[Route]).
go(X,Y,Route,Path) :-
	door(X,Z),
	not(member(Z,Route)),
	go(Z,Y,[Z|Route],Path).
go(X,Y,Route,Path):-
	door(Z,X),
	not(member(Z,Route)),
	go(Z,Y,[Z|Route],Path).

reverse([],A,A).
reverse([H|T],Acc,Result):-
	reverse(T,[H|Acc],Result).