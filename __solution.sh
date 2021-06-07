#!/bin/bash

# set -ex

array=("apply" "destroy" "output" "plan")

execute(){
    export TF_VAR_account_id=$3
    export TF_VAR_region=$4
    export TF_VAR_application=$5
    export TF_VAR_tag=$6
    
    # Here we're applying first solution - ec2 instance
    echo "Applying first solution..."
    echo "Exporting TFVARS to terraform use as variables"

    if [[ "${array[@]}" =~ "$2" ]]; then
        (cd $1__solution ; terraform init ; terraform $2)
    else
        echo "Not valid parameter: $2. Use one of them: ${array[@]}"
        exit 0
    fi

    unset_vars
}

unset_vars() {
    unset TF_VAR_account_id
    unset TF_VAR_region
    unset TF_VAR_application
    unset TF_VAR_tag
}