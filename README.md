# simplify-trackers

List of email spy pixels blocked by [Simplify Gmail](https://simpl.fyi)

### How to use

- Include `simplify-tracker-blocklist.js` in your project
- Test if a url is in the list with `isEmailTracker(url)` – returns `true|false`

### Products and services that use the Simplify Tracker Blocklist:

- [Simplify](https://simpl.fyi)
- [MailTrackerBlocker](https://apparition47.github.io/MailTrackerBlocker/)

### Contributing - Pull Requests

PRs are welcome.

1. If making a PR to add a new tracker, please either confirm your changes actually block the tracker or include an example of the full tracker URL in the PR.
2. Follow existing code-style and data structure: List the domain for the company that owns the tracker and the regex pattern(s) to block all known trackers. If more than one, put them in an array. If only one, just a string. Make sure special characters are properly escaped so they can be joined into a single string and turned into a RegEx.
3. Please update all versions of the tracker list.
4. Nice to have: use [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) and [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)

### Show your support

- I do not ask for donations, all I ask is that you star/share the repo.
- Follow me on Twitter [@leggett](https://twitter.com/leggett) for updates.
- Check out [Simplify](https://simpl.fyi)

### Disclaimer

- This software is provided for educational purposes only and
  is provided "AS IS", without warranty of any kind, express or
  implied, including but not limited to the warranties of merchantability,
  fitness for a particular purpose and noninfringement. in no event shall the
  authors or copyright holders be liable for any claim, damages or other
  liability, whether in an action of contract, tort or otherwise, arising from,
  out of or in connection with the software or the use or other dealings in the
  software.
