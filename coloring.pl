  
border(r,g). border(r,b).
border(g,r). border(g,b).
border(b,r). border(b,g).
border(b,l).
coloring(L,TAA,V,FVG) :-
    border(L,TAA), %border(r,g)
    border(L,V), %border(r,b)
    border(TAA,V), %border(g,b)
    border(V,FVG),  FVG \= r, FVG \= g. %border(b,...)