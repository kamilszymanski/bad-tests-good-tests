#!/bin/bash

#generates html, ePub, txt and pdf outputs

BOOKDIR=/home/tomek/btgt
MAIN_FILE=$BOOKDIR/book.txt
SRCDIR=/home/tomek/btgt
RESDIR=$SRCDIR/resources
TARGET=$SRCDIR/target
BACKUP=$SRCDIR/backup
#ICONSDIR=$SRCDIR/images/icons
VER=$(date +"%Y%m%d_%H%M")
echo ""
echo "VERSION: $VER"

rm -f $TARGET/*.html
rm -rf $TARGET/images
rm -rf $TARGET/btgt*
rm -rf $TARGET/book*
rm -rf $TARGET/bad_tests_good_tests_*
mkdir -p $TARGET/images/icons_html
cp -v $SRCDIR/images/*.jpg $TARGET/images
cp -r -v $SRCDIR/images/icons_html $TARGET/images

function html {
	echo ""
	echo "HTML"
	asciidoc -a icons -a iconsdir=images/icons_html -n -d book -a tabsize=4 -a toc2 -a toclevels=3 -n -o $TARGET/btgt.html $MAIN_FILE
	echo "html: $TARGET/btgt.html"
}

function docbook {
	echo ""
	echo "DOCBOOK"
	echo $MAIN_FILE
	/home/tomek/bin/asciidoc-8.6.5/asciidoc.py --backend docbook --doctype book --attribute icons --attribute docinfo1 --attribute tabsize=4 --attribute print --verbose --out-file $TARGET/btgt.xml $MAIN_FILE
	echo "docbook: $TARGET/btgt.xml"

#asciidoc --backend docbook --doctype book --attribute icons --attribute docinfo1 --attribute tabsize=4 --verbose --out-file $TARGET/junit_book.xml $MAIN_FILE
#--attribute tabsize=16
#asciidoc --backend docbook --doctype book --attribute icons --attribute docinfo1 --attribute tabsize=4 --atribute print=true --verbose --out-file $TARGET/junit_book.xml $MAIN_FILE
}

function text {
	echo ""
	echo "TEXT"
	html2text -nobs -style pretty $TARGET/btgt.html > $TARGET/btgt.txt
	echo "text: $TARGET/btgt.txt"
}

function pdfA4 {
echo ""
echo "PDF A4"
#no double.sided for A4
cp $TARGET/btgt.xml $TARGET/btgt.xml
#sed -i 's/TAG_ISBN/ISBN: 978-83-934893-7-4/g' $TARGET/junit_book_ready.xml
#sed -i 's/TAG_PRINTED//g' $TARGET/junit_book_ready.xml
#sed -i "s/TAG_VERSION/pdf_a4_$VER/g" $TARGET/junit_book_ready.xml

xsltproc --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'/home/tomek/btgt/resources/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path /home/tomek/btgt/images/icons/ --stringparam callout.graphics.path /home/tomek/btgt/images/icons/callouts/ --stringparam navig.graphics.path /home/tomek/btgt/images/icons/ --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam paper.type A4 --output $TARGET/btgt.fo $RESDIR/custom-docbook_btgt_a4.xsl $TARGET/btgt_ready.xml

fop -fo $TARGET/btgt.fo -pdf $TARGET/btgt_a4.pdf
FINAL_FILE_NAME=$TARGET/bad_tests_good_tests_A4_$VER.pdf
cp $TARGET/btgt_a4.pdf $FINAL_FILE_NAME
echo "PDF A4 final version: $FINAL_FILE_NAME"
}

function pdfUs {
echo ""
echo "PDF USLetter"
cp $TARGET/btgt.xml $TARGET/btgt_ready.xml
#sed -i 's/TAG_ISBN/ISBN: 978-83-934893-6-7/g' $TARGET/junit_book_ready.xml
#sed -i 's/TAG_PRINTED//g' $TARGET/junit_book_ready.xml
#sed -i "s/TAG_VERSION/pdf_usletter_$VER/g" $TARGET/junit_book_ready.xml
# no double.sided for USLetter
xsltproc --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'/home/tomek/btgt/resources/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path /home/tomek/btgt/images/icons/ --stringparam callout.graphics.path /home/tomek/btgt/images/icons/callouts/ --stringparam navig.graphics.path /home/tomek/btgt/images/icons/ --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam paper.type USletter --output $TARGET/btgt.fo $RESDIR/custom-docbook_btgt_usletter.xsl $TARGET/btgt_ready.xml

fop -fo $TARGET/btgt.fo -pdf $TARGET/btgt_usletter.pdf
FINAL_FILE_NAME=$TARGET/bad_tests_good_tests_USLetter_$VER.pdf
cp $TARGET/btgt_usletter.pdf $FINAL_FILE_NAME
echo "PDF A4 final version: $FINAL_FILE_NAME"
}

function paper {
echo ""
echo "PDF $1 x $2, margin $3 x $4, stylesheet $5"
#sed -i 's/TAG_ISBN/ISBN: 978-83-934893-9-8/g' $TARGET/junit_book_ready.xml
#sed -i 's/TAG_PRINTED/, printed by CreateSpace createspace.com/g' $TARGET/junit_book_ready.xml
#sed -i "s/TAG_VERSION/print_$VER/g" $TARGET/junit_book_ready.xml
#margin 0.85 0.65 - amazon complained
xsltproc --stringparam page.margin.inner $3 --stringparam page.margin.outer $4 --stringparam double.sided 1 --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'/home/tomek/btgt/resources/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path /home/tomek/btgt/images/icons/ --stringparam callout.graphics.path /home/tomek/btgt/images/icons/callouts/ --stringparam navig.graphics.path /home/tomek/btgt/images/icons/ --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam page.width $1 --stringparam page.height $2 --output $TARGET/btgt.fo $RESDIR/$5 $TARGET/btgt_ready.xml

fop -fo $TARGET/btgt.fo -pdf $TARGET/btgt_paper_$6.pdf
#fop -fo $TARGET/junit_book.fo -pdf $TARGET/junit_book_paper_$6.pdf
FINAL_FILE_NAME=$TARGET/bad_tests_good_tests_paper_$6_$VER.pdf
cp $TARGET/btgt_paper_$6.pdf $FINAL_FILE_NAME
echo "PDF final version: $FINAL_FILE_NAME"
}

function epub {
echo ""
echo "ePub"
rm -rf $TARGET/btgt.epub
#mkdir $TARGET/book.epub
cp $BOOKDIR/docinfo.xml $BOOKDIR/btgt-docinfo.xml
#sed -i 's/TAG_ISBN/ISBN: 978-83-934893-8-1/g' $BOOKDIR/book-docinfo.xml
#sed -i 's/TAG_PRINTED//g' $BOOKDIR/book-docinfo.xml
#sed -i "s/TAG_VERSION/epub_$VER/g" $BOOKDIR/book-docinfo.xml
a2x -k -f epub -a docinfo --attribute tabsize=2 --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\) --stringparam admon.graphics.path images/icons_epub/ --stringparam callout.graphics.path images/icons_epub/callouts/ --stringparam navig.graphics.path images/icons_epub/" --fop $MAIN_FILE -v -D $TARGET
FINAL_FILE_NAME=$TARGET/bad_tests_good_tests_$VER.epub
cp $TARGET/btgt.epub $FINAL_FILE_NAME
echo "ePub final version: $FINAL_FILE_NAME"
}

function epubkindle {
echo ""
echo "ePub for Kindle"
rm -rf $TARGET/btgt.epub
#mkdir $TARGET/book.epub
cp $BOOKDIR/docinfo.xml $BOOKDIR/btgt-docinfo.xml
#sed -i 's/TAG_ISBN/ISBN: 978-83-934893-5-0/g' $BOOKDIR/book-docinfo.xml
#sed -i 's/TAG_PRINTED//g' $BOOKDIR/book-docinfo.xml
#sed -i "s/TAG_VERSION/kindle_$VER/g" $BOOKDIR/book-docinfo.xml
a2x -k -f epub -a docinfo --attribute tabsize=2 --icons -d book --stylesheet=resources/kindle.css --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\) --stringparam admon.graphics.path images/icons_epub/ --stringparam callout.graphics.path images/icons_epub/callouts/ --stringparam navig.graphics.path images/icons_kindle/" --fop $MAIN_FILE -v -D $TARGET

#a2x has already created zipped final file from book.epub.d but we have to modify the sources and zip it once again

#bulleted list
#sed -i '/<p class="simpara">/{ N; s/<p class="simpara">\nthe test/\nthe test/ }' $TARGET/btgt.epub.d/OEBPS/ch10.html
#sed -i '/registers,/{ N; s/registers,\n<\/p>/registers,\n/ }' $TARGET/book.epub.d/OEBPS/ch10.html

# numbered lists
#sed -i '/<p class="simpara">/{ N; s/<p class="simpara">\nif the object/\nif the object/ }' $TARGET/book.epub.d/OEBPS/ch02.html
#sed -i '/will be returned,/{ N; s/will be returned,\n<\/p>/will be returned,\n/ }' $TARGET/book.epub.d/OEBPS/ch02.html

cd $TARGET/btgt.epub.d
FINAL_FILE_NAME=btgt_kindle_$VER.epub
zip -r ../$FINAL_FILE_NAME .
echo "ePub-for-kindle final version: $TARGET/$FINAL_FILE_NAME"
}

showopts () {
  while getopts ":f:" optname
    do
      case "$optname" in
        "f")
          #echo "Option $optname has value $OPTARG"
	  case $OPTARG in
		  "html")
			  html
			  ;;
		  "txt")
			  html
			  text
			  ;;
		  "epub")
			  epub
			  ;;
		  "kindle")
			  epubkindle
			  ;;
		  "pdfus")
			  docbook
			  pdfUs
		  ;;
		  "pdfa4")
			  docbook
			  pdfA4
		  ;;
		  "pdf")
			  docbook
			  pdfA4
			  pdfUs
		  ;;
		  "paper")
			  docbook
cp $TARGET/btgt.xml $TARGET/btgt_ready.xml
xmllint --nonet --noout --valid /home/tomek/btgt/target/btgt_ready.xml
#this is a real deal
paper "7.5in" "9.25in" "0.87in" "0.65in" "custom-docbook-font-11.xsl" "75_925_11_mono_087_065"
#this margin looked too small even though everything looked fine when analyzing with interior reviewer
#paper "7.5in" "9.25in" "0.87in" "0.5in" "custom-docbook-font-11.xsl" "75_925_11_mono_05"

# these are not used
#paper "6in" "9in" "0.5in" "0.5in" "custom-docbook-font-10.xsl" "6_9_10"
#paper "6in" "9in" "0.5in" "0.5in" "custom-docbook-font-11.xsl" "6_9_11"
#paper "7.5in" "9.25in" "0.87in" "0.5in" "custom-docbook-font-10.xsl" "75_925_10"
#paper "7.5in" "9.25in" "0.87in" "0.5in" "custom-docbook-font-11.xsl" "75_925_11"
#paper "7.5in" "9.25in" "0.87in" "0.5in" "custom-docbook.xsl" "75_925_12"
  ;;
	  esac
          ;;
        *)
        # Should not occur
          echo "Unknown error while processing options"
          ;;
      esac
    done
  return $OPTIND
}

showargs () {
  for p in "$@"
    do
      echo "[$p]"
    done
}

showopts "$@"
