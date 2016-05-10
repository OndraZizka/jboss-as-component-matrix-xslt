
if [ "" == "$1" ] ; then
  echo "Usage: `basename $0` <pom-url-list-path>";
  exit 1;
fi



function replace {
  echo "cat $1 | sed 's#$2#$3#i'";
  cat $1 | sed "s#$2#$3#i" > tmp/replace-tmp; rm $1; cp tmp/replace-tmp $1
}


rm -r ./wd
mkdir wd

echo "# release, type, art, ver" > wd/multi-matrix.csv

##  Download the files, put TAG to <version>, extract matrix CSV and append to the compound CSV.
while read -r URL ; do

  if [[ $URL = \#* ]] ; then continue; fi

  echo "  --- Processing $URL ---"

  rm -rf ./tmp
  mkdir tmp
  wget --no-verbose $URL -O tmp/pom.xml

  ## Replace version with the one from URL.
  echo "Replacing version with the one from URL…"
  #TAG=`echo $URL | sed 's#tags/\([^/]\)/#\1#i'`  ##  [^/] does not work for some reason.
  TAG=`echo $URL | sed 's#.*/tags/\(.*\)/component-matrix.*#\1#i'`
  #VER_XML=`grep '<version>' tmp/pom.xml | sed -n 2p`
  #replace tmp/pom.xml "$VER_XML" "<version>$TAG<version>"
  URL_XML=`grep '<url>' tmp/pom.xml`
  replace tmp/pom.xml "$URL_XML" "<url>$TAG</url>"

  echo "Transforming  to CSV using XSLT…"
  ./xslt tmp/pom.xml compMatrix.xsl tmp/matrix.csv
  tail --lines=+2 tmp/matrix.csv >> wd/multi-matrix.csv  ##  Skip the columns definition.

done < $1



# URL="https://svn.jboss.org/repos/jbossas/tags/JBPAPP_5_1_0_CR2/component-matrix/pom.xml"