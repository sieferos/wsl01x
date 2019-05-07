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
### FTP
brew install inetutils
### csv2xls.pl
cpan install Spreadsheet/WriteExcel
```

```bash
### iconv -f UTF-8 -t ISO-8859-1//TRANSLIT
cd ${HOME}/Daniel/TNPS/
for i in $(seq 1 3) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OW-mCare.xlsx | perl scripts/fixdates.pl > OW-mCare.${i}.csv ; done
for i in $(seq 1 4) ; do PYTHONIOENCODING=utf-8 xlsx2csv -s ${i} OBJETIVO-OW-eCare.xlsx | perl scripts/fixdates.pl > OBJETIVO-OW-eCare.${i}.csv ; done
```

```bash
cd ${HOME}/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvclean --dry-run OBJETIVO-OW-eCare.1.csv
PYTHONIOENCODING=utf-8 csvclean --dry-run ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv
```

```bash
cd ${HOME}/Daniel/TNPS/
iconv -c -f UTF-8 -t ISO-8859-1//IGNORE OBJETIVO-OW-eCare.1.csv > OW-eCare.csv
iconv -c -f UTF-8 -t ISO-8859-1//IGNORE ../Comportamiento\ Adobe\ eCare\ -\ WEB/DataExtract_Nov.csv > DataExtract_201811.csv
```

```bash
cd ${HOME}/Daniel/TNPS/
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables OW_eCare --insert OW-eCare.csv --overwrite && echo ".schema OW_eCare" | sqlite3 TNPS.db
PYTHONIOENCODING=utf-8 csvsql --db sqlite:///NPS --tables DataExtract --insert DataExtract_201811.csv --overwrite && echo ".schema DataExtract" | sqlite3 TNPS.db
```

```bash
cd ${HOME}/Daniel/TNPS/
echo 'CREATE INDEX IDX_ID_CLIENT_PROP39_ ON OW_eCare("ID_Client(prop39)");' | sqlite3 TNPS.db
echo 'CREATE INDEX IDX_CREATIONDATE ON OW_eCare("CreationDate");' | sqlite3 TNPS.db

echo 'CREATE INDEX IDX_USER_ID__OW___EVAR39_ ON DataExtract("user id (ow) (evar39)");' | sqlite3 TNPS.db
```

```bash
cd ${HOME}/Daniel/TNPS/

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
  cd ${HOME}/Daniel/TNPS/

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
cd ${HOME}/Daniel/TNPS/

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

```bash
cd ${HOME}/Daniel/TNPS/
echo 'SELECT DISTINCT
"ID_Client(prop39)" AS USER_ID
FROM OW_eCare
WHERE USER_ID != "-"
/**/
AND "CreationDate" LIKE "2018/11/%"
/**/
ORDER BY USER_ID
;' | sqlite3 -cmd ".headers OFF" TNPS.db | tee ${HOME}/Daniel/TNPS/USER_ID.csv
```

```bash
for W in OW_eCare DataExtract ; do mkdir -p ${HOME}/Daniel/TNPS/__idx/${W}/ ; done
```


```
12: subsection1(prop1)
13: subsection2(prop2)
14: subsection3(prop5)
15: subsection4(prop27)
16: subsection5(prop9)
```

```bash
cd ${HOME}/Daniel/TNPS/ && for USER_ID in 15563076 ; do

cd ${HOME}/Daniel/TNPS/ && for USER_ID in $(cat ${HOME}/Daniel/TNPS/USER_ID.csv) ; do
printf "USER_ID [ %s ]\n" "${USER_ID}"
echo 'SELECT
/* "Date" AS DATE, */
"userid(ow)(evar39)" AS USER_ID,
/* ("subsection1(prop1)" || ":" || "subsection2(prop2)") AS navigation, */
CASE ifnull("visitorstatus(prop4)", "-null-")
    WHEN "no logado" THEN "-null-"
    ELSE ifnull("visitorstatus(prop4)", "-null-")
END visitorstatus,
ifnull("clientstatus(prop15)", "-null-") AS clientstatus,
CASE ifnull("clientdebt(prop18)", "-null-")
    WHEN "no" THEN "-null-"
    ELSE ifnull("clientdebt(prop18)", "-null-")
END clientdebt,
/* ifnull("new/repeat(prop21)", "-null-") AS new_repeat, */
ifnull("prepaid/postpaid(prop23)", "-null-") AS prepaid_postpaid,
CASE
    WHEN ifnull("navigationspeed(prop24)", "-null-") LIKE "%velocidad%" THEN "True"
    ELSE "-null-"
END navigationspeed,
/* ifnull("moremegas(prop31)", "-null-") AS moremegas, */
ifnull("purchasedpackages(prop57)", "-null-") AS purchasedpackages,
ifnull("loginprofile(prop58)", "-null-") AS loginprofile,
CASE ifnull("errorcause(prop30)", "-null-")
    WHEN "-null-" THEN "-null-"
    ELSE "True"
END ERROR
/* , count() AS C */
FROM DataExtract
WHERE USER_ID IS NOT NULL AND DATE IS NOT NULL
/**/
AND DATE LIKE "%November%,%2018%"
/**/
AND USER_ID = "'${USER_ID}'"
GROUP BY
/* DATE, */
USER_ID,
/* navigation, */
"visitorstatus",
"clientstatus",
"clientdebt",
/* "new_repeat", */
"prepaid_postpaid",
"navigationspeed",
/* "moremegas", */
"purchasedpackages",
"loginprofile",
ERROR
/* ORDER BY C DESC */
;' | sqlite3 -cmd ".headers ON" TNPS.db | iconv -c -f UTF-8 -t ISO-8859-1//IGNORE | csvformat --delimiter "|" --quoting 0 | ~/github/sieferos/wsl01x/scripts/fixdates.pl | tee ${HOME}/Daniel/TNPS/__idx/DataExtract/201811."${USER_ID}".csv
// sleep 1
done

csvcut --names DataExtract.201811.15563076.csv
```

echo 'SELECT DISTINCT "userid(ow)(evar39)" FROM DataExtract;' | sqlite3 TNPS.db | wc

echo 'SELECT DISTINCT "Date","userid(ow)(evar39)" AS USER_ID FROM DataExtract WHERE USER_ID = 45217533;' | sqlite3 TNPS.db | wc

echo 'SELECT "Date","userid(ow)(evar39)", count() as C FROM DataExtract GROUP BY "Date","userid(ow)(evar39)" ORDER BY C DESC;' | sqlite3 TNPS.db | more


```
"Verbatim", TRUE/FALSE
```


```bash
cd ${HOME}/Daniel/TNPS/ && for USER_ID in $(cat ${HOME}/Daniel/TNPS/USER_ID.csv) ; do
printf "USER_ID [ %s ]\n" "${USER_ID}"
echo 'SELECT
/* "CreationDate" AS DATE, */
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
CASE ifnull("Verbatim", "-null-")
    WHEN "-null-" THEN "False"
    ELSE "True"
END VERBATIM,
ifnull("NPS", "-null-") AS NPS
/* , count() AS C */
FROM OW_eCare
WHERE USER_ID != "-"
/**/
AND "CreationDate" LIKE "2018/11/%"
/**/
AND USER_ID = "'${USER_ID}'"
GROUP BY
/* DATE, */
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
"platform",
VERBATIM,
NPS
/* ORDER BY C DESC */
;' | sqlite3 -cmd ".headers ON" TNPS.db | csvformat --delimiter "|" --quoting 0 | ~/github/sieferos/wsl01x/scripts/fixdates.pl | tee ${HOME}/Daniel/TNPS/__idx/OW_eCare/201811."${USER_ID}".csv
done

csvcut --names OW_eCare.201811.15563076.csv
```

```
csvjoin --no-inference --columns "USER_ID" DataExtract.201811.15563076.csv OW_eCare.201811.15563076.csv | tee DataExtract-OW_eCare.201811.15563076.csv

~/github/sieferos/wsl01x/scripts/csv2xls.pl OW_eCare-DataExtract.201811.15563076.csv OW_eCare-DataExtract.201811.15563076.xls
```

```bash
mkdir -p ${HOME}/Daniel/TNPS/__idx/__JOIN__/

cd ${HOME}/Daniel/TNPS/ && for USER_ID in 15563076 ; do

cd ${HOME}/Daniel/TNPS/ && for USER_ID in $(cat ${HOME}/Daniel/TNPS/USER_ID.csv) ; do
printf "USER_ID [ %s ]\n" "${USER_ID}"
OW_ECARE="${HOME}/Daniel/TNPS/__idx/OW_eCare/201811.${USER_ID}.csv"
DATAEXTRACT="${HOME}/Daniel/TNPS/__idx/DataExtract/201811.${USER_ID}.csv"
if [[ -e "${OW_ECARE}" && -e "${DATAEXTRACT}" ]] ; then
  # printf "\t(OK) [ O:%s | D:%s ]\n" "${OW_ECARE}" "${DATAEXTRACT}"
  csvjoin --no-inference --columns "USER_ID" "${DATAEXTRACT}" "${OW_ECARE}" | tee "${HOME}/Daniel/TNPS/__idx/__JOIN__/201811.${USER_ID}.csv"
else
  printf "\t(KO) [ O:%s | D:%s ]\n" "${OW_ECARE}" "${DATAEXTRACT}"
fi
done
```

```bash
cd ${HOME}/Daniel/TNPS/ && csvstack __idx/__JOIN__/201811.* | csvformat --quoting 0 | tee DataExtract-OW_eCare.JOIN.201811.csv && wc DataExtract-OW_eCare.JOIN.201811.csv
```

```
PIVOT:clientstatus
PIVOT:navigation
PIVOT:clientdebt
```