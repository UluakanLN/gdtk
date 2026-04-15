
# massf-Ar+-history.awk

BEGIN {
    print "#t,ms massf-Ar+"
}

$1 !="#"{
    t=$1; massfArp=$19
    print t*1000.0*1000,massfArp
}

END {}