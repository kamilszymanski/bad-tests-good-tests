#generates HTML version of the book

VER=$(date +"%Y%m%d_%H%M")

echo ""
echo "HTML"
mkdir -p target
asciidoc -a icons -d book -a toc2 -a toclevels=3 -n -o target/bad_tests_good_tests_tomek_kaczanowski_$VER.html book.txt
