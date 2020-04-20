#define NBUF 2

mtype = {msg, ack};

chan to_sndr = [NBUF] of {mtype, bit};  /* bitは型名だったはず */
chan to_rcvr = [NBUF] of {mtype, bit};  /* bitは型名だったはず */

active proctype Sender(){
    bit x, y;
    do
    :: to_rcvr ! msg(x);
        to_sndr ? ack(y);
        if
        :: (x == y) -> x = 1-x; printf("msg ok\n")/* bit反転 */
        :: else printf("msg retry\n");assert(false);/* no op */
        fi
    od
}

active proctype Receiver(){
    bit y = 1;
    do
    :: to_rcvr ? msg(y) -> to_sndr ! ack(y)
    :: timeout          -> to_sndr ! ack(y)
    od
}

active proctype Daemon(){
    do
    :: to_rcvr ? _,_;printf("msg lost!\n");
    od 
}
