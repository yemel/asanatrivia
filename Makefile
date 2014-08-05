

build: clean
	mkdir gen

	cp -r res gen

	mkdir gen/lib
	cp bower_components/underscore/underscore.js gen/lib
	cp bower_components/angular/angular.min.js gen/lib
	cp bower_components/angular-route/angular-route.min.js gen/lib
	
	coffee -co gen/ src/app.coffee
	jade --pretty -o gen/ src/index.jade
	jade --pretty -o gen/tpl src/tpl


clean:
	rm -rf gen


run:
	# Don't use this in a production environment
	serb gen


devserver:
	# Auto-reloading, auto-recompiling local http fileserver
	# Depends on 'serb' (npm) and 'entr' (gzip download)
	find src res | entr -r make build run --no-print-directory


deps:
	sudo npm install -g coffee-script jade serb
	bower install angular angular-route underscore

.SILENT: run devserver
.PHONY: build run clean