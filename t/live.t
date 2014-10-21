use FindBin;
use lib "$FindBin::Bin/lib";
use Pithub::Test;
use Test::Most;

BEGIN {
    use_ok('Pithub');
}

SKIP: {
    skip 'Set PITHUB_TEST_LIVE to true to run this test', 4 unless $ENV{PITHUB_TEST_LIVE};

    my $p = Pithub->new;
    my $result = $p->request( GET => '/' );

    is $result->code,        200,  'HTTP status is 200';
    is $result->success,     1,    'Successful';
    is $result->raw_content, '{}', 'Empty JSON object';
    eq_or_diff $result->content, {}, 'Empty hashref';
}

# These tests may break very easily because data on Github can and will change, of course.
# And they also might fail once the ratelimit has been reached.
SKIP: {
    skip 'Set PITHUB_TEST_LIVE_DATA to true to run this test', 85 unless $ENV{PITHUB_TEST_LIVE_DATA};

    my $p = Pithub->new;

    # Pithub::Gists->create
    # Pithub::Gists->delete
    # Pithub::Gists->fork

    # Pithub::Gists->get
    {
        my $result = $p->gists->get( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists->get successful';
        is $result->content->{created_at}, '2008-07-15T18:17:13Z', 'Pithub::Gists->get created_at';
    }

    # Pithub::Gists->is_starred
    # Pithub::Gists->list
    {
        my $result = $p->gists->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        foreach my $row ( @{ $result->content } ) {
            ok $row->{id}, "Pithub::Gists->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/\d+$}, "Pithub::Gists->list has url: $row->{url}";
        }
    }

    # Pithub::Gists->star
    # Pithub::Gists->unstar
    # Pithub::Gists->update

    # Pithub::Gists::Comments->create
    # Pithub::Gists::Comments->delete
    # Pithub::Gists::Comments->get

    # Pithub::Gists::Comments->list
    {
        my $result = $p->gists->comments->list( gist_id => 1 );
        is $result->success, 1, 'Pithub::Gists::Comments->list successful';
        foreach my $row ( @{ $result->content } ) {
            ok $row->{id}, "Pithub::Gists::Comments->list has id: $row->{id}";
            like $row->{url}, qr{https://api.github.com/gists/comments/\d+$}, "Pithub::Gists::Comments->list has url: $row->{url}";
        }
    }

    # Pithub::Gists::Comments->update

    # Pithub::GitData::Blobs->create
    # Pithub::GitData::Blobs->get
    {
        my $result = $p->git_data->blobs->get( user => 'plu', repo => 'Pithub', sha => '20f946f933a911253e480eb0e9feced1e36dbd45' );
        is $result->success, 1, 'Pithub::GitData::Blobs->get successful';
        eq_or_diff $result->content, {
            'content' => 'dHJlZSA4Nzc2OTQyY2I4MzRlNTEwNzMxNzQwM2E4YTE2N2UzMDE2N2Y4MDU2
CnBhcmVudCA5NjE2ZDRmMTUxNWJmNGRlMWEzMmY4NWE4ZmExYjFjYzQ0MWRh
MTY0CmF1dGhvciBKb2hhbm5lcyBQbHVuaWVuIDxwbHVAcHFwcS5kZT4gMTMw
OTIzNTg4OSArMDQwMApjb21taXR0ZXIgSm9oYW5uZXMgUGx1bmllbiA8cGx1
QHBxcHEuZGU+IDEzMDkyMzY5ODQgKzA0MDAKCkFkZCBDaGFuZ2VzIGZpbGUu
Cg==
',
            'encoding' => 'base64',
            'sha'      => '20f946f933a911253e480eb0e9feced1e36dbd45',
            'size'     => 226,
            'url'      => 'https://api.github.com/repos/plu/Pithub/git/blobs/20f946f933a911253e480eb0e9feced1e36dbd45'
          },
          'Pithub::GitData::Blobs->get content';
    }

    # Pithub::GitData::Commits->create
    # Pithub::GitData::Commits->get
    {
        my $result = $p->git_data->commits->get( user => 'plu', repo => 'Pithub', sha => '20f946f933a911253e480eb0e9feced1e36dbd45' );
        is $result->success, 1, 'Pithub::GitData::Commits->get successful';
        eq_or_diff $result->content,
          {
            'author' => {
                'date'  => '2011-06-27T21:38:09-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'committer' => {
                'date'  => '2011-06-27T21:56:24-07:00',
                'email' => 'plu@pqpq.de',
                'name'  => 'Johannes Plunien'
            },
            'message' => "Add Changes file.\n",
            'parents' => [
                {
                    'sha' => '9616d4f1515bf4de1a32f85a8fa1b1cc441da164',
                    'url' => 'https://api.github.com/repos/plu/Pithub/git/commits/9616d4f1515bf4de1a32f85a8fa1b1cc441da164'
                }
            ],
            'sha'  => '20f946f933a911253e480eb0e9feced1e36dbd45',
            'tree' => {
                'sha' => '8776942cb834e5107317403a8a167e30167f8056',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/8776942cb834e5107317403a8a167e30167f8056'
            },
            'url' => 'https://api.github.com/repos/plu/Pithub/git/commits/20f946f933a911253e480eb0e9feced1e36dbd45'
          },
          'Pithub::GitData::Commits->get content';
    }

    # Pithub::GitData::References->get
    {
        my $result = $p->git_data->references->get( user => 'plu', repo => 'Pithub', ref => 'tags/v0.01000' );
        is $result->success, 1, 'Pithub::GitData::References->get successful';
        eq_or_diff $result->content,
          {
            'object' => {
                'sha'  => '1c5230f42d6d3e376162591f223fc4130d671937',
                'type' => 'commit',
                'url'  => 'https://api.github.com/repos/plu/Pithub/git/commits/1c5230f42d6d3e376162591f223fc4130d671937'
            },
            'ref' => 'refs/tags/v0.01000',
            'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01000'
          },
          'Pithub::GitData::References->get content';
    }

    # Pithub::GitData::References->create

    # Pithub::GitData::References->list
    {
        my $result = $p->git_data->references->list( user => 'plu', repo => 'Pithub', ref => 'tags' );
        my @tags = splice @{ $result->content }, 0, 2;
        is $result->success, 1, 'Pithub::GitData::References->list successful';
        eq_or_diff \@tags,
          [
            {
                'object' => {
                    'sha'  => '1c5230f42d6d3e376162591f223fc4130d671937',
                    'type' => 'commit',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/commits/1c5230f42d6d3e376162591f223fc4130d671937'
                },
                'ref' => 'refs/tags/v0.01000',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01000'
            },
            {
                'object' => {
                    'sha'  => 'ef328a0679a992bd2c0ac537cf19d379f1c8d177',
                    'type' => 'tag',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/tags/ef328a0679a992bd2c0ac537cf19d379f1c8d177'
                },
                'ref' => 'refs/tags/v0.01001',
                'url' => 'https://api.github.com/repos/plu/Pithub/git/refs/tags/v0.01001'
            }
          ],
          'Pithub::GitData::References->list content';
    }

    # Pithub::GitData::References->update

    # Pithub::GitData::Tags->get
    # Pithub::GitData::Tags->create

    # Pithub::GitData::Trees->get
    {
        my $result = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => '7331484696162bf7b5c97de488fd2c1289fd175c' );
        is $result->success, 1, 'Pithub::GitData::Trees->get successful';
        eq_or_diff $result->content,
          {
            'sha'  => '7331484696162bf7b5c97de488fd2c1289fd175c',
            'tree' => [
                {
                    'mode' => '100644',
                    'path' => '.gitignore',
                    'sha'  => '39c3bf7b7e4a25b8673083311cfba2d2389f705e',
                    'size' => 179,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/39c3bf7b7e4a25b8673083311cfba2d2389f705e'
                },
                {
                    'mode' => '100644',
                    'path' => 'dist.ini',
                    'sha'  => 'fb4c94cc3717143903b7d0aae1b12e30653a8e7c',
                    'size' => 210,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/fb4c94cc3717143903b7d0aae1b12e30653a8e7c'
                },
                {
                    'mode' => '040000',
                    'path' => 'lib',
                    'sha'  => '7d2b61bafb9a703b393af386e4bcc350ad2c9aa9',
                    'type' => 'tree',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/trees/7d2b61bafb9a703b393af386e4bcc350ad2c9aa9'
                }
            ],
            'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/7331484696162bf7b5c97de488fd2c1289fd175c'
          },
          'Pithub::GitData::Trees->get content';

        my $result_recursive = $p->git_data->trees->get( user => 'plu', repo => 'Pithub', sha => '7331484696162bf7b5c97de488fd2c1289fd175c', recursive => 1, );
        is $result_recursive->success, 1, 'Pithub::GitData::Trees->get successful';
        eq_or_diff $result_recursive->content,
          {
            'sha'  => '7331484696162bf7b5c97de488fd2c1289fd175c',
            'tree' => [
                {
                    'mode' => '100644',
                    'path' => '.gitignore',
                    'sha'  => '39c3bf7b7e4a25b8673083311cfba2d2389f705e',
                    'size' => 179,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/39c3bf7b7e4a25b8673083311cfba2d2389f705e'
                },
                {
                    'mode' => '100644',
                    'path' => 'dist.ini',
                    'sha'  => 'fb4c94cc3717143903b7d0aae1b12e30653a8e7c',
                    'size' => 210,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/fb4c94cc3717143903b7d0aae1b12e30653a8e7c'
                },
                {
                    'mode' => '040000',
                    'path' => 'lib',
                    'sha'  => '7d2b61bafb9a703b393af386e4bcc350ad2c9aa9',
                    'type' => 'tree',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/trees/7d2b61bafb9a703b393af386e4bcc350ad2c9aa9'
                },
                {
                    'mode' => '100644',
                    'path' => 'lib/Pithub.pm',
                    'sha'  => 'b493b43e8016b86550c065fcf83df537052ad371',
                    'size' => 121,
                    'type' => 'blob',
                    'url'  => 'https://api.github.com/repos/plu/Pithub/git/blobs/b493b43e8016b86550c065fcf83df537052ad371'
                }
            ],
            'url' => 'https://api.github.com/repos/plu/Pithub/git/trees/7331484696162bf7b5c97de488fd2c1289fd175c'
          },
          'Pithub::GitData::Trees->get content recursive';
    }

    # Pithub::GitData::Trees->create

    # Pithub::Issues->create
    # Pithub::Issues->get
    # Pithub::Issues->list
    # Pithub::Issues->update

    # Pithub::Issues::Comments->create
    # Pithub::Issues::Comments->delete
    # Pithub::Issues::Comments->get
    # Pithub::Issues::Comments->list
    # Pithub::Issues::Comments->update

    # Pithub::Issues::Events->get
    # Pithub::Issues::Events->list

    # Pithub::Issues::Labels->add
    # Pithub::Issues::Labels->create
    # Pithub::Issues::Labels->delete
    # Pithub::Issues::Labels->get
    {
        my $result = $p->issues->labels->list( user => 'plu', repo => 'Pithub' );
        is $result->success, 1, 'Pithub::Issues::Labels->list successful';
        eq_or_diff $result->content,
          [
            {
                'color' => 'e10c02',
                'name'  => 'Bug',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
            },
            {
                'color' => '02e10c',
                'name'  => 'Feature',
                'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Feature'
            }
          ],
          'Pithub::Issues::Labels->list content';
    }

    # Pithub::Issues::Labels->list
    {
        my $result = $p->issues->labels->get( user => 'plu', repo => 'Pithub', label_id => 'Bug' );
        is $result->success, 1, 'Pithub::Issues::Labels->get successful';
        eq_or_diff $result->content,
          {
            'color' => 'e10c02',
            'name'  => 'Bug',
            'url'   => 'https://api.github.com/repos/plu/Pithub/labels/Bug'
          },
          'Pithub::Issues::Labels->get content';
    }

    # Pithub::Issues::Labels->remove
    # Pithub::Issues::Labels->replace
    # Pithub::Issues::Labels->update

    # Pithub::Issues::Milestones->create
    # Pithub::Issues::Milestones->delete
    # Pithub::Issues::Milestones->get
    # Pithub::Issues::Milestones->list
    # Pithub::Issues::Milestones->update

    # Pithub::Orgs->get
    # Pithub::Orgs->list
    # Pithub::Orgs->update

    # Pithub::Orgs::Members->conceal
    # Pithub::Orgs::Members->delete
    # Pithub::Orgs::Members->is_member
    # Pithub::Orgs::Members->is_public
    # Pithub::Orgs::Members->list
    # Pithub::Orgs::Members->list_public
    # Pithub::Orgs::Members->publicize

    # Pithub::Orgs::Teams->add_member
    # Pithub::Orgs::Teams->add_repo
    # Pithub::Orgs::Teams->create
    # Pithub::Orgs::Teams->delete
    # Pithub::Orgs::Teams->get
    # Pithub::Orgs::Teams->get_repo
    # Pithub::Orgs::Teams->is_member
    # Pithub::Orgs::Teams->list
    # Pithub::Orgs::Teams->list_members
    # Pithub::Orgs::Teams->list_repos
    # Pithub::Orgs::Teams->remove_member
    # Pithub::Orgs::Teams->remove_repo
    # Pithub::Orgs::Teams->update

    # Pithub::PullRequests->commits
    # Pithub::PullRequests->create
    # Pithub::PullRequests->files
    # Pithub::PullRequests->get
    # Pithub::PullRequests->is_merged
    # Pithub::PullRequests->merge
    # Pithub::PullRequests->update

    # Pithub::PullRequests::Comments->create
    # Pithub::PullRequests::Comments->delete
    # Pithub::PullRequests::Comments->get
    # Pithub::PullRequests::Comments->list
    # Pithub::PullRequests::Comments->update

    # Pithub::Repos->create
    # Pithub::Repos->get
    # Pithub::Repos->list
    # Pithub::Repos->update

    # Pithub::Repos::Collaborators->add
    # Pithub::Repos::Collaborators->is_collaborator
    # Pithub::Repos::Collaborators->remove

    # Pithub::Repos::Commits->create_comment
    # Pithub::Repos::Commits->delete_comment
    # Pithub::Repos::Commits->get
    # Pithub::Repos::Commits->get_comment
    # Pithub::Repos::Commits->list_comments
    # Pithub::Repos::Commits->update_comment

    # Pithub::Repos::Downloads->create
    # Pithub::Repos::Downloads->delete
    # Pithub::Repos::Downloads->get

    # Pithub::Repos::Forks->create

    # Pithub::Repos::Keys->create
    # Pithub::Repos::Keys->delete
    # Pithub::Repos::Keys->get
    # Pithub::Repos::Keys->update

    # Pithub::Repos::Watching->is_watching
    # Pithub::Repos::Watching->list_repos
    # Pithub::Repos::Watching->start_watching
    # Pithub::Repos::Watching->stop_watching

    # Pithub::Users->get
    # Pithub::Users->update

    # Pithub::Users::Emails->add
    # Pithub::Users::Emails->delete
    # Pithub::Users::Emails->list

    # Pithub::Users::Followers->follow
    # Pithub::Users::Followers->is_following
    # Pithub::Users::Followers->list
    # Pithub::Users::Followers->list_following
    # Pithub::Users::Followers->unfollow

    # Pithub::Users::Keys->create
    # Pithub::Users::Keys->delete
    # Pithub::Users::Keys->get
    # Pithub::Users::Keys->list
    # Pithub::Users::Keys->update

    # Pagination + per_page
    {
        my $g = Pithub::Gists->new( per_page => 2 );

        my @seen = ();

        my $test = sub {
            my ( $row, $seen ) = @_;
            my $id = $row->{id};
            ok $id, "Pithub::Gists->list found gist id ${id}";
            is grep( $_ eq $id, @seen ), $seen, "Pithub::Gists->list we did not see id ${id} yet";
            push @seen, $id;
        };

        my $result = $g->list( public => 1 );
        is $result->success, 1, 'Pithub::Gists->list successful';
        is scalar( @{ $result->content } ), 2, 'The per_page setting was successful';

        foreach my $page ( 1 .. 2 ) {
            foreach my $row ( @{ $result->content } ) {
                $test->( $row, 0 );
            }
            $result = $result->next_page unless $page == 2;
        }

        # Browse to the last page and see if we can get some gist id's there
        $result = $result->last_page;
        foreach my $row ( @{ $result->content } ) {
            $test->( $row, 0 );
        }

        # Browse to the previous page and see if we can get some gist id's there
        $result = $result->prev_page;
        foreach my $row ( @{ $result->content } ) {
            $test->( $row, 0 );
        }

        # Browse to the first page and see if we can get some gist id's there
        $result = $result->first_page;
        foreach my $row ( @{ $result->content } ) {
            $test->( $row, 1 );    # we saw those gists already!
        }
    }
}

done_testing;
