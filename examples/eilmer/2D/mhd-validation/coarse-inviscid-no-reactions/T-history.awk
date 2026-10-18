
# T-history.awk

BEGIN {
    print "#t,ms t, T, K"
}

$1 !="#"{
    t=$1; T=$23
    print t*1000.0*1000,T
}

END {}