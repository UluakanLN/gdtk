
# massf-e-history.awk

BEGIN {
    print "#t,ms massf-e"
}

$1 !="#"{
    t=$1; massfe=$20
    print t*1000.0*1000,massfe
}

END {}