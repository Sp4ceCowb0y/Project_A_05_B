#!/bin/bash

WORKDIR=$PWD

while true; do
  PS3='What do you want to do: '
  choices=("Create infra" "Create ebs volume" "Create infra and ebs volume and attach volume to infra" 
  "Create infra and reattach ebs volume" "Reattach ebs volume" "Destroy infra but preserve ebs volume"
  "Destroy ebs volume but preserve infra" "Destroy everything" "Quit")

  select choice in "${choices[@]}"; do
    case $choice in
        "Create infra")
            echo "$choice"

            cd "$WORKDIR/infra"
            terraform init
            terraform plan -out plan.terraform
            terraform apply plan.terraform
            cat "$WORKDIR/infra/backend.txt" > "$WORKDIR/infra/backend.tf"
            echo
            break
        ;;

        "Create ebs volume")
            echo "$choice"

            cd "$WORKDIR/ebs"
            terraform init
            terraform plan -out planebs.terraform
            terraform apply planebs.terraform
            echo
            break
        ;;

        "Create infra and ebs volume and attach volume to infra")
            echo "$choice"

            cd "$WORKDIR/infra"
            terraform init
            terraform plan -out plan.terraform
            terraform apply plan.terraform
            cat "$WORKDIR/infra/backend.txt" > "$WORKDIR/infra/backend.tf"

            cd "$WORKDIR/ebs"
            terraform init
            terraform plan -out planebs.terraform
            terraform apply planebs.terraform

            cd "$WORKDIR/ebs_attach"
            terraform init
            terraform destroy -auto-approve
            terraform plan -out planebsattach.terraform
            terraform apply planebsattach.terraform
            echo
	        break
        ;;

        "Create infra and reattach ebs volume")
            echo "$choice"

            cd "$WORKDIR/infra"
            terraform init
            terraform plan -out plan.terraform
            terraform apply plan.terraform
            cat "$WORKDIR/infra/backend.txt" > "$WORKDIR/infra/backend.tf"

            cd "$WORKDIR/ebs_attach"
            terraform destroy -auto-approve
            terraform plan -out planebsattach.terraform
            terraform apply planebsattach.terraform
            echo
            break
        ;;

        "Reattach ebs volume")
            echo "$choice"

            cd "$WORKDIR/ebs_attach"
            terraform destroy -auto-approve
            terraform plan -out planebsattach.terraform
            terraform apply planebsattach.terraform
            echo
            break
        ;;

        "Destroy infra but preserve ebs volume")
            echo "$choice"

            cd "$WORKDIR/infra"
            terraform destroy -auto-approve
            echo
            break
        ;;

        "Destroy ebs volume but preserve infra")
            echo "$choice"

            cd "$WORKDIR/ebs"
            terraform destroy -auto-approve
            echo
            break
        ;;

        "Destroy everything")
            echo "$choice"

            cd "$WORKDIR/infra"
            terraform destroy -auto-approve

            cd "$WORKDIR/ebs"
            terraform destroy -auto-approve
            echo
            break
        ;;

        "Reattach ebs volume")
            echo "$choice"

            cd "$WORKDIR/ebs_attach"
            terraform destroy -auto-approve
            terraform plan -out planebsattach.terraform
            terraform apply planebsattach.terraform
            echo
            break
        ;;

	    "Quit")
	        echo "Quitting..."
	        exit
	    ;;

        *) echo "invalid option $REPLY";;
    esac
  done
done