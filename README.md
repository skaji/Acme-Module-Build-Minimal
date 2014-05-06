# NAME

Acme::Module::Build::Minimal - only Build build/test/install

# SYNOPSIS

    > cat Build.PL
    use Acme::Module::Build::Minimal;
    Build_PL;

    > perl Build.PL
    > ./Build && ./Build test && ./Build install

# DESCRIPTION

Acme::Module::Build::Minimal is a fork of [Acme::Module::Build::Tiny](https://metacpan.org/pod/Acme::Module::Build::Tiny).
This only implements Build build/test/install.
Other actions, such as `dist` or declare prereqs may be handled
by some authoring tools.

# SEE ALSO

[Acme::Module::Build::Tiny](https://metacpan.org/pod/Acme::Module::Build::Tiny)

[Module::Build::Tiny](https://metacpan.org/pod/Module::Build::Tiny)

[https://github.com/Perl-Toolchain-Gang/cpan-api-buildpl](https://github.com/Perl-Toolchain-Gang/cpan-api-buildpl)

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
