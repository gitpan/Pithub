package Pithub::Repos;
BEGIN {
  $Pithub::Repos::VERSION = '0.01000';
}

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

=head1 NAME

Pithub::Repos

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 branches

=over

=item *

List Branches

    GET /repos/:user/:repo/branches

=back

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

=cut

sub branches {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/branches', $args{user}, $args{repo} ) );
}

=head2 contributors

=over

=item *

List contributors

    GET /repos/:user/:repo/contributors

=back

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

=cut

sub contributors {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/contributors', $args{user}, $args{repo} ) );
}

=head2 create

=over

=item *

Create a new repository for the authenticated user.

    POST /user/repos

=item *

Create a new repository in this organization. The authenticated user
must be a member of this organization.

    POST /orgs/:org/repos

=back

Examples:

    # create a repo for the authenticated user
    $result = $p->repos->create( { name => 'some-repo' } );

    # create a repo for an organization (the authenticated user must
    # belong to this organization)
    $result = $p->repos->create( 'CPAN-API' => { name => 'some-repo' } );

=cut

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

=head2 get

=over

=item *

Get a repo

    GET /repos/:user/:repo

=back

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

=cut

sub get {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s', $args{user}, $args{repo} ) );
}

=head2 languages

=over

=item *

List languages

    GET /repos/:user/:repo/languages

=back

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

=cut

sub languages {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/languages', $args{user}, $args{repo} ) );
}

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

=back

Examples:

    $result = $p->repos->list( user => 'plu' );
    $result = $p->repos->list( org => 'CPAN-API' );
    $result = $p->repos->list;

=cut

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

=head2 tags

=over

=item *

List Tags

    GET /repos/:user/:repo/tags

=back

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

=cut

sub tags {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/tags', $args{user}, $args{repo} ) );
}

=head2 teams

=over

=item *

List Teams

    GET /repos/:user/:repo/teams

=back

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

=cut

sub teams {
    my ( $self, %args ) = @_;
    $self->_validate_user_repo_args( \%args );
    return $self->request( GET => sprintf( '/repos/%s/%s/teams', $args{user}, $args{repo} ) );
}

=head2 update

=over

=item *

Edit

    PATCH /repos/:user/:repo

=back

Examples:

    # update a repo for the authenticated user
    $result = $p->repos->update( Pithub => { description => 'Github API v3' } );

=cut

sub update {
    my ( $self, $name, $data ) = @_;
    croak 'Missing parameter: $name' unless $name;
    croak 'Missing parameter: $data (hashref)' unless ref $data eq 'HASH';
    return $self->request( PATCH => sprintf( '/user/repos/%s', $name ), $data );
}

__PACKAGE__->meta->make_immutable;

1;
