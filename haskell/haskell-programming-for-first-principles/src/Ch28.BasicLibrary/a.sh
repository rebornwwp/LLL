# build
stack ghc -- -prof -fprof-auto -rtsopts -O2 a.hs

#  turn on profile
# time
./a +RTS -P

cat a.prof

# profiling heap usage
./a +RTS -hc -P
