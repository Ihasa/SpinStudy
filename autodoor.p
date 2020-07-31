mtype = {CLOSED,OPENING,OPENED,CLOSING}
mtype = {PASSED,PASSING}
mtype = {TIME_SPEND, MAN_DETECT}

chan c = [0] of {mtype};

#define p (envState == PASSING)
#define q (doorState == CLOSED)

mtype envState=PASSED;
mtype doorState = CLOSED;

active proctype Door() {
    mtype ev;
    do::
        c ? ev;
        if
        ::(doorState == CLOSED) && (ev == MAN_DETECT)->
            doorState = OPENING;
        ::(doorState == OPENING) && (ev == TIME_SPEND)->
            doorState = OPENED;
        ::(doorState == OPENED) && (ev == TIME_SPEND)->
            doorState = CLOSING;
        ::(doorState == CLOSING) && (ev == TIME_SPEND)->
            doorState = CLOSED;
//        ::(doorState == CLOSING) && (ev == MAN_DETECT)->
//            doorState = OPENING;
        ::else ->
        fi
    od
}

active proctype Env() {
    do
    ::(envState == PASSED) -> 
        if
        :: c ! TIME_SPEND;
        :: c ! MAN_DETECT;envState=PASSING;
        fi
    ::(envState == PASSING) ->
        c ! MAN_DETECT; 
        if
        :: c ! TIME_SPEND;
        :: envState = PASSED;
        fi
    od
}

never  {    /* !([](p -> !q)) */
T0_init:
	do
	:: atomic { ((p) && (q)) -> assert(!((p) && (q))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}