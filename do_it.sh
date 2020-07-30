#!/bin/bash
export PYTHON_EXEC=`which python3`
echo "Cleaning cached indexes"
rm scraped/*.html

echo "Caching Spec results"
$PYTHON_EXEC ./fetch-pages.py | grep "Fetching"
echo "Analyze pages"
$PYTHON_EXEC ./analyze-pages.py
echo "Done analyzing"
$PYTHON_EXEC ./check-autoparallel.py
echo "Making graphs"
$PYTHON_EXEC ./make-graphs.py

open *.png
