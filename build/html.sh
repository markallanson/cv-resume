mkdir -p ../out

pandoc ../cv.md \
-s \
-o ../out/cv.html \
--metadata pagetitle="Mark Allanson - CV" \
-c ../styles/basic.css
