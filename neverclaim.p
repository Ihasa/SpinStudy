never  {    /* !([](p-><>q)) */
T0_init:
	do
	:: (! ((q)) && (p)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((q))) -> goto accept_S4
	od;
}
