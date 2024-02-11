PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

vignette:
	${RSCRIPT} vignettes/precompile.R

test:
	${RSCRIPT} -e 'library(methods); devtools::test()'

eg:
	${RSCRIPT} -e 'library(methods); devtools::run_examples(run_dontrun=TRUE)'

doc:
	@mkdir -p man
	${RSCRIPT} -e "library(methods); devtools::document()"

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD check --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"

check_windows:
	${RSCRIPT} -e "devtools::check_win_devel(); devtools::check_win_release()"
