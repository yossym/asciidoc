all:	VBA.html AsciiCode.html bash.html
# ALL: *.adoc
# 	# asciidoc -a toc -a toclevels=3 -a sectnums -a stylesheet=./scss/asciidoctor.scss VBA.adoc
# 	asciidoc -a toc -a toclevels=3 -a sectnums VBA.adoc
# 	asciidoc -a toc -a toclevels=3 -a sectnums AsciiCode.adoc
# 	asciidoc -a toc -a toclevels=3 -a sectnums bash.adoc

VBA.html:	VBA.adoc Makefile
	asciidoc -a toc -a toclevels=3 -a sectnums VBA.adoc

AsciiCode.html:	AsciiCode.adoc Makefile
	asciidoc -a toc -a toclevels=3 -a sectnums AsciiCode.adoc

bash.html:	bash.adoc
	asciidoc -a toc -a toclevels=3 -a sectnums bash.adoc


