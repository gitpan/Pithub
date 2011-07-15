package Pithub::GitData;
BEGIN {
  $Pithub::GitData::VERSION = '0.01004';
}

# ABSTRACT: Github v3 Git Data API

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

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::GitData - Github v3 Git Data API

=head1 VERSION

version 0.01004

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

