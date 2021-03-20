CC	= asciidoc
# FLAGS	= -a toc2 -a toclevels=3
# FLAGS	= -a toc -a toclevels=3
FLAGS	= -a toc -a toclevels=3 --doctype=book

FILES	= VBA.adoc Makefile VBA*.adoc *vbscript* *Microsof*


all:	VBA.html AsciiCode.html bash.html perl.html

# VBA.html:	VBA.adoc Makefile VBAFunction.adoc VBAKeyword.adoc VBSctipt.adoc VBAvariable.adoc
VBA.html:	$(FILES)
	$(CC) $(FLAGS) VBA.adoc

AsciiCode.html:	AsciiCode.adoc Makefile
	$(CC) $(FLAGS) AsciiCode.adoc

bash.html:	bash.adoc
	$(CC) $(FLAGS) bash.adoc

perl.html:	perl.adoc
	$(CC) $(FLAGS) perl.adoc

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
