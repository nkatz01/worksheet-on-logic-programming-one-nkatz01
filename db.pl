:- dynamic(father/2).
:- dynamic(likes/2).
:- dynamic(friend/2).
:- dynamic(stabs/3).

%father(lord_montague, romeo).
%father(lord_capulet, juliet).


likes(mercutio, dancing).
likes(benvolio, dancing).
likes(juliet, romeo).
likes(romeo, juliet).
likes(juliet, dancing).
likes(romeo, dancing).


friend(romeo, marcutio).
friend(romeo , benvolio).

stabs(tybalt, mercutio, sword).
stabs(romeo, tybalt, sword).
hates(romeo, X) :- stabs(X, mercutio, sword). 

happy(albert).
happy(alice).
happy(bob).
happy(bill).
with_albert(alice).
 
runs(albert) :- happy(albert).

dances(alice) :- happy(alice), with_albert(alice).
does_alice_dance :- dances(alice), write('when alice is happy and with albert she dances').

swims(bob) :- happy(bob), near_water(bob).
swims(bob) :- happy(bob).

female(alice).
female(betsy).
female(diana).
female(lizzy).

parent(albert, bob).
parent(albert, betsy).
parent(albert, bill).


parent(alice, bob).
parent(alice, betsy).
parent(alice, bill).

parent(bob, carl).
parent(bob, charlie).

parent(carl, benny).

 
get_leafChild(Z,Y)  :- parent(Z,X), \+parent(X,Y).

get_grandchildren(Z,Y)  :- parent(Z,X),parent(X,Y); get_grandchildren(X,V).
get_grandchildren(Z,Y)  :- parent(Z,X), \+parent(X,Y), fail. 




% get_leafChild(Z,Y); get_grandchildren(

% parent(Z, X),parent(X,Y),get_grandchild



get_grandparent(Z,Y) :- parent(X,Z),
parent(Y,X).

father(albert, bob).
father(albert, bill).

father(bob, carl).
father(bill, rupart).

father(rupart, jack).
father(jack, jim).

father(carl, benny).
father(carl, lizzy).

father(benny, gabe).
father(lizzy, frank).

father(gabe, gideon).


commonAncestor(X,Y) :- descendent(X,Z), descendent(Y,Z).

brother(X,Y) :- father(Z,X), father(Z,Y), \+female(X), \+female(Y).

cousin(X,Y) :- descendent(X,Z), descendent(Y,Z), \+commonAncestor(Z,Y), \+commonAncestor(Z,X) , \+ descendent(X,Y), \+ descendent(Y,X), \+brother(X,Y), X \= Y.
/*
is_grandson(X,Y) :- father(Y, Z),
father(Z,X).

is_descendent(X,Y) :- father(Y,X); is_grandson(X,Y);
is_grandson(X,Z), is_descendent(Z,Y).
*/
grandson(X,Y) :- father(Y, Z),
father(Z,X), \+female(X).

descendent(X,Y) :- father(Y,X);
father(Y,Z), descendent(X,Z).



has_uncle(Z) :- parent(X,Z), brother(Y,X); brother(X,Y), write(Y).

related(X,Y) :- parent(X,Y); parent(Y,X).
related(X,Y) :- parent(X,Z), related(Z,Y) ; parent(Y,Z), related(Z,X).
%write(Z), nl.




warm_blooded(penguin).
warm_blooded(human).

produce_milk(penguin).
produce_milk(human).

have_feahers(penguin).
have_hair(human).

mammal(X) :- warm_blooded(X), produce_milk(X), have_hair(X).

say_hi :- 
write('What is your name? '), read(X), write('HI '),write(X).

write_to_file(File, Text) :- open(File, write, Stream),
write(Stream, Text), nl,
close(Stream).

read_file(File):- open(File, read, Stream), get_char(Stream, Char1),
process_stream(Char1,Stream), 
close(Stream).

process_stream(end_of_file, _) :- !.

process_stream(Char, Stream) :-
write(Char),
get_char(Stream, Char2),
process_stream(Char2, Stream).

count_to_10(10) :- write(10) ,!.

count_to_10(X) :- write(X), nl, Y is X + 1,  count_to_10(Y).

guess_num :- loop(start).
loop(15) :- write('You guessed it').

loop(start) :- write('guess number'), read(X),loop(X).

loop(X) :-
write(X), write(' is not the number'),
write('Guess number'),
read(Guess),
loop(Guess).

write_list([]).

write_list([Kupff|Schwantz]) :-
	write(Kupff), nl, write_list(Schwantz).
	
concat_list([],L, L).

concat_list([H|T], Listb, [H|Res]) :- concat_list(T,Listb,Res).



