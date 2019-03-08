out := ./out
cv_filename = mark-allanson-cv
metadata = --metadata pagetitle="Mark Allanson - CV"
default_styles := -c ./styles/basic.css
pandoc_exec = pandoc -s $(metadata) -o $(out)/$(cv_filename).$(cv_extension) $(default_styles)

define input_files
./sections/header.md \
./sections/contact.md \
./sections/personal-statement.md \
./sections/2010-morgan-stanley.md \
./sections/2009-accenture-jpm.md \
./sections/2006-accenture-assureweb.md \
./sections/2005-accenture-ffe.md \
./sections/2004-accenture-natgrid.md \
./sections/2004-accenture-thameswater.md \
./sections/1999-triniteq.md \
./sections/education.md \
./sections/other.md \
./sections/footer.md
endef

all: clean html html_index pdf docx markdown

html: cv_extension:=html
html: create_out
	$(pandoc_exec) --self-contained $(input_files) ./sections/other-formats-links.md

html_index: html
	cp $(out)/$(cv_filename).html $(out)/index.html

pdf: cv_extension:=pdf
pdf: create_out
	$(pandoc_exec) -t html -V papersize=A4 -c ./styles/pdf.css $(input_files)

docx: cv_extension:=docx
markdown: metadata:=
docx: create_out
	$(pandoc_exec) -V papersize=A4 --reference-doc=styles/basic.docx $(input_files)

markdown: cv_extension:=md
markdown: metadata:=
markdown: create_out
	$(pandoc_exec) $(input_files)

create_out:
	mkdir -p $(out)

clean:
	rm -rf $(out)
