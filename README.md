# CVXOPT wheels for macOS and Linux

This repository automates [CVXOPT](https://github/com/cvxopt/cvxopt) wheel building using [multibuild](https://github.com/matthew-brett/multibuild) and [Travis CI](https://travis-ci.org/cvxopt/cvxopt-wheels).

[![Build Status](https://travis-ci.org/cvxopt/cvxopt-wheels.svg?branch=master)](https://travis-ci.org/cvxopt/cvxopt-wheels)

## Copyright and license

CVXOPT is free software; you can redistribute it and/or modify it under the terms of the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

CVXOPT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.html) for more details.

## What is being built?

We currently build self-contained wheels for macOS and Linux ([manylinux1](https://www.python.org/dev/peps/pep-0513/)).
Linux wheels are linked against [OpenBLAS](http://www.openblas.net) whereas macOS wheels are linked against the built-in BLAS/LAPACK library included in the [Accelerate](https://developer.apple.com/reference/accelerate) framework.

The build process performs the following steps:

- builds OpenBLAS (Linux only)
- builds optional dependencies ([DSDP](http://www.mcs.anl.gov/hs/software/DSDP/), [FFTW](http://www.fftw.org), [GLPK](https://www.gnu.org/software/glpk/), and [GSL](https://www.gnu.org/software/gsl/))
- downloads SuiteSparse source
- builds CVXOPT wheel, linking against dependencies
- processes wheel using [delocate](https://github.com/matthew-brett/delocate) (macOS) or [auditwheel](https://github.com/pypa/auditwheel) (Linux) to include dependencies in wheel
- uploads the wheel to a [Rackspace container](https://3f23b170c54c2533c070-1c8a9b3114517dc5fe17b7c3f8c63a43.ssl.cf2.rackcdn.com)

Version numbers for the dependencies can be found in the `library_builders.sh` source file.

## Triggering a building

The build process is triggered by making a commit to the `cvxopt-wheels` repository. The variable `BUILD_COMMIT` in `.travis.yml` specifies which commit from the CVXOPT repository to build.

