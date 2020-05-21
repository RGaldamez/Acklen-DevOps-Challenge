#! /bin/bash
echo "---
- hosts: localhost
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    - name: Install git to download repo
      apt:
        name: git
        state: present
    - name: Install NodeJs
      apt:
        name: nodejs
        state: present
    - name: Install NPM
      apt:
        name: npm
        state: present
    - name: Download Forked repo of Chat application
      git:
        repo: \"https://github.com/RGaldamez/Chat-App-using-Socket.io\"
        dest: \"/home/app\"
    - name: Install packages in repository
      command: npm install
      args:
        chdir: /home/app
    - name: Start Application
      command: node app.js
      args:
        chdir: /home/app" > install-start-app.yaml
sudo apt update
sudo apt install ansible -y
ansible-playbook install-start-app.yaml