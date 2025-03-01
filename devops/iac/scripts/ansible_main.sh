#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yaml > /dev/null <<EOT
- hosts: localhost
  tasks:
    - name: Install python3 and virtualenv
      apt:
        pkg:
          - python3
          - virtualenv
        update_cache: yes
      become: yes

    - name: Clone API
      git:
        repo: https://github.com/alura-cursos/clientes-leo-api.git
        dest: /home/ubuntu/tcc
        version: master
        force: yes

    - name: Install setuptools
      pip:
        virtualenv: /home/ubuntu/tcc/venv
        name:
          - setuptools

    - name: Install deps in virtualenv (Django and Django Rest)
      pip:
        virtualenv: /home/ubuntu/tcc/venv
        requirements: /home/ubuntu/tcc/requirements.txt

    - name: Update settings.py
      lineinfile:
        path: /home/ubuntu/tcc/setup/settings.py
        regex: 'ALLOWED_HOSTS'
        line: 'ALLOWED_HOSTS = ["*"]'
        backrefs: yes

    - name: Configure DB
      shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py migrate'
    
    - name: Load data
      shell: '. /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py loaddata /home/ubuntu/tcc/clientes/fixtures/clientes.json'
    
    - name: Run server
      shell: '. /home/ubuntu/tcc/venv/bin/activate; nohup python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yaml