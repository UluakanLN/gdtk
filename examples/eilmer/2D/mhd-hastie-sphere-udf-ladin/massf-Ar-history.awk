
# massf-Ar-history.awk

BEGIN {
    print "#t,ms massf-Ar"
}

$1 !="#"{
    t=$1; massfAr=$18
    print t*1000.0*1000,massfAr
}

END {}