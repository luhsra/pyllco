# SPDX-FileCopyrightText: 2022 Gerion Entrup <entrup@sra.uni-hannover.de>
# SPDX-FileCopyrightText: 2023 Jan Neugebauer
#
# SPDX-License-Identifier: GPL-3.0-or-later

project('pyllco', 'cpp',
    version: '0.1',
    default_options: ['warning_level=3',
                      'cpp_std=c++17',
                      'buildtype=debugoptimized'])

add_project_arguments('-Werror=return-type', language: ['c', 'cpp'])

# dependencies and external stuff
cp = find_program('cp')
# cpp = find_program('cpp')

cython = find_program('cython')
cython_flags = ['-Wextra', '--cplus', '-3', '--cimport-from-pyx']

py3_mod = import('python')
py3_inst = py3_mod.find_installation('python3')

llvm_version = ['>=9', '<16']
llvm_dep = dependency('llvm', method: 'config-tool', version: llvm_version, include_type: 'system')

# build process has several steps:
# 1. generate attr_kind.{pyx, pxd} with gen_attr_kind.py
#     - not possible with meson right now, therefore skipping and making it manually
# 2. combine all pyx files to one large with cypp.py
# 3. compile the pyx file to a cpp file with cython
# 4. compile the cpp file to a python module with gcc

# step 1
# attr_kind = custom_target('attr_kind',
#     output: ['attr_kind.pyx', 'attr_kind.pxd'],
#     input: ['gen_attr_kind.py'], # not actually an input but a dependency
#     command: [py3_inst, '@INPUT@', '-I', llvm_dep.include, '--cpp', cpp.path(), '--outdir', '@OUTDIR@']
# )

# step 2
cython_sources = ['attr_kind.pxd', 'ir.pxd']

source_dir = meson.current_source_dir()
combined_pyx = custom_target('pyllco_pyx',
    output: 'pyllco.pyx',
    input: ['cypp.py', 'main.pyx'],
    depend_files: cython_sources,
    depfile: 'pyllco.d',
    command: [py3_inst, '@INPUT0@', '-I', source_dir, '-o', '@OUTPUT@', '--depfile', '@DEPFILE@', '@INPUT1@']
)

headers = ['attr_kind.pxd',
           'ir.pxd',
           'pyllco.pxd',
           'pyllco_helper.h',
           'pyllco_helper.pxd']

# step 3
pyllco_pyx_cpp = custom_target('pyllco',
    output: ['pyllco_pyx.cpp', 'pyllco_pyx.h'],
    input: [combined_pyx] + headers,
    command: [cython, '--capi-reexport-cincludes', '-I', source_dir, '@INPUT0@', '-o', '@OUTPUT0@'] + cython_flags,
)

# step 4
pyllco_source_files = files('pyllco_helper.cpp')
pyllco = py3_inst.extension_module('pyllco',
    [pyllco_pyx_cpp] + pyllco_source_files,
    install: true,
    gnu_symbol_visibility: 'default',
    dependencies: [py3_inst.dependency(), llvm_dep]
)

project_name = 'pyllco-py' + py3_inst.language_version()

pyllco_pyx_header = custom_target('pyllco_header',
    output: 'pyllco.h',
    input: pyllco_pyx_cpp[1],
    command: [cp, '@INPUT@', '@OUTPUT@'],
    depends: pyllco,
    install: true,
    install_dir: get_option('includedir') / project_name
)

install_headers(headers, subdir: project_name)

pkg = import('pkgconfig')
pkg.generate(pyllco,
    filebase: project_name,
    install_dir: get_option('libdir') / 'pkgconfig',
    subdirs: project_name,
    variables: 'Cython.include=${includedir}' / project_name
)

pyllco_inc = include_directories('.')
pyllco_cython_inc = meson.current_source_dir()
pyllco_dir = meson.current_build_dir()

# Attention: If you use this dependency in another Python module
# you must consider a few settings:
# 1. When building, you must set
#    `override_options: 'b_lundef=false'` in the other module.
#    With that the symbols of pyllco within the other module
#    remain undefined.
# 2. When using the other module, you must import pyllco first
#    so the Python interpreter knows about its symbols.
#    You also need to set
#    sys.setdlopenflags(sys.getdlopenflags() | os.RTLD_GLOBAL)
#    within the Python code so CPython resolve the pyllco
#    symbols on a global base.
# This is all due to the fact, that linking together shared
# modules is not supported.
pyllco_dep = declare_dependency(sources: pyllco_pyx_header,
                                include_directories : pyllco_inc)
