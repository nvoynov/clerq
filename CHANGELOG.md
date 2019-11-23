# Change log

## master (unreleased)

Changes:

* Started new project [Clerq Video Guide](https://github.com/nvoynov/clerq-video-guide) that provides example of using Clerq.
* Done massive refactoring of source code; no more gateways.
* Totally redesigned NodeRepository and TextRepository.
* Improved interactors caused by gateways throwing out.
* Improved tests suite; no more DEPRECATED Minitest; Dir.mktmpdir is used for sandbox.
* Improved README to include all changes mentioned before.
* Improved `clerq new PROJECT` command; when the `PROJECT` parameter consists of more than one word, it will create `<project>.thor` file that follows to usual ruby file and class naming conventions; e.g. for `user guide` it will create `user_guide.thor` and `class UserGuide < Thor` inside.
 * Thor `error(msg)` in `cli.rb` changed to `stop!(mgs); raise Thor::Error`.
 * Improved CLI for `build`, `check`, `toc`, `node`; now each one checks if the command is running in clerq project, checked if `clerq.yml` or `src` folder exist.
 * Other small improvements.

## 0.1.0 (2019-11-08)

First release
