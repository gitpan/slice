##
##
##

test:
	../slice -x -o "ENuUNDEF:file.html.en@u+x" -o "DEuUNDEF:file.html.de@u+x" file.in
	@cmp file.html.en.OK file.html.en || echo "FAILED"
	@cmp file.html.de.OK file.html.de || echo "FAILED"
	@echo "OK"

test.ok:
	cp file.html.en file.html.en.OK
	cp file.html.de file.html.de.OK

clean:
	-rm -f file.html.en
	-rm -f file.html.de

##EOF##
