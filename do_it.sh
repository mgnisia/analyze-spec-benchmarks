#!/bin/bash

#PYTHON=python3.8
export MY_PYTHON=/usr/local/opt/python@3.8/bin/python3.8

echo "Cleaning cached indexes"
rm scraped/*.html

echo "Caching Spec results"
$MY_PYTHON ./fetch-pages.py | grep "Fetching"
echo "Analyze pages"
$MY_PYTHON ./analyze-pages.py
echo "Done analyzing"
$P$MY_PYTHONYTHON ./check-autoparallel.py
echo "Making graphs"
$MY_PYTHON ./make-graphs.py

open *.png
