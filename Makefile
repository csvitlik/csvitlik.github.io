## Command Line ########################################################
ifeq ($(V),1)
	Q =
else
	Q = @
endif

## Commands ############################################################
chown = $(Q)chown
cp = $(Q)cp -a
echo = $(Q)echo
find = $(Q)find
mkdir = $(Q)mkdir -p
pandoc = $(Q)pandoc
rm = $(Q)rm -rf
rsync = $(Q)rsync -Pav

## Settings ############################################################
www_uri = csvitlik.github.io

objdir = .
srcdir = .

# $(srcdir)/*.md -> $(objdir)/*.html
src = $(wildcard $(srcdir)/*.md)
obj = index.html

# Inline CSS
stylesheets = $(srcdir)/normalize.css $(srcdir)/style.css
# regular expression taken from `perldoc perlrecharclass`
inline_css = $(shell cat $(stylesheets) | sed -r -e 's/[\t\n\f\r ]+/ /g')

## Target rules ########################################################
all: $(objdir) $(obj)

$(objdir):
	$(mkdir) $@

index.html: README.md
	$(pandoc) \
		-f markdown -t html \
		-V css="$(inline_css)" \
		-V title="$(shell sed -re 's/(# | \{.*)//g;1q' $<)" \
		--template=$(srcdir)/page.tpl.html \
		-o $@ \
		$<

clean:
	$(rm) $(obj) $(www_uri).zip

dist: clean
	cd .. ; zip -r -9 $(www_uri).zip $(www_uri) -x '*/.git*'
	mv ../$(www_uri).zip .

.PHONY: $(objdir) $(obj)
