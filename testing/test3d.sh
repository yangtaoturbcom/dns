#/bin/csh -f

cd ../src
set refin=../testing/restart3d.inp
set makerefin=../testing/reference3d.inp
set refout=../testing/reference3d.out
set tmp=/tmp/temp.out

if ($#argv == 0 ) then
   echo "./test3d.sh [1,2,3,3p]"
   echo " 1 = run 2 (with and without restart) simple 3D test case"
   echo " g = run 1 simple 3D test case using dnsgrid"
   echo " 2 = run lots of 3D test cases (different dimensions)"
   echo " 3 = run several 3D test cases (different dimensions)"
   echo " 3p = run several 3D test cases in parallel (2 and 4 cpus)"
   echo " makeref  = generate new reference output, 3D"
   exit
endif

if ($1 == makeref) then

   ./gridsetup.py 1 1 1 32 32 32
   make ; rm -f $refout 
   ./dns < $makerefin > $refout
  cat $refout
  cd ../testing/3d
  mv reference3d0000.0000.u restart.u
  mv reference3d0000.0000.v restart.v
  mv reference3d0000.0000.w restart.w
  

endif

if ($1 == 1) then
./gridsetup.py 1 1 1 32 32 32
make >& /dev/null ;  rm -f $tmp ; ./dns < $refin > $tmp 
../testing/check.sh $tmp $refout

make >& /dev/null ;  rm -f $tmp ; ./dns < $makerefin > $tmp 
../testing/check.sh $tmp $refout

endif


if ($1 == g) then
./gridsetup.py 1 1 1 32 32 32
make dnsgrid >& /dev/null ;  rm -f $tmp ; ./dnsgrid < $refin > $tmp 
../testing/check.sh $tmp $refout

endif


if ($1 == 2) then

./gridsetup.py 1 1 1 32 32 32 2 2 0
make >& /dev/null ;  rm -f $tmp ; ./dns < $refin > $tmp 
../testing/check.sh $tmp $refout




endif
