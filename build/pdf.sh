mkdir -p ../out

pandoc ../cv.md \
-s \
-o ../out/cv.pdf \
--metadata pagetitle="Mark Allanson - CV" \
-t html \
-c ../styles/basic.css \
-c ../styles/pdf.css \
-V papersize=A4