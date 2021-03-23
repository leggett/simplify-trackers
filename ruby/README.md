This directory contains a demonstration program for removing trackers
from email messages. It's a simple filter that reads a file containing
an email message (the path is given on the command line) and writes the
modified message to STDOUT.  If any trackers are blocked, a header called
```
X-Trackers-Blocked:
```
is added to the resulting message.  The content of the `X-Trackers-Blocked:`
header is a JSON-formatted array of strings.  Each string is the name of
a blocked tracker (the names come from the keys of the hash defined in
`../js/simplify-tracker-blocker.js`).

This is intended as a demonstration to get you started on your own app,
not as production code. It's been tested only on messages that come from
my personal email. You'll probably want to test it a lot more...

The program removes all `<img>` tags with `src=` attributes that match regexes
given in `../js/simplify-tracker-blocker.js`. It also removes any `<img>` tags
where the values of the `height=` and `width=` attributes are <= 1.

The program keeps a list of all the trackers blocked. If any trackers are found
where the values of the `height=` and `width=` attributes are <= 1, those are named
**_unknown_** in the list of all trackers blocked.  The list is a SortedSet so
any particular tracker is listed only once even though it may be blocked multiple
times.

The program uses a file called

```
Trackers.rb
```

which is created from `../js/simplify-tracker-blocker.js` using the _awk(1)_
script:

```
toRuby.awk
```

as follows:

```
rm Trackers.rb; awk -f toRuby.awk ../js/simplify-tracker-blocker.js > Trackers.rb`
```

The main program is `mtb`; the tracker blocking object is defined in
`TrackerBlock.rb`.

`mtb` was developed using Ruby 3.0. If you want to use it with an older version,
you'll have to adjust some of the gem requirements (labeled **_built in stuff_** in
`mtb`).

The external gem requirements are few:

- `mail` -- see https://rubygems.org/gems/mail
- `nokogiri` see https://rubygems.org/gems/mail

This code is freely given and is covered under the the license established by
(@leggett)[https://github.com/leggett]. There is no support for this code expressed
or implied. Please do not contact me about it.

All the files are liberally-commented.

For Ruby purists:

- I like whitespace in general.

- I like indentation of 4 spaces instead of the normal two (IMHO, the
  code is easier to read). If this bothers you...tuff...

### Credits

- Simplify Email Tracker Blocker by [@leggett](https://github.com/leggett)
- Ruby port by [@caponecicero](https://github.com/caponecicero)
