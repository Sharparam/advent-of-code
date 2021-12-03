#!/usr/bin/env raku

with lines() -> \n { for 1,3 { say [+] n Z< n[$_..*] } };
