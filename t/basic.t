use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
    use_ok('Pithub::Base');
}

my %accessors = (
    gists => {
        isa       => 'Pithub::Gists',
        accessors => { comments => 'Pithub::Gists::Comments' }
    },
    git_data => {
        isa       => 'Pithub::GitData',
        accessors => {
            blobs      => 'Pithub::GitData::Blobs',
            commits    => 'Pithub::GitData::Commits',
            references => 'Pithub::GitData::References',
            tags       => 'Pithub::GitData::Tags',
            trees      => 'Pithub::GitData::Trees',
        }
    },
    issues => {
        isa       => 'Pithub::Issues',
        accessors => {
            comments   => 'Pithub::Issues::Comments',
            events     => 'Pithub::Issues::Events',
            labels     => 'Pithub::Issues::Labels',
            milestones => 'Pithub::Issues::Milestones',
        }
    },
    orgs => {
        isa       => 'Pithub::Orgs',
        accessors => {
            members => 'Pithub::Orgs::Members',
            teams   => 'Pithub::Orgs::Teams',
        }
    },
    pull_requests => {
        isa       => 'Pithub::PullRequests',
        accessors => { comments => 'Pithub::PullRequests::Comments' }
    },
    repos => {
        isa       => 'Pithub::Repos',
        accessors => {
            collaborators => 'Pithub::Repos::Collaborators',
            commits       => 'Pithub::Repos::Commits',
            downloads     => 'Pithub::Repos::Downloads',
            forks         => 'Pithub::Repos::Forks',
            keys          => 'Pithub::Repos::Keys',
            watching      => 'Pithub::Repos::Watching',
        }
    },
    users => {
        isa       => 'Pithub::Users',
        accessors => {
            emails    => 'Pithub::Users::Emails',
            followers => 'Pithub::Users::Followers',
            keys      => 'Pithub::Users::Keys',
        }
    },
);

{
    my $p = Pithub->new( user => 'plu', repo => 'Pithub', token => 123 );

    isa_ok $p, 'Pithub';

    while ( my ( $main_accessor, $sub ) = each %accessors ) {
        isa_ok $p->$main_accessor, $sub->{isa};
        while ( my ( $sub_accessor, $isa ) = each %{ $sub->{accessors} } ) {
            isa_ok $p->$main_accessor->$sub_accessor, $isa;
            is $p->$main_accessor->user, 'plu', "Parameter user was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->user, 'plu', "Parameter user was curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->repo, 'Pithub', "Parameter repo was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->repo, 'Pithub', "Parameter repo was curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->token, 123, "Parameter token was curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->token, 123, "Parameter token was curried to ${main_accessor}->${sub_accessor}";
        }
    }
}

# Once again, this time we do not currie the user, repo and token attribute
{
    my $p = Pithub->new;

    while ( my ( $main_accessor, $sub ) = each %accessors ) {
        isa_ok $p->$main_accessor, $sub->{isa};
        while ( my ( $sub_accessor, $isa ) = each %{ $sub->{accessors} } ) {
            isa_ok $p->$main_accessor->$sub_accessor, $isa;
            is $p->$main_accessor->user, undef, "Parameter user was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->user, undef, "Parameter user was not curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->repo, undef, "Parameter repo was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->repo, undef, "Parameter repo was not curried to ${main_accessor}->${sub_accessor}";
            is $p->$main_accessor->token, undef, "Parameter token was not curried to ${main_accessor}";
            is $p->$main_accessor->$sub_accessor->token, undef, "Parameter token was curried to ${main_accessor}->${sub_accessor}";
        }
    }
}

{
    my $base = Pithub::Base->new( skip_request => 1 );

    isa_ok $base, 'Pithub::Base';

    throws_ok { $base->request } qr{Missing mandatory parameters: \$method, \$path}, 'Not given any parameters';
    throws_ok { $base->request( xxx => '/bar' ) } qr{Invalid method: xxx}, 'Not a valid HTTP method';
    lives_ok { $base->request( GET => 'bar' ) } 'Correct parameters do not throw an exception';

    throws_ok { $base->request( GET => '/bar', undef, [] ) }
    qr{The parameter \$options must be a hashref},
      '$options must be a hashref';

    throws_ok { $base->request( GET => '/bar', undef, { prepare_uri => 1 } ) }
    qr{The key prepare_uri in the \$options hashref must be a coderef},
      'prepare_uri must be a coderef';

    lives_ok { $base->request( GET => 'bar', undef, {} ) } 'Empty options hashref';

    my $result       = $base->request( GET => '/bar' );
    my $response     = $result->response;
    my $request      = $response->request;
    my $http_request = $request->http_request;

    isa_ok $result,       'Pithub::Result';
    isa_ok $response,     'Pithub::Response';
    isa_ok $request,      'Pithub::Request';
    isa_ok $http_request, 'HTTP::Request';

    is $result->request, $request, 'Shortcut to the Pithub::Request object';
    is $request->method, 'GET', 'The HTTP method was set in the Pithub::Request object';
    is $request->uri->path, '/bar', 'The HTTP path was set in the Pithub::Request object';
    is $request->has_data, '',    'There was no data set in the Pithub::Request object';
    is $request->data,     undef, 'The data hashref is undef';

    is $http_request->uri->path, '/bar', 'The HTTP path was set in the HTTP::Request object';
    is $http_request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    $base->token('123');
    my $request = $base->request( POST => '/foo', { some => 'data' } )->request;
    eq_or_diff $request->data, { some => 'data' }, 'The data hashref was set in the request object';
    is $request->http_request->header('Authorization'), 'token 123', 'Authorization header was set in the HTTP::Request object';
    ok $base->clear_token, 'Access token clearer';
    is $base->token, undef, 'No token set anymore';
    $request = $base->request( POST => '/foo', { some => 'data' } )->request;
    is $request->http_request->header('Authorization'), undef, 'Authorization header was not set in the HTTP::Request object';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    my $result = $base->request( GET => '/foo' );

    ok $result->response->parse_response( Pithub::Test->get_response('error.notfound') ), 'Load response' if $base->skip_request;

    is $result->code,    404, 'HTTP status is 404';
    is $result->success, '',  'Unsuccessful response';

    ok $result->raw_content, 'Has raw JSON content';
    is ref( $result->content ), 'HASH', 'Has decoded JSON hashref';

    is $result->content->{message}, 'Not Found', 'Attribute exists in response: message';

    is $result->ratelimit,           5000, 'Accessor to X-RateLimit-Limit header';
    is $result->ratelimit_remaining, 4962, 'Accessor to X-RateLimit-Remaining header';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    my $result = $base->request( GET => '/foo' );

    ok $result->response->parse_response( Pithub::Test->get_response('header.link.page.first') ), 'Load response' if $base->skip_request;

    is $result->first_page_uri, undef,                                                     'First page link on first page';
    is $result->prev_page_uri,  undef,                                                     'First page link on first page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Next page link on first page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link on first page';

    is $result->first_page, undef, 'We are on first page already';
    is $result->prev_page,  undef, 'No prev page on the first page';
    is $result->next_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=2',  'Next page call';
    is $result->last_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    my $result = $base->request( GET => '/foo' );

    ok $result->response->parse_response( Pithub::Test->get_response('header.link.page.third') ), 'Load response' if $base->skip_request;

    is $result->first_page_uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page link on third page';
    is $result->prev_page_uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'First page link no third page';
    is $result->next_page_uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page link no third page';
    is $result->last_page_uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page link no third page';

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=2',  'Prev page call';
    is $result->next_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=4',  'Next page call';
    is $result->last_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=26', 'Last page call';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    my $result = $base->request( GET => '/foo' );

    ok $result->response->parse_response( Pithub::Test->get_response('header.link.page.last') ), 'Load response' if $base->skip_request;

    is $result->first_page->request->uri, 'https://api.github.com/users/miyagawa/followers?page=1',  'First page call';
    is $result->prev_page->request->uri,  'https://api.github.com/users/miyagawa/followers?page=25', 'Prev page call';
    is $result->next_page, undef, 'No next page on the last page';
    is $result->last_page, undef, 'We are on last page already';
}

{
    my $base = Pithub::Base->new( skip_request => 1 );
    my $result = $base->request( GET => '/foo' );

    ok $result->response->parse_response( Pithub::Test->get_response('header.link.missing') ), 'Load response' if $base->skip_request;

    is $result->first_page, undef, 'First page call';
    is $result->prev_page,  undef, 'Prev page call';
    is $result->next_page,  undef, 'No next page on the last page';
    is $result->last_page,  undef, 'We are on last page already';
}

done_testing;
