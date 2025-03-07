pkgdatadir = get_option('prefix') / get_option('datadir') / meson.project_name()
moduledir = pkgdatadir / 'packagesinstaller'
gnome = import('gnome')

gnome.compile_resources('packagesinstaller',
  'packagesinstaller.gresource.xml',
  gresource_bundle: true,
  install: true,
  install_dir: pkgdatadir,
)

python = import('python')

conf = configuration_data()
conf.set('PYTHON', python.find_installation('python3').full_path())
conf.set('VERSION', meson.project_version())
conf.set('localedir', get_option('prefix') / get_option('localedir'))
conf.set('pkgdatadir', pkgdatadir)

configure_file(
  input: 'packagesinstaller.in',
  output: 'packagesinstaller',
  configuration: conf,
  install: true,
  install_dir: get_option('bindir'),
  install_mode: 'r-xr-xr-x'
)

packagesinstaller_sources = [
  '__init__.py',
  'main.py',
  'window.py',
  'preferences.py',
  'addvariable.py',
  'addpackage.py',
  'addcommand.py'
]

install_data(packagesinstaller_sources, install_dir: moduledir)
install_subdir('library', install_dir: moduledir)
install_subdir('scripts', install_dir: moduledir)
install_subdir('json', install_dir: moduledir)
