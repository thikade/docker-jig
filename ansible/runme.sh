EXECDIR=$(dirname $0)
echo ansible-playbook  $EXECDIR/setupHost.yml
ansible-playbook  $EXECDIR/setupHost.yml
