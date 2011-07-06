package Pithub::Gists;
BEGIN {
  $Pithub::Gists::VERSION = '0.01003';
}

# ABSTRACT: Github v3 Gists API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Comments' };
around qr{^merge_.*?_args$} => \&Pithub::Base::_merge_args;


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( POST => '/gists', $args{data} );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( DELETE => sprintf( '/gists/%s', $args{gist_id} ) );
}


sub fork {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( POST => sprintf( '/gists/%s/fork', $args{gist_id} ) );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%s', $args{gist_id} ) );
}


sub is_starred {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( GET => sprintf( '/gists/%s/star', $args{gist_id} ) );
}


sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/gists', $user ) );
    }
    elsif ( $args{starred} ) {
        return $self->request( GET => '/gists/starred' );
    }
    elsif ( $args{public} ) {
        return $self->request( GET => '/gists/public' );
    }
    return $self->request( GET => '/gists' );
}


sub star {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( PUT => sprintf( '/gists/%s/star', $args{gist_id} ) );
}


sub unstar {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    return $self->request( DELETE => sprintf( '/gists/%s/star', $args{gist_id} ) );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: gist_id' unless $args{gist_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/gists/%s', $args{gist_id} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Gists - Github v3 Gists API

=head1 VERSION

version 0.01003

=head1 METHODS

=head2 create

=over

=item *

Create a gist

    POST /gists

Examples:

    $result = $p->gists->create(
        data => {
            description => 'the description for this gist',
            public      => 1,
            files       => { 'file1.txt' => { content => 'String file content' } }
        }
    );

=back

=head2 delete

=over

=item *

Delete a gist

    DELETE /gists/:id

Examples:

    $result = $p->gists->delete( gist_id => 784612 );

=back

=head2 fork

=over

=item *

Fork a gist

    POST /gists/:id/fork

Examples:

    $result = $p->gists->fork( gist_id => 784612 );

=back

=head2 get

=over

=item *

Get a single gist

    GET /gists/:id

Examples:

    $result = $p->gists->get( gist_id => 784612 );

=back

=head2 is_starred

=over

=item *

Check if a gist is starred

    GET /gists/:id/star

Examples:

    $result = $p->gists->is_starred( gist_id => 784612 );

=back

=head2 list

=over

=item *

List a user’s gists:

    GET /users/:user/gists

Examples:

    $result = $p->gists->list( user => 'plu' );

=item *

List the authenticated user’s gists or if called anonymously,
this will returns all public gists:

    GET /gists

Examples:

    $result = $p->gists->list;

=item *

List all public gists:

    GET /gists/public

Examples:

    $result = $p->gists->list( public => 1 );

=item *

List the authenticated user’s starred gists:

    GET /gists/starred

=back

Examples:

    $result = $p->gists->list( starred => 1 );

=head2 star

=over

=item *

Star a gist

    PUT /gists/:id/star

Examples:

    $result = $p->gists->star( gist_id => 784612 );

=back

=head2 unstar

=over

=item *

Unstar a gist

    DELETE /gists/:id/star

Examples:

    $result = $p->gists->unstar( gist_id => 784612 );

=back

=head2 update

=over

=item *

Edit a gist

    PATCH /gists/:id

Examples:

    $result = $p->gists->update(
        gist_id => 784612,
        data    => { description => 'bar foo' }
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

