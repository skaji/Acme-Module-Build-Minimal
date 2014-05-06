requires 'perl', '5.008005';
requires 'File::ShareDir';
requires 'CPAN::Meta';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

