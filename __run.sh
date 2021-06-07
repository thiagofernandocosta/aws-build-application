#!/bin/bash

source __variables.sh;
source __solution.sh;

case $1 in

  solution1)
    SOLUTION="01"
    OPERATION=$2
    execute $SOLUTION $OPERATION $AWS_ACCOUNT_ID $AWS_DEFAULT_REGION $APPLICATION_NAME $TAG
    ;;

  solution2)
    SOLUTION="02"
    OPERATION="$2"
    execute $SOLUTION $OPERATION $AWS_ACCOUNT_ID $AWS_DEFAULT_REGION $APPLICATION_NAME $TAG
    ;;

  *)
    echo -n "unknown"
    ;;
esac