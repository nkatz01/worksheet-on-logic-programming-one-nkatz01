/*   File:    ancestors.pl
     Author:  Dave Robertson
     Purpose: Relationships in a family tree
Suppose we have a family tree like this :
alan andrea   bruce betty      eddie elsie   fred  freda
 |     |        |     |          |     |       |     |
 |_____|        |_____|          |_____|       |_____|
    |              |                |             |
  clive        clarissa            greg         greta
   |  |__________|___|              |             |
   |__________|__|                  |_____________|
          |   |                            |
        dave doris                        henry
which is defined in Prolog by the following 3 sets of predicates:
*/

%   parent(Parent, Child).
%   Parent is the parent of Child.

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
	
%   male(Person).
%   This Person is male.

male(alan).
male(bruce).
male(clive).
male(dave).
male(eddie).
male(fred).
male(greg).
male(henry).


%   female(Person).
%   This Person is female.

female(andrea).
female(betty).
female(clarissa).
female(doris).
female(elsie).
female(freda).
female(greta).


%   married(Person1, Person2).
%   Person1 is married to Person2.

married(alan, andrea).
married(bruce, betty).
married(clive, clarissa).
married(eddie, elsie).
married(fred, freda).
married(greg, greta).

%   PROBLEM 1
%   How do you find out if someone is the ancestor of someone else ?

is_integer(0).
is_integer(X) :- is_integer(Y), X is Y + 1.

%   PROBLEM 2
%   How do you find out if someone is the descendant of someone else ?

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

%   There are lots of other different ways of solving this problem.


%   PROBLEM 4
%   How can you decide whether two people could possibly marry, given that
%   only an unrelated male and female are allowed to do this ?

possible_to_marry(A, B):-	% It is possible for A to marry B if
    male(A),			% A is male and
    female(B),			% B is female and
    \+ related(A, B).		% A is not related to B.


%   PROBLEM 5
%   How can you decide whether two people can marry, given the current
%   matrimonial ties ?

can_marry(A, B):-		% A can marry B if
    possible_to_marry(A, B),	% it is possible for A to marry B and
    \+ matrimonial_tie(A),	% there is no matrimonial tie for A and
    \+ matrimonial_tie(B).    	% there is no matrimonial tie for B.

matrimonial_tie(X):-	% X is matrimonially tied if
    married(X, _).	% X is married to somebody.

matrimonial_tie(X):-	% X is matrimonially tied if
    married(_, X).	% somebody is married to X.


%   FOOTNOTE
%   The symbol \== means "not the same as" (e.g. foo \== baz is true).
%   The symbol \+ means "not provable" (e.g. \+ false is always true).
%   The symbol _ represents an "anonymous variable" (i.e. a variable
%              for which there is no need for a particular name).
%   Comments are on lines beginning with %
%            or in sections bounded by /* and */


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