class conductor::config::dev {
  require conductor::install::dev

  exec { "use sqlite gem":
    cwd => "/tmp/conductor/src",
    command => "sed -i s/'pg'/'sqlite3'/ Gemfile"
  }

  exec { "sqlite database.yml":
    cwd => "/tmp/conductor/src",
    command => "cp config/database.sqlite config/database.yml",
  }

  # TODO: perhaps make oauth.json location a variable
  exec { "use established ouath.json if it exists":
    cwd => "/tmp/conductor/src/config",
    onlyif => "test -f /etc/aeolus-conductor/oauth.json",
    command => "cp /etc/aeolus-conductor/oauth.json /tmp/conductor/src/config/"
   }

   if $imagefactory_oauth_user {
     # then conductor/lib/facter/oauth.rb found our ouath keys
     file{ "/tmp/conductor/src/config/settings.yml":
       content => template("conductor/conductor-settings.yml"),
       mode => 640,
     # mode    => 640, owner => 'root', group => 'aeolus'
     }
   } else {
     # a no-op, but define the file object so url dependencies below
     # work as expected
     file{ "/tmp/conductor/src/config/settings.yml" :}
   }

   # and update url's
   if $deltacloud_url != undef {
     exec { "update deltacloud_url":
       cwd => "/tmp/conductor/src/config",
       command => "sed -i s#http://localhost:3002/api#$deltacloud_url# settings.yml",
       require => File["/tmp/conductor/src/config/settings.yml"]
     }
   }
   if $iwhd_url != undef {
     exec { "update iwhd_url":
       cwd => "/tmp/conductor/src/config",
       command => "sed -i s#http://localhost:9090#$iwhd_url# settings.yml",
       require => File["/tmp/conductor/src/config/settings.yml"]
     }
   }
   if $imagefactory_url != undef {
     exec { "update imagefactory_url":
       cwd => "/tmp/conductor/src/config",
       command => "sed -i s#https://localhost:8075/imagefactory#$imagefactory_url# settings.yml",
       require => File["/tmp/conductor/src/config/settings.yml"]
     }
   }

}
