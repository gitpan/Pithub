package Pithub::Request;
BEGIN {
  $Pithub::Request::VERSION = '0.01003';
}

# ABSTRACT: Github v3 request object

use Moose;
use MooseX::Types::URI qw(Uri);
use HTTP::Headers;
use HTTP::Request;
use JSON::Any;
use URI;
use namespace::autoclean;


has 'data' => (
    is        => 'ro',
    isa       => 'HashRef|ArrayRef|Str',
    predicate => 'has_data',
    required  => 0,
);


has 'http_request' => (
    is         => 'ro',
    isa        => 'HTTP::Request',
    lazy_build => 1,
);


has 'method' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);


has 'token' => (
    clearer   => 'clear_token',
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_token',
    required  => 0,
);


has 'ua' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);


has 'uri' => (
    coerce   => 1,
    is       => 'ro',
    isa      => Uri,
    required => 1,
);

has '_json' => (
    is         => 'ro',
    isa        => 'JSON::Any',
    lazy_build => 1,
);

sub _build__json {
    my ($self) = @_;
    return JSON::Any->new;
}

sub _build_http_request {
    my ($self) = @_;

    my $headers = HTTP::Headers->new;

    if ( $self->has_token ) {
        $headers->header( 'Authorization' => sprintf( 'token %s', $self->token ) );
    }

    my $request = HTTP::Request->new( $self->method, $self->uri, $headers );

    if ( $self->has_data ) {
        my $json = $self->_json->encode( $self->data );
        $request->content($json);
    }

    $request->header( 'Content-Length' => length $request->content );

    return $request;
}


sub send {
    my ($self) = @_;
    return $self->ua->request( $self->http_request );
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Pithub::Request - Github v3 request object

=head1 VERSION

version 0.01003

=head1 ATTRIBUTES

=head2 data

The request data. It will be JSON encoded later and set in the
L<HTTP::Request> body.

=head2 http_request

The L<HTTP::Request> object.

=head2 method

The HTTP method (GET, POST, PUT, DELETE, ...).

=head2 token

OAuth access token. If this is set, the authentication header is
added to the L</http_request> object.

=head2 ua

The LWP user agent. This is set from L<Pithub> or any other module
you are using. So you can exchange it by another module which
implements the L<LWP::UserAgent> interface.

    $p = Pithub->new( ua => WWW::Mechanize->new );
    $u = Pithub::Users->new( ua => WWW::Mechanize->new );

Of course you can set various options on the user agent object
before you hand it over to the constructor, e.g. proxy settings.

=head2 uri

An L<URI> object containing everything necessary to make that
particular API call, besides the body (see L</data> for that).

=head1 METHODS

=head2 send

Send the HTTP request. It's just a oneliner actually:

    $self->ua->request( $self->http_request );

=head1 AUTHOR

Johannes Plunien <plu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Johannes Plunien.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

