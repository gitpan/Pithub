package Pithub::Orgs;
BEGIN {
  $Pithub::Orgs::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';
with 'MooseX::Role::BuildInstanceOf' => { target => '::Members' };
with 'MooseX::Role::BuildInstanceOf' => { target => '::Teams' };
around qr{^merge_.*?_args$}          => \&Pithub::Base::_merge_args;

=head1 NAME

Pithub::Orgs

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 get

=over

=item *

Get an organization

    GET /orgs/:org

=back

Examples:

    $result = $p->orgs->get( org => 'CPAN-API' );

=cut

sub get {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    return $self->request( GET => sprintf( '/orgs/%s', $args{org} ) );
}

=head2 list

=over

=item *

List all public organizations for a user.

    GET /users/:user/orgs

Examples:

    $result = $p->orgs->list( user => 'plu' );

=item *

List public and private organizations for the authenticated user.

    GET /user/orgs

=back

Examples:

    $result = $p->orgs->list;

=cut

sub list {
    my ( $self, %args ) = @_;
    if ( my $user = $args{user} ) {
        return $self->request( GET => sprintf( '/users/%s/orgs', $args{user} ) );
    }
    return $self->request( GET => '/user/orgs' );
}

=head2 update

=over

=item *

Edit an organization

    PATCH /orgs/:org

=back

Examples:

    $result = $p->orgs->update(
        org  => 'CPAN-API',
        data => {
            billing_email => 'support@github.com',
            blog          => 'https://github.com/blog',
            company       => 'GitHub',
            email         => 'support@github.com',
            location      => 'San Francisco',
            name          => 'github',
        }
    );

=cut

sub update {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: org' unless $args{org};
    croak 'Missing key in parameters: data (hashref)' unless ref $args{data} eq 'HASH';
    return $self->request( PATCH => sprintf( '/orgs/%s', $args{org} ), $args{data} );
}

__PACKAGE__->meta->make_immutable;

1;
