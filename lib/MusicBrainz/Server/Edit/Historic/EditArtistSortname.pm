package MusicBrainz::Server::Edit::Historic::EditArtistSortname;
use strict;
use warnings;

use base 'MusicBrainz::Server::Edit::Historic::NGSMigration';

sub edit_type { 2 }
sub edit_name { 'Edit artist name' }
sub ngs_class { 'MusicBrainz::Server::Edit::Artist::Edit' }

sub do_upgrade
{
    my $self = shift;

    return {
        entity_id => $self->artist_id,
        old => {
            sort_name => $self->previous_value
        },
        new => {
            sort_name => $self->new_value
        }
    };
}

sub deserialize_previous_value {
    my ($self, $previous) = @_;
    return $previous;
}

sub deserialize_new_value {
    my ($self, $previous) = @_;
    return $previous;
}

1;
