# Copyright (C) 2012 eBox Technologies S.L.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

package EBox::CGI::RemoteServices::DisasterRecovery;

use strict;
use warnings;

use base 'EBox::CGI::ClientBase';

use EBox::Global;
use EBox::Gettext;
use EBox::RemoteServices::Backup;
use Error qw(:try);

sub new
{
    my $class = shift;
    my $self = $class->SUPER::new('title' => __('Recover from a disaster'),
                                  'template' => 'remoteservices/disaster.mas', @_);
    bless($self, $class);
    return $self;
}

sub _process
{
    my ($self) = @_;

    my @array;

    try {
        # FIXME: uncomment this when being able to test it
        #my $backups = EBox::RemoteServices::Backup->new()->listRemoteBackups();
        my $backups = {
            1 => { Date => '27-09-12', Filename => 'backup1', Description => 'Bla bla', sortableDate => 1 },
            2 => { Date => '27-09-11', Filename => 'backup2', Description => 'Ble ble', sortableDate => 2 }
        };
        push (@array, 'backups' => $backups);
    } otherwise {
        my $ex = shift;
        $self->setErrorFromException($ex);
        $self->setChain('RemoteServices/NoConnection');
    };

    $self->{params} = \@array;
}

sub _menu
{
    my ($self) = @_;

    my $software = EBox::Global->modInstance('software');
    $software->firstTimeMenu(0);
}

sub _top
{
    my ($self) = @_;

    $self->_topNoAction();
}

1;
