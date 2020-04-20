/* プリンタとスキャナ */

mtype = {Get, Put};
chan to_pr = [0] of {mtype};
chan to_sc = [0] of {mtype};

/* 資源を表すプロセス(プリンタ・スキャナ共用) */
proctype Target(chan c){ /* 引数付きプロセス */
    do
    /* 資源取得したら解放をまつ　の繰り返し */
    :: c?Get -> c?Put
    od
}

/* 利用者 プリンタを先に確保する */
proctype P(){
    do
    ::  to_pr!Get; 
        if
        ::  to_sc!Get->
            progress:   /* 進行性解析のためのラベル */
                /* 常に通過してほしいところに置く */
                /* progressを接頭辞とした任意の文字列 */
                /* 検証器はループ解析なるものを行い、 */
                /* このラベルが含まれないような状態遷移ループを検出してエラーとする */
                /* 複数のラベルを置いた場合、論理和になる */
                /* 言い換えると「どれか1つのprogressラベルさえ通れば、エラー発生なしとする」ということ */
            skip;
            to_pr!Put;to_sc!Put;
        ::  timeout -> to_pr!Put
        fi
    od 
}

/* 利用者 スキャナを先に確保する */
proctype Q(){
    do
    :: to_sc!Get; to_pr!Get->
    /* progress: */ /* これを書いてしまうとライブロックが検知できなくなる */
                    /* Qが実行し続けるループは正としてしまうため */
    skip;
    to_pr!Put;to_sc!Put;
    od 
}

/* 初期化 */
init {
    /* 初期化中に勝手にプロセスが動き出さないようにatomicで囲む */
    atomic{
        /* プリンタとスキャナを用意 */
        run Target(to_pr); run Target(to_sc);
        /* PとQがプリンタとスキャナを利用する */
        /* Promelaのif文は、ちょっと/特殊なswitch文のイメージ */
        /* 同時に複数のcase文がtrueになった場合、そのうちのどれかが非決定的に選ばれる */
        /* シミュレーションなら、どちらが実行されるかわからない */
        /* 網羅検査なら、両方の可能性が検査される */
        if
        :: run P(); run Q()
        :: run Q(); run P()
        fi
    }
}

