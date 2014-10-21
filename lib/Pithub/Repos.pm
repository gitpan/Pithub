package Pithub::Repos;
BEGIN {
  $Pithub::Repos::VERSION = '0.01002';
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
    return $self->request( GET => sprintf( '/repos/%s/%s/branches', $args{user}, $args{repo} ) );
}


sub contributors {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/contributors', $args{user}, $args{repo} ) );
}


sub create {
    my ( $self, @args ) = @_;
    if ( scalar @args == 1 ) {
        return $self->request( POST => '/user/repos', $args[0] );
    }
    elsif ( scalar @args == 2 ) {
        my ( $org, $data ) = @args;
        return $self->request( POST => sprintf( '/orgs/%s/repos', $org ), $data );
    }
    else {
        croak 'Invalid parameters';
    }
}


sub get {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s', $args{user}, $args{repo} ) );
}


sub languages {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/languages', $args{user}, $args{repo} ) );
}


sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/repos', $user ) );
    }
    elsif ( my $org = $args{org} ) {
        return $self->request( GET => sprintf( '/orgs/%s/repos', $org ) );
    }
    else {
        return $self->request( GET => '/user/repos' );
    }
}


sub tags {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/tags', $args{user}, $args{repo} ) );
}


sub teams {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/teams', $args{user}, $args{repo} ) );
}


sub update {
    my ( $self, $name, $data ) = @_;
    croak 'Missing parameter: $name' unless $name;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/repos/%s', $name ), $data );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Repos - Github v3 Repos API

=head1 VERSION

version 0.01002

=head1 METHODS

=head2 branches

=over

=item *

List Branches

    GET /repos/:user/:repo/branches

Examples:

    $p      = Pithub->new;
    $result = $p->repos->branches( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->branches( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->branches;

    $r      = Pithub::Repos->new;
    $result = $r->repos->branches( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->branches( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->branches;

=back

=head2 contributors

=over

=item *

List contributors

    GET /repos/:user/:repo/contributors

Examples:

    $p      = Pithub->new;
    $result = $p->repos->contributors( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->contributors( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->contributors;

    $r      = Pithub::Repos->new;
    $result = $r->repos->contributors( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->contributors( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->contributors;

=back

=head2 create

=over

=item *

Create a new repository for the authenticated user.

    POST /user/repos

Examples:

    $result = $p->repos->create( { name => 'some-repo' } );

=item *

Create a new repository in this organization. The authenticated user
must be a member of this organization.

    POST /orgs/:org/repos

Examples:

    $result = $p->repos->create( 'CPAN-API' => { name => 'some-repo' } );

=back

=head2 get

=over

=item *

Get a repo

    GET /repos/:user/:repo

Examples:

    $p      = Pithub->new;
    $result = $p->repos->get( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->get( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->get;

    $r      = Pithub::Repos->new;
    $result = $r->repos->get( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->get( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->get;

=back

=head2 languages

=over

=item *

List languages

    GET /repos/:user/:repo/languages

Examples:

    $p      = Pithub->new;
    $result = $p->repos->languages( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->languages( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->languages;

    $r      = Pithub::Repos->new;
    $result = $r->repos->languages( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->languages( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->languages;

=back

=head2 list

=over

=item *

List repositories for the authenticated user.

    GET /user/repos

=item *

List public repositories for the specified user.

    GET /users/:user/repos

=item *

List repositories for the specified org.

    GET /orgs/:org/repos

Examples:

    $result = $p->repos->list( user => 'plu' );
    $result = $p->repos->list( org => 'CPAN-API' );
    $result = $p->repos->list;

=back

=head2 tags

=over

=item *

List Tags

    GET /repos/:user/:repo/tags

Examples:

    $p      = Pithub->new;
    $result = $p->repos->tags( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->tags( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->tags;

    $r      = Pithub::Repos->new;
    $result = $r->repos->tags( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->tags( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->tags;

=back

=head2 teams

=over

=item *

List Teams

    GET /repos/:user/:repo/teams

Examples:

    $p      = Pithub->new;
    $result = $p->repos->teams( user => 'plu', repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu' );
    $result = $p->repos->teams( repo => 'Pithub' );

    $p      = Pithub->new( user => 'plu', repo => 'Pithub' );
    $result = $p->repos->teams;

    $r      = Pithub::Repos->new;
    $result = $r->repos->teams( user => 'plu', repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu' );
    $result = $r->repos->teams( repo => 'Pithub' );

    $r      = Pithub::Repos->new( user => 'plu', repo => 'Pithub' );
    $result = $r->repos->teams;

=back

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo

Examples:

    # update a repo for the authenticated user
    $result = $p->repos->update( Pithub => { description => 'Github API v3' } );

=back

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

