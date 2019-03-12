- [csvkit](https://csvkit.readthedocs.io/en/1.0.3/)

```bash
  $ ssh sieferos@wsl01x

    sieferos@wsl01x:~$ sudo apt-get -y install python-pip python-dev build-essential
    sieferos@wsl01x:~$ sudo pip install --upgrade pip
    sieferos@wsl01x:~$ sudo pip install --upgrade virtualenv

    sieferos@wsl01x:~$ sudo pip install openpyxl==2.5
    sieferos@wsl01x:~$ sudo pip install csvkit

    sieferos@wsl01x:~$ sudo easy_install xlsx2csv
```

```bash
    sieferos@wsl01x:~$ ### iconv -f UTF-8 -t ISO-8859-1//TRANSLIT
    sieferos@wsl01x:~$ cd ~/Daniel/TNPS/
    sieferos@wsl01x:~$ for i in $(seq 1 3) ; do xlsx2csv -s ${i} OW-mCare.xlsx > OW-mCare.${i}.csv ; done
    sieferos@wsl01x:~$ for i in $(seq 1 4) ; do xlsx2csv -s ${i} OBJETIVO-OW-eCare.xlsx > OBJETIVO-OW-eCare.${i}.csv ; done
```

```bash
    sieferos@wsl01x:~$ cd ~/Daniel/TNPS/
    sieferos@wsl01x:~$ csvstat OW-mCare.2.csv | tee OW-mCare.2.csvstat.txt
    sieferos@wsl01x:~$ csvstat OBJETIVO-OW-eCare.1.csv | tee OBJETIVO-OW-eCare.1.csvstat.txt
```
