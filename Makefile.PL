
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Github v3 API",
  "AUTHOR" => "Johannes Plunien <plu\@cpan.org>",
  "BUILD_REQUIRES" => {
    "File::Slurp" => 0,
    "MIME::Base64" => 0,
    "Test::Most" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Pithub",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Pithub",
  "PREREQ_PM" => {
    "Array::Iterator" => 0,
    "HTTP::Message" => 0,
    "JSON" => 0,
    "LWP::Protocol::https" => 0,
    "LWP::UserAgent" => 0,
    "Moo" => 0
  },
  "VERSION" => "0.01019",
  "test" => {
    "TESTS" => "t/*.t t/live/*.t"
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



