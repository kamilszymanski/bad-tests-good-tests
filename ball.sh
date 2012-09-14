# generates html, ePub, txt and pdf outputs

SRCDIR=/home/tomek/btgt
IMGDIR=$SRCDIR/images
ICONSDIR=$IMGDIR/icons
MAIN_FILE=$SRCDIR/book.txt
RESDIR=$SRCDIR/resources
TARGET=$SRCDIR/target
BACKUP=$SRCDIR/backup
BOOKDIR=$SRCDIR/book
VER=$(date +"%Y%m%d_%H%M")
echo ""
echo "VERSION: $VER"

rm -r $TARGET/bad_tests_*.*
rm -f $TARGET/*.html
rm -rf $TARGET/images
rm -rf $TARGET/book_*
mkdir -p $TARGET/images
cp $SRCDIR/images/*.png $TARGET/images
cp $SRCDIR/images/*.jpg $TARGET/images

echo ""
echo "HTML"
asciidoc -a icons -d book -a toc2 -a toclevels=3 -n -o $TARGET/book.html $MAIN_FILE

echo ""
echo "DOCBOOK"
asciidoc --backend docbook --doctype book --attribute icons --verbose --out-file $TARGET/book.xml $MAIN_FILE
#asciidoc --backend docbook --doctype book --attribute icons --attribute docinfo1 --atribute print=true --verbose --out-file $TARGET/book.xml $MAIN_FILE
#asciidoc --backend docbook --doctype book --attribute icons --verbose --out-file $TARGET/book.xml $MAIN_FILE

#
#echo ""
#echo "TEXT"
#html2text -nobs -style pretty $TARGET/book.html > $TARGET/book.txt

#echo ""
#echo "PDF"
#a2x -k -f pdf -a docinfo1 -d book --xsl-file $SRCDIR/resources/custom-format.xml --fop $SRCDIR/book/book.txt -v -D $TARGET
#a2x -k -f pdf -a docinfo1 -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $SRCDIR/book/book.txt -v -D $TARGET
#a2x -k -f pdf -a docinfo1 -d book --xsltproc-opts "--stringparam body.font.master 11 --stringparam generate.toc \"book toc,title,table,figure\" --param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $SRCDIR/book/book.txt -v -D $TARGET
#mv $TARGET/book.pdf $TARGET/book_font_11.pdf


#echo ""
#echo "print versions preparation"
#sed -i 's/contentwidth="[0-9][0-9][0-9]" //g' $TARGET/book_print.xml
#xmllint --nonet --noout --valid $TARGET/book_print.xml

echo ""
echo "PDF A4"
#no double.sided for A4
cp $TARGET/book.xml $TARGET/book_ready.xml
sed -i 's/TAG_ISBN/ISBN: TODO/g' $TARGET/book_ready.xml
sed -i 's/TAG_PRINTED//g' $TARGET/book_ready.xml
sed -i "s/TAG_VERSION/pdf_a4_$VER/g" $TARGET/book_ready.xml
xmllint --nonet --noout --valid $TARGET/book_ready.xml

xsltproc --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'$RESDIR/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path $SRCDIR/images/icons/ --stringparam callout.graphics.path $ICONSDIR/callouts/ --stringparam navig.graphics.path $ICONSDIR --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam paper.type A4 --output $TARGET/book.fo $RESDIR/custom-docbook_a4.xsl $TARGET/book_ready.xml

fop -fo $TARGET/book.fo -pdf $TARGET/book_a4.pdf
cp $TARGET/book_a4.pdf $TARGET/bad_tests_good_tests_A4_$VER.pdf
#gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$TARGET/book_pdf_a4.pdf /home/tomek/book/img/cover_a4.pdf $TARGET/book_pre_a4.pdf


#pdfjoin /home/tomek/book/img/cover_a4.pdf $TARGET/book_pre_a4.pdf --outfile $TARGET/book_pdf_a4.pdf
#a2x -a pdfa4=true -a icons --icons-dir $ICONSDIR -k -f pdf -a docinfo1 -d book --xsltproc-opts "--stringparam header.column.widths \"1 4 1\" --stringparam paper.type A4 --stringparam generate.toc \"book toc,title,table,figure\" --param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $BOOKDIR/book.txt -v -D $TARGET
#mv $TARGET/book.pdf $TARGET/book_a4.pdf

echo ""
echo "PDF USLetter"
cp $TARGET/book.xml $TARGET/book_ready.xml
sed -i 's/TAG_ISBN/ISBN: TODO/g' $TARGET/book_ready.xml
sed -i 's/TAG_PRINTED//g' $TARGET/book_ready.xml
sed -i "s/TAG_VERSION/pdf_usletter_$VER/g" $TARGET/book_ready.xml
xmllint --nonet --noout --valid $TARGET/book_ready.xml
# no double.sided for USLetter
echo "US XSLTPROC"
xsltproc --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'$RESDIR/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path $ICONSDIR --stringparam callout.graphics.path $ICONSDIR/callouts/ --stringparam navig.graphics.path $ICONSDIR --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam paper.type USletter --output $TARGET/book.fo $RESDIR/custom-docbook_usletter.xsl $TARGET/book_ready.xml
echo "US FOP"
fop -fo $TARGET/book.fo -pdf $TARGET/book_usletter.pdf
cp $TARGET/book_usletter.pdf $TARGET/bad_tests_good_tests_USLetter_$VER.pdf
#gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=$TARGET/book_pdf_usletter.pdf /home/tomek/book/img/cover_usletter.pdf $TARGET/book_pre_usletter.pdf


#pdfjoin /home/tomek/book/img/cover_usletter.pdf $TARGET/book_pre_usletter.pdf --outfile $TARGET/book_pdf_usletter.pdf

echo ""
echo "PDF 7.5 x 9.25"
cp $TARGET/book.xml $TARGET/book_ready.xml
sed -i 's/TAG_ISBN/ISBN: TODO/g' $TARGET/book_ready.xml
sed -i 's/TAG_PRINTED/, TODO printed by CreateSpace createspace.com/g' $TARGET/book_ready.xml
sed -i "s/TAG_VERSION/print_$VER/g" $TARGET/book_ready.xml
xmllint --nonet --noout --valid $TARGET/book_ready.xml
#xsltproc --stringparam page.margin.inner 0.85in --stringparam page.margin.outer 0.65in --stringparam double.sided 1 --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'/home/tomek/docs/testbook/resources/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path /home/tomek/book/book/images/icons/ --stringparam callout.graphics.path /home/tomek/book/book/images/icons/callouts/ --stringparam navig.graphics.path /home/tomek/book/book/images/icons/ --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam page.width 7.5in --stringparam page.height 9.25in --output /home/tomek/docs/testbook/target/book.fo /home/tomek/bin/asciidoc-8.6.5/docbook-xsl/fo.xsl $TARGET/book_ready.xml
#margin 0.85 0.65 - amazon complained
xsltproc --stringparam page.margin.inner 0.87in --stringparam page.margin.outer 0.50in --stringparam double.sided 1 --stringparam header.column.widths "1 4 1" --stringparam generate.toc "book toc,title,table,figure" --param local.l10n.xml document\(\'$RESDIR/custom-format.xml\'\) --stringparam callout.graphics 1 --stringparam navig.graphics 1 --stringparam admon.textlabel 0 --stringparam admon.graphics 1 --stringparam admon.graphics.path /home/tomek/book/book/images/icons/ --stringparam callout.graphics.path $ICONSDIR/callouts/ --stringparam navig.graphics.path $ICONSDIR --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0 --stringparam page.width 7.5in --stringparam page.height 9.25in --output $TARGET/book.fo $RESDIR/custom-docbook.xsl $TARGET/book_ready.xml

fop -fo $TARGET/book.fo -pdf $TARGET/book_paper.pdf
cp $TARGET/book_paper.pdf $TARGET/bad_tests_good_tests_paper_$VER.pdf


#stats.sh

#echo ""
#echo "ePub"
#xmllint --nonet --noout --valid /home/tomek/docs/testbook/target/book.xml
#rm -rf /home/tomek/docs/testbook/target/book.epub.d
#mkdir /home/tomek/docs/testbook/target/book.epub.d
#xsltproc --param local.l10n.xml document\(\'/home/tomek/docs/testbook/resources/custom-format.xml\'\) --stringparam callout.graphics 0 --stringparam navig.graphics 0 --stringparam admon.textlabel 1 --stringparam admon.graphics 0 --stringparam toc.section.depth 1 --stringparam chunk.section.depth 0  /home/tomek/bin/asciidoc-8.6.5/docbook-xsl/epub.xsl /home/tomek/docs/testbook/target/book.xml

#a2x -k -f epub -a docinfo1 -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $SRCDIR/book/book.txt -v -D $TARGET
#cp $TARGET/book.epub $TARGET/practical_unit_testing_with_testng_and_mockito_$VER.epub

echo ""
echo "ePub"
#a2x -k -f epub -a docinfo1 --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $SRCDIR/book/book.txt -v -D $TARGET
cp $SRCDIR/docinfo.xml $TARGET/book-docinfo.xml
sed -i 's/TAG_ISBN/ISBN: TODO/g' $TARGET/book-docinfo.xml
sed -i 's/TAG_PRINTED//g' $TARGET/book-docinfo.xml
sed -i "s/TAG_VERSION/epub_$VER/g" $TARGET/book-docinfo.xml
a2x -k -f epub -a docinfo --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$RESDIR/custom-format.xml\'\) --stringparam admon.graphics.path images/icons_epub/ --stringparam callout.graphics.path images/icons_epub/callouts/ --stringparam navig.graphics.path images/icons_epub/" --fop $MAIN_FILE -v -D $TARGET
cp $TARGET/book.epub $TARGET/bad_tests_good_tests_$VER.epub
#a2x -k -f epub -a docinfo1 --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\) --stringparam admon.graphics.path images/icons/ --stringparam callout.graphics.path images/icons/callouts/ --stringparam navig.graphics.path images/icons/" --fop $SRCDIR/book/book.txt -v -D $TARGET
#a2x -k -f epub -a docinfo1 --icons --icons-dir ../images/icons/ -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\) --stringparam admon.graphics.path /home/tomek/book/book/images/icons/ --stringparam callout.graphics.path /home/tomek/book/book/images/icons/callouts/ --stringparam navig.graphics.path /home/tomek/book/book/images/icons/" --fop $SRCDIR/book/book.txt -v -D $TARGET

echo ""
echo "ePub for Kindle"
#a2x -k -f epub -a docinfo1 --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$SRCDIR/resources/custom-format.xml\'\)" --fop $SRCDIR/book/book.txt -v -D $TARGET
cp $SRCDIR/docinfo.xml $TARGET/book-docinfo.xml
sed -i 's/TAG_ISBN/ISBN: TODO/g' $TARGET/book-docinfo.xml
sed -i 's/TAG_PRINTED//g' $TARGET/book-docinfo.xml
sed -i "s/TAG_VERSION/epub_$VER/g" $TARGET/book-docinfo.xml
a2x -k -f epub -a docinfo --icons -d book --xsltproc-opts "--param local.l10n.xml document\(\'$RESDIR/custom-format.xml\'\) --stringparam admon.graphics.path images/icons_epub/ --stringparam callout.graphics.path images/icons_epub/callouts/ --stringparam navig.graphics.path images/icons_kindle/" --fop $MAIN_FILE -v -D $TARGET
mv $TARGET/book.epub $TARGET/book_for_kindle.epub


