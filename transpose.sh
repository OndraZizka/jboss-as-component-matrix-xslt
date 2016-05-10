
#  TODO: This should turn the CSV data 


#     # release, type, artifact, version
#     5.1.0-SNAPSHOT, DEP, org.apache.maven:maven-ant-tasks, 2.0.9
#     5.1.0-SNAPSHOT, DEP, org.jboss.seam.integration:jboss-seam-int-microcontainer, 5.1.0.CR1
#     5.1.0-SNAPSHOT, DEP, org.jboss.seam.integration:jboss-seam-int-jbossas, 5.1.0.CR1

#  into something like this:

#                 5.0.0  5.0.1  5.1.0
#     varia           5.0.0  5.0.0  ... 
#     hibernate       3.4.0  3.4.0  ...
#     jboss-commons   5.0.0  5.0.1  ...
#     ...


# release, type, art, ver


REL_FILE="wd/step01-releases.csv"
ART_FILE="wd/step01-artifacts.csv";
DATA_FILE="wd/multi-matrix.csv"
RESULT_FILE="RESULT-TABLE.csv"

rm -f foo.csv $REL_FILE $ART_FILE


##  Get releases.
java -jar /home/ondra/sw/tools/CsvCruncher/1.0.1/lib/CsvCruncher-1.0.jar $DATA_FILE $REL_FILE \
'SELECT release FROM indata GROUP BY release'



##  Get artifacts.
java -jar /home/ondra/sw/tools/CsvCruncher/1.0.1/lib/CsvCruncher-1.0.jar $DATA_FILE $ART_FILE \
'SELECT art FROM indata GROUP BY art'

##  The result will be like...
#java -jar /home/ondra/sw/tools/CsvCruncher/1.0.1/lib/CsvCruncher-1.0.jar $DATA_FILE $RESULT_FILE \
#"SELECT arts.art 
#, d1.ver AS v1, d2.ver AS v2
#FROM (SELECT art FROM indata GROUP BY art) AS arts
#  LEFT JOIN indata AS d1 ON arts.art = d1.art AND d1.release = '5.1.0-SNAPSHOT'
#  LEFT JOIN indata AS d2 ON arts.art = d2.art AND d2.release = '5.0.0.GA'"


##  Create a SQL which will create a row for the given artifact.

# SELECT d1.ver, d2.ver, d3.ver, d4.ver, d5.ver, d6.ver, d7.ver
# FROM indata AS d1
#   LEFT JOIN indata AS d2
#    ... 
# WHERE 1
#   AND d1.release = '$release' AND d1.art = '$art'
#   AND ...

release="5.1.0-SNAPSHOT"; # Hard-coded, for now...

##  For all articles
echo "SELECT arts.art " > wd/sql.txt;
CNT=1;
while read -r RELEASE ; do
  echo -n ", d$CNT.ver AS v$CNT" >> wd/sql.txt;
  CNT=$((CNT+1));
done < $REL_FILE


echo >> wd/sql.txt
echo "FROM (SELECT art FROM indata GROUP BY art) AS arts" >> wd/sql.txt
CNT=1;
while read -r RELEASE ; do
  echo "  LEFT JOIN indata AS d$CNT ON arts.art = d$CNT.art AND d$CNT.release = '$RELEASE'" >> wd/sql.txt;
  CNT=$((CNT+1));
done < $REL_FILE


if [ "" == "x" ] ; then
echo "WHERE 1" >> wd/sql.txt
CNT=1;
while read -r RELEASE ; do
  echo "  AND d$CNT.rel = '$RELEASE' AND d$CNT.art = arts.art" >> wd/sql.txt;
  CNT=$((CNT+1));
done < $REL_FILE
fi

#   AND d1.release = '$release' AND d1.art = '$art'
#   AND ...


java -jar /home/ondra/sw/tools/CsvCruncher/1.0.1/lib/CsvCruncher-1.0.jar $DATA_FILE $RESULT_FILE "`cat wd/sql.txt`"

##  Prepend column declaration.
echo -n "#  artifact" > $RESULT_FILE.header
while read -r RELEASE ; do
  echo -n ", $RELEASE" >> $RESULT_FILE.header
done < $REL_FILE
echo >> $RESULT_FILE.header
cat $RESULT_FILE >> $RESULT_FILE.header


