package Pithub::GitData;
BEGIN {
  $Pithub::GitData::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Blobs' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::References' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Tags' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Trees' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::GitData

=head1 VERSION

version 0.01000

=cut

__PACKAGE__->meta->make_immutable;

1;
