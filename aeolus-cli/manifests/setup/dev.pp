class aeolus-cli::setup::dev {
  require aeolus-cli::install::dev
  require bundler
  #exec { "bundle install":
  #  cwd => "/tmp/aeolus-cli/src", 
  #  command => "/usr/bin/bundle install --path bundle",
  #  logoutput => on_failure,
  #  #    require => Package[$dependencies]
  #}
  #exec { "gem build aeolus-image.gemspec":
  #  cwd => "/tmp/aeolus-cli", 
  #  command => "/usr/bin/gem build aeolus-image.gemspec",
  #  logoutput => on_failure,
  #}
}