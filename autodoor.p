mtype = {CLOSED,OPENING,OPENED,CLOSING}
mtype = {PASSED,PASSING}
mtype = {TIME_SPEND, MAN_DETECT}

chan c = [0] of {mtype};

#define p ((doorState == OPENING))
#define q ((doorState == CLOSED) && (envState == PASSING))

mtype envState=PASSED;
mtype doorState = CLOSED;

active proctype Door() {
    mtype ev;
    do::
        c ? ev;
        if
        ::(doorState == CLOSED) && (ev == MAN_DETECT)->
            doorState = OPENING;
            printf("door=OPENING\n");
        ::(doorState == OPENING) && (ev == TIME_SPEND)->
            doorState = OPENED;
            printf("door=OPENED\n");
        ::(doorState == OPENED) && (ev == TIME_SPEND)->
            doorState = CLOSING;
            printf("door=CLOSING\n");
        ::(doorState == CLOSING) && (ev == TIME_SPEND)->
            doorState = CLOSED;
            printf("door=CLOSED\n");
        // ::(doorState == CLOSING) && (ev == MAN_DETECT)->
        //     doorState = OPENING;
        //     printf("door=OPENING\n");
        ::else ->
        fi
        //システムの状態遷移が終わった段階で状態をチェック
        assert(!((doorState == CLOSED)&&(envState == PASSING)));
    od
}

active proctype Env() {
    do
    ::(envState == PASSED) -> 
        if
        :: c ! TIME_SPEND;
        :: c ! MAN_DETECT;envState=PASSING;printf("env=PASSING\n");
        fi
    ::(envState == PASSING) ->
        c ! MAN_DETECT;
        c ! TIME_SPEND;
        if
        :: envState = PASSED;printf("env=PASSED\n");
        :: else ->
        fi
    od
}

// never  {    /* !([](p -> !<>q)) */
// T0_init:
// 	do
// 	:: atomic { ((p) && (q)) -> assert(!((p) && (q))) }
// 	:: ((p)) -> goto T0_S4
// 	:: (1) -> goto T0_init
// 	od;
// T0_S4:
// 	do
// 	:: atomic { ((q)) -> assert(!((q))) }
// 	:: (1) -> goto T0_S4
// 	od;
// accept_all:
// 	skip
// }

