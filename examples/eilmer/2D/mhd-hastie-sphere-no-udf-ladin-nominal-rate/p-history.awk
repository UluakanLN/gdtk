
# p-history.awk

BEGIN {
    print "#t,ms p"
}

$1 !="#"{
    t=$1; p=$10
    print t*1000.0*1000,p*0.001
}

END {}