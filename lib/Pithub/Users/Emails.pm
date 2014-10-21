package Pithub::Users::Emails;
BEGIN {
  $Pithub::Users::Emails::VERSION = '0.01000';
}

use Moose;
use Carp qw(croak);
use namespace::autoclean;
extends 'Pithub::Base';

=head1 NAME

Pithub::Users::Emails

=head1 VERSION

version 0.01000

=head1 METHODS

=head2 add

=over

=item *

Add email address(es)

    POST /user/emails

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->add( data => ['plu@cpan.org'] );
    $result = $p->users->emails->add( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->add( data => ['plu@cpan.org'] );
    $result = $e->add( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=cut

sub add {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request( POST => '/user/emails', $args{data} );
}

=head2 delete

=over

=item *

Delete email address(es)

    DELETE /user/emails

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->delete( data => ['plu@cpan.org'] );
    $result = $p->users->emails->delete( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->delete( data => ['plu@cpan.org'] );
    $result = $e->delete( data => [ 'plu@cpan.org', 'plu@pqpq.de' ] );

=cut

sub delete {
    my ( $self, %args ) = @_;
    croak 'Missing key in parameters: data (arrayref)' unless ref $args{data} eq 'ARRAY';
    return $self->request( DELETE => '/user/emails', $args{data} );
}

=head2 list

=over

=item *

List email addresses for a user

    GET /user/emails

=back

Examples:

    $p = Pithub->new( token => 'b3c62c6' );
    $result = $p->users->emails->list;

    $e = Pithub::Users::Emails->new( token => 'b3c62c6' );
    $result = $e->list;

=cut

sub list {
    my ($self) = @_;
    return $self->request( GET => '/user/emails' );
}

__PACKAGE__->meta->make_immutable;

1;
