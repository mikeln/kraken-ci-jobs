#!/bin/bash
pod_densities="${DENSITIES%\"}"
pod_densities="${pod_densities#\"}"

for i in $pod_densities; do
  echo "\"DENSITY\"=\"$i\"" > density_$i.property
done