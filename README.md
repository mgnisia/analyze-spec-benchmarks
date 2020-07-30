# SPEC benchmarks

A set of Python scripts to fetch benchmarks spec.org, analyze them, and output some text & PNG files.
Original version by Jeff Preshing in February 2012.
Released to the public domain.

Forked from patched version by damageboy: https://github.com/damageboy/analyze-spec-benchmarks

For more information:
http://preshing.com/20120208/a-look-back-at-single-threaded-cpu-performance


## Requirements

* Python 3 is required. Tested on Python 3.8.
* `pip3 install future` - scripts have been pass through `futurize` and `pasteurize`, so they ought to work on python 2.7 too
* `pip3 install lxml` - lxml is required if you want to fetch all the data from SPEC's website. Otherwise, you can download aggregated data from: https://github.com/damageboy/analyze-spec-benchmarks/releases/download/data/scraped-2019-05-21.tar.xz
  You could probably rewrite the lxml part using one of Python's built-in modules; I didn't bother.
* `pip3 install pycairo` - pycairo is optional if you want to generate the SVG files.
* `pip3 install pillow` - PIL is optional if you want those PNG files to have high-quality anti-aliasing.
* If you are going to republish any results, you need to abide by SPEC's fair use policy. http://www.spec.org/fairuse.HTML

## Virtual Environment

You can run the scripts in a virtual environment provided by `pipenv`. If you are using macos, the setup of `pycairo` can cause a problems due to a missing `pkg-config`. The latter can be installed by `brew install pkg-config`.

### Setup

1. `pip3 install pipenv`
2. `pipenv install`
3. `pipenv shell`
4. `bash do_it.sh`


Collecting SPEC's data
----------------------
Run `./do_it.sh` to run all scripts in succession. 

These scripts work with the individual benchmarks in each SPEC result, and not the geometric average which SPEC lists in their CSV downloads. Currently, the only way to access these individual benchmark results is to scrape each result page from their website as text and/or HTML.

If you want to skip the steps in this section, you can simply download the aggregated result files from [here (updated on May 21<sup>st</sup>, 2019)](https://github.com/damageboy/analyze-spec-benchmarks/releases/download/data/scraped-2019-05-21.tar.xz) and extract them to this folder.

If you want to scrape & aggregate the results yourself, proceed as follows:

1. Run fetch-pages.py. As of this writing, this script downloads ~60,000 individual pages from SPEC's website and stores them to a folder named "scraped". It's > 1GB of data, but may be more in the future. The script launches a pool of 20 subprocesses to speed up the download process, so it completes in a matter of minutes. Some requests may time out and break the script; if that happens, simply run the script again. All previously downloaded pages will not be downloaded again. Note that if SPEC changes their website in the future, the script will need to be updated.

2. Run analyze-pages.py. This will scan all the pages downloaded by the previous script, and output two CSV files: `summaries.txt` and `benchmarks.txt`. These files will be used as inputs for the remaining scripts.


Determining which benchmarks took advantage of autoparallel, and disqualifying them
-----------------------------------------------------------------------------------

As described in the blog post, certain benchmarks were disqualified from the results due to automatic parallelization. To see the list, search `DISQUALIFIED_BENCHMARKS` in [`make-graphs.py`](make-graphs.py).

This list was obtained by running [`check-autoparallel.py`](check-autoparallel.py). For every benchmark run with autoparallelization, this script finds the highest multiple of that benchmark relative to the geometric average of all benchmarks in that result. The top six SPECint and SPECfp benchmarks were disqualified.

Obviously, I've assumed that the compiler was not able to automatically parallelize any of the benchmarks below that, and I feel the output of check-autoparallel.py currently makes this assumption reasonable. If this assumption is wrong, I doubt it would alter the conclusions in the blog post. (But of course, that's another assumption...)


Generating the graphs
---------------------

Run [`make-graphs.py`](make-graphs.py). It outputs the following:

* identified_cpus.txt
	The right column contains a list of all processor names encountered in the input, along with the source filename. The left column contains the recognized brand name, model name and MHz. I used this file to develop & debug the identifyCPU() function found in the script. If new processors are introduced, this function may need to adapt. It might be a good idea to do a diff of this file generated from the latest SPEC data against a copy generated from older data.
* int_report.txt
	The first two lines show the automatically computed conversion ratios between CINT95, CINT2000 and CINT2006. The rest of the file groups all the results by family, then sorts them by hardware release date and normalized SPECint2006 result value. Each line shows the benchmark suite and line number. You should be able to pick out certain points on the PNG graph, find them in this text file, locate the corresponding line in the CSV, and use that to find the detailed html/PDF result page on SPEC's website.
* fp_report.txt
	Same thing as int_report.txt, but for floating-point benchmarks.
* Graphs similar to the ones you'll find at: http://preshing.com/20120208/a-look-back-at-single-threaded-cpu-performance
  * int_graph.svg
  * fp_graph.svg

Charts Generated on 2020-01-18
------------------------------

## Integer
![](int_graph.svg)

## Floating Point
![](fp_graph.svg)

-----
SPECint(R) and SPECfp(R) are registered trademarks of the Standard Performance Evaluation Corporation (SPEC).
