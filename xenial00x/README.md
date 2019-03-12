```
# /*
# * README.md
# * sieferos: 12/03/2019
# */
```

### SOFTWARE REQUISITES

- [VIRTUALBOX](https://www.virtualbox.org/wiki/Downloads)
- [VAGRANT](https://www.vagrantup.com/docs/installation/)
- [GIT](https://git-scm.com/downloads)
- [SSHFS](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh)
	- [OSX (homebrew)](http://brewformulas.org/Sshfs)

```bash
###
### TO CREATE ANOTHER DIFFERENT INSTANCE OF THIS BOX:
### REPLACE 'wsl01x' TO WHATEVER YOU LIKE
###

###
### SSHFS
###
	OSX: sieferos$ ### allows access linux file system from OS X, this enable to read & write source files from your favourite IDE
	OSX: sieferos$ mkdir -p $HOME/wsl01x/

###
### GO AHEAD!
###
	OSX: sieferos$ cd ~/github/sieferos/wsl01x/xenial00x/ && vagrant --box-name="wsl01x" up

Bringing machine 'default' up with 'virtualbox' provider...
```

```bash
###
### SSH CONFIG ( wsl01x )
###
	OSX: sieferos$ ! ( grep -q "wsl01x" $HOME/.ssh/config 2>/dev/null ) && printf "\nHost %s\n%s\n" "wsl01x" "$(vagrant ssh-config | tail -n +2)" | sed -e 's/User vagrant/User sieferos/' | tee -a $HOME/.ssh/config

Host wsl01x
  HostName 127.0.0.1
  User sieferos
  Port 2200
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /Users/sieferos/github/sieferos/wsl01x/xenial00x/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL

	OSX: sieferos$ ssh wsl01x

		sieferos@wsl01x:~$ exit

Connection to 127.0.0.1 closed.
```

```bash
###
### SSHFS [ https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh ]
###
	OSX: sieferos$ ### ALIASES
	OSX: sieferos$ ! ( grep -q "mount-sshfs-wsl01x" $HOME/.bashrc 2>/dev/null ) && cat <<"EOT" | tee -a $HOME/.bashrc

alias mount-sshfs-wsl01x='sshfs wsl01x:/home/sieferos $HOME/wsl01x -o cache=no 2>&1 && mount | grep -i wsl01x'
alias umount-sshfs-wsl01x='umount $HOME/wsl01x'
alias start-wsl01x='VBoxManage startvm "wsl01x" --type headless'
alias stop-wsl01x='VBoxManage controlvm "wsl01x" poweroff'
EOT

	OSX: sieferos$ source $HOME/.bashrc
	OSX: sieferos$ mount-sshfs-wsl01x

wsl01x:/home/sieferos on /Users/sieferos/wsl01x (osxfuse, nodev, nosuid, synchronous, mounted by sieferos)
```

```bash
###
### SSH-KEY-BASED-AUTHENTICATION [ https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server ]
###
	OSX: sieferos$ ssh-copy-id -f sieferos@wsl01x

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/sieferos/.ssh/id_rsa.pub"

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'sieferos@wsl01x'"
and check to make sure that only the key(s) you wanted were added.

	OSX: sieferos$ cd && ssh sieferos@wsl01x uname -a

Linux wsl01x 4.4.0-142-generic #168-Ubuntu SMP Wed Jan 16 21:00:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```
