## sensu handlers for ansible

see [SensuのhandlerとしてAnsibleを使う - Qiita](http://qiita.com/hiconyan/items/f8a7ab8854bac1e51114)

#### about

 - `ansible-handler.rb`: run ansible-playbook `/path/to/[check-name].yml`

#### how to use

 1. `cd /path/to/sensu/handlers`
 2. `wget https://raw.githubusercontent.com/hico-horiuchi/sensu-ansible/master/ansible_handler.rb`
 3. `chmod 755 ansible_handler.rb`
 4. `cd /path/to/sensu/conf.d`
 5. `wget https://raw.githubusercontent.com/hico-horiuchi/sensu-ansible/master/handler_ansible.json`
 6. please modify to suit your ansible environment this `handler_ansible.json`
 7. please restart sensu-server
