## Virtual machine creation

This playbook uses Ansible to create virtual machines on host server. Create your own XML file for the VM and then run this playbook to create as many VMs as you like. 

Requirements
------------

- The following packages should be installed on the host server
```
apt install ansible libguestfs-tool python3-libvirt
```

- Install  the latest version of Ansible community general
```
ansible-galaxy collection install community.general
```

- You should create your own XML file for the VM to use as template. 

Steps to create virtual machine
------------

1. Enter the VM hostnames in the <code>vm_name.txt</code> file. For example:
```
srv16-mme-1
srv16-mme-2
.
.
.
```
2. Edit the <code>kvm_provision.yaml</code> file and specify the resources for the server.
3. Place the .qcow2 base image in the <code>/var/lib/libvirt/images</code> and rename it to <code>sample-mme-image.qcow2</code>
4. Place the sample coredump .qcow2 image in the <code>/data</code> directory and rename it to <code>sample-coredump.qcow2</code>
5. Edit the VM template file under <code>roles/kvm_provision/templates/vm-template.xml.j2</code> to match your desired state. 
6. Execute the <code>create_vm</code> script to start creating VMs. 

## Network configuration

1. Edit the <code>configure_network.sh</code> file and specify the gateways for all intefaces. (OM,s1mme,s11,db)
2. Edit the <code>mme_name.txt</code> file in this directory and specify the information in this format:
```
MME_NAME OM_IP S1MME_IP S11_IP DB_IP
```

An example would be like this:
```
srv16-mme-1 172.17.93.80/22 172.17.80.194/27 172.17.56.34/27 172.17.88.194/27
```
3. Make sure that all hostnames (e,g srv16-mme-1) resolve to the IP of the host machine libvirt interface. You can edit the /etc/hosts as so:
```
srv16-mme-1     192.168.10.1
```
4. Execute the <code>configure_network.sh</code> script to start the configuration proccess.