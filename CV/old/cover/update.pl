#!/usr/bin/perl

BEGIN {
    push(@INC, "/var/www/html/search/");
}

use strict;
use Search;
use Getopt::Long;

my %options;
GetOptions(\%options, "school=s");

my $school = $options{'school'};
my $updates = "../cover/update_letters.tex";

my $dbh = &dbhandle();

sub make_update {
    
    
    my @schools;
    if (defined($options{'school'})) {
	@schools = split(',', $options{'school'});
    } else {
	my $q = "select name from schools";
	my $sth = $dbh->prepare($q);
	$sth->execute;
	while (my ($name) = $sth->fetchrow_array()) {
	    push(@schools, $name);
	}
    }

    open (F, ">$updates") || die "can't open $updates:$!\n";

    foreach my $school (@schools) {
	my $q = "select address, greeting from schools where name like '$school'";
	my $sth = $dbh->prepare($q);
	$sth->execute;
	my ($address, $greeting) = $sth->fetchrow_array();
	
	next if ($address eq '');

	$address =~ s/\n/\\\\\n/g;
	$address =~ s/\#/\\\#/g;

	my $opening = "To Whom it May Concern";
	if (!($greeting eq '')) {
	    $opening = "Dear $greeting";
	}



	print F <<EOF_L;
\\begin{letter}
{$address}
\\opening{$opening:}
\\text
\\end{letter}

EOF_L
}

my $num_letters = scalar(@schools);
print F <<EOF_L;
\\printreturnlabels{$num_letters}{
Nick Feamster \\\\ 
Massachusetts Institute of Technology \\\\
32 Vassar Street, Room 32-G982 \\\\
Cambridge, MA 02139}
EOF_L

    close(F);



}



&make_update();
system("make update");
