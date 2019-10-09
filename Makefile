PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

move:
	cd inst/vign;\
	cp rvertnet_vignette.md ../../vignettes;\
	cp -rf figure/* ../../vignettes/figure/

rmd2md:
	cd vignettes;\
	mv rvertnet_vignette.md rvertnet_vignette.Rmd

all:
	${RSCRIPT} -e 'library(methods); devtools::compile_dll()'

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

doc:
	@mkdir -p man
	${RSCRIPT} -e "library(methods); devtools::document()"

install:
	R CMD INSTALL .

build:
	R CMD build .

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD check --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck
