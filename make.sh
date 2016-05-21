#!/bin/sh

coffee -c -b -o build src/*
browserify build/main.js -o build/app.js
uglifyjs build/app.js > build/app.min.js
