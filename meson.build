project('pyllco', 'cpp',
    version: '0.1',
    default_options: ['warning_level=3',
                      'cpp_std=c++17',
                      'buildtype=debugoptimized'])

add_project_arguments('-Werror=return-type', language: ['c', 'cpp'])

cython = find_program('cython')
cython_flags = ['-Wextra', '--cplus', '-3', '--cimport-from-pyx']

py3_mod = import('python')
py3_inst = py3_mod.find_installation('python3')

llvm_version = ['>=9', '<10']
llvm_dep = dependency('llvm', version: llvm_version, include_type: 'system')

headers = ['pyllco_helper.h', 'pyllco_helper.pxd', 'ir.pxd', 'pyllco.pxd']

py_modules = py3_inst.get_path('purelib')

pyllco_pyx_cpp = custom_target('pyllco',
    output : 'pyllco_pyx.cpp',
    input : ['pyllco.pyx'] + headers,
    command : [cython, '@INPUT0@', '-o', '@OUTPUT@'] + cython_flags
)

pyllco = py3_inst.extension_module('pyllco',
    pyllco_pyx_cpp,
    install: true,
    subdir: get_option('prefix') + py_modules,
    dependencies: [py3_inst.dependency(), llvm_dep]
)

project_name = 'pyllco-py' + py3_inst.language_version()

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
                                include_directories : pyllco_inc)
