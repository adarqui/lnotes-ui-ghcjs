build:
	stack build --fast

clean:
	stack clean

until:
	until stack build; do echo eek; done

sync:
	rsync -av ./static/dist/ /Users/x/code/github/adarqui/ln-yesod/static/lnotes.dist/

build-web:
	stack build --fast
	find . -name "lnotes-ui-ghcjs-exe.jsexe" -exec rsync -av {}/ ./static/dist/ \;
	# fake min.js just so we don't have to change anything in dev mode
	cp static/dist/all.js static/dist/all.min.js
	make sync

production: build-web
	ccjs static/dist/all.js --compilation_level=ADVANCED_OPTIMIZATIONS > static/dist/all.min.js
	zopfli -i1000 static/dist/all.min.js > static/dist/all.min.js.gz
	make sync
