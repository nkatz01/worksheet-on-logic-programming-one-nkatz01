parent(henry, bessy).
		parent(pam, bob).
		parent(tom,bob).
		parent(tom, liz).
		parent(bob,ann).
		parent(bob, pat).
		parent(pat, jim).
		parent(bob, peter).
		parent(peter,jim).

		predecessor(X,Z) :-parent(X,Z).
		predecessor(U,Z) :-parent(U,Y),predecessor(Y,Z).