EXECDIR=$(dirname $0)
echo sudo ansible-playbook  $EXECDIR/setupHost.yml
sudo ansible-playbook  $EXECDIR/setupHost.yml
