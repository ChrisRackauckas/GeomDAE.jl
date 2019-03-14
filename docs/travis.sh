#!/bin/bash

if [ ${TRAVIS_OS_NAME} = "linux" ]; then
    julia --color=yes -e 'cd(Pkg.dir("GeometricIntegrators")); include(joinpath("docs", "make.jl"))';
fi