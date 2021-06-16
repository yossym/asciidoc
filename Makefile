# CC	= asciidoc
# CC = /usr/local/bin/asciidoc
CC = asciidoctor 
# FLAGS	= -a toc2 -a toclevels=3
# FLAGS	= -a toc -a toclevels=3
# today = ${shell date '+%Y_%m_%d'}
today = ${shell date -I}
# FLAGS	= -a toc -a toclevels=3 --doctype=book -a revdate=${today}
FLAGS	= -a toc -a toclevels=3 -a revdate=${today}

FILES	= VBA.adoc Makefile VBA*.adoc *vbscript* *Microsof* OfficeVBAreference.adoc


all:	VBA.html AsciiCode.html bash.html perl.html gnuplot.html VariousTechnologies.html

# VBA.html:	VBA.adoc Makefile VBAFunction.adoc VBAKeyword.adoc VBSctipt.adoc VBAvariable.adoc
VBA.html:	$(FILES)
	$(CC) $(FLAGS) VBA.adoc

AsciiCode.html:	AsciiCode.adoc Makefile
	$(CC) $(FLAGS) AsciiCode.adoc

bash.html:	bash.adoc
	$(CC) $(FLAGS) bash.adoc

perl.html:	perl.adoc
	$(CC) $(FLAGS) perl.adoc

sample.html:	sample.adoc
	$(CC) $(FLAGS) sample.adoc

gnuplot.html:	gnuplot.adoc
	$(CC) $(FLAGS) gnuplot.adoc


VariousTechnologies.html:	VariousTechnologies.adoc
	$(CC) $(FLAGS) VariousTechnologies.adoc

# all:	VBA.html AsciiCode.html bash.html
# # ALL: *.adoc
# # 	# asciidoc -a toc -a toclevels=3 -a sectnums -a stylesheet=./scss/asciidoctor.scss VBA.adoc
# # 	asciidoc -a toc -a toclevels=3 -a sectnums VBA.adoc
# # 	asciidoc -a toc -a toclevels=3 -a sectnums AsciiCode.adoc
# # 	asciidoc -a toc -a toclevels=3 -a sectnums bash.adoc
#
# VBA.html:	VBA.adoc Makefile
# 	asciidoc -a toc2  VBA.adoc
# 	#asciidoc -a toc2 -a theme=flask VBA.adoc
#
# AsciiCode.html:	AsciiCode.adoc Makefile
# 	asciidoc -a toc  AsciiCode.adoc
#
# bash.html:	bash.adoc
# 	asciidoc -a toc  bash.adoc
#
#
clean:
	\rm *.html
