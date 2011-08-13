
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Github v3 API',
  'AUTHOR' => 'Johannes Plunien <plu@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Basename' => '0',
    'File::Slurp' => '0',
    'FindBin' => '0',
    'HTTP::Response' => '0',
    'Test::More' => '0',
    'Test::Most' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Pithub',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Pithub',
  'PREREQ_PM' => {
    'Array::Iterator' => '0',
    'Carp' => '0',
    'HTTP::Headers' => '0',
    'HTTP::Message' => '0',
    'HTTP::Request' => '0',
    'HTTP::Request::Common' => '0',
    'JSON::Any' => '0',
    'JSON::XS' => '0',
    'LWP::Protocol::https' => '0',
    'LWP::UserAgent' => '0',
    'Moo' => '0',
    'URI' => '0'
  },
  'VERSION' => '0.01006',
  'test' => {
    'TESTS' => 't/*.t t/live/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



