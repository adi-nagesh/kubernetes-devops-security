#!/bin/bash 
#cis-master.sh

total_fail $(kube-bench run --targets node   --check 4.2.1,4.2.2 --json | jq .Totals.total_fail)
if [["$total_fail" -ne 0]];
      then 
           echo "CIS benchmark failed node  while testing for 4.2.1,4.2.2"
           exit 1;
      else
           echo "CIS Benchmark Passed  for node 4.2.1,4.2.2"
fi; 