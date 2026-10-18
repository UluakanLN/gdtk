
# Tev-history.awk

BEGIN {
    print "#t,ms t, Tev, K"
}

$1 !="#"{
    t=$1; Tev=$25
    print t*1000.0*1000,Tev
}

END {}