#!/usr/bin/env perl
use strict;
use warnings;
use File::Slurp qw(read_file write_file);
use List::Util qw(any);
use autodie qw(:all);
use IPC::Run qw(run);

my $output_dir = "../build";

my %section_headers = (
  tap  => '# Tap it',
  cask => '# Cask it',
  brew => '# Brewwwwww it',
);

sub read_lines {
  my ($cmd) = @_;
  open(my $fh, "-|", $cmd) or die "Can't run $cmd: $!";
  my @lines = <$fh>;
  close $fh;
  chomp @lines;
  return sort @lines;
}

sub read_clean_brewfile {
  my @lines = read_file('Brewfile');
  chomp(@lines);
  return grep { /\S/ } @lines;  # keep only non-empty lines
}

sub extract_unique_entries {
  my ($lines, $type) = @_;
  map { /^\s*\Q$type\E\s+'([^']+)'/ ? ($1) : () } @$lines;
}

sub process_section {
    my ($lines, $installed, $type) = @_;
    my %seen = map { $_ => 1 } extract_unique_entries($lines, $type);
    push @$lines, map { "$type '$_'" } grep { !$seen{$_} && $_ !~ /\n/ } @$installed;
}

sub group_brews_by_letter {
  my ($lines) = @_;
  my (%groups, @preserve);

  for my $line (@$lines) {
    if ($line =~ /^brew\s+'([^']+)'/) {
      my $letter = lc substr($1, 0, 1);
      push @{ $groups{$letter} }, $line;
    } elsif ($line =~ /^#\s*(disable|https|brew\s+'https|brew\s+'gromgit)/) {
      push @preserve, $line;
    }
  }

  my @grouped = ($section_headers{brew});
  for my $letter (sort keys %groups) {
    push @grouped, "", "# Formula/$letter", sort @{ $groups{$letter} };
  }
  push @grouped, @preserve if @preserve;
  return @grouped;
}

sub run_diff_or_die {
  my ($out, $err);
  my @cmd = ("diff", "-u", "Brewfile", "$output_dir/Brewfile.generated");
  my $ok = run \@cmd, '>' , "$output_dir/Brewfile.patch", '2>', \$err;
  if (!$ok && $? != 256) {  # diff exits 1 on expected diffs
    die "diff failed: $err";
  }
}

sub build_brewfile_lines {
  my ($sections) = @_;
  my @brew_lines_grouped = group_brews_by_letter($sections->{brew});
  my @lines;
  push @lines, @{$sections->{header}}, "" if @{$sections->{header}};
  push @lines, $section_headers{tap}, sort grep { /^tap\s+'/ } @{$sections->{tap}} if @{$sections->{tap}};
  push @lines, "";
  push @lines, $section_headers{cask}, sort grep { /^cask\s+'/ } @{$sections->{cask}} if @{$sections->{cask}};
  push @lines, "";
  push @lines, @brew_lines_grouped;
  return @lines;
}


my @installed_taps   = read_lines('brew tap');
my @installed_casks  = read_lines('brew list --cask');
my @installed_brews  = read_lines('brew leaves -r');

my @brewfile = read_clean_brewfile();

my %sections = (
  header => [],
  tap    => [],
  cask   => [],
  brew   => []
);

my $section = 'header';
my %markers = (
  qr/^#\s*Tap/i  => 'tap',
  qr/^#\s*Cask/i => 'cask',
  qr/^#\s*Brew/i => 'brew',
);

for my $line (@brewfile) {
  foreach my $regex (keys %markers) {
    if ($line =~ $regex) {
      $section = $markers{$regex};
      last;
    }
  }
  push @{$sections{$section}}, $line;
}

my %installed = (
  tap   => \@installed_taps,
  cask  => \@installed_casks,
  brew  => \@installed_brews,
);

process_section($sections{$_}, $installed{$_}, $_) for qw(tap cask brew);
# process_section($sections{tap},  \@installed_taps,   'tap');
# process_section($sections{cask}, \@installed_casks,  'cask');
# process_section($sections{brew}, \@installed_brews,  'brew');

my @new_brewfile = build_brewfile_lines(\%sections);
write_file("$output_dir/Brewfile.generated", map { "$_\n" } @new_brewfile);

run_diff_or_die();

print "✅ Patch written to Brewfile.patch\n";
print "💡 Apply it using:\n  patch $output_dir/Brewfile < $output_dir/Brewfile.patch\n";
exit 0;
