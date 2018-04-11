# CVXOPT wheels for macOS, Linux, and Windows

This repository automates [CVXOPT](https://github/com/cvxopt/cvxopt) wheel building using [multibuild](https://github.com/matthew-brett/multibuild), [Travis CI](https://travis-ci.org/cvxopt/cvxopt-wheels), and [AppVeyor](https://ci.appveyor.com/project/martinandersen/cvxopt-wheels).

[![Build Status](https://travis-ci.org/cvxopt/cvxopt-wheels.svg?branch=master)](https://travis-ci.org/cvxopt/cvxopt-wheels)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/martinandersen/cvxopt-wheels?branch=master&svg=true)](https://ci.appveyor.com/project/martinandersen/cvxopt-wheels)

## Copyright and license

CVXOPT is free software; you can redistribute it and/or modify it under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

CVXOPT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) for more details.

## What is being built?

We currently build the following:

- Self-contained wheels for macOS and Linux ([manylinux1](https://www.python.org/dev/peps/pep-0513/)), including the optional dependencies DSDP, FFTW, GLPK, and GSL. The wheels are linked against [OpenBLAS](http://www.openblas.net).
- Wheels for Windows (x86-64 only) *without* any of the optional dependencies. The wheels are linked against MKL and *not self-contained*: MKL must be installed (e.g., via Pip or Conda) for these wheels to work.

The build process performs the following steps:

- downloads SuiteSparse source
- builds OpenBLAS (macOS/Linux)
- builds all optional dependencies ([DSDP](http://www.mcs.anl.gov/hs/software/DSDP/), [FFTW](http://www.fftw.org), [GLPK](https://www.gnu.org/software/glpk/), and [GSL](https://www.gnu.org/software/gsl/)) (macOS/Linux)
- builds CVXOPT wheel, linking against dependencies
- processes wheel using [delocate](https://github.com/matthew-brett/delocate) (macOS) or [auditwheel](https://github.com/pypa/auditwheel) (Linux) to include dependencies in wheel
- uploads the wheel to a [Rackspace container](https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com) (macOS/Linux)

Version numbers for the dependencies can be found in the `library_builders.sh` source file.

## Triggering a build

The build process is triggered by making a commit to the `cvxopt-wheels` repository. The variable `BUILD_COMMIT` in `.travis.yml` and `.appveyor.yml` specifies which commit from the CVXOPT repository to build.
