chan c1 = [0] of {byte, byte};

typedef MyVector {
    byte val1;
    byte val2;
} ;
chan c2 = [0] of {MyVector};

active proctype proc1(){
    byte val1=10, val2=200;
    MyVector vec;
    vec.val1 = 20;
    vec.val2 = 100;
    do::
        c1 ! val1,val2;
        c2 ! vec;
    od
}

active proctype proc2(){
    byte val1,val2;
    do::
        c1 ? val1,val2;
        printf("proc2:%d, %d\n", val1, val2);
    od
}

active proctype proc3(){
    MyVector vec;
    do::
        c2 ? vec;
        printf("proc3:%d, %d\n", vec.val1, vec.val2);
    od
}
