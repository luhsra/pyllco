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

llvm_version = ['>=9', '<13']
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
py_modules = py3_inst.get_path('purelib')
pyllco = py3_inst.extension_module('pyllco',
    [pyllco_pyx_cpp] + pyllco_source_files,
    install: true,
    subdir: get_option('prefix') + py_modules,
    dependencies: [py3_inst.dependency(), llvm_dep]
)

project_name = 'pyllco-py' + py3_inst.language_version()

pyllco_pyx_header = custom_target('pyllco_header',
    output: 'pyllco.h',
    input: pyllco_pyx_cpp[1],
    command: [cp, '@INPUT@', '@OUTPUT@'],
    install: true,
    install_dir: get_option('includedir') / project_name
)

install_headers(headers, subdir: project_name)

pkg = import('pkgconfig')
pkg.generate(pyllco,
    filebase: project_name,
    install_dir: get_option('libdir') / 'pkgbuild',
    subdirs: project_name,
    variables: 'Cython.include=${includedir}' / project_name
)

pyllco_inc = include_directories('.')
pyllco_cython_inc = meson.current_source_dir()
pyllco_dir = meson.current_build_dir()
pyllco_dep = declare_dependency(link_with: pyllco,
                                sources: pyllco_pyx_header,
                                include_directories : pyllco_inc)
