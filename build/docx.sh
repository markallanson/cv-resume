mkdir -p ../out

pandoc ../cv.md -s \
-o ../out/cv.docx \
--reference-doc=../styles/basic.docx \
-V papersize=A4