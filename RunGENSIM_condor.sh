#!/bin/bash
echo "Starting job on " `date`
echo "Running on: `uname -a`"
echo "System software: `cat /etc/redhat-release`"
source /cvmfs/cms.cern.ch/cmsset_default.sh

### copy CMSSW tar file from store area 
###xrdcp -s root://cmseos.fnal.gov//store/user/rasharma/aashaqTemp/CMS_FulllSimulation.tar .
xrdcp -s root://cmseos.fnal.gov//store/user/ashah/aashaqTemp_94X/CMS_FulllSimulation_94X.tar .
tar -xf CMS_FulllSimulation_94X.tar 
rm CMS_FulllSimulation_94X.tar 
cd CMS_FulllSimulation_94X
echo "======="
ls
echo "======"

# copy gridpack in pwd
#xrdcp -s root://cmseos.fnal.gov//store/user/rasharma/aashaqTemp/ggh01_M125_Toa01a01_M20_Tomumubb_slc6_amd64_gcc481_CMSSW_7_1_30_tarball.tar.xz .
xrdcp -f root://cmseos.fnal.gov//store/user/ashah/FullSimulation/$2 .

echo $PWD
eval `scramv1 project CMSSW CMSSW_9_3_6_patch2`
cd CMSSW_9_3_6_patch2/src/
# set cmssw environment
eval `scram runtime -sh`
cd -

echo "========================="
echo "==========aashaqPATH is=="
a=$PWD
echo $a
b=$(echo $a/$2 | perl -pe 's/\//\\\//g')
echo $b

perl -pe "s/AASHAQ/"$4"/g" run_generic_tarball_cvmfs.sh.bkup > run_generic_tarball_cvmfs.sh 
echo "===================="
cat run_generic_tarball_cvmfs.sh
echo "===================="

perl -pe "s/aashaqPATH/"$b"/g" HIG-RunIIFall17wmLHEGS-01377_1_cfg.py.bkup > HIG-RunIIFall17wmLHEGS-01377_1_cfg.py 

echo "========================="
echo "==========aashaqPATH is=="
echo $aashaqPATH
echo "========================="
echo $PWD
echo "========================="
cat HIG-RunIIFall17wmLHEGS-01377_1_cfg.py
echo "========================="
echo "========================="
echo "========================="
echo "========================="
cmsRun HIG-RunIIFall17wmLHEGS-01377_1_cfg.py $1
echo "List all root files = "
ls *.root
echo "List all files"
ls 
OUTDIR=root://cmseos.fnal.gov//store/user/ashah/FullSimulation/$3/
echo "xrdcp output for condor"
for FILE in *inLHE*.root
do
  echo "xrdcp -f ${FILE} ${OUTDIR}/${FILE}"
  xrdcp -f ${FILE} ${OUTDIR}/${FILE} 2>&1
  XRDEXIT=$?
  if [[ $XRDEXIT -ne 0 ]]; then
    rm *.root
    echo "exit code $XRDEXIT, failure in xrdcp"
    exit $XRDEXIT
  fi
  rm ${FILE}
done
#date
#echo "+=============================="
#
#echo "Loading CMSSW env"
#
## as LHE and DR/MINIAOD are in different CMSSW reelase so change CMSSW environment
#eval `scramv1 project CMSSW CMSSW_9_4_6_patch1`
#cd CMSSW_9_4_6_patch1/src
#echo $PWD
#eval `scram runtime -sh`
#cd -
#cmsRun HIG-RunIIFall17DRPremix-01966_1_cfg.py $1
#cmsRun HIG-RunIIFall17DRPremix-01966_2_cfg.py $1
#cmsRun HIG-RunIIFall17MiniAODv2-01265_1_cfg.py $1
#echo "List all root files = "
#ls *.root
#echo "List all files"
#ls 
#echo "+=============================="
#
## copy output to eos
#OUTDIR=root://cmseos.fnal.gov//store/user/ashah/FullSimulation/$3/
#echo "xrdcp output for condor"
#for FILE in HIG-RunIIFall17MiniAODv2*.root 
##for FILE in HIG-RunIISummer16MiniAODv2-*.root 
#do
#  echo "xrdcp -f ${FILE} ${OUTDIR}/${FILE}"
#  xrdcp -f ${FILE} ${OUTDIR}/${FILE} 2>&1
#  XRDEXIT=$?
#  if [[ $XRDEXIT -ne 0 ]]; then
#    rm *.root
#    echo "exit code $XRDEXIT, failure in xrdcp"
#    exit $XRDEXIT
#  fi
#  rm ${FILE}
#done
#date
