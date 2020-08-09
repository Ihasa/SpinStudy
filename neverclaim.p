never  {    /* !([](p -> ((p U q) U r))) */
T0_init:
	do
	:: (! ((r)) && (p)) -> goto accept_S4
	:: (! ((q)) && ! ((r)) && (p)) -> goto accept_S13
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((r))) -> goto T0_S4
	:: (! ((q)) && ! ((r))) -> goto accept_S13
	:: atomic { (! ((p)) && ! ((q)) && ! ((r))) -> assert(!(! ((p)) && ! ((q)) && ! ((r)))) }
	od;
accept_S13:
	do
	:: (! ((q))) -> goto accept_S13
	:: atomic { (! ((p)) && ! ((q))) -> assert(!(! ((p)) && ! ((q)))) }
	od;
T0_S4:
	do
	:: (! ((r))) -> goto accept_S4
	:: (! ((q)) && ! ((r))) -> goto accept_S13
	:: atomic { (! ((p)) && ! ((q)) && ! ((r))) -> assert(!(! ((p)) && ! ((q)) && ! ((r)))) }
	od;
accept_all:
	skip
}
