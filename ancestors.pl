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

parent(henry, bessy).
parent(clive, dave).
parent(gene,betty).
parent(alan, clive).
parent(jake,alan).
parent(freda, greta).
parent(clarissa, dave).
parent(andrea, clive).
parent(clive, doris).
parent(greg, henry).
parent(clarissa, doris).
parent(betty, clarissa).
parent(eddie, greg).
parent(greta, henry).
parent(elsie, greg).
parent(bruce, clarissa).
parent(fred, greta).
parent(doris,bobby).
parent(richard,bobby).
parent(chirs,richard).
parent(roger,richard).



ancestor(A, B):-	% A is B's ancestor if
    parent(A, B).% A is B's parent	

ancestor(A, B):-
	 
	write(' in second ancestor'),nl,
    parent(P, B),	 
    ancestor(A, P).

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


factorial(0, 1).
factorial(N, NFact) :-
    N > 0,
    Nminus1 is N - 1,
    factorial(Nminus1, Nminus1Fact),
    NFact is Nminus1Fact * N.
	
	
fun(X) :-              /* fun if .... */   
                    
        red(X),        /* red */                    


        car(X).            /* and a car */      

       
fun(X) :-              /* or its fun if its.... */    


        blue(X),           /* blue */                   


        bike(X).           /* and a bike */              




/* database of red  & blue items */

red(cricket_ball).              
red(my_hat).                      
red(car_27).                    
blue(cheese). 
blue(raleigh).                                
blue(honda).  
/* database of cars  and bikes*/             


car(peugot).    
car(rover).   
 bike(yamaha).           
 bike(raleigh).
 bike(honda).    