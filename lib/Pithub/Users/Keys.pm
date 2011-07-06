package Pithub::Users::Keys;
BEGIN {
  $Pithub::Users::Keys::VERSION = '0.01003';
}

# ABSTRACT: Github v3 User Keys API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => '/user/keys', $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( DELETE => sprintf( '/user/keys/%s', $args{key_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    return $self->request( GET => sprintf( '/user/keys/%s', $args{key_id} ) );
}


sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/keys' );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/keys/%s', $args{key_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Users::Keys - Github v3 User Keys API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 create

=over

=item *

Create a public key

    POST /user/keys

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->create(
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->create(
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=back

=head2 delete

=over

=item *

Delete a public key

    DELETE /user/keys/:id

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->delete( key_id => 123 );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->delete( key_id => 123 );

=back

=head2 get

=over

=item *

Get a single public key

    GET /user/keys/:id

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->get( key_id => 123 );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->get( key_id => 123 );

=back

=head2 list

=over

=item *

List public keys for a user

    GET /user/keys

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->list;

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->list;

=back

=head2 update

=over

=item *

Update a public key

    PATCH /user/keys/:id

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->keys->update(
        key_id => 123,
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

    $k = Pithub::Users::Keys->new( token => 'b3c62c6' );
    $result = $k->update(
        key_id => 123,
        data => {
            title => 'plu@localhost',
            key   => 'ssh-rsa AAA...',
        }
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

