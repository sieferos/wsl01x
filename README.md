- [csvkit](https://csvkit.readthedocs.io/en/1.0.3/)
- [sqlitebrowser](https://sqlitebrowser.org/)

```bash
sudo apt-get -y install python-pip python-dev build-essential
sudo pip install --upgrade pip
sudo pip install --upgrade virtualenv

sudo pip install openpyxl==2.5
sudo pip install csvkit

sudo easy_install xlsx2csv
```

```bash
brew cask install db-browser-for-sqlite
```

```bash
### iconv -f UTF-8 -t ISO-8859-1//TRANSLIT
cd ~/Daniel/TNPS/
for i in $(seq 1 3) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OW-mCare.xlsx > OW-mCare.${i}.csv ; done
for i in $(seq 1 4) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OBJETIVO-OW-eCare.xlsx > OBJETIVO-OW-eCare.${i}.csv ; done
```

```bash
cd ~/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvclean --dry-run OBJETIVO-OW-eCare.1.csv
PYTHONIOENCODING=utf-8 csvclean --dry-run ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv
```

```bash
cd ~/Daniel/TNPS/
iconv -c -f UTF-8 -t ISO-8859-1//TRANSLIT OBJETIVO-OW-eCare.1.csv > OW-eCare.csv
```

```bash
cd ~/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables OW_eCare --insert OW-eCare.csv --overwrite && echo ".schema OW_eCare" | sqlite3 NPS
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables DataExtract --insert ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv --overwrite && echo ".schema DataExtract" | sqlite3 NPS
```

```bash
cd ~/Daniel/TNPS/
echo 'CREATE INDEX IDX_ID_CLIENT_PROP39_ ON OW_eCare("ID_Client(prop39)");' | sqlite3 NPS
echo 'CREATE INDEX IDX_USER_ID__OW___EVAR39_ ON DataExtract("user id (ow) (evar39)");' | sqlite3 NPS
```

```bash
cd ~/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvstat OW-mCare.2.csv | tee OW-mCare.2.csvstat.txt
PYTHONIOENCODING=utf-8 csvcut --names OBJETIVO-OW-eCare.1.csv | tee OBJETIVO-OW-eCare.1.csvstat.txt
PYTHONIOENCODING=utf-8 csvstat OBJETIVO-OW-eCare.1.csv | tee -a OBJETIVO-OW-eCare.1.csvstat.txt
PYTHONIOENCODING=utf-8 csvcut --columns "ID_Client(prop39)","Creation Date","URL","Country","Region","City","Device Vendor","Device Model","Is Mobile Device","Browser Name","Recommendation","Satisfaction","pageName","NPS" OBJETIVO-OW-eCare.1.csv > OW-eCare.csv

PYTHONIOENCODING=utf-8 csvcut --names OW-eCare.csv | tee OW-eCare.csvstat.txt
PYTHONIOENCODING=utf-8 csvstat OW-eCare.csv | tee -a OW-eCare.csvstat.txt

PYTHONIOENCODING=utf-8 csvgrep --columns "ID_Client(prop39)" --match "105512209" OW-eCare.csv | tee OW-eCare.105512209.csv
```

```bash
PYTHONIOENCODING=utf-8 csvcut --names ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | tee DataExtract_201811.csvstat.txt
echo "user id (ow) (evar39)" > DataExtract_201811.U.csv && PYTHONIOENCODING=utf-8 csvcut --columns "user id (ow) (evar39)" ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | sort -u >> DataExtract_201811.U.csv
PYTHONIOENCODING=utf-8 csvgrep --columns "user id (ow) (evar39)" --match "105512209" ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | tee DataExtract_201811.csv
PYTHONIOENCODING=utf-8 csvcut --names DataExtract_201811.csv | tee DataExtract_201811.csvstat.txt
PYTHONIOENCODING=utf-8 csvstat DataExtract_201811.csv | tee -a DataExtract_201811.csvstat.txt

PYTHONIOENCODING=utf-8 csvjoin --columns "user id (ow) (evar39)","ID_Client(prop39)" --outer DataExtract_201811.U.csv OW-eCare.csv | tee DataExtract_201811.J.csv
PYTHONIOENCODING=utf-8 csvstat DataExtract_201811.J.csv | tee DataExtract_201811.J.stats.txt
```
