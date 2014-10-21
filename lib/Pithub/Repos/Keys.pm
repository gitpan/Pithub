package Pithub::Repos::Keys;
BEGIN {
  $Pithub::Repos::Keys::VERSION = '0.01005';
}

# ABSTRACT: Github v3 Repo Keys API

use Moo;
use Carp qw(croak);
extends 'Pithub::Base';


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'POST',
        path   => sprintf( '/repos/%s/%s/keys', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'DELETE',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}


sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/keys', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: key_id' unless $args{key_id};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s/keys/%s', delete $args{user}, delete $args{repo}, delete $args{key_id} ),
        %args,
    );
}

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Keys - Github v3 Repo Keys API

=head1 VERSION

version 0.01005

=head1 METHODS

=head2 create

=over

=item *

Create

    POST /repos/:user/:repo/keys

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->create(
        user => 'plu',
        repo => 'Pithub',
        data => {
            title => 'some key',
            key   => 'ssh-rsa AAA...',
        },
    );

=back

=head2 delete

=over

=item *

Delete

    DELETE /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->delete(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=head2 get

=over

=item *

Get

    GET /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->get(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
    );

=back

=head2 list

=over

=item *

List

    GET /repos/:user/:repo/keys

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo/keys/:id

Examples:

    my $k = Pithub::Repos::Keys->new;
    my $result = $k->update(
        user   => 'plu',
        repo   => 'Pithub',
        key_id => 1,
        data   => { title => 'some new title' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

