
# GeometricIntegrators.jl

*Julia library of geometric integrators for ordinary differential equations and differential algebraic equations.*

[![License](https://img.shields.io/badge/license-MIT%20License-blue.svg)](LICENSE.md)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://ddmgni.github.io/GeometricIntegrators.jl/latest/)
[![Build Status](https://travis-ci.org/DDMGNI/GeometricIntegrators.jl.svg?branch=master)](https://travis-ci.org/DDMGNI/GeometricIntegrators.jl)
[![Coverage Status](https://coveralls.io/repos/github/DDMGNI/GeometricIntegrators.jl/badge.svg)](https://coveralls.io/github/DDMGNI/GeometricIntegrators.jl)
[![codecov](https://codecov.io/gh/DDMGNI/GeometricIntegrators.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/DDMGNI/GeometricIntegrators.jl)

GeometricIntegrators.jl is a library of geometric integrators for ordinary differential equations and differential algebraic equations in Julia. Its main aim is the implementation and verification of novel geometric integrators, especially with respect to long-time stability and conservation of geometric structures. In order to be able to perform simulations with millions or billions of time steps, the design of the library tries to minimize overhead and maximize performance. For example, all data structures are preallocated and reused so that all runtime allocations are eliminated. GeometricIntegrators.jl provides solvers for various families of integrators as well as facilities to derive such integrators of arbitrary order, e.g., via discrete variational principles.  

*Disclaimer:* The package is currently under heavy development. Regular refactoring and breaking changes are expected.


## Features

The following list provides and overview of supported and planned features.

#### Families of Standard Methods

- [x] Explicit Runge-Kutta Methods (ERK),
- [ ] Diagonally Implicit Runge-Kutta Methods (DIRK),
- [ ] Singly Diagonally Implicit Runge-Kutta Methods (SIRK),
- [x] Fully Implicit Runge-Kutta Methods (FIRK),
- [x] Explicit Partitioned Runge-Kutta Methods (EPRK),
- [x] Implicit Partitioned Runge-Kutta Methods (IPRK),
- [ ] Additive Runge-Kutta Methods (ARK),
- [ ] Specialised Additive Runge-Kutta Methods (SARK),
- [x] Partitioned Additive Runge-Kutta Methods (PARK),
- [ ] Specialised Partitioned Additive Runge-Kutta Methods (SPARK),
- [ ] Generalised Partitioned Additive Runge-Kutta Methods (GPARK),
- [ ] Two-step Runge-Kutta Methods (TSRK),
- [ ] General Linear Methods (GLM).

#### Families of Geometric Integrators

- [x] Gauss-Legendre Runge-Kutta Methods (GLRK),
- [x] Variational Partitioned Runge-Kutta Methods (VPRK),
- [x] Variational Partitioned Additive Runge-Kutta Methods (VPARK),
- [x] Continuous Galerkin Variational Integrators (CGVI),
- [ ] Discontinuous Galerkin Variational Integrators (DGVI),
- [ ] Hamilton-Pontryagin-Galerkin Integrators (HPGI),
- [ ] Spline Variational Integrators (SVI),
- [ ] Taylor Variational Integrators (TVI),
- [x] Splitting Methods (SM).

#### Families of Equations

- [x] Systems of ODEs,
- [x] Systems of DAEs,
- [ ] Systems of SDEs,
- [x] Partitioned ODEs,
- [x] Partitioned DAEs,
- [ ] Partitioned SDEs,
- [x] Implicit ODEs,
- [x] Implicit DAEs,
- [ ] Implicit SDEs,
- [x] Hamiltonian DAEs,
- [x] Split ODEs,

which can be prescribed manually or obtained as

- [ ] Euler-Lagrange Equations,
- [ ] Hamilton Equations,
- [ ] Hamilton-Pontryagin Equations,
- [ ] Lagrange-d'Alembert Equations,
- [ ] Hamilton-d'Alembert Equations,
- [ ] Symplectic Equations,
- [ ] Poisson Equations,

with

- [ ] Holonomic Constraints,
- [ ] Nonholonomic Constraints,
- [ ] Dirac Constraints.

#### Linear Solvers

- [x] LU decomposition (LAPACK),
- [x] LU decomposition (native Julia),
- [ ] Krylov,

#### Nonlinear Solvers

- [ ] Fixed-Point Iteration,
- [ ] Fixed-Point Iteration with Aitken Acceleration,
- [ ] Fixed-Point Iteration with Anderson Acceleration,
- [ ] Jacobian-free Newton-Krylov,
- [x] Newton's method,
- [x] Newton's method with line search (Armijo, quadratic),
- [x] Quasi-Newton,

with

- [x] Finite Difference Jacobian,
- [x] Jacobian obtained via Automatic Differentiation.

#### Diagnostics

- [x] Symplecticity Conditions,
- [ ] Runge-Kutta Stability Area,
- [ ] Convergence Analysis,
- [x] First Poincaré Integral Invariant,
- [x] Second Poincaré Integral Invariant.


## License

The GeometricIntegrators.jl package is licensed under the [MIT "Expat" License](LICENSE.md).
