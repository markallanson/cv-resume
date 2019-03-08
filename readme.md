Mark Allanson - CV/Resume
=========================

This repository contains the raw source and build system for my CV/Resume only. [You can find the latest published 
release here](https://markallanson.net/cv).

The resume build system uses and requires an installation of [make](https://www.gnu.org/software/make/), 
[pandoc](https://pandoc.org/) and [wkhtmltopdf](https://wkhtmltopdf.org).

Building
--------
Simply run `make all` to build all resume formats into the `./out/` directory. There are also targets representing
the format you want to build `html`, `pdf`, `docx` and `markdown`.