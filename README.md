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
for i in $(seq 1 3) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OW-mCare.xlsx | perl scripts/fixdates.pl > OW-mCare.${i}.csv ; done
for i in $(seq 1 4) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OBJETIVO-OW-eCare.xlsx | perl scripts/fixdates.pl > OBJETIVO-OW-eCare.${i}.csv ; done
```

```bash
cd ~/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvclean --dry-run OBJETIVO-OW-eCare.1.csv
PYTHONIOENCODING=utf-8 csvclean --dry-run ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv
```

```bash
cd ~/Daniel/TNPS/
iconv -c -f UTF-8 -t ISO-8859-1//IGNORE OBJETIVO-OW-eCare.1.csv > OW-eCare.csv
iconv -c -f UTF-8 -t ISO-8859-1//IGNORE ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv > DataExtract_201811.csv
```

```bash
cd ~/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables OW_eCare --insert OW-eCare.csv --overwrite && echo ".schema OW_eCare" | sqlite3 TNPS.db
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables DataExtract --insert DataExtract_201811.csv --overwrite && echo ".schema DataExtract" | sqlite3 TNPS.db
```

```bash
cd ~/Daniel/TNPS/
echo 'CREATE INDEX IDX_ID_CLIENT_PROP39_ ON OW_eCare("ID_Client(prop39)");' | sqlite3 TNPS.db
echo 'CREATE INDEX IDX_CREATIONDATE ON OW_eCare("CreationDate");' | sqlite3 TNPS.db

echo 'CREATE INDEX IDX_USER_ID__OW___EVAR39_ ON DataExtract("user id (ow) (evar39)");' | sqlite3 TNPS.db
```

```bash
cd ~/Daniel/TNPS/

PYTHONIOENCODING=utf-8 csvcut --names OW-eCare.csv | tee OW-eCare.stats.txt
PYTHONIOENCODING=utf-8 csvstat OW-eCare.csv | tee -a OW-eCare.stats.txt
PYTHONIOENCODING=latin csvcut --columns "ID_Client(prop39)","Creation Date","URL","Country","Region","City","Device Vendor","Device Model","Is Mobile Device","Browser Name","Recommendation","Satisfaction","pageName","NPS" OW-eCare.csv > OW-eCare.c.csv

PYTHONIOENCODING=utf-8 csvcut --names OW-eCare.csv | tee OW-eCare.stats.txt
PYTHONIOENCODING=utf-8 csvstat OW-eCare.csv | tee -a OW-eCare.stats.txt

PYTHONIOENCODING=utf-8 csvgrep --columns "ID_Client(prop39)" --match "968068762" OW-eCare.csv | tee OW-eCare.968068762.csv
```

```bash
PYTHONIOENCODING=utf-8 csvcut --names ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | tee DataExtract_201811.stats.txt
echo "user id (ow) (evar39)" > DataExtract_201811.U.csv && PYTHONIOENCODING=utf-8 csvcut --columns "user id (ow) (evar39)" ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | sort -u >> DataExtract_201811.U.csv
PYTHONIOENCODING=utf-8 csvgrep --columns "user id (ow) (evar39)" --match "968068762" ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv | tee DataExtract_201811.csv
PYTHONIOENCODING=utf-8 csvcut --names DataExtract_201811.csv | tee DataExtract_201811.stats.txt
PYTHONIOENCODING=utf-8 csvstat DataExtract_201811.csv | tee -a DataExtract_201811.stats.txt

PYTHONIOENCODING=utf-8 csvjoin --columns "user id (ow) (evar39)","ID_Client(prop39)" --outer DataExtract_201811.U.csv OW-eCare.csv | tee DataExtract_201811.J.csv
PYTHONIOENCODING=utf-8 csvstat DataExtract_201811.J.csv | tee DataExtract_201811.J.stats.txt
```

```bash
  cd ~/Daniel/TNPS/

echo 'SELECT "ID_Client(prop39)" AS ID_CLIENT, count() AS C FROM OW_eCare WHERE ID_CLIENT != "-" GROUP BY ID_CLIENT ORDER BY C DESC;' | sqlite3 TNPS.db | more

echo 'SELECT "ID_Client(prop39)" AS ID_CLIENT, "CreationDate" AS D, count() AS C FROM OW_eCare WHERE ID_CLIENT != "-" GROUP BY ID_CLIENT,D ORDER BY C DESC;' | sqlite3 TNPS.db | more


echo 'SELECT ifnull("errorcause(prop30)", "-null-") AS EC, count() AS C FROM DataExtract GROUP BY EC ORDER BY C DESC;' | sqlite3 TNPS.db | more


echo 'SELECT "Pages", count() AS C FROM DataExtract WHERE Pages IS NOT NULL GROUP BY "Pages" ORDER BY C DESC;' | sqlite3 TNPS.db | tee Pages.csv | csvstat --no-header-row | tee Pages.stats.txt

echo 'SELECT "subsection1(prop1)" AS SECTION1, "subsection2(prop2)" AS SECTION2, count() AS C FROM DataExtract WHERE SECTION1 IS NOT NULL AND SECTION2 IS NOT NULL GROUP BY SECTION1,SECTION2 ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | wc

echo 'SELECT "subsection1(prop1)" AS SECTION1, "subsection2(prop2)" AS SECTION2, "subsection3(prop5)" AS SECTION3, count() AS C FROM DataExtract WHERE SECTION1 IS NOT NULL AND SECTION2 IS NOT NULL GROUP BY SECTION1,SECTION2,SECTION3 ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | wc

echo 'SELECT "subsection1(prop1)" AS SECTION, count() AS C FROM DataExtract WHERE SECTION IS NOT NULL GROUP BY SECTION ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | tee subsection1.csv | csvstat --no-header-row | tee subsection1.stats.txt

echo 'SELECT "subsection2(prop2)" AS SECTION, count() AS C FROM DataExtract WHERE SECTION IS NOT NULL GROUP BY SECTION ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | tee subsection2.csv | csvstat --no-header-row | tee subsection2.stats.txt

echo 'SELECT "subsection3(prop5)" AS SECTION, count() AS C FROM DataExtract WHERE SECTION IS NOT NULL GROUP BY SECTION ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | tee subsection3.csv | csvstat --no-header-row | tee subsection3.stats.txt

echo 'SELECT "subsection4(prop27)" AS SECTION, count() AS C FROM DataExtract WHERE SECTION IS NOT NULL GROUP BY SECTION ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | tee subsection4.csv | csvstat --no-header-row | tee subsection4.stats.txt

echo 'SELECT "subsection5(prop9)" AS SECTION, count() AS C FROM DataExtract WHERE SECTION IS NOT NULL GROUP BY SECTION ORDER BY C DESC;' | sqlite3 -separator ',' TNPS.db | tee subsection5.csv | csvstat --no-header-row | tee subsection5.stats.txt
```

```bash
cd ~/Daniel/TNPS/

echo 'SELECT * FROM DataExtract WHERE "userid(ow)(evar39)" = 968068762 ORDER BY Date,"hh:mm(prop54)" DESC;' | sqlite3 -cmd ".headers ON" TNPS.db | csvformat --delimiter "|" --quoting 0 | tee DataExtract.968068762.csv | csvstat | tee DataExtract.968068762.stats.txt

echo 'SELECT OW_eCare.*
FROM OW_eCare
WHERE OW_eCare."ID_Client(prop39)" = 968068762
;' | sqlite3 -cmd ".headers ON" TNPS.db | csvformat --delimiter "|" --quoting 0 | tee OW_eCare.COLUMNS.csv

csvcut --names OW_eCare.COLUMNS.csv


echo 'SELECT DataExtract.*,OW_eCare."Recommendation"
FROM OW_eCare
LEFT JOIN DataExtract
ON OW_eCare."ID_Client(prop39)" = DataExtract."userid(ow)(evar39)"
WHERE OW_eCare."ID_Client(prop39)" = 968068762
;' | sqlite3 -cmd ".headers ON" TNPS.db | csvformat --delimiter "|" --quoting 0 | tee DataExtract.968068762.csv | csvstat | tee DataExtract.968068762.stats.txt

csvcut --names DataExtract.968068762.csv

cat DataExtract.968068762.csv | csvcut --columns "Date","userid(ow)(evar39)","Pages","hh:mm(prop54)"
```

```
29: errorcause(prop30) TRUE/FALSE
```

```
1: Date
2: userid(ow)(evar39)
12: subsection1(prop1)
13: subsection2(prop2)
14: subsection3(prop5)
15: subsection4(prop27)
16: subsection5(prop9)

echo 'SELECT
"Date" AS DATE,
"userid(ow)(evar39)" AS USER_ID,
ifnull("visitorstatus(prop4)", "-null-") AS visitorstatus,
ifnull("clientstatus(prop15)", "-null-") AS clientstatus,
ifnull("clientdebt(prop18)", "-null-") AS clientdebt,
ifnull("new/repeat(prop21)", "-null-") AS new_repeat,
ifnull("prepaid/postpaid(prop23)", "-null-") AS prepaid_postpaid,
ifnull("navigationspeed(prop24)", "-null-") AS navigationspeed,
ifnull("moremegas(prop31)", "-null-") AS moremegas,
ifnull("servicetype(prop36)", "-null-") AS servicetype,
ifnull("purchasedpackages(prop57)", "-null-") AS purchasedpackages,
ifnull("loginprofile(prop58)", "-null-") AS loginprofile,
count() AS C
FROM DataExtract
WHERE USER_ID IS NOT NULL AND DATE IS NOT NULL
GROUP BY
DATE,
USER_ID,
"visitorstatus",
"clientstatus",
"clientdebt",
"new_repeat",
"prepaid_postpaid",
"navigationspeed",
"moremegas",
"servicetype",
"purchasedpackages",
"loginprofile"
ORDER BY C DESC
;' | sqlite3 -cmd ".headers ON" TNPS.db | wc
```

echo 'SELECT DISTINCT "userid(ow)(evar39)" FROM DataExtract;' | sqlite3 TNPS.db | wc

echo 'SELECT DISTINCT "Date","userid(ow)(evar39)" AS USER_ID FROM DataExtract WHERE USER_ID = 45217533;' | sqlite3 TNPS.db | wc

echo 'SELECT "Date","userid(ow)(evar39)", count() as C FROM DataExtract GROUP BY "Date","userid(ow)(evar39)" ORDER BY C DESC;' | sqlite3 TNPS.db | more


```
"Verbatim", TRUE/FALSE
```


```bash
echo 'SELECT
"CreationDate" AS DATE,
"ID_Client(prop39)" AS USER_ID,
"Country" AS "Country",
"Region" AS "Region",
"City" AS "City",
"PrimaryHardwareType" AS "PrimaryHardwareType",
"OSName" AS "OSName",
"BrowserName" AS "BrowserName",
"Recommendation" AS "Recommendation",
"pageName" AS "pageName",
"paginasenlavisita" AS "paginasenlavisita",
"platform(prop11)" AS "platform",
count() AS C
FROM OW_eCare
WHERE USER_ID != "-"
GROUP BY
DATE,
USER_ID,
"Country",
"Region",
"City",
"PrimaryHardwareType",
"OSName",
"BrowserName",
"Recommendation",
"pageName",
"paginasenlavisita",
"platform"
ORDER BY C DESC
;' | sqlite3 -cmd ".headers ON" TNPS.db | wc
```
