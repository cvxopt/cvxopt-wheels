# CVXOPT wheels for macOS, Linux, and Windows

This repository automates [CVXOPT](https://github.com/cvxopt/cvxopt) wheel building using [multibuild](https://github.com/matthew-brett/multibuild), [Travis CI](https://app.travis-ci.com/cvxopt/cvxopt-wheels), and [AppVeyor](https://ci.appveyor.com/project/martinandersen/cvxopt-wheels).

[![Build Status](https://app.travis-ci.com/cvxopt/cvxopt-wheels.svg?branch=master)](https://app.travis-ci.com/github/cvxopt/cvxopt-wheels)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/martinandersen/cvxopt-wheels?branch=master&svg=true)](https://ci.appveyor.com/project/martinandersen/cvxopt-wheels)

## Copyright and license

CVXOPT is free software; you can redistribute it and/or modify it under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

CVXOPT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) for more details.

## What is being built?

We currently build the following:

- Self-contained wheels for macOS and Linux ([manylinux1](https://www.python.org/dev/peps/pep-0513/)), including the optional dependencies DSDP, FFTW, GLPK, and GSL. The Linux wheels are linked against [OpenBLAS](http://www.openblas.net), and the macOS wheels are linked against [Accelerate](https://developer.apple.com/documentation/accelerate?language=objc).
- Wheels for Windows without any of the optional dependencies (Python 3.5+ wheels include GLPK). The wheels are linked against OpenBLAS.

The build process performs the following steps:

- downloads SuiteSparse source
- builds OpenBLAS (Linux)
- builds all optional dependencies ([DSDP](http://www.mcs.anl.gov/hs/software/DSDP/), [FFTW](http://www.fftw.org), [GLPK](https://www.gnu.org/software/glpk/), and [GSL](https://www.gnu.org/software/gsl/)) (macOS/Linux)
- builds CVXOPT wheel, linking against dependencies
- processes wheel using [delocate](https://github.com/matthew-brett/delocate) (macOS) or [auditwheel](https://github.com/pypa/auditwheel) (Linux) to include dependencies in wheel
- uploads wheel to a Rackspace container (macOS/Linux) or to [AppVeyor cloud storage](https://ci.appveyor.com/project/martinandersen/cvxopt-wheels/history) (Windows)

Version numbers for the dependencies can be found in the `library_builders.sh` source file.

## Triggering a build

The build process is triggered by making a commit to the `cvxopt-wheels` repository. The variable `BUILD_COMMIT` in `.travis.yml` and `.appveyor.yml` specifies which commit from the CVXOPT repository to build.
