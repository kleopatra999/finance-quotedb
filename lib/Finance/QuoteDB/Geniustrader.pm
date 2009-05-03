package Finance::QuoteDB::Geniustrader;

use strict;
use warnings;

use Exporter ();
use vars qw/@EXPORT @EXPORT_OK @EXPORT_TAGS/;

use Log::Log4perl qw(:easy);

=head1 NAME

Finance::QuoteDB::Geniustrader - Interfaces to external program Geniustrader

=cut

@EXPORT = ();
@EXPORT_OK = qw // ;
@EXPORT_TAGS = ( all => [@EXPORT_OK] );

=head1 SYNOPSIS

Please take a look at script/fqdb which is the command-line frontend
to Finance::QuoteDB.

=head1 METHODS

=head2 writeConfig

writeConfig ( $fqdb-obj, $file )

This function will create a Geniustrader config file for the $fqdb object.

=cut

sub writeConfig {
  my ($fqdb,$file) = @_ ;
  my $fh ;
  my $dsn = $fqdb->{dsn};
  INFO ("--- $dsn") ;
  if ( open($fh,"+>","$file") ) {
    print $fh "DB::module genericdbi\n" ;
    my $db = "";
    my $dbname = "";
    my $dbhost = "" ;
    my $dbport = "";
    if ($dsn=~/dbi:(\w+):(\S+)(;.*)?$/) {
      $db = $1 ;
      $dbname = $2 ;
    }
    if ($dsn=~/;host=(\w+)(;.*)?$/) {
      $dbhost = $1 ;
    }
    if ($dsn=~/;port=(\w+)(;.*)?$/) {
      $dbport = $1 ;
    }
    print $fh "DB:genericdbi:db=$db\n" if $db ;
    print $fh "DB:genericdbi:dbname=$dbname\n" if $dbname ;
    print $fh "DB:genericdbi:dbhost=$dbhost\n" if $dbhost ;
    print $fh "DB:genericdbi:dbport=$dbport\n" if $dbport ;
    print $fh "DB:genericdbi:dbuser=".$fqdb->{dsnuser}."\n" if $fqdb->{dsnuser} ;
    print $fh "DB:genericdbi:dbpasswd=".$fqdb->{dsnpasswd}."\n" if $fqdb->{dsnpasswd} ;
    print $fh "DB::genericdbi::prices_sql=SELECT day_open, day_high, day_low, day_close, volume, date FROM quote WHERE symbolID = '\$code' ORDER BY date DESC\n" ;
    close $fh ;
  } else {
    ERROR ("Could not open $file in write mode") ;
  }
}

1;
