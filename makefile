out := ./out
cv_filename = mark-allanson-cv
metadata := --metadata pagetitle="Mark Allanson - CV"
default_styles := -c ./styles/basic.css
pandoc_exec = pandoc -s $(metadata) -o $(out)/$(cv_filename).$(cv_extension) $(default_styles)

define input_files
header.md \
contact.md \
personal-statement.md \
2010-morgan-stanley.md \
2009-accenture-jpm.md \
2006-accenture-assureweb.md \
2004-accenture-natgrid.md \
2004-accenture-thameswater.md \
1999-triniteq.md education.md other.md
endef

all: clean html html_index pdf docx markdown

html: cv_extension:=html
html: create_out
	$(pandoc_exec) --self-contained $(input_files) other-formats-links.md

html_index: html
	cp $(out)/$(cv_filename).html $(out)/index.html

pdf: cv_extension:=pdf
pdf: create_out
	$(pandoc_exec) -t html -V papersize=A4 -c ./styles/pdf.css $(input_files)

docx: cv_extension:=docx
docx: create_out
	$(pandoc_exec) -V papersize=A4 --reference-doc=styles/basic.docx $(input_files)

markdown: cv_extension:=md
markdown: create_out
	$(pandoc_exec) $(input_files)

create_out:
	mkdir -p $(out)

clean:
	rm -rf $(out)
