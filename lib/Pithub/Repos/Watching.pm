package Pithub::Repos::Watching;
BEGIN {
  $Pithub::Repos::Watching::VERSION = '0.01002';
}

# ABSTRACT: Github v3 Repo Watching API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';


sub is_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}


sub list_repos {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/watched', $args{user} ) );
    }
    return $self->request( GET => '/user/watched' );
}


sub list {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/watchers', $args{user}, $args{repo} ) );
}


sub start_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( PUT => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}


sub stop_watching {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( DELETE => sprintf( '/user/watched/%s/%s', $args{user}, $args{repo} ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos::Watching - Github v3 Repo Watching API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 is_watching

=over

=item *

Check if you are watching a repo

    GET /user/watched/:user/:repo

Examples:

    $result = $p->repos->watching->is_watching(
        repo => 'Pithub',
        user => 'plu',
    );

=back

=head2 list_repos

=over

=item *

List repos being watched by a user

    GET /users/:user/watched

Examples:

    $result = $p->repos->watching->list_repos( user => 'plu' );

=item *

List repos being watched by the authenticated user

    GET /user/watched

Examples:

    $result = $p->repos->watching->list_repos;

=back

=head2 list

=over

=item *

List watchers

    GET /repos/:user/:repo/watchers

Examples:

    $result = $p->repos->watching->list(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 start_watching

=over

=item *

Watch a repo

    PUT /user/watched/:user/:repo

Examples:

    $result = $p->repos->watching->start_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head2 stop_watching

=over

=item *

Stop watching a repo

    DELETE /user/watched/:user/:repo

Examples:

    $result = $p->repos->watching->stop_watching(
        user => 'plu',
        repo => 'Pithub',
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

