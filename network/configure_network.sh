#!/bin/bash

# ~~~~~~~~~ INFO ~~~~~~~~~~~~ #
#	Author: Ali Foroughi
#	Email: <ali.foroughi92@gmail.com
# ~~~~~~~~~~~~~~~~~~~~~~~~~~ #

### Configure these values: 
OM_GW=172.17.95.254
S1MME_GW=172.17.80.193
S11_GW=172.17.56.33
DB_GW=172.17.88.193


echo -e "\nPlease verify the information: \nOM GW: $OM_GW \nS1MME GW: $S1MME_GW \nS11 GW: $S11_GW \nDB GW: $DB_GW\n"
read -e -p "Contiue? (y/n): " INFO_VERIFY

if [ $INFO_VERIFY == "n" ]
then
    echo "Canceling configuration. Exiting"
    exit 0
fi

echo "[mme]" > inventory.txt

# Extract MME names and insert them in the inventory file
while read MME; do
MME_NAME=$(echo $MME | cut -d " " -f 1)
echo $MME_NAME >> inventory.txt
done < mme_names.txt

# Extract IPs from the text file and insert them as the variables for hosts

while read LINE; do

MME_NAME=$(echo $LINE | cut -d " " -f 1)
OM_IP=$(echo $LINE | cut -d " " -f 2)
S1MME_IP=$(echo $LINE | cut -d " " -f 3)
ROUTING_RULES=$(echo $LINE | cut -d " " -f 3 | cut -d "/" -f 1)
S11_IP=$(echo $LINE | cut -d " " -f 4)
DB_IP=$(echo $LINE | cut -d " " -f 5)

echo "om: $OM_IP" > host_vars/$MME_NAME
echo "om_gw: $OM_GW" >> host_vars/$MME_NAME
echo "om_if: ens8" >> host_vars/$MME_NAME

echo "s1mme: $S1MME_IP" >> host_vars/$MME_NAME
echo "s1mme_gw: $S1MME_GW" >> host_vars/$MME_NAME
echo "s1mme_if: ens9" >> host_vars/$MME_NAME

echo "s11: $S11_IP" >> host_vars/$MME_NAME 
echo "s11_gw: $S11_GW" >> host_vars/$MME_NAME
echo "s11_if: ens10" >> host_vars/$MME_NAME


echo "db: $DB_IP" >> host_vars/$MME_NAME 
echo "db_gw: $DB_GW" >> host_vars/$MME_NAME
echo "db_if: ens11" >> host_vars/$MME_NAME

echo 'routing_rules4: "from ROUTING_RULES priority 5 table 2"' >> host_vars/$MME_NAME
sed -i 's/ROUTING_RULES/'$ROUTING_RULES'/g' host_vars/$MME_NAME
echo 'routes4_s11: 172.20.2.0/24 '$S11_GW'' >> host_vars/$MME_NAME
echo 'routes4_db: 172.17.88.32/27 '$DB_GW'' >> host_vars/$MME_NAME

done < mme_names.txt

ansible-playbook -i inventory.txt configure_network.yaml
rm inventory.txt
