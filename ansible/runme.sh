EXECDIR=$(dirname $0)
echo sudo /usr/local/bin/ansible-playbook  $EXECDIR/setupHost.yml
sudo      /usr/local/bin/ansible-playbook  $EXECDIR/setupHost.yml
