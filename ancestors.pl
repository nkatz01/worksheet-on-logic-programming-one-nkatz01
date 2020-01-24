

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

is_integer(0).
is_integer(X) :- is_integer(Y),write(Y), write(X),nl, X is Y+1.

idiv(X,Y,Result) :- is_integer(Result),
Prod1 is Result*Y,
Prod2 is (Result+1)*Y,
Prod1 =< X, Prod2 > X,
!.


/*myList(Pred, L) :-
    myList(Pred, [], L).
	
myList(Pred, Accum, L) :-
   is(Value, eval(Pred)),
    \+ member(Value, Accum), !,
    myList(I, [Value|Accum], L). 
myList(_, L, L).
%canReadMsg(I, Value)*/

listAll(X,AllMsgs):- 
	canReadMsg(X,Msg), listAll(X,Msg,AllMsgs).
	
listAll(X,Acc,Result) :- 
	canReadMsg(X,Res), \+member(Res,Acc), Acc\=Res, flatten([Acc|Res],Result).

 
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
 
tweetsOf(X,Y):- tweeted(X,Y).

canReadMsg(X,Y) :- follows(X,Z),tweeted(Z,Y).

mutual(X,Y) :- follows(X,Y), follows(Y,X).

%only partial solution
allTheyCanSee(X,Res) :- findall(Y, canReadMsg(X,Y),List), flatten(List,Res).

retweets(X,M) :- allTheyCanSee(X,Res), member(M,Res).

canAlsoSee(X,Res) :- follows(X,Y),   retweets(Y,Res).


canSee(X,Res) :- follows(X,Y), tweeted(Y,Res), Y\=X.
canSee(X,Res) :- follows(X,Y), follows(Y,Z), canSee(Z,Res).
/*%P is person, T is tweet list instacne, [T] is that put into a list, res is all accum
outpMsgPerPerson(P,Res) :- msgPerPerson(P, T,[T],Res).
%,flatten(List,Res).

msgPerPerson(P,T,L,[P|L]).
msgPerPerson(P,T,L,Res) :- canReadMsg(P,T), not(member(T,L)), msgPerPerson(P,T,[T|L],Res).
 


ask" your knowledge base the following questions (you may want to add rules to the knowledge base to help you answer the questions):
a) Which messages can Fred see (assuming that only direct followers will see a message)?
	canReadMsg(fred,Y).
b) Find all the persons who are friends, i.e., they follow each other.
	mutual(X,Y).
c) Output for each person which messages they can see.

d) If everyone resends every message they receive, which messages can Fred see?*/




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