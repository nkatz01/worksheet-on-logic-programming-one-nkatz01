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




%a) Which messages can Fred see (assuming that only direct followers will see a message)?

	
	%helper function (can also be used on its own but prints out different solutions on request only - though works for any X).
	canReadMsg(X,Y) :- follows(X,Z),tweeted(Z,Y).

	%helper function. 
	%Given a specified X, you get back X's name together with a 'list' of all tweets (from all solutions combined) they can see. (Note, you cannot ask for multiple solutions with a 'variable' X.)
	listAllMsgForPerson(X,[X|[AllMsgs]]):- tweeted(X,M), %they can for sure see their own tweets.
	  listAll(X,[M],AllMsg),flatten(AllMsg,AllMsgs).
	  
	%includes cut and base is after recurseive call   
	listAll(X,Acc,Result) :- 
	canReadMsg(X,Res), \+member(Res,Acc), Acc\=Res, listAll(X,[Res|Acc],Result),!.
	listAll(X,Acc,Acc).
	
%b) Find all the persons who are friends, i.e., they follow each other.
	
	%sorts the resutls so that it cann be asymmetrically identical results can later be romved by setof called in listAllMutuals.
	mutual(Results) :- follows(X,Y), follows(Y,X),sort([X,Y],Results).

	listAllMutuals(List) :- setof(Pair, mutual(Pair),List).


%c) 
listEveryones(Results):- findall(Tweets, listAllMsgForPerson(X,Tweets),Results).

%9 d) 
%find all possible combinations of tweets X may see and return them as a lists with their duplicates removed.
ifEveryoneRetweets(X,Results) :- findall(Res, helperRetweets(X,Res),List), flatten(List,Ls), sort(Ls,Results). 
helperRetweets(X,Res) :- retweets(X,[],Res,Accu).%optionally a list of the people-chain can be retreived.

%X, the last person in the chian, Acc to aggregate the people processed so far, then a list of messages, then the results of all people aggregated.
%covers 3 cases, X follows noone, then take their tweet (and put X into Accu); X follows someone but someone follows noone, then take someone's tweet; X follows someone but someone has already been processed (loop), then take just X's tweet.
retweets(X,Acc,[M],Accu) :- \+follows(X,_),tweeted(X,M),Accu = [X|Acc];follows(X,Y),\+follows(Y,_),tweeted(Y,M),Accu = [Y|Acc];follows(X,Y),follows(Y,_),member(Y,Acc),tweeted(X,M),Accu = [X|Acc].

%if X follows someone, recourse on someone, provided they're not in the list already and append X to Acc; after returning, take X's tweet and append to list together with the tweet returned from Y.
retweets(X,Acc,[M|T],Accu) :-  follows(X,Y), \+member(Y,Acc),retweets(Y,[X|Acc],T,Accu),tweeted(X,M).

%10
add_up_list(L,K):- reverse(L,Ls), add_up_list_h(Ls, Res), reverse(Res,K).  

add_up_list_h([],[]). 
add_up_list_h([H|T],[Ttl|Newtail]) :-  sum_list(T,Sumrest), Ttl is H+Sumrest, add_up_list_h(T,Newtail).

%11, & 12
scotish(malcom).
french(claude).
walse(owen).
'northern irland'(sean).
english(nigel).

cricket(john).
checs(owen).
rugby(malcom).
football(claude).
football(nigel).

british(john). 
british(X) :- english(X); 'northern irland'(X); scotish(X); walse(X).
%alternatively, we can delete one before the previous line and include in the previous line ;X=john	 as an option .

sportsman(X) :- cricket(X); football(X); rugby(X).

%a) 
	%from the console ->  ?- sportsman(owen). 


	allBritishSportsman(Acc):- findall(X,(british(X)),List), britishSportsman([],List,Acc).
	britishSportsman(Acc,[],Acc).
	britishSportsman(Acc,[H|T],Res) :- sportsman(H), britishSportsman([H|Acc],T, Res).
	britishSportsman(Acc,[H|T],Res) :- \+sportsman(H), britishSportsman(Acc,T, Res). 

	%alternatively and more succinct, we can acheive it this way:

	allBritishSportsman(Res):- british(Y), sportsman(Y) ,britishSportsman([Y],Acc, Res),!.

	britishSportsman(Acc,Y, Res) :- british(X), sportsman(X), \+member(X,Acc), britishSportsman([X|Acc], X, Res).
	britishSportsman(Acc,Y,Acc) :- british(X), sportsman(X), member(X,Acc) .


%b) list all nationalities (but English and British are reapeted, hence the alternative solution).
	/*sitizan(nationality(scotish,malcom)).
	sitizan(nationality(french,claude)).
	sitizan(nationality(walse,owen)).
	sitizan(nationality('northern irland',sean)).
	sitizan(nationality(english,nigel)).
	sitizan(nationality(british,john)). 
	sitizan(nationality(british,X)) :- sitizan(nationality(english,X)); sitizan(nationality('northern irland',X)); sitizan(nationality(scotish,X)); sitizan(nationality(walse,X)).
	sportsman(X) :- cricket(X); football(X); rugby(X).
		
	?- football(X),sitizan(Y), Y = nationality(Z,X). %from the console
	 
	allFootballerNation(Res):- football(X),sitizan(Y), Y = nationality(Z,X) ,footballerNation([Z],Acc, Res),!.

	footballerNation(Acc,placeHolder, Res) :- football(X),sitizan(Y), Y = nationality(Z,X) , \+member(Z,Acc), footballerNation([Z|Acc], P, Res).
	footballerNation(Acc,placeHolder,Acc) :- football(X),sitizan(Y), Y = nationality(Z,X) ,  member(Z,Acc)  .
	*/

	%(This uses pairs to clear symantic dups (in our case, whoever is British is also English) by also processing name and removing those nationalities where the name is the same.
	%Must use swish.
	
	allFootballerNation(Results):- football(X),sitizan(Y), Y = nationality(Z,X) ,footballerNation([[X-Z]],Acc, Res),flatten(Res,Resu), sort(1, @<, Resu, Results),!.

	footballerNation(Acc,placeHolder, Res) :- football(X),sitizan(Y), Y = nationality(Z,X) , \+member([X-Z],Acc), footballerNation([[X-Z]|Acc], P, Res).
	footballerNation(Acc,placeHolder,Acc) :- football(X),sitizan(Y), Y = nationality(Z,X) ,  member([X-Z],Acc).

%13
	merge(L,K,Results) :- append(L,K,Res), sort(Res,Results).
	
%14
	mygcd(A,0,A).
	mygcd(A,B,Y) :- A > B, Newb is A mod B , mygcd(B,Newb,Y),!.
	mygcd(A,B,Y) :- Newb is B mod A , mygcd(A,Newb,Y).
	
%15 a)
node(N,[],[]).
node(N,L,[]).
node(N,[],R).
node(N,L,R).

getValue(T,[V]) :- T = node(V,[],[]).
getValue(T,[V|NewV]) :- T = node(V,L,[]), getValue(L,NewV).
getValue(T,Results) :- T = node(V,L,R), R\=[], L\=[], getValue(L,Lval), getValue(R,Rval), Res = [Rval,Lval|V], flatten(Res,Results).
getValue(T,[V|NewV]) :- T = node(V,[],R), getValue(R,NewV). 


/*Additional testing:
testNode(Tree) :- A = node(3,[],[]), C = node(4,[],[]), B = node(2,A,C),  X = node(6,[],[]) , Z = node(7,[],[]), Y = node(5,X,Z), Tree = node(1,B,Y).
preOrderTest(List) :- testNode(Tree), getValue(Tree,Ls), reverse(Ls,List).*/
%Answer:

preOrder(Tree,List) :- getValue(Tree,L),reverse(L,Lst1),  List = Lst1.
preOrderTest :- A = node(10,[],[]), C = node(8,[],[]), B = node(7,A,C),  X = node(9,[],[]) , Z = node(11,[],[]), Y = node(55,X,Z), Tree = node(0,B,Y), preOrder(Tree ,[0,7,10,8,55,9,11]) .

%b)
jstReturn(E,E).
search_tree(L,Tree):- sort(L,Ls), map_list_to_pairs(jstReturn, Ls, Pairlst),list_to_assoc(Pairlst,Tree).