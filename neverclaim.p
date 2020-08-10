never  {    /* !([](s -> !(t && u))) */
T0_init:
	do
	:: atomic { ((s) && (t && u)) -> assert(!((s) && (t && u))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
