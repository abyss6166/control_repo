class minecraft {
  file {'/opt/minecraft':
    ensure => directory,
  }
  file {'/opt/minecraft/minecraft_server.jar':
    ensure => file,
    source => 'https://piston-data.mojang.com/v1/objects/c9df48efed58511cdd0213c56b9013a7b5c9ac1f/server.jar',
  }
  file {'/tmp/jdk-19_linux-x64_bin.rpm':
    ensure => file,
    source => 'https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.rpm'
  }
  package {'jdk':
    provider => 'rpm',
    ensure => present,
    source => '/tmp/jdk-19_linux-x64_bin.rpm'
  }
  file {'/opt/minecraft/eula.txt':
    ensure => file,
    content => 'eula=true'
  }
  file {'/etc/systemd/system/minecraft.service':
    ensure => file,
    source => 'puppet:///modules/minecraft/minecraft.service'
  }
  service {'minecraft':
    ensure => running,
    enable => true,
  }
}
