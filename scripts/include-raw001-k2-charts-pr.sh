# collect chart folders
CHARTS=$(ls -dm */ | sed 's/,//g' | sed 's/cnct-atlas//g' | sed 's/\///g')

for chart in ${CHARTS};
do 
  docker run \
    --volumes-from=jenkins \
    quay.io/samsung_cnct/k2:latest helm lint ${WORKSPACE}/$chart || { echo "chart $chart failed linter"; exit 1; }
done