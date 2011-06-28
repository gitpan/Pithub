package Pithub::Users;
BEGIN {
  $Pithub::Users::VERSION = '0.01001';
}

# ABSTRACT: Github v3 Users API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Emails' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Followers' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;


sub get {
    my ( $self, %args ) = @_;
    if ( $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s', $args{user} ) );
    }
    return $self->request( GET => '/user' );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => '/user', $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Users - Github v3 Users API

=head1 VERSION

version 0.01001

=head1 METHODS

=head2 get

=over

=item *

Get a single user

    GET /users/:user

=item *

Get the authenticated user

    GET /user

=back

Examples:

    $p = Pithub->new;
    $result = $p->users->get( user => 'plu');

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->get;

    $u = Pithub::Users->new;
    $result = $u->get( user => 'plu');

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->get;

=head2 update

=over

=item *

Update the authenticated user

    PATCH /user

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->update( data => { email => 'plu@cpan.org' } );

    $u = Pithub::Users->new( token => 'b3c62c6' );
    $result = $u->update( data => { email => 'plu@cpan.org' } );

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

