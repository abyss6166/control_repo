class minecraft (
$serverurl='https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar',
$jdkurl='https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.rpm',
$install_dir='/opt/minecraft'
){
  file {$install_dir:
    ensure => directory,
  }
  file {"${install_dir}/minecraft_server.jar":
    ensure => file,
    source => $serverurl,
    before => Service['minecraft'],
  }
  file {'/tmp/jdk-19_linux-x64_bin.rpm':
    ensure => file,
    source => $jdkurl
  }
  package {'jdk':
    provider => 'rpm',
    ensure => present,
    source => '/tmp/jdk-19_linux-x64_bin.rpm'
  }
  file {"${install_dir}/eula.txt":
    ensure => file,
    content => 'eula=true'
  }
  file {'/etc/systemd/system/minecraft.service':
    ensure => file,
    content => epp('minecraft/minecraft.service',{
      install_dir => $install_dir,
    })
  }
  service {'minecraft':
    ensure => running,
    enable => true,
    require => [Package['jdk',File["${install_dir}/eula.txt"],File['/etc/systemd/system/minecraft.service']],
  }
}
