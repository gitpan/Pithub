package Pithub::Users::Emails;
BEGIN {
  $Pithub::Users::Emails::VERSION = '0.01003';
}

# ABSTRACT: Github v3 User Emails API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request( POST => '/user/emails', $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request( DELETE => '/user/emails', $args{data} );
}


sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/emails' );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Users::Emails - Github v3 User Emails API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 add

=over

=item *

Add email address(es)

    POST /user/emails

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->add( data => ['plu@cpan.org'] );
    $result = $p->users->emails->add( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->add( data => ['plu@cpan.org'] );
    $result = $e->add( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=back

=head2 delete

=over

=item *

Delete email address(es)

    DELETE /user/emails

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->delete( data => ['plu@cpan.org'] );
    $result = $p->users->emails->delete( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->delete( data => ['plu@cpan.org'] );
    $result = $e->delete( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=back

=head2 list

=over

=item *

List email addresses for a user

    GET /user/emails

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->list;

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->list;

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

