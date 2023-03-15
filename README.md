<!--
SPDX-FileCopyrightText: 2022 Gerion Entrup <entrup@sra.uni-hannover.de>
SPDX-FileCopyrightText: 2023 Gerion Entrup <entrup@sra.uni-hannover.de>

SPDX-License-Identifier: GPL-3.0-or-later
-->

PyLLco
======

A Python wrapper for LLVM Constants.
This wrapper is kind of rudimentary and meant for the subset of LLVM that [ARA](https://github.com/luhsra/ara) needs.
However, we are open for pull requests.

Dependencies
------------

- meson
- cython
- LLVM (see meson.build for current compatible versions)

Compiling
---------

```
meson build
ninja
ninja install
```

License
-------

GPLv3+
