package Pithub::Repos;
BEGIN {
  $Pithub::Repos::VERSION = '0.01004';
}

# ABSTRACT: Github v3 Repos API

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Collaborators' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Commits' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Downloads' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Forks' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Keys' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Watching' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;


sub branches {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/branches', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub contributors {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/contributors', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub create {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    if ( my $org = delete $args{org} ) {
        return $self->request(
            method => 'POST',
            path   => sprintf( '/orgs/%s/repos', $org ),
            %args,
        );
    }
    else {
        return $self->request(
            method => 'POST',
            path   => '/user/repos',
            %args,
        );
    }
}


sub get {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub languages {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/languages', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub list {
    my ( $self, %args ) = @_;
    if ( my $user = delete $args{user} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/users/%s/repos', $user ),
            %args,
        );
    }
    elsif ( my $org = delete $args{org} ) {
        return $self->request(
            method => 'GET',
            path   => sprintf( '/orgs/%s/repos', $org ),
            %args
        );
    }
    else {
        return $self->request(
            method => 'GET',
            path   => '/user/repos',
            %args,
        );
    }
}


sub tags {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/tags', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub teams {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'GET',
        path   => sprintf( '/repos/%s/%s/teams', delete $args{user}, delete $args{repo} ),
        %args,
    );
}


sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    $self->_validate_user_repo_args( \%args );
    return $self->request(
        method => 'PATCH',
        path   => sprintf( '/repos/%s/%s', delete $args{user}, delete $args{repo} ),
        %args,
    );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos - Github v3 Repos API

=head1 VERSION

version 0.01004

=head1 METHODS

=head2 branches

=over

=item *

List Branches

    GET /repos/:user/:repo/branches

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->branches( user => 'plu', repo => 'Pithub' );

=back

=head2 contributors

=over

=item *

List contributors

    GET /repos/:user/:repo/contributors

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->contributors( user => 'plu', repo => 'Pithub' );

=back

=head2 create

=over

=item *

Create a new repository for the authenticated user.

    POST /user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->create( data => { name => 'some-repo' } );

=item *

Create a new repository in this organization. The authenticated user
must be a member of this organization.

    POST /orgs/:org/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->create(
        org  => 'CPAN-API',
        data => { name => 'some-repo' }
    );

=back

=head2 get

=over

=item *

Get a repo

    GET /repos/:user/:repo

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->get( user => 'plu', repo => 'Pithub' );

=back

=head2 languages

=over

=item *

List languages

    GET /repos/:user/:repo/languages

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->languages( user => 'plu', repo => 'Pithub' );

=back

=head2 list

=over

=item *

List repositories for the authenticated user.

    GET /user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list;

=item *

List public repositories for the specified user.

    GET /users/:user/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list( user => 'plu' );

=item *

List repositories for the specified org.

    GET /orgs/:org/repos

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->list( org => 'CPAN-API' );

=back

=head2 tags

=over

=item *

List Tags

    GET /repos/:user/:repo/tags

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->tags( user => 'plu', repo => 'Pithub' );

=back

=head2 teams

=over

=item *

List Teams

    GET /repos/:user/:repo/teams

Examples:

    my $repos  = Pithub::Repos->new;
    my $result = $repos->teams( user => 'plu', repo => 'Pithub' );

=back

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo

Examples:

    # update a repo for the authenticated user
    my $repos  = Pithub::Repos->new;
    my $result = $repos->update(
        repo => 'Pithub',
        data => { description => 'Github API v3' },
    );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

