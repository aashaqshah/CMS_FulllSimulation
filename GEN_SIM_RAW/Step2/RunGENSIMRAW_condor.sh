#!/bin/bash
cd /uscms_data/d3/rasharma/aQGC_analysis/CMS_FulllSimulation_April2017/LHE_GEN/CMSSW_8_0_21/src
echo $PWD
eval `scram runtime -sh`
cd -
echo $PWD
a=$PWD
echo $a
b=$(echo $a | perl -pe 's/\//\\\//g')
echo $b
cmsRun SMP-RunIISummer16DR80Premix-00158_2_cfg.py $*
echo "List all root files = "
ls *.root
echo "List all files"
ls 
echo "+=============================="

# copy output to eos
#OUTDIR=root://cmseos.fnal.gov//store/user/lnujj/WpWm_aQGC_Ntuples_Ram/condor_test/
#OUTDIR=root://cmseos.fnal.gov//store/user/rasharma/condortest/
OUTDIR=root://cmseos.fnal.gov//store/user/rasharma/CMSSW_FullSimulation_April2017/New_21May2017/GEN_SIM_RAW_Step2/WPlepWMhadJJ_EWK_LO_aQGC-FT-FS-FM_mjj100VJpT10_Pythia8CUEP8M1_13TeV_Madgraph_ext1/
echo "xrdcp output for condor"
for FILE in *.root
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