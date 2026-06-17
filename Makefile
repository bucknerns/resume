OUT_DIR=output
IN_DIR=.
STYLES_DIR=styles
STYLE=chmduquesne
PYTHON=~/code/env/bin/python

all: pdf

pdf: dir
	@mtxrun --generate > /dev/null 2>&1
	@for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		pandoc --standalone --template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			--top-level-division=section \
			--variable papersize=A4 \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		mtxrun --path=$(OUT_DIR) --result=$$FILE_NAME.pdf --script context $$FILE_NAME.tex > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
	done

html: dir
	@for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		pandoc --standalone --embed-resources --css $(STYLES_DIR)/$(STYLE).css \
			--from markdown --to html \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f; \
		$(PYTHON) -m weasyprint $(OUT_DIR)/$$FILE_NAME.html $(OUT_DIR)/$$FILE_NAME.pdf; \
	done

dir:
	@mkdir -p $(OUT_DIR)

clean:
	rm -f $(OUT_DIR)/*
