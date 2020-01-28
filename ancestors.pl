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

%empty_assoc(Assoc).

jstReturn(E,E).
search_tree(L,Tree):- sort(L,Ls), map_list_to_pairs(jstReturn, Ls, Pairlst),list_to_assoc(Pairlst,Tree).	


node(N,[],[]).
node(N,L,[]).
node(N,[],R).
node(N,L,R).


getValue(T,[V]) :- T = node(V,[],[]).
getValue(T,[V|NewV]) :- T = node(V,L,[]), getValue(L,NewV).
getValue(T,Results) :- T = node(V,L,R), R\=[], L\=[], getValue(L,Lval), getValue(R,Rval), Res = [Rval,Lval|V], flatten(Res,Results).
getValue(T,[V|NewV]) :- T = node(V,[],R), getValue(R,NewV). 


testNode(Tree) :- A = node(3,[],[]), C = node(4,[],[]), B = node(2,A,C),  X = node(6,[],[]) , Z = node(7,[],[]), Y = node(5,X,Z), Tree = node(1,B,Y).
preOrderTest(List) :- testNode(Tree), getValue(Tree,Ls), reverse(Ls,List).

preOrder(Tree,List) :- getValue(Tree,L),reverse(L,Lst1),  List = Lst1.
preOrderTest :- A = node(10,[],[]), C = node(8,[],[]), B = node(7,A,C),  X = node(9,[],[]) , Z = node(11,[],[]), Y = node(55,X,Z), Tree = node(0,B,Y), preOrder(Tree ,[0,7,10,8,55,9,11]) .

%getValue(node(2,[],node(1,[],[])),V).
 %getValue(node(2, node(1,[],[]),[]),V).
 %getValue(	node(2,node(1,[],[]), node(3,[],[])),V	).
 %getValue(	node(1,node(1,[],[]), node(1,[],[])),V	).
 /*
  node(4, node(2, node(1, [], []), node(3, [], [])), node(5, node(6, [], []),[])).
  
    node(4, node(2, node(1, [], []), node(3, [], [])), node(5, node(6, [], []), node(7, [], []))).


 getValue(T,[V]) :- T = node(V,[],[]).
getValue(T,[V|NewV]) :- T = node(V,L,[]), getValue(L,NewV).

getValue(T,[V|NewV]) :- T = node(V,L,R), R\=[], getValue(L,NewV). 

getValue(T,[V|NewV]) :- T = node(V,L,R), L\=[], getValue(R,NewV).

getValue(T,[V|NewV]) :- T = node(V,[],R), getValue(R,NewV).  
 
 
	 bothChildren(4,
		bothChildren(2, 												bothChildren(6, 
			childless(1, nill, nill), 	childless(3, nill, nill)),	 						childless(5, nill, nill), 	childless(7, nill, nill))),

isEmpty(T) :- T = emptybt.
isLeaf(T) :- 
addNodeL
preorder(T,L) :- 

getNode(T,Tr) :-
getNode(T,Tr) :- X = bothChildren(_,Tr,childless).
getValue(T,V) :- T = leftChild(V,nill, nill);childless(V,nill, nill);rightChild(V,nill, nill).
%getValue(T,V) :- T = bothChildren(_,bothChildren(V,_,_),_).


childless(V,nill, nill).
rightChild(V,nill, childless).
leftChild(V,childless, nill).
bothChildren(V,childless,childless).

myen(V,X) :- X = childless(V,nill,nill).
myrc(T,V,X):- X = rightChild(V,nill,T).
mylc(T,V,X):- X = leftChild(V,T, nill).
mybc(V,LT,RT,X) :- X = bothChildren(V,LT,RT).
testTree(Tree) :- myen(1,A), myen(3,C), mybc(2,A,C,B), myen(5,X), myen(7,Z), mybc(6,X,Z,Y),  mybc(4,B,Y,Tree).


mkPair([],[]).
mkPair([T|H],[Res-Res]) :- mkPair(T,Res)
 t(t4, f, <, t
 (t2, d, <, 											t(t6, g, -, 
	t(t1, b, <,                                         	t(t5, c, -, t, t), 	t(t7, h, -, t, t))).
		t(n, a, -, t, t), t), 	t(t3, e, -, t, t)), 		
	[1,2,3,4,5,6,7]	
 	list_to_assoc([n-a, t1-b,t2-d,t3-e,t4-f,t5-c,t6-g,t7-h], Assoc)

emptybt(L,[]).
consbt(N,T1,T2).
T1(1,T3,T4).
T2(2,T5,T6).

Difficult
Consider a representation of binary trees as terms, as follows:

emptybt is the empty binary tree.
consbt(N,T1,T2) the binary tree with root N and left and right subtrees, T1 and T2.
a) Define a predicate preorder(T,L) which holds iff L is the list of nodes produced by the preorder traversal of the binary tree T.
b) Define a predicate search_tree(L,T) which, given a list of integers L, returns a balanced search-tree T containing the elements of L.
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