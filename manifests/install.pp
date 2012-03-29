# Class: jboss::install
#
# This class installs jboss
#
# == Variables
#
# Refer to jboss class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It's automatically included by jboss
#
class jboss::install inherits jboss {

  case $jboss::install {

    package: {
      package { 'jboss':
        ensure => $jboss::manage_package,
        name   => $jboss::package,
      }
    }

    source: {

      $created_dirname = url_parse("$jboss::real_install_source",'filedir')

      puppi::netinstall { 'netinstall_jboss':
        url                 => $jboss::real_install_source,
        destination_dir     => $jboss::real_install_destination,
        preextract_command  => $jboss::install_precommand,
        postextract_command => $jboss::install_postcommand,
      }

      file { 'jboss_link':
        path   => "${jboss::real_install_destination}/${jboss::install_dirname}" ,
        ensure => "${jboss::real_install_destination}/${created_dirname}" ,
      } 
    }

    puppi: {
      puppi::project::archive { 'jboss':
        source                   => $jboss::real_install_source,
        deploy_root              => $jboss::real_install_destination,
        predeploy_customcommand  => $jboss::install_precommand,
        postdeploy_customcommand => $jboss::install_postcommand,
        report_email             => 'root',
        auto_deploy              => true,
        enable                   => true,
      }
    }

    default: { }

  }

}
