```bash
mkdir -p ${HOME}/github/sieferos/wsl01x/scripts/cfg/
```

```bash
cd ${HOME}/Daniel/TNPS/ && echo '
SELECT
("pivot@navigation[" || "subsection1(prop1)" || ":" || "subsection2(prop2)" || "]") AS navigation
FROM DataExtract
/**/
/* WHERE DATE LIKE "%November%,%2018%" */
/**/
GROUP BY navigation
;' | sqlite3 -cmd ".headers OFF" TNPS.db | iconv -c -f UTF-8 -t ISO-8859-1//IGNORE | csvformat --delimiter "|" --quoting 0 | tee ${HOME}/github/sieferos/wsl01x/scripts/cfg/navigation.cfg
```

```bash
cd ${HOME}/Daniel/TNPS/ && echo '
SELECT
("pivot@clientstatus[" || ifnull("clientstatus(prop15)", "-null-") || "]") AS clientstatus
FROM DataExtract
WHERE "clientstatus(prop15)" NOT LIKE "cod%"
AND length("clientstatus(prop15)") > 1
/**/
/* WHERE DATE LIKE "%November%,%2018%" */
/**/
GROUP BY clientstatus
;' | sqlite3 -cmd ".headers OFF" TNPS.db | iconv -c -f UTF-8 -t ISO-8859-1//IGNORE | csvformat --delimiter "|" --quoting 0 | tee ${HOME}/github/sieferos/wsl01x/scripts/cfg/clientstatus.cfg
```
