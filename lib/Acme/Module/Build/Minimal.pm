package Acme::Module::Build::Minimal;
use 5.008005;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT = qw(Build_PL Build);

our $VERSION = "0.01";

{
    no warnings 'once';
    *Build_PL = \&Acme::Module::Build::Minimal::Build_PL::Build_PL;
    *Build = \&Acme::Module::Build::Minimal::Build::Build;
}


package Acme::Module::Build::Minimal::Build_PL;
#use CPAN::Meta;
use File::Copy ();
sub Build_PL {
    # my $self = __PACKAGE__->new_from_meta_file;
    # $self->create_build_script;
    my $self = __PACKAGE__->new;
    $self->create_build_script;
}

sub new {
    my $class = shift;
    bless {}, $class;
}
sub parse_options {
}

# sub new_from_meta_file {
#     my $class = shift;
#     my $meta_file = shift || do {
#         my ($try) = grep -f, qw(META.json META.yml);
#         $try or croak "Missing MEAT.json/yml";
#     };
#     my $meta = CPAN::Meta->load_file($meta_file);
#     bless { meta => $meta }, $class;
#
# }

sub create_build_script {
    my $self = shift;
    my $perl = $^X;
    _spew('Build', "#!$perl\nuse Acme::Module::Build::Minimal;\nBuild;\n");
    chmod 0755, 'Build';
    for my $meta (grep -f, qw(META.json META.yml)) {
        File::Copy::copy($meta, "MY$meta");
    }
}

sub _spew {
    my ($file, $content) = @_;
    open my $fh, ">", $file or die "failed to open $file: $!\n";
    print {$fh} $content;
}

package Acme::Module::Build::Minimal::Build;
use Config;
use ExtUtils::Install ();
use ExtUtils::MakeMaker (); # for MM
use File::Find ();
use File::Spec;
use GetOpt::Long ();
use Test::Harness;

sub new {
    my $class = shift;
    bless {}, $class;
}
sub Build {
    my $self = __PACKAGE__->new;
    $self->do_it(@ARGV);
}
sub do_it {
    my $self = shift;
    my $action = shift || 'build';
    if (my $can = $self->can("ACTION_$action")) {
        $self->$can;
    } else {
        die "Unknown action '$action'";
    }
}
sub ACTION_build {
    my $self = shift;
    my $map = {
        (map { ($_ => "blib/$_") } _files('lib')),
        (map { ($_ => "blib/$_") } _files('script')),
    };
    ExtUtils::Install::pm_to_blib($map, 'blib/lib/auto');
    ExtUtils::MM->fixin($_), chmod(0555, $_) for _files('blib/script');
}

sub ACTION_test {
    my $self = shift;
    $self->ACTION_build;
    local @INC = (File::Spec->rel2abs('blib/lib'), @INC);
    Test::Harness::runtests(_files('t', qr/\.t$/));
}
sub ACTION_install {
    my $self = shift;
    $self->ACTION_build;
    ExtUtils::Install::install(
        map { ("blib/$_" => $Config{"installsite$_"}) } qw(lib script),
    );
    return 1;
}

sub _files {
    my ($dir, $regexp) = @_;
    return unless -d $dir;
    $regexp ||= qr/./; # any
    my @file;
    File::Find::find(sub { push @file, $File::Find::name if -f && /$regexp/ }, $dir);
    return sort @file;
}




1;
__END__

=encoding utf-8

=head1 NAME

Acme::Module::Build::Minimal - only Build build/test/install

=head1 SYNOPSIS

    > cat Build.PL
    use Acme::Module::Build::Minimal;
    Build_PL;

    > perl Build.PL
    > ./Build && ./Build test && ./Build install

=head1 DESCRIPTION

Acme::Module::Build::Minimal is a fork of L<Acme::Module::Build::Tiny>.
This only implements Build build/test/install.
Other actions, such as C<dist> or declare prereqs may be handled
by some authoring tools.

=head1 SEE ALSO

L<Acme::Module::Build::Tiny>

L<Module::Build::Tiny>

L<https://github.com/Perl-Toolchain-Gang/cpan-api-buildpl>

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

