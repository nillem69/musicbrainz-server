package t::MusicBrainz::Server::Controller::WS::2::JSON::LookupRelease;
use utf8;
use JSON;
use Test::Routine;
use Test::More;
use MusicBrainz::Server::Test::WS qw(
    ws2_test_json
    ws2_test_json_unauthorized
);

with 't::Mechanize', 't::Context';

test 'basic release lookup' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'basic release lookup',
    '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6' =>
        {
            id => "b3b7e934-445b-4c68-a097-730c6a6d47e6",
            title => "Summer Reggae! Rainbow",
            status => "Pseudo-Release",
            "status-id" => "41121bb9-3413-3818-8a9a-9742318349aa",
            quality => "normal",
            "text-representation" => {
                language => "jpn",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2001-07-04",
            country => "JP",
            "release-events" => [{
                date => "2001-07-04",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4942463511227",
            asin => "B00005LA6G",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
        };
};

test 'basic release lookup, inc=annotation' => sub {

    my $c = shift->c;
    MusicBrainz::Server::Test->prepare_test_database($c, '+webservice');
    MusicBrainz::Server::Test->prepare_test_database($c, '+webservice_annotation');

    ws2_test_json 'basic release lookup, inc=annotation',
    '/release/adcf7b48-086e-48ee-b420-1001f88d672f?inc=annotation' =>
        {
            id => "adcf7b48-086e-48ee-b420-1001f88d672f",
            title => "My Demons",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            "text-representation" => {
                language => "eng",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2007-01-29",
            country => "GB",
            "release-events" => [{
                date => "2007-01-29",
                "area" => {
                    disambiguation => '',
                    "id" => "8a754a16-0027-3a29-b6d7-2b40ea0481ed",
                    "name" => "United Kingdom",
                    "sort-name" => "United Kingdom",
                    "iso-3166-1-codes" => ["GB"],
                },
            }],
            barcode => "600116817020",
            asin => "B000KJTG6K",
            annotation => "this is a release annotation",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
        };
};

test 'basic release lookup, inc=ratings' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    # MBS-9129: inc=ratings should be a no-op on a release
    ws2_test_json 'basic release lookup, inc=ratings',
    '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6?inc=ratings' =>
        {
            id => "b3b7e934-445b-4c68-a097-730c6a6d47e6",
            title => "Summer Reggae! Rainbow",
            status => "Pseudo-Release",
            "status-id" => "41121bb9-3413-3818-8a9a-9742318349aa",
            quality => "normal",
            "text-representation" => {
                language => "jpn",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2001-07-04",
            country => "JP",
            "release-events" => [{
                date => "2001-07-04",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4942463511227",
            asin => "B00005LA6G",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
        };
};

test 'basic release with tags' => sub {

    my $c = shift->c;

    MusicBrainz::Server::Test->prepare_test_database($c, '+webservice');
    MusicBrainz::Server::Test->prepare_test_database(
        $c, "INSERT INTO release_tag (count, release, tag) VALUES (1, 123054, 114);");

    ws2_test_json 'basic release with tags',
    '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6?inc=tags' =>
        {
            id => "b3b7e934-445b-4c68-a097-730c6a6d47e6",
            title => "Summer Reggae! Rainbow",
            status => "Pseudo-Release",
            "status-id" => "41121bb9-3413-3818-8a9a-9742318349aa",
            quality => "normal",
            "text-representation" => {
                language => "jpn",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2001-07-04",
            country => "JP",
            "release-events" => [{
                date => "2001-07-04",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4942463511227",
            asin => "B00005LA6G",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            tags => [ { count => 1, name => "hello project" } ]
        };
};

test 'basic release with collections' => sub {
    my $c = shift->c;

    MusicBrainz::Server::Test->prepare_test_database($c, '+webservice');
    MusicBrainz::Server::Test->prepare_test_database($c, <<'EOSQL');
        INSERT INTO release_tag (count, release, tag) VALUES (1, 123054, 114);
        INSERT INTO editor (id, name, password, ha1, email, email_confirm_date) VALUES (15412, 'editor', '{CLEARTEXT}mb', 'be88da857f697a78656b1307f89f90ab', 'foo@example.com', now());
        INSERT INTO editor_collection (id, gid, editor, name, public, type) VALUES (14933, 'f34c079d-374e-4436-9448-da92dedef3cd', 15412, 'My Collection', TRUE, 1);
        INSERT INTO editor_collection (id, gid, editor, name, public, type) VALUES (14934, '5e8dd65f-7d52-4d6e-93f6-f84651e137ca', 15412, 'My Private Collection', FALSE, 1);
        INSERT INTO editor_collection_release (collection, release) VALUES (14933, 123054), (14934, 123054);
EOSQL

    my $common_release_json = {
        id => "b3b7e934-445b-4c68-a097-730c6a6d47e6",
        title => "Summer Reggae! Rainbow",
        status => "Pseudo-Release",
        "status-id" => "41121bb9-3413-3818-8a9a-9742318349aa",
        quality => "normal",
        "text-representation" => {
            language => "jpn",
            script => "Latn",
        },
        "cover-art-archive" => {
            artwork => JSON::false,
            count => 0,
            front => JSON::false,
            back => JSON::false,
            darkened => JSON::false,
        },
        date => "2001-07-04",
        country => "JP",
        "release-events" => [{
            date => "2001-07-04",
            "area" => {
                disambiguation => '',
                "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                "name" => "Japan",
                "sort-name" => "Japan",
                "iso-3166-1-codes" => ["JP"],
            },
        }],
        barcode => "4942463511227",
        asin => "B00005LA6G",
        disambiguation => "",
        packaging => JSON::null,
        "packaging-id" => JSON::null,
    };

    ws2_test_json 'basic release with collections',
        '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6?inc=collections' => {
            %$common_release_json,
            collections => [
                {
                    id => "f34c079d-374e-4436-9448-da92dedef3cd",
                    name => "My Collection",
                    editor => "editor",
                    type => "Release",
                    "type-id" => "d94659b2-4ce5-3a98-b4b8-da1131cf33ee",
                    "entity-type" => "release",
                    "release-count" => 1
                },
            ],
        };

    ws2_test_json 'basic release with private collections',
        '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6?inc=user-collections' => {
            %$common_release_json,
            collections => [
                {
                    id => "5e8dd65f-7d52-4d6e-93f6-f84651e137ca",
                    name => "My Private Collection",
                    editor => "editor",
                    type => "Release",
                    "type-id" => "d94659b2-4ce5-3a98-b4b8-da1131cf33ee",
                    "entity-type" => "release",
                    "release-count" => 1
                },
                {
                    id => "f34c079d-374e-4436-9448-da92dedef3cd",
                    name => "My Collection",
                    editor => "editor",
                    type => "Release",
                    "type-id" => "d94659b2-4ce5-3a98-b4b8-da1131cf33ee",
                    "entity-type" => "release",
                    "release-count" => 1
                },
            ],
        }, { username => 'editor', password => 'mb' };
};

test 'release lookup with artists + aliases' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup with artists + aliases',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=artists+aliases' =>
        {
            id => "aff4a693-5970-4e2e-bd46-e2ee49c22de7",
            title => "the Love Bug",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            "text-representation" => { language => "eng", script => "Latn" },
            "cover-art-archive" => {
                artwork => JSON::true,
                count => 1,
                front => JSON::true,
                back => JSON::false,
                darkened => JSON::false,
            },
            "artist-credit" => [
                {
                    name => "m-flo",
                    joinphrase => "",
                    artist => {
                        id => "22dd2db3-88ea-4428-a7a8-5cd3acf23175",
                        name => "m-flo",
                        "sort-name" => "m-flo",
                        disambiguation => "",
                        aliases => [
                            { "sort-name" => "m-flow", name => "m-flow", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            { "sort-name" => "mediarite-flow crew", name => "mediarite-flow crew", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            { "sort-name" => "meteorite-flow crew", name => "meteorite-flow crew", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            { "sort-name" => "mflo", name => "mflo", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            { "sort-name" => "えむふろう", name => "えむふろう", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            { "sort-name" => "エムフロウ", name => "エムフロウ", locale => JSON::null, primary => JSON::null, type => JSON::null, "type-id" => JSON::null, begin => JSON::null, end => JSON::null, ended => JSON::false },
                            ],
                    }
                }],
            date => "2004-03-17",
            country => "JP",
            "release-events" => [{
                date => "2004-03-17",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4988064451180",
            asin => "B0001FAD2O",
            aliases => [],
        };
};

test 'release lookup with labels and recordings' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup with labels and recordings',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=labels+recordings' =>
        {
            id => "aff4a693-5970-4e2e-bd46-e2ee49c22de7",
            title => "the Love Bug",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            "text-representation" => { language => "eng", script => "Latn" },
            "cover-art-archive" => {
                artwork => JSON::true,
                count => 1,
                front => JSON::true,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2004-03-17",
            country => "JP",
            "release-events" => [{
                date => "2004-03-17",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4988064451180",
            asin => "B0001FAD2O",
            "label-info" => [
                {
                    "catalog-number" => "RZCD-45118",
                    label => {
                        id => "72a46579-e9a0-405a-8ee1-e6e6b63b8212",
                        name => "rhythm zone",
                        "sort-name" => "rhythm zone",
                        disambiguation => "",
                        "label-code" => JSON::null,
                    }
                }],
            media => [
                {
                    format => 'CD',
                    "format-id" => "9712d52a-4509-3d4b-a1a2-67c88c643e31",
                    title => '',
                    position => 1,
                    "track-offset" => 0,
                    "track-count" => 3,
                    tracks => [
                        {
                            id => "ec60f5e2-ed8a-391d-90cd-bf119c50f6a0",
                            position => 1,
                            number => "1",
                            title => "the Love Bug",
                            length => 243000,
                            recording => {
                                id => "0cf3008f-e246-428f-abc1-35f87d584d60",
                                title => "the Love Bug",
                                length => 243000,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        },
                        {
                            id => "2519283c-93d9-30de-a0ba-75f99ca25604",
                            position => 2,
                            number => "2",
                            length => 222000,
                            title => "the Love Bug (Big Bug NYC remix)",
                            recording => {
                                id => "84c98ebf-5d40-4a29-b7b2-0e9c26d9061d",
                                title => "the Love Bug (Big Bug NYC remix)",
                                length => 222000,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        },
                        {
                            id => "4ffc18f0-96cc-3e1f-8192-cf0d0c489beb",
                            position => 3,
                            number => "3",
                            length => 333000,
                            title => "the Love Bug (cover)",
                            recording => {
                                id => "3f33fc37-43d0-44dc-bfd6-60efd38810c5",
                                title => "the Love Bug (cover)",
                                length => 333000,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        }]
                }],
        };
};

test 'release lookup with release-groups' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup with release-groups',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=artist-credits+release-groups' =>
        {
            id => "aff4a693-5970-4e2e-bd46-e2ee49c22de7",
            title => "the Love Bug",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            "text-representation" => { language => "eng", script => "Latn" },
            "cover-art-archive" => {
                artwork => JSON::true,
                count => 1,
                front => JSON::true,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2004-03-17",
            country => "JP",
            "release-events" => [{
                date => "2004-03-17",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4988064451180",
            asin => "B0001FAD2O",
            "artist-credit" => [
                {
                   name => "m-flo",
                   artist => {
                      id => "22dd2db3-88ea-4428-a7a8-5cd3acf23175",
                      name => "m-flo",
                      "sort-name" => "m-flo",
                      disambiguation => "",
                   },
                   joinphrase => '',
                }
            ],
            "release-group" => {
                id => "153f0a09-fead-3370-9b17-379ebd09446b",
                title => "the Love Bug",
                disambiguation => "",
                "first-release-date" => "2004-03-17",
                "primary-type" => "Single",
                "primary-type-id" => "d6038452-8ee0-3f68-affc-2de9a1ede0b9",
                "secondary-types" => [],
                "secondary-type-ids" => [],
                "artist-credit" => [
                    {
                       name => "m-flo",
                       artist => {
                          id => "22dd2db3-88ea-4428-a7a8-5cd3acf23175",
                          name => "m-flo",
                          "sort-name" => "m-flo",
                          disambiguation => "",
                       },
                       joinphrase => "",
                    }
                ],
            }
        };
};

test 'release lookup with release-group and ratings' => sub {

    # MBS-9129: Rating requests apply to the release's RG, if any.

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup with release-groups and ratings',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=release-groups+ratings' =>
        {
            id => "aff4a693-5970-4e2e-bd46-e2ee49c22de7",
            title => "the Love Bug",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            "text-representation" => { language => "eng", script => "Latn" },
            "cover-art-archive" => {
                artwork => JSON::true,
                count => 1,
                front => JSON::true,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2004-03-17",
            country => "JP",
            "release-events" => [{
                date => "2004-03-17",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4988064451180",
            asin => "B0001FAD2O",
            "release-group" => {
                id => "153f0a09-fead-3370-9b17-379ebd09446b",
                title => "the Love Bug",
                disambiguation => "",
                "first-release-date" => "2004-03-17",
                "primary-type" => "Single",
                "primary-type-id" => "d6038452-8ee0-3f68-affc-2de9a1ede0b9",
                "secondary-types" => [],
                "secondary-type-ids" => [],
                rating => { "votes-count" => 0, value => JSON::null },
            }
        };

    ws2_test_json 'release lookup with release-groups and user ratings',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=release-groups+user-ratings' =>
        {
            id => "aff4a693-5970-4e2e-bd46-e2ee49c22de7",
            title => "the Love Bug",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            "text-representation" => { language => "eng", script => "Latn" },
            "cover-art-archive" => {
                artwork => JSON::true,
                count => 1,
                front => JSON::true,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2004-03-17",
            country => "JP",
            "release-events" => [{
                date => "2004-03-17",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4988064451180",
            asin => "B0001FAD2O",
            "release-group" => {
                id => "153f0a09-fead-3370-9b17-379ebd09446b",
                title => "the Love Bug",
                disambiguation => "",
                "first-release-date" => "2004-03-17",
                "primary-type" => "Single",
                "primary-type-id" => "d6038452-8ee0-3f68-affc-2de9a1ede0b9",
                "secondary-types" => [],
                "secondary-type-ids" => [],
                "user-rating" => { value => JSON::null },
            }
        }, { username => 'the-anti-kuno', password => 'notreally' };

    ws2_test_json_unauthorized 'release lookup with release-groups and user ratings, bad credentials',
    '/release/aff4a693-5970-4e2e-bd46-e2ee49c22de7?inc=release-groups+user-ratings',
    { username => 'the-anti-kuno', password => 'wrong' };
};

test 'release lookup with discids and puids' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup with discids and puids',
    '/release/b3b7e934-445b-4c68-a097-730c6a6d47e6?inc=discids+puids+recordings' =>
        {
            id => "b3b7e934-445b-4c68-a097-730c6a6d47e6",
            title => "Summer Reggae! Rainbow",
            status => "Pseudo-Release",
            "status-id" => "41121bb9-3413-3818-8a9a-9742318349aa",
            quality => "normal",
            "text-representation" => {
                language => "jpn",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "2001-07-04",
            country => "JP",
            "release-events" => [{
                date => "2001-07-04",
                "area" => {
                    disambiguation => '',
                    "id" => "2db42837-c832-3c27-b4a3-08198f75693c",
                    "name" => "Japan",
                    "sort-name" => "Japan",
                    "iso-3166-1-codes" => ["JP"],
                },
            }],
            barcode => "4942463511227",
            asin => "B00005LA6G",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            media => [
                {
                    format => "CD",
                    "format-id" => "9712d52a-4509-3d4b-a1a2-67c88c643e31",
                    title => '',
                    position => 1,
                    discs => [
                        {
                            id => "W01Qvrvwkaz2Cm.IQm55_RHoRxs-",
                            'offset-count' => 3,
                            offsets => [
                                150,
                                22352,
                                38335
                            ],
                            sectors => 60295
                        }
                    ],
                    "track-count" => 3,
                    "track-offset" => 0,
                    tracks => [
                        {
                            id => "3b9d0128-ed86-3c2c-af24-c331a3798875",
                            position => 1,
                            number => "1",
                            title => "Summer Reggae! Rainbow",
                            length => 296026,
                            recording => {
                                id => "162630d9-36d2-4a8d-ade1-1c77440b34e7",
                                title => "サマーれげぇ!レインボー",
                                length => 296026,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        },
                        {
                            id => "c7c21691-6f85-3ec7-9b08-e431c3b310a5",
                            position => 2,
                            number => "2",
                            title => "Hello! Mata Aou Ne (7nin Matsuri version)",
                            length => 213106,
                            recording => {
                                id => "487cac92-eed5-4efa-8563-c9a818079b9a",
                                title => "HELLO! また会おうね (7人祭 version)",
                                length => 213106,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        },
                        {
                            id => "e436c057-ca19-36c6-9f1e-dc4ada2604b0",
                            position => 3,
                            number => "3",
                            title => "Summer Reggae! Rainbow (Instrumental)",
                            length => 292800,
                            recording => {
                                id => "eb818aa4-d472-4d2b-b1a9-7fe5f1c7d26e",
                                title => "サマーれげぇ!レインボー (instrumental)",
                                length => 292800,
                                disambiguation => "",
                                video => JSON::false,
                            }
                        }]
                }]
        };
};

test 'release lookup, barcode is NULL' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup, barcode is NULL',
    '/release/fbe4eb72-0f24-3875-942e-f581589713d4' =>
        {
            id => "fbe4eb72-0f24-3875-942e-f581589713d4",
            title => "For Beginner Piano",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            "text-representation" => {
                language => "eng",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "1999-09-23",
            country => "US",
            "release-events" => [{
                date => "1999-09-23",
                "area" => {
                    disambiguation => '',
                    "id" => "489ce91b-6658-3307-9877-795b68554c98",
                    "name" => "United States",
                    "sort-name" => "United States",
                    "iso-3166-1-codes" => ["US"],
                },
            }],
            barcode => JSON::null,
            asin => "B00001IVAI",
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
        };
};

test 'release lookup, barcode is  empty string' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup, barcode is empty string',
    '/release/dd66bfdd-6097-32e3-91b6-67f47ba25d4c' =>
        {
            id => "dd66bfdd-6097-32e3-91b6-67f47ba25d4c",
            title => "For Beginner Piano",
            status => "Official",
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            quality => "normal",
            "text-representation" => {
                language => "eng",
                script => "Latn",
            },
            "cover-art-archive" => {
                artwork => JSON::false,
                count => 0,
                front => JSON::false,
                back => JSON::false,
                darkened => JSON::false,
            },
            date => "1999-09-13",
            country => "GB",
            "release-events" => [{
                date => "1999-09-13",
                "area" => {
                    disambiguation => '',
                    "id" => "8a754a16-0027-3a29-b6d7-2b40ea0481ed",
                    "name" => "United Kingdom",
                    "sort-name" => "United Kingdom",
                    "iso-3166-1-codes" => ["GB"],
                },
            }],
            barcode => "",
            asin => JSON::null,
            disambiguation => "",
            packaging => JSON::null,
            "packaging-id" => JSON::null,
        };
};

test 'release lookup, relation attributes' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup, relation attributes',
    '/release/28fc2337-985b-3da9-ac40-ad6f28ff0d8e?inc=release-rels+artist-rels' =>
        {
            disambiguation => '',
            'text-representation' => {
                language => 'jpn',
                script => 'Jpan'
            },
            quality => 'normal',
            packaging => JSON::null,
            "packaging-id" => JSON::null,
            'cover-art-archive' => {
                darkened => JSON::false,
                back => JSON::false,
                front => JSON::false,
                count => 0,
                artwork => JSON::false
            },
            date => '2004-01-15',
            asin => 'B0000YGBSG',
            'release-events' => [{
                area => {
                    id => '2db42837-c832-3c27-b4a3-08198f75693c',
                    disambiguation => '',
                    name => 'Japan',
                    'iso-3166-1-codes' => ['JP'],
                    'sort-name' => 'Japan'
                },
                date => '2004-01-15'
            }],
            relations => [{
                begin => JSON::null,
                attributes => ['executive'],
                type => 'producer',
                direction => 'backward',
                'type-id' => '8bf377ba-8d71-4ecc-97f2-7bb2d8a2a75f',
                ended => JSON::false,
                'attribute-ids' => {'executive' => 'e0039285-6667-4f94-80d6-aa6520c6d359'},
                'attribute-values' => {},
                'source-credit' => '',
                'target-credit' => '',
                end => JSON::null,
                artist => {
                    id => '4d5ec626-2251-4bb1-b62a-f24f471e3f2c',
                    'sort-name' => 'Lee, Soo-Man',
                    disambiguation => '',
                    name => '이수만'
                },
                'target-type' => 'artist',
            },
            {
                begin => JSON::null,
                type => 'transl-tracklisting',
                attributes => [],
                release => {
                    disambiguation => '',
                    'text-representation' => {
                        language => 'jpn',
                        script => 'Latn'
                    },
                    quality => 'normal',
                    packaging => JSON::null,
                    "packaging-id" => JSON::null,
                    date => '2004-01-15',
                    'release-events' => [{
                        area => {
                            id => '2db42837-c832-3c27-b4a3-08198f75693c',
                            name => 'Japan',
                            disambiguation => '',
                            'sort-name' => 'Japan',
                            'iso-3166-1-codes' => ['JP']
                        },
                        date => '2004-01-15'
                    }],
                    title => 'LOVE & HONESTY',
                    country => 'JP',
                    status => JSON::null,
                    "status-id" => JSON::null,
                    id => '757a1723-3769-4298-89cd-48d31177852a',
                    barcode => JSON::null
                },
                direction => 'forward',
                ended => JSON::false,
                'type-id' => 'fc399d47-23a7-4c28-bfcf-0607a562b644',
                'attribute-ids' => {},
                'attribute-values' => {},
                end => JSON::null,
                'target-credit' => '',
                'source-credit' => '',
                'target-type' => 'release',
            }],
            title => 'LOVE & HONESTY',
            country => 'JP',
            status => 'Official',
            "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
            id => '28fc2337-985b-3da9-ac40-ad6f28ff0d8e',
            barcode => '4988064173891'
        };
};

test 'release lookup, track artists have no tags' => sub {

    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    ws2_test_json 'release lookup, track artists have no tags/genres',
    '/release/4f5a6b97-a09b-4893-80d1-eae1f3bfa221?inc=artists+recordings+tags+genres+artist-rels+recording-level-rels'
    => {
        'artist-credit' => [ {
            artist => {
                disambiguation => '',
                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                name => 'Plone',
                'sort-name' => 'Plone'
            },
            joinphrase => '',
            name => 'Plone'
        } ],
        asin => 'B00001IVAI',
        barcode => '5021603064126',
        country => 'GB',
        'cover-art-archive' => {
            artwork => JSON::false,
            back => JSON::false,
            count => 0,
            darkened => JSON::false,
            front => JSON::false
        },
        date => '1999-09-13',
        disambiguation => '',
        id => '4f5a6b97-a09b-4893-80d1-eae1f3bfa221',
        media => [ {
            format => 'CD',
            "format-id" => "9712d52a-4509-3d4b-a1a2-67c88c643e31",
            title => '',
            'track-count' => 10,
            'track-offset' => 0,
            position => 1,
            tracks => [
                {
                    id => '9b9a84b5-0a41-38f6-859f-36cb22ac813c',
                    length => 267560,
                    position => 1,
                    number => '1',
                    recording => {
                        disambiguation => '',
                        id => '44704dda-b877-4551-a2a8-c1f764476e65',
                        length => 267560,
                        video => JSON::false,
                        relations => [
                            {
                                artist => {
                                    disambiguation => '',
                                    id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                    name => 'Plone',
                                    'sort-name' => 'Plone',
                                },
                                attributes => [],
                                "attribute-ids" => {},
                                "attribute-values" => {},
                                begin => undef,
                                direction => 'backward',
                                end => undef,
                                ended => JSON::false,
                                type => 'producer',
                                'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                                'source-credit' => '',
                                'target-credit' => '',
                                'target-type' => 'artist',
                            }
                        ],
                        title => 'On My Bus'
                    },
                    title => 'On My Bus'
                },
                {
                    id => 'f38b8e31-a10d-3973-8c1f-10923ee61adc',
                    length => 230506,
                    position => 2,
                    number => '2',
                    recording => {
                        disambiguation => '',
                        id => '8920288e-7541-48a7-b23b-f80447c8b1ab',
                        length => 230506,
                        video => JSON::false,
                        relations => [ {
                                artist => {
                                    disambiguation => '',
                                    id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                    name => 'Plone',
                                    'sort-name' => 'Plone',
                                },
                                attributes => [],
                                "attribute-ids" => {},
                                "attribute-values" => {},
                                begin => undef,
                                direction => 'backward',
                                end => undef,
                                ended => JSON::false,
                                type => 'producer',
                                'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                                'source-credit' => '',
                                'target-credit' => '',
                                'target-type' => 'artist',
                        } ],
                        title => 'Top & Low Rent'
                    },
                    title => 'Top & Low Rent'
                },
                {
                    id => 'd17bed32-940a-3fcc-9210-a5d7c516b4bb',
                    length => 237133,
                    number => '3',
                    position => 3,
                    recording => {
                        disambiguation => '',
                        id => '6e89c516-b0b6-4735-a758-38e31855dcb6',
                        length => 237133,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Plock'
                    },
                    title => 'Plock'
                },
                {
                    id => '001bc675-ba25-32bc-9914-d5d9e22c3c44',
                    length => 229826,
                    position => 4,
                    number => '4',
                    recording => {
                        disambiguation => '',
                        id => '791d9b27-ae1a-4295-8943-ded4284f2122',
                        length => 229826,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Marbles'
                    },
                    title => 'Marbles'
                },
                {
                    id => 'c009176f-ff26-3f5f-bd16-46cede30ebe6',
                    length => 217440,
                    position => 5,
                    number => '5',
                    recording => {
                        disambiguation => '',
                        id => '4f392ffb-d3df-4f8a-ba74-fdecbb1be877',
                        length => 217440,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Busy Working'
                    },
                    title => 'Busy Working'
                },
                {
                    id => '70454e43-b39b-3ca7-8c50-ae235b5ef358',
                    length => 227293,
                    position => 6,
                    number => '6',
                    recording => {
                        disambiguation => '',
                        id => 'dc891eca-bf42-4103-8682-86068fe732a5',
                        length => 227293,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'The Greek Alphabet'
                    },
                    title => 'The Greek Alphabet'
                },
                {
                    id => '1b5da50c-e20f-3762-839c-5a0eea89d6a5',
                    length => 244506,
                    position => 7,
                    number => '7',
                    recording => {
                        disambiguation => '',
                        id => '25e9ae0f-8b7d-4230-9cde-9a07f7680e4a',
                        length => 244506,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Press a Key'
                    },
                    title => 'Press a Key'
                },
                {
                    id => 'f1b5bd23-ad01-3c0c-a49a-cf8e99088369',
                    length => 173960,
                    position => 8,
                    number => '8',
                    recording => {
                        disambiguation => '',
                        id => '6f9c8c32-3aae-4dad-b023-56389361cf6b',
                        length => 173960,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Bibi Plone'
                    },
                    title => 'Bibi Plone'
                },
                {
                    id => '928f2274-5694-35f9-92da-a1fc565867cf',
                    length => 208706,
                    position => 9,
                    number => '9',
                    recording => {
                        disambiguation => '',
                        id => '7e379a1d-f2bc-47b8-964e-00723df34c8a',
                        length => 208706,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Be Rude to Your School'
                    },
                    title => 'Be Rude to Your School'
                },
                {
                    id => '40727388-237d-34b2-8a3a-288878e5c883',
                    length => 320067,
                    position => 10,
                    number => '10',
                    recording => {
                        disambiguation => '',
                        id => 'a8614bda-42dc-43c7-ac5f-4067acb6f1c5',
                        length => 320067,
                        video => JSON::false,
                        relations => [ {
                            artist => {
                                disambiguation => '',
                                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                                name => 'Plone',
                                'sort-name' => 'Plone',
                            },
                            attributes => [],
                            "attribute-ids" => {},
                            "attribute-values" => {},
                            begin => undef,
                            direction => 'backward',
                            end => undef,
                            ended => JSON::false,
                            type => 'producer',
                            'type-id' => '5c0ceac3-feb4-41f0-868d-dc06f6e27fc0',
                            'source-credit' => '',
                            'target-credit' => '',
                            'target-type' => 'artist',
                        } ],
                        title => 'Summer Plays Out'
                    },
                    title => 'Summer Plays Out'
                }
            ]
        } ],
        packaging => JSON::null,
        "packaging-id" => JSON::null,
        quality => 'normal',
        relations => [ {
            artist => {
                disambiguation => '',
                id => '3088b672-fba9-4b4b-8ae0-dce13babfbb4',
                name => 'Plone',
                'sort-name' => 'Plone',
            },
            attributes => [],
            "attribute-ids" => {},
            "attribute-values" => {},
            begin => undef,
            direction => 'backward',
            end => undef,
            ended => JSON::false,
            type => 'design/illustration',
            'type-id' => '307e95dd-88b5-419b-8223-b146d4a0d439',
            'source-credit' => '',
            'target-credit' => '',
            'target-type' => 'artist',
        } ],
        'release-events' => [ {
            area => {
                disambiguation => '',
                id => '8a754a16-0027-3a29-b6d7-2b40ea0481ed',
                'iso-3166-1-codes' => [ 'GB' ],
                name => 'United Kingdom',
                'sort-name' => 'United Kingdom'
            },
            date => '1999-09-13'
        } ],
        status => 'Official',
        "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
        tags => [],
        genres => [],
        'text-representation' => {
            language => 'eng',
            script => 'Latn'
        },
        title => 'For Beginner Piano'
    };
};

test 'release lookup, pregap track' => sub {
    MusicBrainz::Server::Test->prepare_test_database(shift->c, '+webservice');

    my %artist_credit = ('artist-credit' => [{
        artist => {
            disambiguation => '',
            id => '38c5cdab-5d6d-43d1-85b0-dac41bde186e',
            name => 'Blind Melon',
            'sort-name' => 'Blind Melon'
        },
        joinphrase => '',
        name => 'Blind Melon'
    }]);

    ws2_test_json 'release lookup, pregap track',
    '/release/ec0d0122-b559-4aa1-a017-7068814aae57?inc=artists+recordings+artist-credits'
    => {
        %artist_credit,
        asin => undef,
        barcode => '0208311348266',
        'cover-art-archive' => {
            artwork => JSON::false,
            back => JSON::false,
            count => 0,
            darkened => JSON::false,
            front => JSON::false
        },
        disambiguation => '',
        id => 'ec0d0122-b559-4aa1-a017-7068814aae57',
        media => [ {
            format => 'CD',
            "format-id" => "9712d52a-4509-3d4b-a1a2-67c88c643e31",
            title => '',
            'track-count' => 2,
            'track-offset' => 0,
            position => 1,
            pregap => {
                id => '1a0ba71b-fb23-3931-a426-cd204a82a90e',
                title => 'Hello Goodbye [hidden track]',
                length => 128000,
                position => 0,
                number => '0',
                %artist_credit,
                recording => {
                    id => 'c0beb80b-4185-4328-8761-b9e45a5d0ac6',
                    title => 'Hello Goodbye [hidden track]',
                    disambiguation => '',
                    length => 128000,
                    video => JSON::false,
                    %artist_credit,
                }
            },
            tracks => [
                {
                    id => '7b84af2d-96b3-3c50-a667-e7d10e8b000d',
                    title => 'Galaxie',
                    length => 211133,
                    position => 1,
                    number => '1',
                    %artist_credit,
                    recording => {
                        id => 'c43ee188-0049-4eec-ba2e-0385c5edd2db',
                        title => 'Hello Goodbye / Galaxie',
                        disambiguation => '',
                        length => 211133,
                        video => JSON::false,
                        %artist_credit,
                    }
                },
                {
                    id => 'e9f7ca98-ba9d-3276-97a4-26475c9f4527',
                    title => '2 X 4',
                    length => 240400,
                    position => 2,
                    number => '2',
                    %artist_credit,
                    recording => {
                        id => 'c830c239-3f91-4485-9577-4b86f92ad725',
                        title => '2 X 4',
                        disambiguation => '',
                        length => 240400,
                        video => JSON::false,
                        %artist_credit,
                    }
                }
            ]
        } ],
        packaging => JSON::null,
        "packaging-id" => JSON::null,
        quality => 'normal',
        status => 'Official',
        "status-id" => "4e304316-386d-3409-af2e-78857eec5cfe",
        'text-representation' => {
            language => 'eng',
            script => 'Latn'
        },
        title => 'Soup'
    };
};


test 'MBS-7914' => sub {
    my $test = shift;
    my $c = $test->c;

    MusicBrainz::Server::Test->prepare_test_database($c, '+mbs-7914');

    ws2_test_json 'track aliases are included (MBS-7914)',
    '/release/a3ea3821-5955-4cee-b44f-4f7da8a332f7?inc=artists+media+recordings+artist-credits+aliases' => {
        aliases => [],
        'artist-credit' => [{
            artist => {
                aliases => [{
                    locale => JSON::null,
                    name => "グスタフ・マーラー",
                    primary => JSON::null,
                    'sort-name' => "グスタフ・マーラー",
                    type => JSON::null,
                    "type-id" => JSON::null,
                    begin => JSON::null,
                    end => JSON::null,
                    ended => JSON::false,
                }],
                disambiguation => '',
                id => '8d610e51-64b4-4654-b8df-064b0fb7a9d9',
                name => 'Gustav Mahler',
                'sort-name' => 'Mahler, Gustav'
            },
            joinphrase => '',
            name => 'Gustav Mahler'
        }],
        asin => JSON::null,
        barcode => JSON::null,
        'cover-art-archive' => {
            artwork => JSON::false,
            back => JSON::false,
            count => 0,
            darkened => JSON::false,
            front => JSON::false
        },
        disambiguation => '',
        id => 'a3ea3821-5955-4cee-b44f-4f7da8a332f7',
        media => [{
            format => JSON::null,
            "format-id" => JSON::null,
            position => 1,
            title => '',
            'track-count' => 1,
            'track-offset' => 0,
            tracks => [{
                'artist-credit' => [{
                    artist => {
                        aliases => [{
                            locale => JSON::null,
                            name => "グスタフ・マーラー",
                            primary => JSON::null,
                            'sort-name' => "グスタフ・マーラー",
                            type => JSON::null,
                            "type-id" => JSON::null,
                            begin => JSON::null,
                            end => JSON::null,
                            ended => JSON::false,
                        }],
                        disambiguation => '',
                        id => '8d610e51-64b4-4654-b8df-064b0fb7a9d9',
                        name => 'Gustav Mahler',
                        'sort-name' => 'Mahler, Gustav'
                    },
                    joinphrase => '',
                    name => 'Gustav Mahler'
                }],
                id => '8ac89142-1318-490a-bed2-5b0c89b251b2',
                length => JSON::null,
                position => 1,
                number => '1',
                recording => {
                    aliases => [],
                    'artist-credit' => [{
                        artist => {
                            disambiguation => '',
                            id => '509c772e-1164-4457-8d09-0553cfa77d64',
                            name => 'Chicago Symphony Orchestra',
                            'sort-name' => 'Chicago Symphony Orchestra'
                        },
                        joinphrase => '',
                        name => 'Chicago Symphony Orchestra'
                    }],
                    disambiguation => '',
                    id => '36d398e2-85bf-40d5-8686-4f0b78c80ca8',
                    length => JSON::null,
                    title => 'Symphony no. 2 in C minor: I. Allegro maestoso',
                    video => JSON::false
                },
                title => 'Symphony no. 2 in C minor: I. Allegro maestoso'
            }]
        }],
        packaging => JSON::null,
        "packaging-id" => JSON::null,
        quality => 'normal',
        status => JSON::null,
        "status-id" => JSON::null,
        'text-representation' => { language => JSON::null, script => JSON::null },
        title => 'Symphony no. 2'
    };
};

1;
