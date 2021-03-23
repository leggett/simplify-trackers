This directory contains a demonstration program for removing trackers
from email messages.  It's a simple filter that reads a file containing
an email message (the path is given on the command line) and writes the
modified message to STDOUT.

The program uses a file called
```
Trackers.rb
```
which is created from `../simplify-tracker-blocker.js` using the *awk(1)*
script:
```
toRuby.awk
```
as follows:
```
rm Trackers.rb; awk -f toRuby.awk ../../simplify-tracker-blocker.js > Trackers.rb`
```

The main program is `mtb`;  the tracker blocking object is defined in
`TrackerBlock.rb`.

`mtb` was developed using Ruby 3.0.  If you want to use it with an older version,
you'll have to adjust some of the gem requirements (labeled **_built in stuff_** in
`mtb`).

The external gem requirements are few:

- `mail` -- see  https://rubygems.org/gems/mail
- `nokogiri` see https://rubygems.org/gems/mail

This code is freely given and is covered under the the license established by 
(@leggett)[https://github.com/leggett].  There is no support for this code expressed
or implied.  Please do not contact me about it.

All the files are liberally-commented.

For Ruby purists:

- I like indentation of 4 spaces instead of the normal two (IMHO, the
code is easier to read).  If this bothers you...tuff...

- I like whitespace in general.  If this bothers you...tuff...
